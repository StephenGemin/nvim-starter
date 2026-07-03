require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers

-- wezterm-types stub, installed via dotfiles chezmoiexternal (~/.config/wezterm-types).
-- Mirrors NvChad's own lua_ls library (nvchad/configs/lspconfig.lua) plus the
-- wezterm-types path -- re-list all entries since vim.lsp.config merges by
-- overwriting matching keys, not appending arrays.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
          vim.fn.expand "~/.config/wezterm-types",
        },
      },
    },
  },
})
