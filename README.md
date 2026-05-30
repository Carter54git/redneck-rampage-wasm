# Redneck Rampage — браузерный порт

Веб-сборка **Rednukem** (форк **NBlood / EDuke32**) для **Redneck Rampage**: движок компилируется в **WebAssembly** через **Emscripten**, оболочка — HTML5 + WebGL.

**Онлайн-демо:** [https://retrogamescenter.ru/ports/redneckrweb/run.html](https://retrogamescenter.ru/ports/redneckrweb/run.html)

## Возможности

- Запуск в современном браузере без установки (после сборки или на хостинге с готовыми `wasm`/`data`)
- Разрешение **960×540**, mouselook, сохранения в **IndexedDB**
- Загрузка уровней без длительной блокировки вкладки (Asyncify + пошаговый вход на карту)
- OPL3-музыка и звук через SDL2 в браузере

## Состав репозитория

| Каталог | Назначение |
|---------|------------|
| `NBlood-master/` | Исходники Rednukem и Build Engine (патчи под `__EMSCRIPTEN__`) |
| `web/` | `run.html`, `saves.js`, `serve.py`, скрипт staging |
| `scripts/` | `build-web.ps1` — сборка под Emscripten |
| `gamefiles/` | Сюда кладутся файлы игры (в Git не входят) |

## Что нужно для сборки

1. **Emscripten SDK** — [https://emscripten.org/docs/getting_started/downloads.html](https://emscripten.org/docs/getting_started/downloads.html)  
   Установка и активация: `emsdk install latest` → `emsdk activate latest`.

2. **Файлы игры** — легальная копия Redneck Rampage (CD, GOG и т.п.).  
   Подробности: [gamefiles/README.md](gamefiles/README.md).  
   Минимум: `REDNECK.GRP`, `REDNECK.CFG`; для полной совместимости — весь каталог игры (`.CON`, `TABLES.DAT`, …).

3. **Python 3** — для локального тестового сервера (`web/serve.py`).

4. **make** — в PATH (для Windows удобен [Make из WinGet](https://github.com/mbuilov/mmake-win) или среда MSYS2).

На Windows скрипт сборки сам ищет `emsdk` в каталоге проекта или в соседнем `bloodweb\emsdk`, если он у вас уже есть.

## Сборка (Windows)

```powershell
git clone <URL-репозитория> RedneckRampage-Web
cd RedneckRampage-Web

# Скопируйте файлы игры в gamefiles\ (см. gamefiles\README.md)
# Test-Path gamefiles\REDNECK.GRP

.\scripts\build-web.ps1
```

Первая сборка занимает несколько минут. В каталог `web\` попадут:

- `rednukem.js`, `rednukem.wasm`, `rednukem.data` (в `.data` упакованы файлы из `web\gamedata\`).

Повторная сборка без перекопирования игровых файлов:

```powershell
.\scripts\build-web.ps1 -SkipStage
```

## Локальный запуск

```powershell
cd web
python serve.py
```

Откройте в браузере: **http://127.0.0.1:8767/run.html**  
Порт можно задать переменной `RR_PORT`. Не открывайте `run.html` через `file://` — нужен HTTP.

После обновления `wasm` / `data` сделайте принудительное обновление страницы (**Ctrl+F5**).

Параметр скорости: `?speed=0.93` (по умолчанию в `run.html`).

## Публикация на сайте

1. Соберите проект локально.
2. Залейте на сервер содержимое `web\`: `run.html`, `saves.js`, `rednukem.js`, `rednukem.wasm`, `rednukem.data`, при необходимости `indeximg.png`.
3. Настройте MIME для `.wasm` (`application/wasm`) и кэширование (для разработки удобен `Cache-Control: no-store`, как в `serve.py`).

**Не выкладывайте в открытый репозиторий** `REDNECK.GRP` и другие защищённые авторским правом файлы игры.

## Техническая основа (кратко)

- **Emscripten:** `MODULARIZE`, `createRednukemModule`, Asyncify, preload FS (`gamedata` → `/`).
- **Видео:** 8-bit indexed blit в WebGL (`glsurface`), не десктопный Polymost GL1.
- **Цикл:** ~30 game tics/s по `emscripten_get_now()`, отдельная ветка `G_EmscriptenRunGameTic` в одиночной игре.
- **Ввод:** Pointer Lock, буферы `__rrMouseDx` / `__rrMouseDy`, флаги меню `__rrMenuOpen`.
- **Сохранения:** перехват FS в `saves.js` → IndexedDB (`rednukem-saves-v1`).

## Лицензия

Исходный код движка — **GPL-2.0** (см. [LICENSE](LICENSE)).  
Торговые марки и контент *Redneck Rampage* принадлежат правообладателям; репозиторий их не распространяет.
