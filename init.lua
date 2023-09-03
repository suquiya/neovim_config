vim.loader.enable()

local g = vim.g
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1

g.loaded_vimball = 1
g.loaded_vimballPlugin = 1

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

g.loaded_2html_plugin = 1
g.loaded_spellfile_plugin = 1
g.loaded_rrhelper = 1

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
map('i','<C-s>','<Esc>:w<CR>')
map('i','<M-s>','<C-o>:w<CR>')
map('i','<C-z>','<C-o>u')
map('n','<C-z>','u')
map('i','<C-y>','<C-o><C-R>')
map('n','<C-y>','<C-R>')
map('i','<C-g>','<C-o>yy')
map('i','<C-p>p','<C-o>p')
map('n','<F3>',':noh<CR>')
map('i','<F3>','<C-o>:noh<CR>')
map('n','<leader>mo',':Mason<CR>')
map('n','<leader>lo',":Lazy<CR>")
map('n','<leader>lu',":Lazy update<CR>")
map('n','<C-\\>',':vs<CR>')
map('i','<C-\\>','<C-o>:vs<CR>')
map('n','<C-x>',':q<CR>')
map('n','<C-c>',':q!<CR>')
map('n','<leader>qq',':q<CR>')
map('n','<leader>qa',':qa<CR>')
map('n','gx',":Neotree toggle<CR>")
map('n','<leader>ex',":Neotree toggle<CR>")
map('n','<leader>eb',":Neotree buffer current<CR>")
map('n','<leader>eg',":Neotree git_status current<CR>")
map('n','<C-l>',"<C-w><C-l>")
map('n','<C-Right>',"<C-w><C-l>")
map('n','<C-k>',"<C-w><C-k>")
map('n','<C-Left>',"<C-w><C-k>")
map('n','<M-e>',":Neotree toggle<CR>")
map('i','<M-e>',"<C-o>:Neotree toggle<CR>")

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
		"williamboman/mason-lspconfig.nvim",
		event={"VimEnter","BufReadPre"},
		opts={
			ensure_installed = {
				"rust_analyzer",
				"lua_ls"
			}
		},
		config=function(_,_opts)
			require("mason-lspconfig").setup(_opts)
			local lspconf = require("lspconfig")
			local gcap = require("cmp_nvim_lsp").default_capabilities()
			lspconf.lua_ls.setup({
				capabilities = gcap,
				settings = {
					Lua = {
						diagnostics={
							globals="vim"
						},
						hint = {enable = true},
						workspace= {
							library=vim.api.nvim_get_runtime_file("",true)
						},
						format = {
							enable = true,
							defaultconfig = {
								indent_style = "tab",
								indent_size = "2"
							}
						}
					}
				}
			})
		end,
		dependencies= {
			{
				"williamboman/mason.nvim",
				event={"VimEnter"},
				opts={},
			},
			{
				"neovim/nvim-lspconfig",
				config=function()
					local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
					for type, icon in pairs(signs) do
						local hl = "DiagnosticSign" .. type
						vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
					end
				end,
				event="VimEnter"
			}
		},
	},
	{
		"simrat39/rust-tools.nvim",
		event="BufReadPre *.rs",
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
	},
	{
		'kkharji/lspsaga.nvim',
		event="VimEnter",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		cmd = {"TSInstall","TSUpdate"},
		event="VeryLazy",
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
		end,
	},
	{
		'windwp/nvim-autopairs',
   	event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event="VeryLazy",
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
		--dependencies = { 'nvim-lua/plenary.nvim', },
		event="VeryLazy",
		cmd="Telescope",
		opts={},
		config = function(_,_opts)
			require('telescope').setup(_opts)
			local builtin = require('telescope.builtin')
			local map_opts = {noremap = true,silent=false}
			vim.keymap.set('n','<leader>ff',builtin.find_files, map_opts)
			vim.keymap.set('n','<leader>fg',builtin.live_grep,map_opts)
			vim.keymap.set('n','<leader>fb',builtin.buffers,map_opts)
			vim.keymap.set('n','<leader>fh',builtin.help_tags,map_opts)
		end
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
	{ 'echasnovski/mini.bufremove', version = false, event="VeryLazy"},
	{
		"kwkarlwang/bufresize.nvim",
		event="VeryLazy"
	},
	{
		"Shatur/neovim-session-manager",
		config = function()
			local config = require('session_manager.config')
			require('session_manager').setup({
				autoload_mode = config.AutoloadMode.LastSession,
				autosave_last_session = true,
			})
		end,
		event="VeryLazy"
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		event="VeryLazy",
		opts = {},
		config = function(_,_opts)
			require("bufferline").setup(_opts)
		end,
		dependencies = {
			{
				'nvim-tree/nvim-web-devicons',
			},
			{
				"nvim-neo-tree/neo-tree.nvim",
				branch = "v3.x",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
					"MunifTanjim/nui.nvim",
				},
				cmd="Neotree",
				opts = {
					close_if_last_window=true,
					source_selector = {
						winbar = true,
						status = true
					},
					filesystem = {
						window = {
							width = 30,
							mappings = {
								["<F5>"] = "refresh",
								["+"] = "open",
							},
						},
						filtered_items = {
							hide_dotfiles = false
						},
						hijack_netrw_behavior = "open_default",
						follow_current_file = {enabled = true}
					}
				}
			},
			{
				'echasnovski/mini.statusline',
				version = false,
				event="BufEnter",
				config=function(_,_)
					require('mini.statusline').setup()
				end,
				dependencies = {
					{'nvim-tree/nvim-web-devicons'},
					{'lewis6991/gitsigns.nvim',opts={}}
				}
			},
		}
	},
	{
		"folke/which-key.nvim",
		cmd = "WhichKey",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		'mvllow/modes.nvim',
		tag = 'v0.2.0',
		config = function()
			require('modes').setup()
		end
	}
},{
	defaults={lazy=true}
})

vim.opt.number = true

vim.opt.list = true
vim.opt.listchars:append "space:."
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:--"
vim.opt.listchars:append "trail:*"



