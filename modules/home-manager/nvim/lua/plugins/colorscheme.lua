return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	config = function()
		require("gruvbox").setup({})
		vim.cmd("colorscheme gruvbox")
	end,
}
