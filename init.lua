vim.loader.enable()

local g = vim.g

-- 各種不要なビルトインプラグインを無効に
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
g.loaded_tutor_mode_plugin = 1

vim.opt.tabstop=3
vim.opt.shiftwidth=3

local map = function(mode,keys,to,_opts)
	local opts = {noremap = true,silent=true}
	if _opts then
		opts = vim.tbl_extend('force',opts,_opts)
	end
	vim.keymap.set(mode,keys,to,opts)
end
vim.g.mapleader=" "

local nsopt = {silent=false}
map('i','jj','<Esc>')
map('i','<C-j><C-k>','<Esc>')
map('n','<C-s>',':w<CR>')
map('i','<C-s>','<C-o>:w<CR>')
map('i','<M-s>','<C-o>:w<CR>')
map('i','<C-z>','<C-o>u')
map('n','<C-z>','u')
map('i','<C-y>','<C-o><C-R>')
map('n','<C-y>','<C-R>')
map('i','<C-g>','<C-o>yy')
map('i','<C-p>p','<C-o>p')
map('i','<C-f>','<Esc>/',nsopt)
map('n','<C-f>','/',nsopt)
map('n','<F3>',':noh<CR>')
map('i','<F3>','<C-o>:noh<CR>')
-- map('n','<leader>mo',':Mason<CR>')
-- map('n','<leader>lo',":Lazy<CR>")
-- map('n','<leader>lu',":Lazy update<CR>")
map('n','<C-\\>',':vs<CR>')
map('i','<C-\\>','<C-o>:vs<CR>')
map('n','<C-x>',':q<CR>')
map('n','<C-c>',':q!<CR>')
map('n','<leader>qq',':q<CR>')
map('n','<leader>qa',':qa<CR>')
-- map('n','gx',":Neotree toggle<CR>")
-- map('n','<leader>ex',":Neotree toggle<CR>")
-- map('n','<leader>eb',":Neotree buffer current<CR>")
-- map('n','<leader>eg',":Neotree git_status current<CR>")
map('n','<C-l>',"<C-w><C-l>")
map('n','<C-Right>',"<C-w><C-l>")
map('n','<C-k>',"<C-w><C-k>")
map('n','<C-Left>',"<C-w><C-k>")
-- map('n','<M-e>',":Neotree toggle<CR>")
-- map('i','<M-e>',"<C-o>:Neotree toggle<CR>")
-- map('n','<leader>ff',":Telescope find_files<CR>")
-- map('n','<leader>bb',":Telescope buffers<CR>")
-- map('n','<leader>fb',":Telescope buffers<CR>")
-- map('n','<leader>fr',":Telescope frecency<CR>")
-- map('n','<leader>cc',":Telescope frecency<CR>")
-- map('n','<leader><leader>f',":Telescope frecency<CR>")
-- map('n','<leader>t',":Telescope",nsopt)
-- map('n','<M-t>',":Telescope",nsopt)
-- map('i','<M-t>',"<Esc>:Telescope",nsopt)
-- map('n',"<M-w>", ':Telescope buffers<CR>')
-- map('i','<M-w>','<C-o>:Telescope buffers<CR>')
map('i','<C-P>','<Esc>:',nsopt)

-- tablineまわり
vim.opt.showtabline = 0
local function toggle_buffer_line()
	vim.opt.showtabline = vim.opt.showtabline + 1 % 3
end
map('n','<leader>bl',toggle_buffer_line)

-- Lazyのセットアップ（インストールできていなかったら取り寄せ）
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
-- 	vim.fn.system({
-- 	"git",
-- 	"clone",
-- 	"--filter=blob:none",
-- 	"https://github.com/folke/lazy.nvim.git",
-- 	"--branch=stable", -- latest stable release
-- 	lazypath,
-- })
-- end
-- vim.opt.rtp:prepend(lazypath)
vim.opt.whichwrap = 'h,l,<,>,[,],~'

