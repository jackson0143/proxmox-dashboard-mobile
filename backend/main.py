from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
import httpx, os
from dotenv import load_dotenv
load_dotenv()
from contextlib import asynccontextmanager


PVE_BASE = os.getenv("PVE_BASE") # e.g. https://pve.example.local:8006/api2/json
PVE_TOKEN = os.getenv("PVE_TOKEN") #USER@REALM!tokenid=secret
DASHBOARD_API_KEY = os.getenv("DASHBOARD_API_KEY")

if not PVE_TOKEN:
    raise RuntimeError("Set PVE_TOKEN env var: USER@REALM!tokenid=secret")

client: httpx.AsyncClient | None = None
HEADERS = {"Authorization": f"PVEAPIToken={PVE_TOKEN}"}


@asynccontextmanager
async def lifespan(app: FastAPI):
    global client
    client = httpx.AsyncClient(
        verify=os.getenv("PVE_VERIFY", "false").lower() == "true",
        timeout=15,
        base_url=PVE_BASE,
        headers=HEADERS,
    )
    yield
    await client.aclose()

# --- App setup ---
app = FastAPI(title="Proxmox API", description="Proxmox API for dashboard mobile", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("CORS_ALLOW_ORIGINS", "*").split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Health check ---
@app.get("/health")
async def health():
    return {"status": "ok"}


# --- Helper methods ---
def require_dashboard_api_key(api_key: str):
    expected_key = DASHBOARD_API_KEY
    if api_key != expected_key:
        raise HTTPException(status_code=401, detail="Invalid API key")

async def api_get(url: str, params: dict | None = None):
    try:
        async with client:
            response = await client.get(url, params=params, headers=HEADERS)
            response.raise_for_status()
            return response.json()
    except httpx.HTTPStatusError as e:
        raise HTTPException(status_code=500, detail=f"Proxmox API error: {e}")

async def api_post(url: str, data: dict | None = None):
    try:
        async with client:
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
@app.post("/api/qemu/{node}/{vmid}/{action}")
async def qemu_action(node:str, vmid:int, action:str, dependencies=[Depends(require_dashboard_api_key)]):
    if action not in VALID_QEMU_ACTIONS:
        raise HTTPException(status_code=400, detail=f"Invalid action: {action}. Valid actions are: {VALID_QEMU_ACTIONS}")
    url = f"{PVE_BASE}/nodes/{node}/qemu/{vmid}/status/{action}"
    return await api_post(url)

@app.post("/api/lxc/{node}/{vmid}/{action}")
async def lxc_action(node:str, vmid:int, action:str, dependencies=[Depends(require_dashboard_api_key)]):
    if action not in VALID_LXC_ACTIONS:
        raise HTTPException(status_code=400, detail=f"Invalid action: {action}. Valid actions are: {VALID_LXC_ACTIONS}")
    url = f"{PVE_BASE}/nodes/{node}/lxc/{vmid}/status/{action}"
    return await api_post(url)



