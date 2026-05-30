# Redneck Rampage — browser port

A **Rednukem** web build (fork of **NBlood / EDuke32**) for **Redneck Rampage**: the engine is compiled to **WebAssembly** with **Emscripten**; the shell uses HTML5 and WebGL.

**Live demo:** [https://retrogamescenter.ru/ports/redneckrweb/run.html](https://retrogamescenter.ru/ports/redneckrweb/run.html)

## Features

- Play in a modern browser without installing a native build (after you build locally or host the compiled `wasm` / `data` bundle)
- **960×540** resolution, mouselook, saves in **IndexedDB**
- Level loads without freezing the tab for long periods (Asyncify + staged level entry)
- OPL3 music and sound effects via SDL2 in the browser

## Repository layout

| Directory | Purpose |
|-----------|---------|
| `NBlood-master/` | Rednukem and Build Engine sources (`__EMSCRIPTEN__` patches) |
| `web/` | `run.html`, `saves.js`, `serve.py`, staging script |
| `scripts/` | `build-web.ps1` — Emscripten build |
| `gamefiles/` | Place your game files here (not tracked by Git) |

## Requirements

1. **Emscripten SDK** — [https://emscripten.org/docs/getting_started/downloads.html](https://emscripten.org/docs/getting_started/downloads.html)  
   Install and activate: `emsdk install latest` → `emsdk activate latest`.

2. **Game data** — a legal copy of Redneck Rampage (CD, GOG, etc.).  
   See [gamefiles/README.md](gamefiles/README.md).  
   Minimum: `REDNECK.GRP`, `REDNECK.CFG`; for best compatibility, copy the full game directory (`.CON`, `TABLES.DAT`, and related files).

3. **Python 3** — for the local test server (`web/serve.py`).

4. **make** — available on `PATH` (on Windows, use [Make from WinGet](https://github.com/mbuilov/mmake-win) or MSYS2).

On Windows, the build script looks for `emsdk` in the project directory or in a sibling `bloodweb\emsdk` folder if you already use that layout.

## Building (Windows)

```powershell
git clone <repository-url> RedneckRampage-Web
cd RedneckRampage-Web

# Copy your game files into gamefiles\ (see gamefiles\README.md)
# Test-Path gamefiles\REDNECK.GRP

.\scripts\build-web.ps1
```

The first build takes several minutes. Outputs are written to `web\`:

- `rednukem.js`, `rednukem.wasm`, `rednukem.data` (game files from `web\gamedata\` are packed into `.data`).

Rebuild without re-staging game files:

```powershell
.\scripts\build-web.ps1 -SkipStage
```

## Running locally

```powershell
cd web
python serve.py
```

Open in your browser: **http://127.0.0.1:8767/run.html**  
Set the port with the `RR_PORT` environment variable. Do not open `run.html` via `file://`; HTTP is required.

After updating `wasm` or `data`, hard-refresh the page (**Ctrl+F5**).

Gameplay speed URL parameter: `?speed=0.93` (default in `run.html`).

## Deploying to a web server

1. Build the project locally.
2. Upload the contents of `web\`: `run.html`, `saves.js`, `rednukem.js`, `rednukem.wasm`, `rednukem.data`, and `indeximg.png` if you use it.
3. Serve `.wasm` with MIME type `application/wasm`. For development, `Cache-Control: no-store` (as in `serve.py`) avoids stale binaries.

Do **not** commit `REDNECK.GRP` or other copyrighted game assets to a public repository.

## Technical notes

- **Emscripten:** `MODULARIZE`, `createRednukemModule`, Asyncify, preload filesystem (`gamedata` → `/`).
- **Video:** 8-bit indexed blit to WebGL (`glsurface`), not desktop Polymost GL1.
- **Game loop:** ~30 game tics per second via `emscripten_get_now()`; single-player path uses `G_EmscriptenRunGameTic`.
- **Input:** Pointer Lock, `__rrMouseDx` / `__rrMouseDy`, menu flag `__rrMenuOpen`.
- **Saves:** FS hooks in `saves.js` → IndexedDB (`rednukem-saves-v1`).

## License

Engine source is **GPL-2.0** (see [LICENSE](LICENSE)).  
*Redneck Rampage* trademarks and game content belong to their rights holders; this repository does not distribute them.
