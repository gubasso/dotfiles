local M = {}

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    vim.schedule(function()
      fn(name)
    end)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- Function for highlighting the visual selection upon pressing <CR> in Visual mode
function M.highlight_selection()
  -- Yank selection into the * register
  vim.cmd.normal({ '"*y', bang = true })

  -- Read from the * register
  local text = vim.fn.getreg("*")

  -- Escape special characters (\/) and replace newlines
  text = vim.fn.escape(text, "\\/")
  text = vim.fn.substitute(text, "\n", "\\n", "g")

  -- Prepend '\V' for "very nomagic" to match literally
  local searchTerm = "\\V" .. text

  -- Set Vim's search register, print it, add to history, and enable hlsearch
  vim.fn.setreg("/", searchTerm)
  print("/" .. searchTerm)
  vim.fn.histadd("search", searchTerm)
  vim.opt.hlsearch = true
end

-- Function for highlighting the word under cursor on <leader><CR> in Normal mode
function M.highlight_cword()
  -- Expand the <cword>, and wrap it with \v<...> for "very magic" mode
  local cword = vim.fn.expand("<cword>")
  local searchTerm = "\\v<" .. cword .. ">"

  -- Set Vim's search register, print it, add to history, and enable hlsearch
  vim.fn.setreg("/", searchTerm)
  print("/" .. searchTerm)
  vim.fn.histadd("search", searchTerm)
  vim.opt.hlsearch = true
end

function M.open_in_browser()
  local url = vim.fn.expand("<cfile>")
  if url == "" then
    vim.notify("No file/URL under the cursor", vim.log.levels.WARN)
    return
  end

  local open_cmd = "xdg-open"

  -- Run the command as a background job (no shell escaping needed
  -- if you pass arguments as a list)
  vim.fn.jobstart({ open_cmd, url }, { detach = true })
end

return M
