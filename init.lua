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
vim.opt.swapfile = false

local map = function(mode,keys,to,_opts)
	local opts = {noremap = true,silent=true}
	if _opts then
		opts = vim.tbl_extend('force',opts,_opts)
	end
	vim.keymap.set(mode,keys,to,opts)
end
vim.g.mapleader=" "

vim.o.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20"

local nsopt = {silent=false}
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
map('n','<leader>mo',':Mason<CR>')
map('n','<leader>du',":DepsUpdate<CR>")
map('n','<C-\\>',':vs<CR>')
map('i','<C-\\>','<C-o>:vs<CR>')
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
map('n','<leader>ff',":Telescope find_files<CR>")
map('n','<leader>bb',":Telescope buffers<CR>")
map('n','<leader>fb',":Telescope buffers<CR>")
map('n','<leader>fr',":Telescope frecency<CR>")
map('n','<leader>cc',":Telescope colorscheme<CR>")
map('n','<leader><leader>f',":Telescope frecency<CR>")
map('n','<leader>t',":Telescope",nsopt)
map('n','<M-t>',":Telescope",nsopt)
map('i','<M-t>',"<Esc>:Telescope",nsopt)
map('n',"<M-w>", ':Telescope buffers<CR>')
map('i','<M-w>','<C-o>:Telescope buffers<CR>')
map('i','<C-P>','<Esc>:',nsopt)
map('i','jk','<Esc>')
map('i','<C-:>','<Esc>:')

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		'git', 'clone', '--filter=blob:none',
		'https://github.com/echasnovski/mini.nvim', mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })


-- tablineまわり
vim.opt.showtabline = 0
local function toggle_buffer_line()
	vim.opt.showtabline = vim.opt.showtabline + 1 % 3
end
map('n','<leader>bl',toggle_buffer_line)


vim.opt.whichwrap = 'h,l,<,>,[,],~'
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 2

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	require("mini.basics").setup()
	require("mini.move").setup()
	require('mini.pairs').setup()

	--	add('lewis6991/gitsigns.nvim')
	--	require("gitsigns").setup()

	require('mini.icons').setup()
	require('mini.git').setup()
	require('mini.diff').setup()

	require('mini.statusline').setup()
	require('mini.bufremove').setup()
	require('mini.comment').setup()
	require('mini.bracketed').setup()
	require('mini.cursorword').setup()
	require('mini.splitjoin').setup()
	require('mini.surround').setup()
	require('mini.trailspace').setup({})
	require('mini.sessions').setup({})

end)

later(function()
	add('nvim-tree/nvim-web-devicons')
end)

-- 詳しくいろいろやりたいとき用に設定用autocmdグループを作成
vim.api.nvim_create_augroup('init_lua',{
	clear = true
})

-- completion plugin add
now(function()
	add('hrsh7th/nvim-cmp')
	add("hrsh7th/cmp-nvim-lsp-signature-help")
	add('hrsh7th/cmp-buffer')
	add('hrsh7th/cmp-path')
	add("hrsh7th/cmp-nvim-lua")
	add('hrsh7th/cmp-cmdline')
	add("L3MON4D3/LuaSnip")
	add("saadparwaiz1/cmp_luasnip")
	add('hrsh7th/cmp-nvim-lsp')
end)


-- lspとmasonまわりのあれこれ
now(function() add("williamboman/mason.nvim") require("mason").setup() add("neovim/nvim-lspconfig") local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" } for type, icon in pairs(signs) do local hl = "DiagnosticSign" .. type vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl }) end

add("williamboman/mason-lspconfig.nvim")
require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"lua_ls"
	}
})
map('n','<space>e',vim.diagnostic.open_float)
map('n','[d',vim.diagnostic.goto_prev)
map('n',']d',vim.diagnostic.goto_next)
map('n','<space>q',vim.diagnostic.setloclist)
-- LspAttachにキーマッピング設定を入れ込む
vim.api.nvim_create_autocmd('LspAttach',{
	group = vim.api.nvim_create_augroup('UserLspConfig',{}),
	callback = function(ev)
		-- <c-x><c-o>で補完が可能になる？
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- マッピング
		local opts = {buffer = ev.buf}
		map('n','K',vim.lsp.buf.hover,opts)
		map('n','gD',vim.lsp.buf.declaration,opts)
		map('n','gd',vim.lsp.buf.definition,opts)
	end
})

