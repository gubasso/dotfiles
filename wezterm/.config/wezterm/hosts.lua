local M = {}
local wezterm = require "wezterm"

local scale = 1.3
local default_scheme = "Dracula"
local default_families = { "Hack", "Source Code Pro" }

-- per-host overrides: specify just scheme and an ordered list of font families
local host_settings = {
  valinor = {
    scheme   = "Dracula",
    families = { "Hack", "IBM Plex Mono", "Source Code Pro" },
  },
  tumblesuse = {
    scheme   = "Ryuuko",
    families = { "IBM Plex Mono", "Hack", "Source Code Pro" },
  },
}

--- Build a wezterm font_with_fallback list from family names.
-- @param families table  Array of font family names (strings).
-- @param scale number    Uniform scale to apply to each family.
-- @return table          List of fallback font descriptors.
--
-- Example:
-- build_font_fallback({ "Hack", "Fira Code" }, 1.2)
-- --> {
--       { family = "Hack",      scale = 1.2 },
--       { family = "Fira Code",  scale = 1.2 },
--     }
local function build_font_fallback(families, scale)
  local fallback = {}
  for _, fam in ipairs(families) do
    table.insert(fallback, { family = fam, scale = scale })
  end
  return fallback
end


--- Get host-specific config.
-- @param hostname string  The current machine's hostname.
-- @return table           Config table with `scheme` and `font` fields.
function M.get(hostname)
  local hs = host_settings[hostname] or {
    scheme   = default_scheme,
    families = default_families,
  }

  -- build the wezterm font_fallback list
  local fallback_fonts = build_font_fallback(hs.families, scale)

  return {
    scheme = hs.scheme,
    font   = wezterm.font_with_fallback(fallback_fonts),
  }
end

return M
