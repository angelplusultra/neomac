vim.g.barbar_auto_setup = false -- disable auto-setup
require('barbar').setup {
	icons = {
		-- Configure the base icons on the bufferline.
		-- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
		buffer_index = false,
		buffer_number = false,
		button = '',
		-- Enables / disables diagnostic symbols
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = true },
			[vim.diagnostic.severity.WARN] = { enabled = false },
			[vim.diagnostic.severity.INFO] = { enabled = false },
			[vim.diagnostic.severity.HINT] = { enabled = true },
		},
		-- gitsigns = {
		-- 	added = { enabled = true, icon = '+' },
		-- 	changed = { enabled = true, icon = '~' },
		-- 	deleted = { enabled = true, icon = '-' },
		-- },
	},

	-- highlight = {
	-- 	diagnostic = {
	-- 		error = { guifg = "#FF0000", guibg = nil }, -- Red for errors
	-- 		warn  = { guifg = "#FFA500", guibg = nil }, -- Orange for warnings
	-- 		info  = { guifg = "#00BFFF", guibg = nil }, -- Blue for info
	-- 		hint  = { guifg = "#32CD32", guibg = nil }, -- Green for hints
	-- 	},
	-- },
}
