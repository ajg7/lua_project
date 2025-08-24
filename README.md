# lua_project

Minimal LÖVE (LOVE2D) starter that now renders a tiny retro pixel alien sprite (replacing the single green pixel).

## Files

- `main.lua` – Game entry point, draws a small pixel-art alien (scalable).
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

You should see an 800x600 window titled "Pixel Alien" with a small green alien gently bobbing / jumping in place.

Controls:

| Key       | Action                      |
| --------- | --------------------------- |
| `+` / `=` | Increase pixel size (scale) |
| `-`       | Decrease pixel size         |
| `Space`   | Pause / resume jump         |
| `Esc`     | Quit                        |

If `love` isn't on your PATH, drag the project folder onto `love.exe` in Explorer.

## What to Try Next

- Tweak the alien pattern: edit the `alienPattern` table in `main.lua` (use `X`, `O`, or `.` for empty).
- Add colors: extend the `colors` table mapping characters to RGBA.
- Animate: create multiple pattern tables and cycle them in `update`.

## License

Public domain / Unlicense – do whatever you like.
