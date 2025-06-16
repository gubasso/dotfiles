local wezterm = require 'wezterm'
local act = wezterm.action
local helpers = require 'helpers'
local split_nav = helpers.split_nav
local mk_binding = helpers.mk_binding


local function build_keymaps()
  local keys = {
    -- Unbind Alt+Enter (default toggles fullscreen)
    mk_binding('a', 'Enter', act.DisableDefaultAssignment),
    -- Ctrl+Enter -> Alt+Enter (new line in Fish shell)
    mk_binding('c', 'Enter', act.SendKey{ key="Enter", mods="ALT" }),

    -- Copy Mode
    mk_binding('lc', '[', act.ActivateCopyMode),
    mk_binding('l',  '[', act.ActivateCopyMode),

    -- Command Palette
    mk_binding('lc', 'p', act.ActivateCommandPalette),

    -- Splits
    mk_binding('l',  '-', act.SplitVertical   { domain = 'CurrentPaneDomain' }),
    mk_binding('ls', '|', act.SplitHorizontal { domain = 'CurrentPaneDomain' }),

    -- Move between panes
    split_nav('move',   'h'),
    split_nav('move',   'j'),
    split_nav('move',   'k'),
    split_nav('move',   'l'),

    -- Resize panes
    split_nav('resize', 'h'),
    split_nav('resize', 'j'),
    split_nav('resize', 'k'),
    split_nav('resize', 'l'),

    -- Close pane
    mk_binding('l', 'x', act.CloseCurrentPane { confirm = true }),

    -- Zoom
    mk_binding('lc', 'z', act.TogglePaneZoomState),

    -- Tabs ---------------------------------------------------
    -- new tab at current domain
    mk_binding('lc', 'c', act.SpawnTab "CurrentPaneDomain"),
    -- new tab at home_dir
    mk_binding('c', 't', act.SpawnCommandInNewTab { cwd = wezterm.home_dir }),
    mk_binding('lc', 'k', act.ActivateTabRelative( 1)  ),
    mk_binding('lc', 'j', act.ActivateTabRelative(-1)  ),
    mk_binding('lc', 'Space', act.ActivateLastTab),
    mk_binding('c', 'Tab', act.ActivateLastTab),
    mk_binding('c', 'w', act.CloseCurrentTab { confirm = false }),

    -- Rename tab
    mk_binding('l', ',', act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      },
      action = wezterm.action_callback(function(win, _, line)
        if line then win:active_tab():set_title(line) end
      end),
    }),

    -- Launcher
    mk_binding('lc', 't', act.ShowLauncherArgs { flags = 'FUZZY|TABS' }),
    mk_binding('l',  'm', act.ActivateKeyTable { name = 'move_tab', one_shot = false }),

    -- Workspaces ----------------------------------------------------------
    mk_binding('l', 'w', act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' }),

    -- Disable default SUPER+w
    mk_binding('s', 'w', act.DisableDefaultAssignment),
  }

  -- Tabs --------------------------------------------------------------------
  -- Number‑to‑tab mappings (1–9)
  for i = 1, 9 do
    table.insert(keys, mk_binding('c', tostring(i), act.ActivateTab(i - 1)))
  end

  return keys
end

local function buld_key_tables()
  -- move_tab table
  local move_tab = {
    { key = 'h', action = act.MoveTabRelative(-1) },
    { key = 'j', action = act.MoveTabRelative(-1) },
    { key = 'k', action = act.MoveTabRelative(1) },
    { key = 'l', action = act.MoveTabRelative(1) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  }

  -- copy_mode table
  local copy_mode = {}
  if wezterm.gui then
    local default_copy_mode = wezterm.gui.default_key_tables().copy_mode
    for _, binding in ipairs(default_copy_mode) do
      table.insert(copy_mode, binding)
    end
  end
  table.insert(copy_mode, {
    key = '/',
    mods = 'NONE',
    -- action = act.Search { CaseInSensitiveString = ' ' },
    action = act.Multiple({
      act.CopyMode("ClearPattern"),
      act.Search({ CaseInSensitiveString = "" }),
    })
  })

  -- search_mode table
  local search_mode = {}
  if wezterm.gui then
    -- grab the defaults for search overlay
    local defaults = wezterm.gui.default_key_tables().search_mode
    for _, b in ipairs(defaults) do
      table.insert(search_mode, b)
    end
  end

  local custom_search = {
    -- clear pattern (e.g. Ctrl‑L / Ctrl‑U)
    mk_binding("c", "l", act.CopyMode('ClearPattern')),
    -- Enter: accept & leave the match selected
    mk_binding("n", "Enter", act.CopyMode('AcceptPattern')),
    -- Escape: exit search overlay, stay in copy mode with no selection
    mk_binding("n", "Escape", act.Multiple{
      { CopyMode = "AcceptPattern" },
      { CopyMode = "ClearSelectionMode" },
    }),
  }

  for _, k in ipairs(custom_search) do
    table.insert(search_mode, k)
  end

  return {
    move_tab = move_tab,
    copy_mode = copy_mode,
    search_mode = search_mode
  }
end

return {
  get_keys = build_keymaps,
  get_key_tables = buld_key_tables,
}
