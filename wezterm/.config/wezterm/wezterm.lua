local wezterm = require 'wezterm'
local hostname = wezterm.hostname()

-- import our host-specific table
local hosts = require 'hosts'
local host_config = hosts.get(hostname)

-- import helpers
local helpers = require 'helpers'
local keymaps = require 'keymaps'
local basename = helpers.basename

-- Use config builder object if possible
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Core defaults
config.default_cwd            = wezterm.home_dir
config.default_workspace      = wezterm.home_dir
config.scrollback_lines       = 5000
config.window_close_confirmation = "AlwaysPrompt"

-- Appearance
config.window_decorations     = 'RESIZE'
config.tab_max_width          = 30
config.inactive_pane_hsb      = { saturation = 0.5, brightness = 0.7 }
config.status_update_interval = 1000

-- Apply host-specific color scheme & font
config.color_scheme = host_config.scheme
config.font         = host_config.font
config.window_background_opacity = 0.8

-- Fetch built-in schemes and sync tab-bar colors
local schemes = wezterm.color.get_builtin_schemes()
config.colors = config.colors or {}
config.colors.tab_bar = schemes[config.color_scheme].tab_bar
config.use_fancy_tab_bar = false


wezterm.on('update-status', function(window, pane)
    -- Workspace name
  local stat = ""

  -- file://ambar/home/gubasso/.dotfiles/wezterm/.config/wezterm/
  local cwd = " " .. basename(pane:get_current_working_dir())
  local cmd = " " .. basename(pane:get_foreground_process_name())

  if window:active_key_table() then
    stat = '󰬔 ' .. window:active_key_table() .. ' |'
  end

  if window:leader_is_active() then
    stat = ' '
  end

  -- pick a single gray for all:
  local gray = "#a5a5a5"

  window:set_right_status(wezterm.format({
    { Foreground = { Color = gray } },
    { Text = stat },
    { Text = " " },
    { Text = cwd },
    { Text = " | " },
    { Text = cmd },
    { Text = " " },
    "ResetAttributes",
  }))
end)

-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
-- function(tab, tabs, panes, config, hover, max_width)
wezterm.on(
  'format-tab-title',
  function(tab, _, _, _, _, _)
    local pane = tab.active_pane
    local tab_number = tab.tab_index + 1 .. ': '

    -- Prefer the user-set title if it exists, otherwise fall back to cwd
    local cwd = basename(pane.current_working_dir)
    local display = (tab.tab_title ~= "" and tab.tab_title) or cwd

    local zoom = ''
    if pane.is_zoomed then
      zoom = ' '
    end
    local title = zoom .. tab_number .. display
    return { { Text = ' ' .. title .. ' ' } }
end)

-- Keys ----------------------------------------------------------

config.leader = {
  key = 'Space',
  mods = 'CTRL',
  timeout_milliseconds = 1000,
}

config.keys = keymaps.get_keys()
config.key_tables = keymaps.get_key_tables()

return config
