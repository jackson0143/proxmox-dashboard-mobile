from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.middleware.cors import CORSMiddleware
import httpx, os
from dotenv import load_dotenv
load_dotenv()
from contextlib import asynccontextmanager
from pathlib import Path
from starlette.staticfiles import StaticFiles

PVE_BASE = os.getenv("PVE_BASE") # e.g. https://pve.example.local:8006/api2/json
PVE_TOKEN = os.getenv("PVE_TOKEN") #USER@REALM!tokenid=secret
DASHBOARD_API_KEY = os.getenv("DASHBOARD_API_KEY")

if not PVE_TOKEN:
    raise RuntimeError("Set PVE_TOKEN env var: USER@REALM!tokenid=secret")

HEADERS = {"Authorization": f"PVEAPIToken={PVE_TOKEN}"}



# --- App setup ---
app = FastAPI(title="Proxmox Dashboard API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# --- Health check ---
@app.get("/health")
async def health():
    return {"status": "ok"}



# --- Helper methods ---

def require_dashboard_api_key(
    x_api_key: str | None = Header(None, alias="X-API-Key"),
    api_key: str | None = None,
):

    provided = x_api_key or api_key
    if DASHBOARD_API_KEY and provided != DASHBOARD_API_KEY:
        raise HTTPException(status_code=401, detail="Unauthorized")



@app.get("/auth-check", dependencies=[Depends(require_dashboard_api_key)])
async def auth_check():
    return {"ok": True}


async def api_get(url: str, params: dict | None = None):
    try:
        async with httpx.AsyncClient(verify=False, timeout=10) as client:
            response = await client.get(url, params=params, headers=HEADERS)
            response.raise_for_status()
            return response.json()
    except httpx.HTTPStatusError as e:
        raise HTTPException(status_code=500, detail=f"Proxmox API error: {e}")

async def api_post(url: str, data: dict | None = None):
    try:
        async with httpx.AsyncClient(verify=False, timeout=10) as client:
            response = await client.post(url, json=data, headers=HEADERS)
            response.raise_for_status()
            return response.json()
    except httpx.HTTPStatusError as e:
        raise HTTPException(status_code=500, detail=f"Proxmox API error: {e}")


# --- Routes ---
@app.get("/api/vms", dependencies=[Depends(require_dashboard_api_key)])
async def list_vms():
 
    items = await api_get(f"{PVE_BASE}/cluster/resources?type=vm")
    return items["data"]





VALID_QEMU_ACTIONS = ["reboot", "shutdown", "start", "stop"]
VALID_LXC_ACTIONS = ["reboot", "shutdown", "start", "stop"]
@app.post("/api/qemu/{node}/{vmid}/{action}", dependencies=[Depends(require_dashboard_api_key)])
async def qemu_action(node:str, vmid:int, action:str):
    if action not in VALID_QEMU_ACTIONS:
        raise HTTPException(status_code=400, detail=f"Invalid action: {action}. Valid actions are: {VALID_QEMU_ACTIONS}")
    url = f"{PVE_BASE}/nodes/{node}/qemu/{vmid}/status/{action}"
    return await api_post(url)

@app.post("/api/lxc/{node}/{vmid}/{action}", dependencies=[Depends(require_dashboard_api_key)])
async def lxc_action(node:str, vmid:int, action:str):
    if action not in VALID_LXC_ACTIONS:
        raise HTTPException(status_code=400, detail=f"Invalid action: {action}. Valid actions are: {VALID_LXC_ACTIONS}")
    url = f"{PVE_BASE}/nodes/{node}/lxc/{vmid}/status/{action}"
    return await api_post(url)





# app.mount("/", StaticFiles(directory="build/web", html=True), name="webapp")