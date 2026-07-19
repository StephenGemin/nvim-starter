require "nvchad.autocmds"

-- Rebuild treesitter parsers when neovim's version changes. A parser compiled
-- against an older neovim build can fail with "Parser could not be created for
-- buffer" after an upgrade -- nvim-treesitter's own update() only checks upstream
-- git revision drift, not ABI compatibility, so a forced reinstall is required.
local ts_version_file = vim.fn.stdpath "data" .. "/nvim_version_for_treesitter"

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Rebuild treesitter parsers after a neovim upgrade",
  callback = function()
    local current = tostring(vim.version())

    local cached
    local f = io.open(ts_version_file, "r")
    if f then
      cached = f:read "*a"
      f:close()
    end

    if cached == current then
      return
    end

    vim.schedule(function()
      local ok, treesitter = pcall(require, "nvim-treesitter")
      if not ok then
        vim.notify(
          "autocmds: nvim-treesitter API not found, skipping automatic parser rebuild; run :TSUpdate! manually.",
          vim.log.levels.WARN
        )
        return
      end

      local parsers = treesitter.get_installed()
      if #parsers == 0 then
        return
      end

      vim.notify("Neovim version changed, rebuilding treesitter parsers...", vim.log.levels.INFO)
      -- summary = true makes nvim-treesitter report its own per-parser success/failure,
      -- same as the built-in :TSInstall! command.
      treesitter.install(parsers, { force = true, summary = true })

      local wf = io.open(ts_version_file, "w")
      if wf then
        wf:write(current)
        wf:close()
      end
    end)
  end,
})
