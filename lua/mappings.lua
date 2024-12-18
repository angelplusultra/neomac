local map = require('utils').map

map("<leader>n", ':NvimTreeToggle<CR>')
map('<esc>', ':nohlsearch<CR>')
vim.keymap.set('n', '<leader>p', vim.lsp.buf.format)


map("<S-Right>", ":BufferNext<CR>")
map("<S-Left>", ":BufferPrevious<CR>")
map("<S-BS>", ":BufferClose<CR>")
-- map("<leader>f", ":Prettier<CR>")
map("<leader>pf", ":Prettier<CR>")

map("<leader>db", ":DapToggleBreakpoint<CR>")
map("<leader>dc", ":DapContinue<CR>")
map("<leader>c", ":ChatGPT<CR>")
map("<leader>i", ":ChatGPTEditWithInstructions<CR>")
-- map("<leader>ca", ":lua print('hello')<CR>")
-- Keybinding to open code actions
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code Action" })
map("<leader>ft", ":TodoTelescope keywords=TODO,FIX,BUG,INFO,NOTE,HACK,WARNING <CR>")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>fds', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', function() require('telescope.builtin').diagnostics({ severity_bound = 0 }) end, {})
-- vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end)
-- vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)



vim.keymap.set('i', '<C-A>', 'copilot#Accept("<CR>")', {
	expr = true,
	replace_keycodes = false
})
vim.g.copilot_no_tab_map = true


vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rb",
	callback = function()
		vim.lsp.buf.format();
	end,
})
