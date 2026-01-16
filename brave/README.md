# Brave Browser Configuration

General Brave browser setup.

## Contents

```
brave/
├── .hooks/
│   └── depends                             # Requires: bin
└── .local/share/
    ├── applications/
    │   └── brave-browser.desktop           # Overrides system .desktop, uses brave-launcher
    └── brave-unpacked-extensions/
        └── open-temp-chat/                 # ChatGPT temp chat extension
```

## Desktop Entry

The `brave-browser.desktop` file overrides the system Brave desktop entry (XDG precedence).
It launches Brave via `brave-launcher` which reads custom flags from `~/.config/brave/flags.conf`.

**Requires:** `bin` package (provides `brave-launcher`)

## Unpacked Extensions

### open-temp-chat

Minimal MV3 extension that opens ChatGPT in temporary chat mode via keyboard shortcut.

**Features:**
- Opens `https://chatgpt.com/?temporary-chat=true&hints=search` in a new tab
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
