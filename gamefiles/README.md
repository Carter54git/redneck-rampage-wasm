# Redneck Rampage — game files for the web build

Copy your **legally owned** Redneck Rampage install here (CD, GOG, etc.).  
Files are packed into `rednukem.data` at build time. **Not committed to Git.**

## Required

| File | Size (approx.) | Notes |
|------|----------------|--------|
| `REDNECK.GRP` | ~135 MB | Main game archive (CRC must match Rednukem) |
| `REDNECK.CFG` | small | Setup / config |

## Recommended (loose files from CD/GOG)

Rednukem also expects many `.CON` scripts and data files **outside** the GRP on desktop builds.  
For web preload, copy **the full game directory** into `gamefiles/` (same layout as your `Redneck` folder):

- `REDNECK.GRP`, `REDNECK.CFG`, `REDNECK.RTS`
- `TABLES.DAT`, `LOOKUP.DAT`, `PALETTE.DAT`, `COMMIT.DAT`
- `*.CON` (GAME.CON, USER.CON, DEFS.CON, character CONs, etc.)
- `DEMO*.DMO` (optional)
- **CD music (optional):** `track02.ogg` … `track09.ogg` — Rednukem extension, not in the original GRP. Without these files the game runs but level music is silent.

**Source path (your machine):** `C:\Users\user\Desktop\rredneckweb\Redneck\` → copy contents to `gamefiles\`.

## Verify

```powershell
Test-Path gamefiles\REDNECK.GRP
Test-Path gamefiles\REDNECK.CFG
```

## Do not use

- `REDNECK.GRP` from *Rides Again* alone (different CRC / `GAMEFLAG_RRRA`) unless you intend that expansion.
- Duke Nukem 3D `DUKE3D.GRP` — wrong game.

## Rights

Do not redistribute `REDNECK.GRP` in a public Git repo. Host only your own built `rednukem.data` if you have the right to deploy it.
