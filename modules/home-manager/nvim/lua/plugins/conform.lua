return {
	"stevearc/conform.nvim",
	lazy = false,
	opts = {
		formatters_by_ft = {
			go = { "gofmt" },
			lua = { "stylua" },
			c = { "clang-format" },
			nix = { "nixfmt" },
			rust = { "rustfmt" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