vim.api.nvim_create_autocmd({"BufReadPre"}, {
	pattern = {"*.lua"},
	once = true,
	callback = function()
		local lspconf = require("lspconfig")
		local gcap = require("cmp_nvim_lsp").default_capabilities()
		lspconf.lua_ls.setup({
			capabilities = gcap,
			settings = {
				Lua = {
					diagnostics={
						globals={"vim"}
					},
					hint = {enable = true},
					workspace= {
						library=vim.api.nvim_get_runtime_file("",true),
						checkThirdParty = false,
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
	end
})
end)

--cmp setup
now(function()
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
end)

-- rustまわりのセットアップ
now(function()
	add({
		source='mrcjkb/rustaceanvim',
		checkout='v5.18.1'
	})

	vim.g.rustaceanvim = {
		tools ={
			inlay_hints ={
				parameter_hints_prefix = "←",
				other_hints_prefix = "⇒",
			}
		},
		server = {
			on_attach = function(_,bufnr)
				-- Hover actions
				vim.keymap.set("n","<C-space>", vim.lsp.buf.hover, {buffer = bufnr})
				-- Code action groups
				local codeAction = function ()
					vim.cmd.RustLsp('codeAction')
				end
				vim.keymap.set("n","<Leader>a",codeAction,{buffer=bufnr})
			end,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = true,
					check = {
						command="clippy",
						features = "all"
					}
				}
			}
		}
	}
end)

-- lspsaga
now(function()
	add('kkharji/lspsaga.nvim')

	local lspsaga = require 'lspsaga'
	lspsaga.setup {
		debug = false,
		use_saga_diagnostic_sign = true,
		-- diagnostic sign
		error_sign = "󰅚",
		warn_sign = "󰀪",
		hint_sign = "󰌶",
		infor_sign = "",
		diagnostic_header_icon = "   ",
		-- code action title icon
		code_action_icon = "󰌵",
		code_action_prompt = {
			enable = true,
			sign = true,
			sign_priority = 40,
			virtual_text = true,
		},
		finder_definition_icon = "  ",
		finder_reference_icon = "  ",
		max_preview_lines = 10,
		finder_action_keys = {
			open = "o",
			vsplit = "s",
			split = "i",
			quit = "q",
			scroll_down = "<C-f>",
			scroll_up = "<C-b>",
		},
		code_action_keys = {
			quit = "q",
			exec = "<CR>",
		},
		rename_action_keys = {
			quit = "<C-c>",
			exec = "<CR>",
		},
		definition_preview_icon = "󰀹",
		border_style = "single",
		rename_prompt_prefix = "➤",
		rename_output_qflist = {
			enable = false,
			auto_open_qflist = false,
		},
		server_filetype_map = {},
		diagnostic_prefix_format = "%d. ",
		diagnostic_message_format = "%m %c",
		highlight_prefix = false,
	}
end)

-- treesitterとblankline

now(function()
	add({
		source="nvim-treesitter/nvim-treesitter",
		hooks = { post_checkout = function() vim.cmd('TSUpdateSync') end },
	})


	require('nvim-treesitter.configs').setup{
		ensure_installed = {"lua","rust"},
		auto_install=true,
		highlight = {
			enable = true,
			disable={"rust"}
		},
		ident = {
			enable=true,
			disable={"rust"}
		},
	}
	require 'nvim-treesitter.install'.prefer_git = false
	add("lukas-reineke/indent-blankline.nvim")

	require('ibl').setup{
		indent = {
			char = {"│"},
			tab_char = {"│"}
		},
	}
end)


-- plenary
now(function()
	add('nvim-lua/plenary.nvim')
end)

later(function()
	add("cshuaimin/ssr.nvim")
	local ssr = require("ssr")
	ssr.setup({
		border="rounded",
		min_width=50,
		max_width=120,
		max_height=25,
		keymaps={
			close="q",
			next_match="n",
			prev_match="N",
			replace_confirm="<cr>",
			replace_all="<leader><cr>"
		}
	})
	map('n','<leader>sr',ssr.open)
end)

later(function()
	add('nmac427/guess-indent.nvim')
	require('guess-indent').setup{}
end)



-- バッファの扱い
later(function()

	add("kwkarlwang/bufresize.nvim")
	require("bufresize").setup({})

	add({
		source = "utilyre/barbecue.nvim",
		depends = {
			"SmiteshP/nvim-navic",
		}
	})
	require("barbecue").setup({})

end)

-- noice設定
later(function()
	add({
		source = "folke/noice.nvim",
		depends = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			--"rcarriga/nvim-notify",
		}
	})
	local _opts = {
		-- add any options here
		popupmenu = {
			-- cmp-cmdline has more sources and can be extended
			backend = "cmp", -- backend to use to show regular cmdline completions
		},
		lsp = {
			-- can not filter null-ls's data
			-- j-hui/fidget.nvim
			progress = {
				enabled = false,
			},
		},
		messages = {
			-- Using kevinhwang91/nvim-hlslens because virtualtext is hard to read
			view_search = false,
		},
	}
	require('noice').setup(_opts)
	vim.keymap.set("c", "<S-Enter>", function()
		require("noice").redirect(vim.fn.getcmdline())
	end, { desc = "Redirect Cmdline" })

end)

-- セッション管理

local nt = false
local load_neo_tree = function()
	if nt then
		return
	else
		nt = true
		add({
			source="nvim-neo-tree/neo-tree.nvim",
			checkout = "v3.x",
			depends = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
		})
		local _opts = {
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
					visible=true,
					hide_dotfiles = false
				},
				hijack_netrw_behavior = "open_default",
				follow_current_file = {enabled = true}
			}
		}
		require("neo-tree").setup(_opts)
	end
