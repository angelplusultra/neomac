require("toggleterm").setup {
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	float_opts = {

		border = 'curved',
		width = 80,
		height = 20

	}


}

local map = require('utils').map

map('<leader>v', ':ToggleTerm direction=vertical<CR> a')
map('<leader>h', ':ToggleTerm direction=float<CR> a')
vim.keymap.set('t', '<leader>v', "<C-\\><C-n>:ToggleTerm <CR>,", {})
vim.keymap.set('t', '<leader>h', "<C-\\><C-n>:ToggleTerm <CR>,", {})
