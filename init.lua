vim.loader.enable()

vim.opt.tabstop=3
vim.opt.shiftwidth=3
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
	}
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
