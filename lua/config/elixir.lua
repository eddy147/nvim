local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup({
	elixirls = {
		enable = true,
		cmd = "/home/eddy/.asdf/shims/elixir-ls",
		root_dir = function(fname)
			local root = vim.fs.root(fname, { "mix.exs", ".git" })
			return root or vim.fs.dirname(fname)
		end,
		settings = elixirls.settings({
			dialyzerEnabled = true,
			fetchDeps = true,
			enableTestLenses = false,
			suggestSpecs = true,
		}),
		on_attach = function(_, bufnr)
			local run_mix = function(cmd, save_first)
				if save_first then
					vim.cmd("write")
				end
				vim.cmd("split | terminal " .. cmd)
			end

			local show_elixir_keymaps = function()
				local lines = {
					"Elixir keymaps",
					"",
					"<leader>mm  mix format",
					"<leader>mc  mix credo",
					"<leader>mg  mix deps.get",
					"<leader>mt  mix test current file",
					"<leader>mT  mix test current line",
					"<leader>mf  mix test --failed",
					"<leader>mh  show this help",
					"",
					"<space>fp   ElixirFromPipe",
					"<space>tp   ElixirToPipe",
					"<space>em   ElixirExpandMacro (visual)",
				}

				vim.lsp.util.open_floating_preview(lines, "markdown", {
					border = "rounded",
					focusable = true,
					max_width = 48,
				})
			end

			vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = bufnr, noremap = true, silent = true })
			vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = bufnr, noremap = true, silent = true })
			vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = bufnr, noremap = true, silent = true })

			vim.keymap.set("n", "<leader>mt", function()
				run_mix("mix test " .. vim.fn.fnameescape(vim.fn.expand("%")), true)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Mix test file" })

			vim.keymap.set("n", "<leader>mT", function()
				run_mix("mix test " .. vim.fn.fnameescape(vim.fn.expand("%")) .. ":" .. vim.api.nvim_win_get_cursor(0)[1], true)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Mix test nearest" })

			vim.keymap.set("n", "<leader>mf", function()
				run_mix("mix test --failed", false)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Mix test failed" })

			vim.keymap.set("n", "<leader>mm", function()
				run_mix("mix format", true)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Mix format" })

			vim.keymap.set("n", "<leader>mc", function()
				run_mix("mix credo", false)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Mix credo" })

			vim.keymap.set("n", "<leader>mg", function()
				run_mix("mix deps.get", false)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Mix deps get" })

			vim.keymap.set("n", "<leader>mh", show_elixir_keymaps, {
				buffer = bufnr,
				noremap = true,
				silent = true,
				desc = "Elixir keymaps help",
			})
		end,
	},
})
