vim.loader.enable()

vim.opt.tabstop=3
vim.opt.shiftwidth=3

local map = function(mode,keys,to,_opts)
	local opts = {noremap = true,silent=false}
	if _opts then 
		opts = vim.tbl_extend('force',opts,_opts)
	end
	vim.keymap.set(mode,keys,to,opts)
end

vim.g.mapleader=" "

map('i','jj','<Esc>')
map('i','<C-j><C-k>','<Esc>')
map('n','<C-s>',':w<CR>')
map('i','<C-s>','<C-o>:w<CR>')
map('i','<C-z>','<C-o>u')
map('n','<C-z>','u')
map('i','yy','<C-o>yy')
map('i','<C-p>p','<C-o>p')
map('n','<F3>',':noh<CR>')
map('i','<F3>','<C-o>:noh<CR>')
map('n','<leader>mo',':Mason<CR>')
map('n','<leader>lo',":Lazy<CR>")
map('n','<leader>lu',":Lazy update<CR>")
map('n','<C-\\>',':vs<CR>')
map('n','<C-x>',':q<CR>')
map('n','qqq',':q<CR>')
map('n','qqa',':qa<CR>')

-- Lazyのセットアップ（インストールできていなかったら取り寄せ）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
	"git",
	 "clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable", -- latest stable release
	lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"williamboman/mason.nvim"
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig"
	},
	{
		"simrat39/rust-tools.nvim",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local rt = require("rust-tools")
			rt.setup({
				tools = {
					inlay_hints = {
						parameter_hints_prefix = "←",
						other_hints_prefix = "⇒",
					}
				},
				server = {
					on_attach = function(_, bufnr)
						-- Hover actions
						vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
					server = {
						settings = {
							["rust-analyzer"] = {
								checkOnSave = true,
								check = {
									command = "clippy",
									features = "all"
								}
							}
						},
						capabilities = capabilities,
					}
				},
			})
		end,
		ft="rs"
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require('nvim-treesitter.configs').setup{
				ensure_installed = {"lua","rust"},
				auto_install=true,
				highlight = {
					enable = true,
				},
				ident = {
					enable=true,
				},
			}
			-- require 'nvim-treesitter.install'.prefer_git = false
		end
	},
	{
		'windwp/nvim-autopairs',
   	event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event="BufRead",
		config = function()
			require("indent_blankline").setup {
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
				show_current_context_start = true,
			}
		end
	},
	{
		'numToStr/Comment.nvim',
		opts = {
			-- add any options here
		},
		event="InsertEnter"
	},
	{
		'nvim-lua/plenary.nvim',
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		--dependencies = { 'nvim-lua/plenary.nvim' },
		cmd="Telescope"
	},
	{
		'nmac427/guess-indent.nvim',
		cmd="GuessIndent",
		event="InsertEnter",
		config = function()
			require('guess-indent').setup{}
		end
	},
	{
		'hrsh7th/nvim-cmp',
		event={"InsertEnter","CmdlineEnter"},
		config = function()
			-- completion setup
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						col_offset = 0,
						side_padding= 0
					}),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<S-Tab>'] = cmp.mapping.select_prev_item(),
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.close(),
					['<CR>'] = cmp.mapping.confirm { select = false }
				}),
				sources = cmp.config.sources({
					{ name = 'path' }, -- file paths
					{ name = 'nvim_lsp'}, -- from language server
					{ name = "nvim_lsp_signature_help" },
					{ name = 'nvim_lua'}, -- complete neovim's Lua runtime API such vim.lsp.*
					{ name = 'buffer',keyword_length = 3}, -- source current buffer
					{ name = 'calc'}, -- source for math calculation
				}),
				preselect = cmp.PreselectMode.None,
				formatting = {
					fields = {'abbr','kind','menu'},
					format = function(entry,item)
						local src = {
							nvim_lsp = 'lsp',
							luasnip = 'snip',
							buffer = 'buf',
							path = 'path',
							cmdline = 'cmd',
							nvim_lua = 'lua',
							calc = 'calc',
							nvim_lsp_signature_help = 'nlsh'
						};
						item.menu = src[entry.source.name]
						return item
					end,
				}
			})

			cmp.setup.cmdline({'/','?'},{
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{name='buffer'}
				}
			})

			cmp.setup.cmdline(':',{
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources(
				{
					{name='path'}
				},
				{
					{name="cmdline"}
				})
			})
		end
	},
	{'hrsh7th/cmp-nvim-lsp',event="InsertEnter"},
	{"hrsh7th/cmp-nvim-lsp-signature-help",event="InsertEnter"},
	{'hrsh7th/cmp-buffer',event={"InsertEnter","CmdlineEnter"}},
	{'hrsh7th/cmp-path',event={"InsertEnter","CmdlineEnter"}},
	{ "hrsh7th/cmp-nvim-lua",event="InsertEnter *.lua"},
	{'hrsh7th/cmp-cmdline',event="CmdlineEnter"},
	
	{ "L3MON4D3/LuaSnip",event="InsertEnter"},
	{ "saadparwaiz1/cmp_luasnip",event="InsertEnter"},
	{ 'echasnovski/mini.bufremove', version = false, event="BufRead"},
	{
		"kwkarlwang/bufresize.nvim",
		event="VimEnter"
	},
	{
		"Shatur/neovim-session-manager",
		config = function()
		local path = require('plenary.path');
		local config = require('session_manager.config')
		require('session_manager').setup({
			autoload_mode = config.AutoloadMode.LastSession,
			autosave_last_session = true,
		})
		end,
		event="VimEnter"
	},
},{
	defaults={lazy=true}
})

vim.opt.list = true
vim.opt.listchars:append "space:."
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:--"
vim.opt.listchars:append "trail:*"

require("mason").setup();

require("mason-lspconfig").setup({
	ensure_installed = {
		 "rust_analyzer"
	 },
});

