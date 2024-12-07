local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)


hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)



local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

require("ibl").setup({
	enabled = false,
	indent = {
		char = "▏",

	},
	scope = {
		enabled = enable,
		highlight = highlight
	}

})
local function configureIndent()
	local filetype = vim.bo.filetype

	if filetype == "ruby" or filetype == "lua" or filetype == "python" then
		vim.cmd("IBLEnable")
	else
		vim.cmd("IBLDisable")
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = configureIndent
})