end
now(function()
	add('jedrzejboczar/possession.nvim')

	local _opts={
		commands = {
			save="SSave",
			load="Sload",
			delete="Sdelete",
			list="Slist"
		}
	}
	require("possession").setup(_opts)
end)

now(function ()
	vim.api.nvim_create_autocmd({"BufEnter"},{
		group = "init_lua",
		once=true,
		callback=function ()
			add("Exafunction/codeium.nvim")

			require("codeium").setup({
				virtual_text = {
					enabled = true
				}
			})
		end
	})
end)

later(function()
	now(load_neo_tree)
end)

vim.api.nvim_create_autocmd({"BufEnter"},{
	group = 'init_lua',
	once = true,
	callback = function ()
		now(function()
			add('dstein64/nvim-scrollview')
		end)
	end
})

vim.api.nvim_create_autocmd({"BufEnter"},{
	group = "init_lua",
	once = true,
	callback = function ()
		require('scrollview').setup({
			scrollview_signs_on_startup={'all'}
		})
	end
})

vim.api.nvim_create_autocmd({"CmdUndefined"},{
	group = "init_lua",
	pattern="WhickKey",
	once = true,
	callback = function ()
		add("folke/which-key.nvim")
		require("which-key").setup()
		vim.cmd("WhickKey")
	end
})
-- 	{
-- 		'mvllow/modes.nvim',
-- 		tag = 'v0.2.0',
-- 		config = function()
-- 			require('modes').setup()
-- 		end
-- 	}
later(function ()
	add('akinsho/toggleterm.nvim')
	require("toggleterm").setup({
		open_mapping = [[<M-t>]],
	})
end)
--telescope
later(function()
	add(
	{source='nvim-telescope/telescope.nvim',
	checkout='0.1.x'}
	)

	--[[ local function make_fzf_native(params)
		vim.cmd("lcd " .. params.path)
		vim.cmd("!make -s")
		vim.cmd("lcd -")
	end

	add(
	{
		source='nvim-telescope/telescope-fzf-native.nvim',
		hooks={
			post_install = make_fzf_native,
			post_checkout = make_fzf_native
		}
	}
	)	]] --
	add("nvim-telescope/telescope-frecency.nvim")
	add("nvim-telescope/telescope-file-browser.nvim")
	add("nvim-telescope/telescope-project.nvim")
	add("debugloop/telescope-undo.nvim")
	add('cljoly/telescope-repo.nvim')
	add('LukasPietzschmann/telescope-tabs')


	local actions = require("telescope.actions")
	local action_layout = require('telescope.actions.layout')
	local opts = {
		defaults = {
			mappings = {
				n = {
					["<M-p>"] = action_layout.toggle_preview
				},
				i = {
					["<M-p>"] = action_layout.toggle_preview
				}
			}
		},
		pickers = {
			colorscheme = {
				enable_preview = true
			},
			buffers = {
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer
					},
					n = {
						["<C-d>"] = actions.delete_buffer
					}
				}
			}
		}
	}
	require('telescope').setup(opts)
	local builtin = require('telescope.builtin')
	local map_opts = {noremap = true,silent=false}
	map('n','<leader>bb',":Telescope buffers<CR>")

	map('n',"<M-w>", ':Telescope buffers<CR>')
	map('i','<M-w>','<C-o>:Telescope buffers<CR>')

	local ff = builtin.find_files
	map('n','<leader>ff',ff, map_opts)
	map('n','<leader>fg',builtin.live_grep,map_opts)
	local fb = builtin.buffers
	map('n','<leader>fb',fb,map_opts)
	map('n','<leander>bb',fb,map_opts)
	map('n','<leader>fh',builtin.help_tags,map_opts)
	-- require('telescope').load_extension('session-lens')
	require("telescope").load_extension("frecency")
	require("telescope").load_extension("file_browser")
	require('telescope').load_extension('project')
	require('telescope').load_extension("undo")
	require'telescope'.load_extension('repo')
	--	require('telescope').load_extension('possession')

	map('n','<leader>ft',':Telescope telescope-tabs list_tabs<CR>')
