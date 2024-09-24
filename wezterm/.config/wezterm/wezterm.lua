local wezterm = require 'wezterm'
local config = {}
-- Use config builder object if possible
if wezterm.config_builder then config = wezterm.config_builder() end
local act = wezterm.action
local scale = 1.6
local basename = function(s)
  local str = tostring(s)
  local base = str:match("([^/]+)/?$")
  return base
end

-- Settings
config.default_cwd = 'home'
config.default_workspace = "home"
config.scrollback_lines = 5000
config.window_close_confirmation = "AlwaysPrompt"

-- Appearance ------------------------------
config.window_decorations = 'RESIZE'
config.tab_max_width = 30
-- config.color_scheme = 'Catppuccin Macchiato'
-- config.color_scheme = 'Seafoam Pastel'
-- config.color_scheme = 'Maia (Gogh)'
config.color_scheme = 'Ryuuko'

-- config.font = wezterm.font 'IBM Plex Mono'
-- config.font_size = 14
config.font = wezterm.font_with_fallback({
  { family = 'IBM Plex Mono', scale = scale },
  { family = 'Hack', scale = scale },
  { family = 'Source Code Pro', scale = scale },
})

-- config.window_background_opacity = 0.9

config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.7,
}

config.use_fancy_tab_bar = false
config.status_update_interval = 1000

-- todo: zoom
-- get PaneInformation and zoom info: https://github.com/wez/wezterm/issues/3404
-- get all panes with info https://wezfurlong.org/wezterm/config/lua/MuxTab/index.html
-- loop, if any zoomed, appear zoom icon (left window status)
wezterm.on('update-status', function(window, pane)
    -- Workspace name
  local stat = '󰰯 ' .. window:active_workspace()
  -- local stat_color = "#f7768e"
  -- wezterm.log_info(window:active_pane())

  -- file://ambar/home/gubasso/.dotfiles/wezterm/.config/wezterm/
  local cwd = " " .. basename(pane:get_current_working_dir())
  local cmd = " " .. basename(pane:get_foreground_process_name())

  if window:active_key_table() then
    stat = '󰬔 ' .. window:active_key_table()
    -- stat_color = "#7dcfff"
  end

  if window:leader_is_active() then
    stat = ''
    -- stat_color = "#bb9af7"
  end

  window:set_right_status(wezterm.format({
    { Text = stat },
    { Text = " | " },
    { Text = cwd },
    { Text = " | " },
    { Foreground = { Color = "FFB86C" } },
    { Text = cmd },
    "ResetAttributes",
    { Text = " | " },
  }))
end)

-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
-- function(tab, tabs, panes, config, hover, max_width)
wezterm.on(
  'format-tab-title',
  function(tab, _, _, _, _, _)
    local pane = tab.active_pane
    local zoom = ''
    local cwd_tab = basename(pane.current_working_dir)
    if pane.is_zoomed then
      zoom = ' '
    end
    local title = zoom .. basename(pane.foreground_process_name) .. ' - ' .. cwd_tab
    return {
      { Text = ' ' .. title .. ' ' },
    }
end)



------------------------------------------------------------------------------
-- https://github.com/mrjones2014/smart-splits.nvim --------------------------
------------------------------------------------------------------------------

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

-- local split_nav_keys = {
-- },


------------------------------------------------------------------------------
-- Keys ----------------------------------------------------------------------
------------------------------------------------------------------------------

config.leader = {
  key = 'Space',
  mods = 'CTRL',
  timeout_milliseconds = 1000,
}

config.keys = {
  -- Leader key
  { key = '[', mods = 'LEADER|CTRL', action = act.ActivateCopyMode },
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  -- Command Pallete
  { key = "p", mods = "LEADER|CTRL", action = act.ActivateCommandPalette },
  -- Splits
  {
    key = '-', mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    key = '|', mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  -- Move through panes
  --
  -- { key = 'h', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection("Left") },
  -- { key = 'j', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection("Down") },
  -- { key = 'k', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection("Up") },
  -- { key = 'l', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection("Right") },
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
  -- Close pane
  {
    key = 'x', mods = 'LEADER',
    action = act.CloseCurrentPane { confirm = true }
  },
  -- Zoom
  { key = 'z', mods = 'LEADER|CTRL', action = act.TogglePaneZoomState },
  -- Tabs Keybindings
  -- { key = 'c', mods = 'LEADER|CTRL', action = act.SpawnTab 'DefaultDomain' },
  { key = 'c', mods = 'LEADER|CTRL', action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir }  },
  { key = 'k', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(1) },
  { key = 'j', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(-1) },
  { key = 'Space', mods = 'LEADER|CTRL', action = act.ActivateLastTab },
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      },
      -- function(window, pane, line)
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }
  },
  -- { key = 't', mods = 'LEADER|CTRL', action = act.ShowTabNavigator },
  { key = 't', mods = 'LEADER|CTRL',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|TABS'
    }
  },
  { key = 'm', mods = 'LEADER',
    action = act.ActivateKeyTable { name = 'move_tab', one_shot = false }
  },
  -- Workspaces Keybindings
  { key = 'w', mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES'
    }
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  -- Resize table at config.keys
  -- { key = 'r', mods = 'LEADER',
  --   action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false }
  -- },
  -- Resize table
  -- resize_pane = {
  --   { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
  --   { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
  --   { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
  --   { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
  --   { key = 'Escape', action = 'PopKeyTable' },
  --   { key = 'Enter', action = 'PopKeyTable' },
  -- },
  -- Move tab
  move_tab = {
    { key = 'h', action = act.MoveTabRelative(-1) },
    { key = 'j', action = act.MoveTabRelative(-1) },
    { key = 'k', action = act.MoveTabRelative(1) },
    { key = 'l', action = act.MoveTabRelative(1) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  }
}

-- print("ok")

return config
