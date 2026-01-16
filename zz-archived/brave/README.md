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
    │   ├── webapp-ai.desktop               # AI assistants (AI profile)
    │   ├── webapp-google.desktop           # Google Workspace (Google profile)
    │   └── webapp-social.desktop           # Social media (Social profile)
    └── brave-unpacked-extensions/
        └── open-temp-chat/                 # ChatGPT temp chat extension
```

## Desktop Launchers

Each `.desktop` file uses `brave-launcher` to apply flags automatically:

| Launcher | Profile | Use Case |
|----------|---------|----------|
| `brave-browser.desktop` | Default | General browsing |
| `webapp-ai.desktop` | AI | Gemini, ChatGPT, Claude |
| `webapp-google.desktop` | Google | Gmail, Drive, Calendar |
| `webapp-social.desktop` | Social | Whatsapp, X, LinkedIn |