end)

-- colorscheme
later(function ()
	add( "EdenEast/nightfox.nvim" )
	add('marko-cerovac/material.nvim')
--	add("folke/tokyonight.nvim")
	add({ source="rose-pine/neovim", name = "rose-pine" })
	add({source='luisiacc/gruvbox-baby',checkout='main'})
	add({ source='Everblush/nvim', name = 'everblush' })
	add({ source = "catppuccin/nvim", name = "catppuccin" })

	vim.g.everforest_background = "hard"

	add("sainnhe/everforest")
-- vim.g.sonokai_transparent_background = 0
	vim.g.sonokai_style="espresso"
	vim.g.sonokai_colors_override = {black={'#1c1c1c','232'}, bg_dim = {'#212121', '232'}, bg0={'#222222','235'}, bg1={'#333333','236'}}

	add("sainnhe/sonokai")
	vim.cmd.colorscheme("sonokai")
	add("ellisonleao/gruvbox.nvim")
	add("olimorris/onedarkpro.nvim")
	add('navarasu/onedark.nvim')
	-- Lua
	require('onedark').setup {
		style = 'darker'
	}

	add("loctvl842/monokai-pro.nvim")
	require("monokai-pro").setup()
	add("rebelot/kanagawa.nvim")
end)

vim.opt.number = true

vim.opt.list = true
vim.opt.listchars:append "space:."
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:--"
vim.opt.listchars:append "trail:*"


if vim.g.neovide then
	vim.o.guifont="Cascadia_Code_NF,PlemolJP_Console_NF:h14"
	--'Cascadia Code','Cascadia Code','Martian Mono Std Lt','PlemolJP Console NF','FantasqueSansMono NF','Lekton NF','JetBrainsMono NF','ShureTechMono NF','Hasklug NF','Inconsolata NF','Liga Hack','UbuntuMono NF','LiterationMono NF','Hack NF',HackGen,Cica,'Myrica M', Consolas, monospace
	vim.opt.linespace=1
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_scroll_animation_length = 0.1
	vim.g.neovide_cursor_trail_size = 0
end
