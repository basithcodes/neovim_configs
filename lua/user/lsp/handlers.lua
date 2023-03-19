local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  print('problem in handlers')
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_keymaps()
	local opts = { noremap = true, silent = true }
  -- local bufopts = { noremap=true, silent=true, buffer=bufnr }
	local keymap = vim.keymap.set

	-- keymap(bufnr, "n", "<leader>ql", vim.diagnostic.setloclist, opts)
	-- keymap(bufnr, "n", "<leader>qf", vim.diagnostic.setqflist, opts)
	-- keymap(bufnr, "n", "[d", vim.diagnostic.goto_next, opts)
	-- keymap(bufnr, "n", "]d", vim.diagnostic.goto_prev, opts)
	-- keymap(bufnr, "n", "<leader>e", vim.diagnostic.open_float, opts)

	-- keymap(bufnr, "n", "gD", vim.lsp.buf.declaration, opts)
	-- keymap(bufnr, "n", "gd", vim.lsp.buf.definition, opts)
	-- keymap(bufnr, "n", "K", vim.lsp.buf.hover, opts)
	-- keymap(bufnr, "n", "gi", vim.lsp.buf.implementation, opts)
	-- keymap(bufnr, "n", "gr", vim.lsp.buf.references, opts)
	-- keymap(bufnr, "n", "<leader>fo", function() vim.lsp.buf.format { async = true } end, opts)
	-- keymap(bufnr, "n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) { async = true } end, opts)
	-- keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	-- keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
	-- keymap(bufnr, "n", "<leader>cda", vim.lsp.buf.code_action, opts)
	-- keymap(bufnr, "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	-- keymap(bufnr, "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	-- keymap(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, opts)
	-- keymap(bufnr, "n", "<C-k>", vim.lsp.buf.signature_help, opts)
	-- keymap(bufnr, "n", '<space>show', vim.diagnostic.show ,  opts)
	-- keymap(bufnr, "n", '<leader>hide', vim.diagnostic.hide, opts)

	keymap("n", "<leader>ql", vim.diagnostic.setloclist, opts)
	keymap("n", "<leader>qf", vim.diagnostic.setqflist, opts)
	keymap("n", "[d", vim.diagnostic.goto_next, opts)
	keymap("n", "]d", vim.diagnostic.goto_prev, opts)
	keymap("n", "<leader>e", vim.diagnostic.open_float, opts)

	keymap("n", "gD", vim.lsp.buf.declaration, opts)
	keymap("n", "gd", vim.lsp.buf.definition, opts)
	keymap("n", "K", vim.lsp.buf.hover, opts)
	keymap("n", "gi", vim.lsp.buf.implementation, opts)
	keymap("n", "gr", vim.lsp.buf.references, opts)
	keymap("n", "<leader>fo", function() vim.lsp.buf.format { async = true } end, opts)
	keymap("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) { async = true } end, opts)
	keymap("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
	keymap("n", "<leader>cda", vim.lsp.buf.code_action, opts)
	keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
	keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	keymap("n", '<space>show', vim.diagnostic.show ,  opts)
	keymap("n", '<leader>hide', vim.diagnostic.hide, opts)
end

M.on_attach = function(client)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps()
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

return M
