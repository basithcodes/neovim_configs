-- Dont show the binary files in preview

local fb_actions = require "telescope._extensions.file_browser.actions"
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

-- Telescope Setup
require("telescope").setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    buffer_previewer_maker = new_maker,
  },

  pickers = {
    -- Default configuration for builtin picker goes here:
    -- picker_name = {
    --	picker_config_key = value,
    --	...
    -- },
    find_files = {
      find_command = {"fd", "--type", "f", "--strip-cwd-prefix"},
    },
  },

  extensions = {
    file_browser = {
      --disables netrw and use telescope-file-browser in its place
      -- hijack_netrw = true,
      -- path
      -- cwd
      cwd_to_path = false,
      grouped = false,
      files = true,
      add_dirs = true,
      depth = 1,
      auto_depth = false,
      select_buffer = false,
      hidden = false,
      -- respect_gitignore
      -- browser_files
      -- browser_folders
      hide_parent_dir = false,
      collapse_dirs = false,
      quiet = false,
      dir_icon = "",
      dir_icon_hl = "Default",
      display_stat = {
        date = true,
        size = true,
      },
      use_fd = true,
      git_status = true,

      mappings = {
        ["i"] = {
          ["A-c"] = fb_actions.create,
          ["S-CR"] = fb_actions.create_from_prompt,
          ["A-r"] = fb_actions.rename,
          ["A-m"] = fb_actions.move,
          ["A-y"] = fb_actions.copy,
          ["A-d"] = fb_actions.remove,
          ["C-o"] = fb_actions.open,
          ["C-g"] = fb_actions.goto_parent_dir,
          ["C-e"] = fb_actions.goto_home_dir,
          ["C-w"] = fb_actions.goto_cwd,
          ["C-t"] = fb_actions.change_cwd,
          ["C-f"] = fb_actions.toggle_browser,
          ["C-h"] = fb_actions.toggle_hidden,
          ["C-s"] = fb_actions.toggle_all,
        },
        ["n"] = {
          ["c"] = fb_actions.create,
          ["r"] = fb_actions.rename,
          ["m"] = fb_actions.move,
          ["y"] = fb_actions.copy,
          ["d"] = fb_actions.remove,
          ["o"] = fb_actions.open,
          ["g"] = fb_actions.goto_parent_dir,
          ["e"] = fb_actions.goto_home_dir,
          ["w"] = fb_actions.goto_cwd,
          ["t"] = fb_actions.change_cwd,
          ["f"] = fb_actions.toggle_browser,
          ["h"] = fb_actions.toggle_hidden,
          ["s"] = fb_actions.toggle_all,
        },
      },
    },
  },
  fzf = {
    fuzzy = true,												-- false will do the exact matching
    override_generic_sorter = true,			-- override the generic sorter
    override_file_sorter = true,				-- override the file sorter
    case_mode = "smart_case",						-- "ignore_case" or "respect_case"
    -- The default case mode is "smart case"
  }
}

require("telescope").load_extension("fzf")
require("telescope").load_extension('harpoon')
require("telescope").load_extension("file_browser")

-- Project and file navigation functions
local M = {}

-- File Navigation

-- Find files in current directory
M.curr_dir_files = function()
  require('telescope.builtin').find_files({
    prompt_title = "< Current Directory Files >",
    shorten_path = false,
  })
end

-- Directory Browser
M.file_browser = function()
  require('telescope').extensions.file_browser.file_browser({
    prompt_title = "< File Browser >",
  })
end

-- Grepping in current directory
M.curr_dir_grepping = function()
  require('telescope.builtin').live_grep({
    prompt_title = "< Grepping word in multiple files of cwd >",
  })
end

-- Opened Buffers
M.buffers = function ()
  require("telescope.builtin").buffers({
    prompt_title = "< Buffer Files >",
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    width = 0.25,
    layout_config = {
      preview_width = 0.65,
    },
  })
end

-- Project Navigation
M.project_workspace = function()
  local char_cut
  local query = {"*.myproj", ".git"}
  local total_length
  local workspace = vim.inspect(vim.lsp.buf.list_workspace_folders())
  if workspace ~= '{}' or workspace ~= nil then
    total_length = string.len(workspace)
    char_cut = string.sub(workspace,4,total_length-3)
    print(char_cut)
    --TODO
    --@ get actual project name
    require("telescope.builtin").find_files({
      prompt_title = "< " .. char_cut .. " >",
      file_ignore_patterns = {

      },
      cwd = char_cut,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new
    })
  end
end

-- config navigation
M.lua_conf = function()
  require("telescope.builtin").find_files({
    prompt_title = "Lua Configs",
    cwd = "~/.config/nvim/",
    file_previewer = require("telescope.previewers").vim_buffer_cat.new
  })
end

return M