-- require("lazy").setup({
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		event={"VimEnter","BufReadPre"},
-- 		opts={
-- 			ensure_installed = {
-- 				"rust_analyzer",
-- 				"lua_ls"
-- 			}
-- 		},
-- 		config=function(_,_opts)
-- 			require("mason-lspconfig").setup(_opts)
-- 			local lspconf = require("lspconfig")
-- 			local gcap = require("cmp_nvim_lsp").default_capabilities()
-- 			lspconf.lua_ls.setup({
-- 				capabilities = gcap,
-- 				settings = {
-- 					Lua = {
-- 						diagnostics={
-- 							globals={"vim"}
-- 						},
-- 						hint = {enable = true},
-- 						workspace= {
-- 							library=vim.api.nvim_get_runtime_file("",true),
-- 							checkThirdParty = false,
-- 						},
-- 						format = {
-- 							enable = true,
-- 							defaultconfig = {
-- 								indent_style = "tab",
-- 								indent_size = "2"
-- 							}
-- 						}
-- 					}
-- 				}
-- 			})
-- 			map('n','<space>e',vim.diagnostic.open_float)
-- 			map('n','[d',vim.diagnostic.goto_prev)
-- 			map('n',']d',vim.diagnostic.goto_next)
-- 			map('n','<space>q',vim.diagnostic.setloclist)
--
-- 			-- LspAttachにキーマッピング設定を入れ込む
-- 			vim.api.nvim_create_autocmd('LspAttach',{
-- 				group = vim.api.nvim_create_augroup('UserLspConfig',{}),
-- 				callback = function(ev)
-- 					-- <c-x><c-o>で補完が可能になる？
-- 					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
--
-- 					-- マッピング
-- 					local opts = {buffer = ev.buf}
-- 					map('n','K',vim.lsp.buf.hover,opts)
-- 					map('n','gD',vim.lsp.buf.declaration,opts)
-- 					map('n','gd',vim.lsp.buf.definition,opts)
-- 				end
-- 			})
-- 		end,
-- 		dependencies= {
-- 			{
-- 				"williamboman/mason.nvim",
-- 				event={"VimEnter"},
-- 				opts={},
-- 			},
-- 			{
-- 				"neovim/nvim-lspconfig",
-- 				config=function()
-- 					local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
-- 					for type, icon in pairs(signs) do
-- 						local hl = "DiagnosticSign" .. type
-- 						vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- 					end
-- 				end,
-- 				event="VimEnter"
-- 			}
-- 		},
-- 	},
-- 	{
-- 		'mrcjkb/rustaceanvim',
-- 		version = '^3', -- Recommended,
-- 		config=function()
-- 			vim.g.rustaceanvim = {
-- 				tools ={
-- 					inlay_hints ={
-- 						parameter_hints_prefix = "←",
-- 						other_hints_prefix = "⇒",
-- 					}
-- 				},
-- 				server = {
-- 					on_attach = function(_,bufnr)
-- 						-- Hover actions
-- 						vim.keymap.set("n","<C-space>", vim.lsp.buf.hover(), {buffer = bufnr})
-- 						-- Code action groups
-- 						local codeAction = function ()
-- 							vim.cmd.RustLsp('codeAction')
-- 						end
-- 						vim.keymap.set("n","<Leader>a",codeAction,{buffer=bufnr})
-- 					end,
-- 					settings = {
-- 						["rust-analyzer"] = {
-- 							checkOnSave = true,
-- 							check = {
-- 								command="clippy",
-- 								features = "all"
-- 							}
-- 						}
-- 					}
-- 				}
-- 			}
-- 		end,
-- 		ft = { 'rust' },
-- 	},
-- 	{
-- 		'kkharji/lspsaga.nvim',
-- 		event="VimEnter",
-- 		config=function()
-- 			local lspsaga = require 'lspsaga'
-- 			lspsaga.setup {
-- 			debug = false,
-- 			use_saga_diagnostic_sign = true,
-- 			-- diagnostic sign
-- 			error_sign = "󰅚",
-- 			warn_sign = "󰀪",
-- 			hint_sign = "󰌶",
-- 			infor_sign = "",
-- 			diagnostic_header_icon = "   ",
-- 			-- code action title icon
-- 			code_action_icon = "󰌵",
-- 			code_action_prompt = {
-- 				enable = true,
-- 				sign = true,
-- 				sign_priority = 40,
-- 				virtual_text = true,
-- 			},
-- 			finder_definition_icon = "  ",
-- 			finder_reference_icon = "  ",
-- 			max_preview_lines = 10,
-- 			finder_action_keys = {
-- 				open = "o",
-- 				vsplit = "s",
-- 				split = "i",
-- 				quit = "q",
-- 				scroll_down = "<C-f>",
-- 				scroll_up = "<C-b>",
-- 			},
-- 			code_action_keys = {
-- 				quit = "q",
-- 				exec = "<CR>",
-- 			},
-- 			rename_action_keys = {
-- 				quit = "<C-c>",
-- 				exec = "<CR>",
-- 			},
-- 			definition_preview_icon = "󰀹",
-- 			border_style = "single",
-- 			rename_prompt_prefix = "➤",
-- 			rename_output_qflist = {
-- 				enable = false,
-- 				auto_open_qflist = false,
-- 			},
-- 			server_filetype_map = {},
-- 			diagnostic_prefix_format = "%d. ",
-- 			diagnostic_message_format = "%m %c",
-- 			highlight_prefix = false,
-- 		}
-- 		end
-- 	},
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		build = ":TSUpdateSync",
-- 		cmd = {"TSInstall","TSUpdate"},
-- 		event="BufReadPre",
-- 		config = function()
-- 			require('nvim-treesitter.configs').setup{
-- 				ensure_installed = {"lua","rust"},
-- 				auto_install=true,
-- 				highlight = {
-- 					enable = true,
-- 					disable={"rust"}
-- 				},
-- 				ident = {
-- 					enable=true,
-- 					disable={"rust"}
-- 				},
-- 			}
-- 			require 'nvim-treesitter.install'.prefer_git = false
-- 		end,
-- 	},
-- 	{
-- 		'windwp/nvim-autopairs',
-- 		event = "InsertEnter",
-- 		opts = {} -- this is equalent to setup({}) function
-- 	},
-- 	{
-- 		"lukas-reineke/indent-blankline.nvim",
-- 		event={"VeryLazy"},
-- 		config=function()
-- 			require('ibl').setup{
-- 				 indent = {
-- 					 char = {"│"},
-- 					 tab_char = {"│"}
-- 				 },
-- 			}
-- 		end,
-- 		dependencies = { 'nvim-treesitter/nvim-treesitter' },
-- 	},
-- 	-- {
-- 	-- 	'numToStr/Comment.nvim',
-- 	-- 	keys={"gc","gcc","gb"},
-- 	-- 	opts = {
-- 	-- 		-- add any options here
-- 	-- 	},
-- 	-- 	event="InsertEnter"
-- 	-- },
-- 	{
-- 		'nvim-lua/plenary.nvim',
-- 	},
-- 	{
-- 		'nvim-telescope/telescope.nvim',
-- 		branch = '0.1.x',
-- 		--dependencies = { 'nvim-lua/plenary.nvim', },
-- 		event="VeryLazy",
-- 		cmd="Telescope",
-- 		config = function(_,_)
-- 			local actions = require("telescope.actions")
-- 			local action_layout = require('telescope.actions.layout')
-- 			local opts = {
-- 				defaults = {
-- 					mappings = {
-- 						n = {
-- 							["<M-p>"] = action_layout.toggle_preview
-- 						},
-- 						i = {
-- 							["<M-p>"] = action_layout.toggle_preview
-- 						}
-- 					}
-- 				},
-- 				pickers = {
-- 					colorscheme = {
-- 						enable_preview = true
-- 					},
-- 					buffers = {
-- 						mappings = {
-- 							i = {
-- 								["<C-d>"] = actions.delete_buffer
-- 							},
-- 							n = {
-- 								["<C-d>"] = actions.delete_buffer
-- 							}
-- 						}
-- 					}
-- 				}
-- 			}
-- 			require('telescope').setup(opts)
-- 			local builtin = require('telescope.builtin')
-- 			local map_opts = {noremap = true,silent=false}
-- 			map('n','<leader>bb',":Telescope buffers<CR>")
--
-- 			map('n',"<M-w>", ':Telescope buffers<CR>')
-- 			map('i','<M-w>','<C-o>:Telescope buffers<CR>')
--
-- 			local ff = builtin.find_files
-- 			map('n','<leader>ff',ff, map_opts)
-- 			map('n','<leader>fg',builtin.live_grep,map_opts)
-- 			local fb = builtin.buffers
-- 			map('n','<leader>fb',fb,map_opts)
-- 			map('n','<leander>bb',fb,map_opts)
-- 			map('n','<leader>fh',builtin.help_tags,map_opts)
-- 			require('telescope').load_extension('fzf')
-- 			--require('telescope').load_extension('session-lens')
-- 			require("telescope").load_extension("frecency")
-- 			require("telescope").load_extension("file_browser")
-- 			require("telescope").load_extension("lazy")
-- 			require('telescope').load_extension('project')
-- 			require('telescope').load_extension("undo")
-- 			require'telescope'.load_extension('repo')
-- 			require('telescope').load_extension('possession')
--
-- 			map('n','<leader>ft',':Telescope telescope-tabs list_tabs<CR>');
-- 		end,
-- 		dependencies ={
-- 			{
-- 				'nvim-telescope/telescope-fzf-native.nvim',
-- 				build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
-- 			},
-- 			{
-- 				"nvim-telescope/telescope-frecency.nvim",
-- 			},
-- 			{
-- 				"nvim-telescope/telescope-file-browser.nvim",
-- 			},
-- 			{
-- 				"tsakirist/telescope-lazy.nvim"
-- 			},
-- 			{
-- 				"nvim-telescope/telescope-project.nvim"
-- 			},
-- 			{
-- 				"debugloop/telescope-undo.nvim",
-- 			},
-- 			{
-- 				'cljoly/telescope-repo.nvim'
-- 			},
-- 			{
-- 				'LukasPietzschmann/telescope-tabs',
-- 			}
-- 		}
-- 	},
-- 	{
-- 		"cshuaimin/ssr.nvim",
-- 		keys="<leader>sr",
-- 		config=function ()
-- 			local ssr = require("ssr")
-- 			ssr.setup({
-- 				border="rounded",
-- 				min_width=50,
-- 				max_width=120,
-- 				max_height=25,
-- 				keymaps={
-- 					close="q",
-- 					next_match="n",
-- 					prev_match="N",
-- 					replace_confirm="<cr>",
-- 					replace_all="<leader><cr>"
-- 				}
-- 			})
-- 			map('n','<leader>sr',ssr.open)
-- 		end
-- 	},
-- 	{
-- 		'nmac427/guess-indent.nvim',
-- 		cmd="GuessIndent",
-- 		event="InsertEnter",
-- 		config = function()
-- 			require('guess-indent').setup{}
-- 		end
-- 	},
-- 	{
-- 		'hrsh7th/nvim-cmp',
-- 		event={"InsertEnter","CmdlineEnter"},
-- 		config = function()
-- 			-- completion setup
-- 			local cmp = require('cmp')
-- 			cmp.setup({
-- 				snippet = {
-- 					expand = function(args)
-- 						require("luasnip").lsp_expand(args.body)
-- 					end,
-- 				},
-- 				window = {
-- 					completion = cmp.config.window.bordered({
-- 						col_offset = 0,
-- 						side_padding= 0
-- 					}),
-- 					documentation = cmp.config.window.bordered(),
-- 				},
-- 				mapping = cmp.mapping.preset.insert({
-- 					['<S-Tab>'] = cmp.mapping.select_prev_item(),
-- 					['<Tab>'] = cmp.mapping.select_next_item(),
-- 					['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
-- 					['<C-f>'] = cmp.mapping.scroll_docs(4),
-- 					['<C-Space>'] = cmp.mapping.complete(),
-- 					['<C-e>'] = cmp.mapping.close(),
-- 					['<CR>'] = cmp.mapping.confirm { select = false }
-- 				}),
-- 				sources = cmp.config.sources({
-- 					{ name = 'path' }, -- file paths
-- 					{ name = 'nvim_lsp'}, -- from language server
-- 					{ name = "nvim_lsp_signature_help" },
-- 					{ name = 'nvim_lua'}, -- complete neovim's Lua runtime API such vim.lsp.*
-- 					{ name = 'buffer',keyword_length = 3}, -- source current buffer
-- 					{ name = 'calc'}, -- source for math calculation
-- 				}),
-- 				preselect = cmp.PreselectMode.None,
-- 				formatting = {
-- 					fields = {'abbr','kind','menu'},
-- 					format = function(entry,item)
-- 						local src = {
-- 							nvim_lsp = 'lsp',
-- 							luasnip = 'snip',
-- 							buffer = 'buf',
-- 							path = 'path',
-- 							cmdline = 'cmd',
-- 							nvim_lua = 'lua',
-- 							calc = 'calc',
-- 							nvim_lsp_signature_help = 'nlsh'
-- 						};
-- 						item.menu = src[entry.source.name]
-- 						return item
-- 					end,
-- 				}
-- 			})
--
-- 			cmp.setup.cmdline({'/','?'},{
-- 				mapping = cmp.mapping.preset.cmdline(),
-- 				sources = {
-- 					{name='buffer'}
-- 				}
-- 			})
--
-- 			cmp.setup.cmdline(':',{
-- 				mapping = cmp.mapping.preset.cmdline(),
-- 				sources = cmp.config.sources(
-- 				{
-- 					{name='path'}
-- 				},
-- 				{
-- 					{name="cmdline"}
-- 				})
-- 			})
-- 		end
-- 	},
-- 	{'hrsh7th/cmp-nvim-lsp',event="InsertEnter"},
-- 	{"hrsh7th/cmp-nvim-lsp-signature-help",event="InsertEnter"},
-- 	{'hrsh7th/cmp-buffer',event={"InsertEnter","CmdlineEnter"}},
-- 	{'hrsh7th/cmp-path',event={"InsertEnter","CmdlineEnter"}},
-- 	{ "hrsh7th/cmp-nvim-lua",event="InsertEnter *.lua"},
-- 	{'hrsh7th/cmp-cmdline',event="CmdlineEnter"},
-- 	{ "L3MON4D3/LuaSnip",event="InsertEnter"},
-- 	{ "saadparwaiz1/cmp_luasnip",event="InsertEnter"},
-- 	{
-- 		"kwkarlwang/bufresize.nvim",
-- 		event="VeryLazy"
-- 	},
-- 	{
-- 		"utilyre/barbecue.nvim",
-- 		name = "barbecue",
-- 		event="VeryLazy",
-- 		version = "*",
-- 		dependencies = {
-- 			"SmiteshP/nvim-navic",
-- 			"nvim-tree/nvim-web-devicons", -- optional dependency
-- 		},
-- 		opts = {
-- 			-- configurations go here
-- 		},
-- 	},
-- 	{
-- 		"folke/noice.nvim",
-- 		event = "VimEnter",
-- 		opts = {
-- 			-- add any options here
-- 			popupmenu = {
-- 				-- cmp-cmdline has more sources and can be extended
-- 				backend = "cmp", -- backend to use to show regular cmdline completions
-- 			},
-- 			lsp = {
-- 				-- can not filter null-ls's data
-- 				-- j-hui/fidget.nvim
-- 				progress = {
-- 					enabled = false,
-- 				},
-- 			},
-- 			messages = {
-- 				-- Using kevinhwang91/nvim-hlslens because virtualtext is hard to read
-- 				view_search = false,
-- 			},
-- 		},
-- 		config= function(_,_opts)
-- 			require('noice').setup(_opts)
-- 			vim.keymap.set("c", "<S-Enter>", function()
-- 				require("noice").redirect(vim.fn.getcmdline())
-- 			end, { desc = "Redirect Cmdline" })
-- 		end,
-- 		dependencies = {
-- 			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
-- 			"MunifTanjim/nui.nvim",
-- 			-- OPTIONAL:
-- 			--   `nvim-notify` is only needed, if you want to use the notification view.
-- 			--   If not available, we use `mini` as the fallback
-- 			--"rcarriga/nvim-notify",
-- 		}
-- 	},
-- 	--[[{
-- 		'akinsho/bufferline.nvim',
-- 		version = "*",
-- 		opts = {},
-- 		config = function(_,_opts)
-- 			require("bufferline").setup(_opts)
-- 		end,
-- 		keys = "<leader>bl";
-- 		dependencies = {
-- 			{
-- 				'nvim-tree/nvim-web-devicons',
-- 			},
-- 			--{
-- 			--	"nvim-neo-tree/neo-tree.nvim",
-- 			--}
-- 		}
-- 	},]]--
-- 	{
-- 		'jedrzejboczar/possession.nvim',
-- 		event="VimEnter",
-- 		opts={
-- 			commands = {
-- 				save="SSave",
-- 				load="Sload",
-- 				delete="Sdelete",
-- 				list="Slist"
-- 			}
-- 		},
-- 		dependencies = {
-- 			'nvim-lua/plenary.nvim'
-- 		}
-- 	},
-- 	{
-- 		"nvim-neo-tree/neo-tree.nvim",
-- 		branch = "v3.x",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
-- 			"MunifTanjim/nui.nvim",
-- 		},
-- 		cmd="Neotree",
-- 		opts = {
-- 			close_if_last_window=true,
-- 			source_selector = {
-- 				winbar = true,
-- 				status = true
-- 			},
-- 			filesystem = {
-- 				window = {
-- 					width = 30,
-- 					mappings = {
-- 						["<F5>"] = "refresh",
-- 						["+"] = "open",
-- 					},
-- 				},
-- 				filtered_items = {
-- 					visible=true,
-- 					hide_dotfiles = false
-- 				},
-- 				hijack_netrw_behavior = "open_default",
-- 				follow_current_file = {enabled = true}
-- 			}
-- 		}
-- 	},
-- 	{
-- 		'echasnovski/mini.nvim',
-- 		version = false,
-- 		event={"BufEnter","VeryLazy"},
-- 		config=function(_,_)
-- 			require('mini.statusline').setup()
-- 			require('mini.bufremove').setup()
-- 			require('mini.comment').setup()
-- 			require('mini.bracketed').setup()
-- 			require('mini.cursorword').setup()
-- 			require('mini.move').setup()
-- 			require('mini.splitjoin').setup()
-- 			require('mini.surround').setup()
-- 			require('mini.trailspace').setup({})
-- 		end,
-- 		dependencies = {
-- 			{'nvim-tree/nvim-web-devicons'},
-- 			{'lewis6991/gitsigns.nvim',opts={}}
-- 		}
-- 	},
-- 	{
-- 		'dstein64/nvim-scrollview',
-- 		event='BufEnter',
-- 		config=function ()
-- 			require('scrollview').setup({
-- 				scrollview_signs_on_startup={'all'}
-- 			})
-- 		end
-- 	},
-- 	{
-- 		"folke/which-key.nvim",
-- 		cmd = "WhichKey",
-- 		config = function()
-- 			vim.o.timeout = true
-- 			vim.o.timeoutlen = 300
-- 		end,
-- 		opts = {},
-- 	},
-- 	{
-- 		'mvllow/modes.nvim',
-- 		tag = 'v0.2.0',
-- 		config = function()
-- 			require('modes').setup()
-- 		end
-- 	},
-- 	--[[{
-- 		'rmagatti/auto-session',
-- 		event="VimEnter",
-- 		opts = {
-- 			log_level = "error",
-- 		}
-- 	},]]--
-- 	{
-- 		'akinsho/toggleterm.nvim',
-- 		version = "*",
-- 		event="VimEnter",
-- 		config=function ()
-- 			require("toggleterm").setup({
-- 				open_mapping = [[<M-t>]],
-- 			})
-- 		end
-- 	},
-- 	-- カラースキームたち
-- 	{ "EdenEast/nightfox.nvim",event="VeryLazy" },
-- 	{'marko-cerovac/material.nvim',event="VeryLazy"},
-- 	{
-- 		"folke/tokyonight.nvim",
-- 		event="VeryLazy",
-- 		opts = {},
-- 	}
-- },{
-- 	defaults={lazy=true}
-- })

vim.opt.number = true

vim.opt.list = true
vim.opt.listchars:append "space:."
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:--"
vim.opt.listchars:append "trail:*"


if vim.g.neovide then
	vim.o.guifont="PlemolJP_Console_NF:h14"
	--'Cascadia Code','Cascadia Code','Martian Mono Std Lt','PlemolJP Console NF','FantasqueSansMono NF','Lekton NF','JetBrainsMono NF','ShureTechMono NF','Hasklug NF','Inconsolata NF','Liga Hack','UbuntuMono NF','LiterationMono NF','Hack NF',HackGen,Cica,'Myrica M', Consolas, monospace
	vim.opt.linespace=1
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0
end
