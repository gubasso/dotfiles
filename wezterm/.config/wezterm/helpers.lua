local wezterm = require "wezterm"

local M = {}

function M.basename(s)
  local str = tostring(s)
  local base = str:match("([^/]+)/?$")
  return base
end


-- https://github.com/mrjones2014/smart-splits.nvim -----------

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

function M.split_nav(resize_or_move, key)
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

local mods_tbl = {
  l  = "LEADER",
  lc = "LEADER|CTRL",
  ls = "LEADER|SHIFT",
  s  = "SUPER",
  c = "CTRL",
  n = "NONE",
}

function M.mk_binding(mods, key, action)
  local chosen_mods = mods_tbl[mods] or "LEADER"
  return { key = key, mods = chosen_mods, action = action }
end


return M
