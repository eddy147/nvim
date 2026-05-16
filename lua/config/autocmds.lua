local augroup = require("config.shared").augroup

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.py",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.css",
		"*.scss",
		"*.html",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.c",
		"*.cpp",
		"*.h",
		"*.hpp",
		"*.ex",
		"*.exs",
		"*.heex",
		"*.eex",
		"*.leex",
	},
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local ft = vim.bo[args.buf].filetype
		local is_elixir = {
			elixir = true,
			eelixir = true,
			heex = true,
			surface = true,
		}

		local formatter = nil
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if is_elixir[ft] and c.name == "ElixirLS" then
				formatter = "ElixirLS"
				break
			end
			if c.name == "efm" then
				formatter = formatter or "efm"
			end
		end

		if not formatter then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == formatter
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"')
		local last_line = vim.api.nvim_buf_line_count(0)
		local row = last_pos[1]

		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "elixir", "eelixir", "heex", "surface" },
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
		if vim.bo[args.buf].syntax == "" then
			vim.bo[args.buf].syntax = args.match
		end
		vim.diagnostic.config({
			virtual_text = false,
			severity_sort = true,
		}, args.buf)
	end,
})
