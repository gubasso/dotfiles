# Brave Browser Configuration

General Brave browser setup with webapp profiles.

## Contents

```
brave/
├── .hooks/
│   ├── depends                             # Requires: bin
│   └── post-stow                           # Auto-creates profiles via brave-profile-setup
└── .local/share/
    ├── applications/
    │   ├── brave-browser.desktop           # Main browser (Default profile)
    │   ├── webapp-ai.desktop               # AI assistants (AI profile)
    │   ├── webapp-google.desktop           # Google Workspace (Google profile)
    │   └── webapp-social.desktop           # Social media (Social profile)
    └── brave-unpacked-extensions/
        └── open-temp-chat/                 # ChatGPT temp chat extension
```

## Desktop Entries

All `.desktop` files use `brave-launcher` which reads custom flags from `~/.config/brave/flags.conf`.

| Launcher | Profile | Use Case |
|----------|---------|----------|
| `brave-browser.desktop` | Default | General browsing |
| `webapp-ai.desktop` | AI | Gemini, ChatGPT, Claude |
| `webapp-google.desktop` | Google | Gmail, Drive, Calendar |
| `webapp-social.desktop` | Social | Whatsapp, X, LinkedIn |

**Requires:** `bin` package (provides `brave-launcher` and `brave-profile-setup`)

## Profile Setup

The `post-stow` hook automatically runs `brave-profile-setup AI Google Social` which:
1. Detects Brave data directory (native or Flatpak)
2. Creates profile directories with semantic names
3. Copies Extensions and Preferences from Default profile

**First-time setup:** Run Brave once to create the Default profile with your desired extensions and settings before running `dots brave`.

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
