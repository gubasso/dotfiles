# Brave Browser Configuration

Brave browser setup optimized for Wayland with hardware acceleration.

## Contents

```
brave/
├── .config/
│   └── brave-flags.conf                    # Startup flags for Wayland/GPU
└── .local/share/
    └── brave-unpacked-extensions/
        └── open-temp-chat/                 # ChatGPT temp chat extension
```

## Flags Configuration

`brave-flags.conf` is read by the `brave-launcher` script (from the `bin` package) and applies these optimizations:

| Category | Flags |
|----------|-------|
| **Wayland** | `--ozone-platform=wayland`, `--enable-features=WaylandWindowDecorations` |
| **GPU** | `--use-angle=gl`, `--enable-gpu-rasterization`, `--enable-zero-copy` |
| **VA-API** | `--enable-features=VaapiVideoDecoder,VaapiVideoDecodeLinuxGL` |
| **WebRTC** | `--enable-features=WebRTCPipeWireCapturer` (screen sharing) |
| **Privacy** | `--disable-crash-reporter`, `--disable-breakpad` |

## Unpacked Extensions

### open-temp-chat

Minimal MV3 extension that opens ChatGPT in temporary chat mode via keyboard shortcut.

**Features:**
- Opens `https://chatgpt.com/?temporary-chat=true` in a new tab
- Configurable keyboard shortcut
- No data collection, minimal permissions (only `tabs`)

#### Installation

1. Deploy the package:
   ```bash
   dots brave
   # or restow if already deployed
   dots -R brave
   ```

2. Load the extension in Brave:
   - Open `brave://extensions/`
   - Enable **Developer mode** (top-right toggle)
   - Click **Load unpacked**
   - Select: `~/.local/share/brave-unpacked-extensions/open-temp-chat`

3. Assign keyboard shortcut:
   - Open `brave://extensions/shortcuts`
   - Find "Open ChatGPT Temp Chat"
   - Click the input field and press your desired shortcut (e.g., `Alt+T`)

#### Updating the Extension

After modifying extension files, reload in Brave:
- Go to `brave://extensions/`
- Click the refresh icon on the extension card

## Dependencies

- `bin` package: provides `brave-launcher` script
