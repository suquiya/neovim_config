vim.loader.enable()

vim.opt.tabstop=3
vim.opt.shiftwidth=3


function key_map(mode,keys,to,_opts)
	local opts = {noremap = true,silent=false}
	if _opts then 
		opts = vim.tbl_extend('force',opts,_opts)
	end
	vim.keymap.set(mode,keys,to,opts)
end
local key_binds = {
	{'i','jj','<Esc>'},
	{'n','<C-s>',':w<CR>'},
	{'i','<C-z>','<C-o>u'},
	{'n','<C-z>','u'},
	{'i','yy','<C-o>yy'},
	{'i','<C-v>','<C-o>p'},
	--{},
	--{},
	--{},
	--{},
	--{},
	--{},
}

for _i,bind in ipairs(key_binds) do
	key_map(bind[1],bind[2],bind[3],bind[4])
end

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
		"nvim-lua/plenary.nvim"
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
		end
	},
	{
		'windwp/nvim-autopairs',
   	event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	{ "lukas-reineke/indent-blankline.nvim" },
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
  },
})
