# lua_project

Local two‑player retro alien duel with an intro dialogue cutscene.

## Files

- `main.lua` – Game loop, entities, bullets, background image, and a timed/skippable intro dialogue cutscene (typewriter + slide-in).
- `conf.lua` – Window configuration (size, title).

## Prerequisites

1. Install LÖVE (Windows):
   - Visit the official site: <https://love2d.org/> and download the latest 64-bit Windows installer.
   - Run the installer (accept defaults). This installs `love.exe` (usually in `C:\Program Files\LOVE`).
2. (Optional) Add the install directory to your `PATH` so you can run `love` from any terminal:
   - Open: Windows Search -> type `Edit the system environment variables` -> Environment Variables.
   - Under System variables select `Path` -> Edit -> New -> `C:\Program Files\LOVE` (adjust if different).
   - Open a new terminal and run `love --version` to verify it works.

## Run

From this project folder:

```bash
love .
```

You should see an 800x600 window titled "Alien Duel" with a post‑apocalyptic background and an intro cutscene (aliens slide in, dialogue lines type out). Use Enter to fast‑forward or advance; last line waits for Enter.

Gameplay Controls:

| Player | Move       | Shoot      |
| ------ | ---------- | ---------- |
| P1     | W A S D    | F          |
| P2     | Arrow Keys | Right Ctrl |

Other:

| Key   | Action                                    |
| ----- | ----------------------------------------- |
| Enter | Advance / fast-forward dialogue / restart |
| Esc   | Quit                                      |

If `love` isn't on your PATH, drag the project folder onto `love.exe` in Explorer.

## What to Try Next

- Extend dialogue: edit `cutscene.script` in `main.lua` (each item has `text` and `duration`). Use `math.huge` duration to wait for player input.
- Add sound effects for shooting and hit.
- Add a scoreboard for multiple rounds.
- Animate the aliens (multiple patterns cycled over time).

## License

Public domain / Unlicense – do whatever you like.
