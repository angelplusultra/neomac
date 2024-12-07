local M = {}
M.map = function (keys, func)
	vim.keymap.set('n', keys, func)
end


return M
