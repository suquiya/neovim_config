vim.loader.enable()

vim.opt.tabstop=3
vim.opt.shiftwidth=3
vim.g.mapleader=" "


local map = function(mode,keys,to,_opts)
	local opts = {noremap = true,silent=false}
	if _opts then 
		opts = vim.tbl_extend('force',opts,_opts)
	end
	vim.keymap.set(mode,keys,to,opts)
end

map('i','jj','<Esc>')
map('n','<C-s>',':w<CR>')
map('i','<C-s>','<C-o>:w<CR>')
map('i','<C-z>','<C-o>u')
map('n','<C-z>','u')
map('i','yy','<C-o>yy')
map('i','<C-p>p','<C-o>p')
map('n','<F3>',':noh<CR>')
map('i','<F3>','<C-o>:noh<CR>')
map('n','<leader>mo',':Mason<CR>')


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
		"williamboman/mason-lspconfig.nvim"
	},
	{
		"neovim/nvim-lspconfig"
	},
	{
		"simrat39/rust-tools.nvim"
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
		"lukas-reineke/indent-blankline.nvim"
	},
	{
		'numToStr/Comment.nvim',
		opts = {
			-- add any options here
		},
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
		config = function()
			require('guess-indent').setup{}
		end
	},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/cmp-path'},
	{'hrsh7th/cmp-cmdline'},
	{'hrsh7th/nvim-cmp'}
},{
	defaults={lazy=true}
})

require("mason").setup();

require("mason-lspconfig").setup({
	ensure_installed = {
		 "rust_analyzer"
	 },
});

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
			}
		}
	},
})


vim.opt.list = true
vim.opt.listchars:append "space:."
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:--"
vim.opt.listchars:append "trail:*"

require("indent_blankline").setup {
	-- for example, context is off by default, use this to turn it on
	show_current_context = true,
	show_current_context_start = true,
}

-- completion setup

local cmp = require('cmp')

cmp.setup({
	snippet = {
		expand = function(args)
		end,
	},
	window = {
		completion = {
			cmp.config.window.bordered(),
		},
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm { select = false }
	},
	sources = {
		{ name = 'path' }, -- file paths
		{ name = 'nvim_lsp', keyword_length = 1, priority = 10 }, -- from language server
		{name="nvim_lsp"},
		{name='buffer'}
	}
})
