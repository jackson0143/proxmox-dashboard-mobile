# proxmox-mobile-dashboard
Simple Mobile friendly dashboard for Proxmox Virtualisation Environment built with Flutter (ShadCN flutter package) and FASTAPI. Monitor your VMs and LXCs and control it easily through the mobile app.

Made to simplify the main thing I use daily, might add more things if I have time. Also I have never used Flutter before so just tring it out

[![Flutter](https://img.shields.io/badge/Flutter-stable-blue)]()
[![FastAPI](https://img.shields.io/badge/FastAPI-async-green)]()



## ✨ Features (MVP)
- VM/LXC list with live CPU/RAM % (polling)
- Start / Stop / Rstart options
- Designed for iOS and Android (using Flutter)

Future features:
- graphs/charts of performance
- in-line clean CLI?
- lxc/qemu preview
- create/delete containers

  ![screenshot1](https://github.com/jackson0143/proxmox-dashboard-mobile/blob/main/images/screenshot1.PNG)
![screenshot2](https://github.com/jackson0143/proxmox-dashboard-mobile/blob/main/images/screenshot2.PNG)
## 🛡️ Security Notes
- Keep Proxmox API reachable only from LAN


## Quick Start for development
I have not made a start script to auto configure, so you can manually configure the paths in .env
in the root directory '/', create a .env file
```bash
PVE_BASE=<proxmox-ip here>
PVE_TOKEN=USER@REALM!tokenid=secret
DASHBOARD_API_KEY=change-me
PVE_VERIFY=falseo

API_BASE=<path of the backend FASTAPI just hosted>
API_KEY=change-me
```
Run the backend by cd backend then running 
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Then run flutter app by 
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5173 --dart-define-from-file=.env
```

