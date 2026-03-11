return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			--show diagnostics
			vim.diagnostic.enable = true
			vim.diagnostic.config({
				--virtual_lines = true,
				virtual_text = true,
			})
			-- format on save
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end
					if client.supports_method('textDocument/formatting') then
						vim.api.nvim_create_autocmd('BufWritePre', {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
							end,
						})
					end
				end,
			})
			--lua lsp
			vim.lsp.config['lua_ls'] = {
				cmd = { 'lua-language-server' },
				filetypes = { 'lua' },
			}
			vim.lsp.enable('lua_ls')

			--rust lsp
			vim.lsp.config['rust-analyzer'] = {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				setting = {
					['rust-analyzer'] = {
					}
				}
			}
			vim.lsp.enable('rust-analyzer')
		end,
	}
}
