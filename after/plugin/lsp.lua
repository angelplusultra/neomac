local on_attach = function(_, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set('n', keys, func, { buffer = bufnr })
	end

	bufmap('<leader>r', vim.lsp.buf.rename)
	bufmap('<leader>a', vim.lsp.buf.code_action)
	bufmap('gd', vim.lsp.buf.definition)
	bufmap('gD', vim.lsp.buf.declaration)
	bufmap('gI', vim.lsp.buf.implementation)
	bufmap('<leader>D', vim.lsp.buf.type_definition)
	bufmap('K', vim.lsp.buf.hover)
	bufmap('gl', vim.diagnostic.open_float)

	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, {})
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


require('mason').setup()

require('mason-lspconfig').setup_handlers({
	function(server_name)
		if server_name == 'rust_analyzer' then
			vim.lsp.inlay_hint.enable(true, { 0 })

			require("lspconfig")["rust_analyzer"].setup {

				on_attach = on_attach,
				capabilities = capabilities
			}
			return
		else
			require('lspconfig')[server_name].setup {
				on_attach = on_attach,
				capabilities = capabilities
			}
		end
	end,


	['lua_ls'] = function()
		require('neodev').setup()
		require('lspconfig').lua_ls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				}

			},
		}
	end,

})
