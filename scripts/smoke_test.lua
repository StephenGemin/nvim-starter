-- Headless smoke test for this Neovim config.
--
-- Run after a normal nvim startup (init.lua already sourced), e.g.:
--   nvim --headless -c "luafile scripts/smoke_test.lua"
-- or via scripts/smoke_test_local.sh, which sets up an isolated XDG env first.

local function fail(msg)
  io.stderr:write("SMOKE TEST FAILED: " .. msg .. "\n")
  os.exit(1)
end

-- lazy.nvim funnels plugin `config()`/`opts` runtime errors through
-- vim.notify(level=ERROR) (see lazy.core.util.try)
local notified_errors = {}
local orig_notify = vim.notify
vim.notify = function(msg, level, notify_opts)
  if level == vim.log.levels.ERROR then
    table.insert(notified_errors, msg)
  end
  return orig_notify(msg, level, notify_opts)
end

local ok, err = pcall(function()
  -- force every plugin to load
  vim.cmd "Lazy! load all"

  -- Open a real buffer per filetype in active use, to fire ft-autocmds /
  -- LSP-attach / treesitter-attach for each.
  for _, ft in ipairs { "lua", "html", "css", "markdown" } do
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = ft
    vim.cmd "doautocmd FileType"
  end

  -- Give scheduled work a chance to run before checking for errors.
  vim.wait(2000)
end)

vim.notify = orig_notify

if not ok then
  fail("error while exercising config: " .. tostring(err))
end

-- Also check lazy.nvim's own install/build task errors (clone, checkout,
-- build) -- a different failure point than the vim.notify capture above,
-- which only catches plugin config()/opts errors.
local has_task_errors = false
for name, plugin in pairs(require("lazy.core.config").spec.plugins) do
  if require("lazy.core.plugin").has_errors(plugin) then
    has_task_errors = true
    io.stderr:write("lazy.nvim: " .. name .. " has install/build errors\n")
  end
end

if #notified_errors > 0 then
  io.stderr:write(table.concat(notified_errors, "\n") .. "\n")
end

if has_task_errors or #notified_errors > 0 then
  fail "one or more plugins failed to load"
end

io.stderr:write "SMOKE TEST PASSED\n"
os.exit(0)
