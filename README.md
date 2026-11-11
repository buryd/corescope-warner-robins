# CoreScope — Warner Robins / Middle Georgia

Local CoreScope configuration for the Warner Robins, GA MeshCore mesh (not Chicagoland).

| Setting | Value |
|---------|--------|
| Default region | `WRB` (Warner Robins) |
| Also supported | `MCN` (Macon) |
| Map center | 32.613, −83.624 |
| RF preset | USA `910.525 / 62.5 / SF7 / CR5` |
| UI | http://localhost:3000 |
| MQTT | `localhost:1883` |
| Topics | `meshcore/WRB/{pubkey}/packets` |

## Start CoreScope

### First-time Windows setup

Docker Desktop needs **Virtual Machine Platform** + **WSL**. Those were enabled for this PC; **reboot once**, then:

```powershell
cd C:\Users\dell\CoreScope-WarnerRobins
powershell -ExecutionPolicy Bypass -File .\continue-after-reboot.ps1
```

That script installs/starts Docker Desktop if needed, then runs CoreScope.

### Already have Docker Running

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

Or manually:

```powershell
copy config.json data\config.json
docker compose up -d
```

Open http://localhost:3000 — branding should say **Middle Georgia MeshCore**, map centered on Warner Robins.  
(Port 80 is reserved on this Windows host, so the UI is published on **3000**.)

## Feed local packets (required)

CoreScope only shows what an **observer** MQTT-publishes. Chicago traffic will not appear here.

1. Flash a MeshCore radio as observer/repeater with `-D MESH_PACKET_LOGGING=1`.
2. Set USA channel; companion TX 22; RAK repeater `set tx 16`.
3. Install [meshcoretomqtt](https://github.com/Cisien/meshcoretomqtt) on the PC/Pi with the USB radio.
4. Use `observer\99-user.toml` (`iata = "WRB"`, broker `127.0.0.1:1883`).
5. Confirm packets: CoreScope **Live** tab, or `docker compose logs -f`.

## MeshScope (Android)

Settings → custom analyzer URL:

- Phone on same Wi‑Fi: `http://192.168.x.x:3000` (this PC’s LAN IP)
- Android emulator: `http://10.0.2.2:3000`

## Files

| File | Purpose |
|------|---------|
| `config.json` | WRB/MCN regions, map, geo filter, branding, MQTT |
| `docker-compose.yml` | CoreScope container + ports 80 / 1883 |
| `observer/99-user.toml` | meshcoretomqtt → local broker |
| `setup.ps1` | One-shot Docker + start |

Change `apiKey` in `config.json` before exposing this host beyond your LAN.
