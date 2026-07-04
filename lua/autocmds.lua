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
      local install_ok, install = pcall(require, "nvim-treesitter.install")
      local info_ok, info = pcall(require, "nvim-treesitter.info")
      if not (install_ok and info_ok) then
        return
      end

      local parsers = info.installed_parsers()
      if #parsers == 0 then
        return
      end

      vim.notify("Neovim version changed, rebuilding treesitter parsers...", vim.log.levels.INFO)

      local force_install = install.commands.TSInstallSync["run!"]
      local ok = pcall(force_install, unpack(parsers))

      if ok then
        local wf = io.open(ts_version_file, "w")
        if wf then
          wf:write(current)
          wf:close()
        end
        vim.notify("Treesitter parsers rebuilt for this Neovim version.", vim.log.levels.INFO)
      else
        vim.notify("Failed to rebuild treesitter parsers automatically; run :TSInstall! manually.", vim.log.levels.WARN)
      end
    end)
  end,
})
