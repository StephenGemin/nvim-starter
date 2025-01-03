require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Colemak
local left = "n"
local down = "e"
local up = "i"
local right = "o"

-- -- QWERTY
-- local left = "h"
-- local down = "j"
-- local up = "k"
-- local right = "l"

-- Up/down/left/right
map({ "n", "o", "x" }, left,  "h", { desc = "Left (h)" })
map({ "n", "o", "x" }, down,  "j", { desc = "Down (j)" })
map({ "n", "o", "x" }, up,    "k", { desc = "Up (k)" })
map({ "n", "o", "x" }, right, "l", { desc = "Right (l)" })

-- Insert mode: Ctrl + navigation
map("i", "<C-" .. left  .. ">", "<Left>",  { desc = "Move left" })
map("i", "<C-" .. down  .. ">", "<Down>",  { desc = "Move down" })
map("i", "<C-" .. up    .. ">", "<Up>",    { desc = "Move up" })
map("i", "<C-" .. right .. ">", "<Right>", { desc = "Move right" })

-- Insert/new line
map("n", "s", "i")  -- switch to insert mode before the cursor
map("n", "S", "I")  -- insert text at the beginning of the line
map("n", "t", "o")  -- open a new line below the current one
map("n", "T", "O")  -- open a new line above the current one

-- resizing splits from smart-splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
map('n', "<A-" .. left  .. ">", require('smart-splits').resize_left)
map('n', "<A-" .. down  .. ">", require('smart-splits').resize_down)
map('n', "<A-" .. up    .. ">", require('smart-splits').resize_up)
map('n', "<A-" .. right .. ">", require('smart-splits').resize_right)
-- moving between splits
map('n', "<C-" .. left  .. ">", require('smart-splits').move_cursor_left)
map('n', "<C-" .. down  .. ">", require('smart-splits').move_cursor_down)
map('n', "<C-" .. up    .. ">", require('smart-splits').move_cursor_up)
map('n', "<C-" .. right .. ">", require('smart-splits').move_cursor_right)
map('n', "<C-\\>", require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
map('n', '<leader><leader>'.. left,  require('smart-splits').swap_buf_left)
map('n', '<leader><leader>'.. down,  require('smart-splits').swap_buf_down)
map('n', '<leader><leader>'.. up,    require('smart-splits').swap_buf_up)
map('n', '<leader><leader>'.. right, require('smart-splits').swap_buf_right)

-- QWERTY
-- -- resizing splits
-- -- these keymaps will also accept a range,
-- -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
-- map('n', '<A-h>', require('smart-splits').resize_left)
-- map('n', '<A-j>', require('smart-splits').resize_down)
-- map('n', '<A-k>', require('smart-splits').resize_up)
-- map('n', '<A-l>', require('smart-splits').resize_right)
-- -- moving between splits
-- map('n', '<C-h>', require('smart-splits').move_cursor_left)
-- map('n', '<C-j>', require('smart-splits').move_cursor_down)
-- map('n', '<C-k>', require('smart-splits').move_cursor_up)
-- map('n', '<C-l>', require('smart-splits').move_cursor_right)
-- map('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- -- swapping buffers between windows
-- map('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
-- map('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
-- map('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
-- map('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
