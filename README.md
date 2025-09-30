# proxmox-mobile-dashboard
Mobile friendly dashboard for Proxmox Virtualisation Environment built with Flutter and FASTAPI. Monitor your VMs and LXCs and control it easily through the mobile app.




[![Flutter](https://img.shields.io/badge/Flutter-stable-blue)]()
[![FastAPI](https://img.shields.io/badge/FastAPI-async-green)]()


## ✨ Features (MVP)
- VM/LXC list with live CPU/RAM % (polling)
- Start / Stop / Reset actions (QEMU first; LXC soon)
- Designed for iOS and Android (using Flutter)


- The app never sees your Proxmox API token. The proxy whitelists endpoints you choose.


## 🚀 Quick Start
```bash
Fill here when done
```


## 🛡️ Security Notes

- Keep Proxmox API reachable only from LAN


- env.dev.json file in root
.env in /backend
