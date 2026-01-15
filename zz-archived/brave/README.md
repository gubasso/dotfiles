# Brave Browser Configuration

Brave browser setup optimized for Wayland with hardware acceleration and webapp profiles.

## Contents

```
brave/
├── .config/
│   └── brave-flags.conf                    # Startup flags for Wayland/GPU
└── .local/share/
    ├── applications/                       # Desktop launchers
    │   ├── brave-browser.desktop           # Main browser (Default profile)
    │   ├── webapp-ai.desktop               # AI/ChatGPT (Profile 1)
    │   ├── webapp-google.desktop           # Google services (Profile 2)
    │   └── webapp-social.desktop           # Social apps (Profile 3)
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

## Desktop Launchers

Each `.desktop` file uses `brave-launcher` to apply flags automatically:

| Launcher | Profile | Use Case |
|----------|---------|----------|
| `brave-browser.desktop` | Default | General browsing |
| `webapp-ai.desktop` | Profile 1 | ChatGPT and AI tools |
| `webapp-google.desktop` | Profile 2 | Google Workspace |
| `webapp-social.desktop` | Profile 3 | Social media |

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
- `stow`: GNU Stow for symlink management
