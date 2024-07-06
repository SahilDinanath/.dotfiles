return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "theHamsta/nvim-dap-virtual-text" },
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("nvim-dap-virtual-text").setup()
		dapui.setup()

		vim.keymap.set("n", "<F1>", dap.restart, { desc = "DAP restart" })

		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "DAP continue" })
		vim.keymap.set("n", "<F10>", function()
			dap.step_over()
		end, { desc = "DAP step over" })

		vim.keymap.set("n", "<F11>", function()
			dap.step_into()
		end, { desc = "DAP step into" })
		vim.keymap.set("n", "<F12>", function()
			dap.step_out()
		end, { desc = "DAP step out" })

		vim.keymap.set("n", "<Leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "[D]ebug toggle [B]reak point" })

		vim.keymap.set("n", "<space>de", function()
			require("dapui").eval(nil, { enter = true })
		end, { desc = "[D]ebug [E]val" })
		vim.keymap.set("n", "<Leader>dl", function()
			dap.run_last()
		end, { desc = "[D]ebug run [L]ast" })
		vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "[D]ebug [T]oggle" })
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "-i", "dap" },
		}
		dap.configurations.c = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
		}
	end,
}
