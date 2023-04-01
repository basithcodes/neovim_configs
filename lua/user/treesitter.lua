local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
  -- ensure_installed = { "lua", "markdown", "bash", "python" , "c", "cpp", "cmake", "java", "json", "yaml"}, -- put the language you want in this array
  ensure_installed = "all", -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)

  highlight = {
		enable = true, -- false will disable the whole extension
		-- disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true,
    -- disable = { "python", "css" }
  },

	context_commentstring = {
		enable = true,
		enable_autocmd = true,
	},

})
