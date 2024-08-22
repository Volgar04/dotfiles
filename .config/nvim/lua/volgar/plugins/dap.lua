return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

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

		vim.keymap.set("n", "<Leader>dt", function()
			dap.toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>dc", function()
			dap.continue()
		end)
		vim.keymap.set("n", "<Leader>do", function()
			dap.step_over()
		end)
		vim.keymap.set("n", "<Leader>di", function()
			dap.step_into()
		end)
		vim.keymap.set("n", "<Leader>du", function()
			dap.step_out()
		end)

		dap.configurations.dart = {
			{
				type = "dart",
				request = "launch",
				name = "Launch dart",
				dartSdkPath = "/Users/nicolasmartin/Documents/dev/flutter/bin/cache/dart-sdk",
				flutterSdkPath = "/Users/nicolasmartin/Documents/dev/flutter/bin/flutter",
				program = "${workspaceFolder}/lib/main.dart",
				cwd = "${workspaceFolder}",
			},
			{
				type = "flutter",
				request = "launch",
				name = "Launch flutter",
				dartSdkPath = "/Users/nicolasmartin/Documents/dev/flutter/bin/cache/dart-sdk",
				flutterSdkPath = "/Users/nicolasmartin/Documents/dev/flutter/bin/flutter",
				program = "${workspaceFolder}/lib/main.dart",
				cwd = "${workspaceFolder}",
			},
		}
		dap.adapters.dart = {
			type = "executable",
			command = "dart",
			args = { "debug_adapter" },
			-- windows users will need to set 'detached' to false
			options = {
				detached = false,
			},
		}
		dap.adapters.flutter = {
			type = "executable",
			command = "flutter", -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
			args = { "debug_adapter" },
			-- windows users will need to set 'detached' to false
			options = {
				detached = false,
			},
		}
	end,
}
