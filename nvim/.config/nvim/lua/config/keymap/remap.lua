local nnoremap = require("config.shared.remap").nnoremap
local vnoremap = require("config.shared.remap").vnoremap

local function setup_personal_remaps()
  -- files
  nnoremap("<leader>pv", "<cmd>Ex<CR>")
  -- buffers
  nnoremap("<leader>bn", "<cmd>bn<CR>")
  nnoremap("<leader>bb", "<cmd>bp<CR>")
  nnoremap("<leader>bd", "<cmd>bd<CR>")
  nnoremap("<leader>bD", "<cmd>bd!<CR>")
  -- clipboard: yank
  nnoremap("<leader>Y", "\"+yg_")
  nnoremap("<leader>y", "\"+y")
  vnoremap("<leader>y", "\"+y")
  nnoremap("<leader>yy", "\"+yy")
  -- clipboard: paste
  nnoremap("<leader>P", "\"+P")
  vnoremap("<leader>P", "\"+P")
  nnoremap("<leader>p", "\"+p")
  vnoremap("<leader>p", "\"+p")
  -- mics
  nnoremap("<leader>s", "<cmd>so<CR>")
  nnoremap("<leader>te", "<cmd>te<CR>")
end

-- Find files using Telescope command-line sugar.
local function setup_telescope()
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')

  nnoremap('<leader>ff', builtin.find_files)
  nnoremap('<leader>fg', builtin.live_grep)
  nnoremap('<leader>fb', builtin.buffers)
  nnoremap('<leader>fh', builtin.help_tags)

  telescope.setup {
    pickers = {
      find_files = { hidden = true },
      live_grep = { additional_args = function() return { "--hidden" } end },
    }
  }

  return telescope
end

-- Harpoon
local function setup_harpoon(telescope)
  local harpoon_mark = require('harpoon.mark')
  local harpoon_term = require('harpoon.term')
  local harpoon_ui = require('harpoon.ui')

  nnoremap('<leader>mm', harpoon_mark.add_file)
  nnoremap('<leader>mt', harpoon_term.gotoTerminal)
  nnoremap('<leader>ml', harpoon_ui.toggle_quick_menu)
  nnoremap('<leader>mn', harpoon_ui.nav_next)
  nnoremap('<leader>mb', harpoon_ui.nav_prev)

  telescope.load_extension('harpoon')
end

-- Magit
local function setup_neogit()
  local neogit = require('neogit')

  nnoremap('<leader>gg', neogit.open)

  neogit.setup {
    -- github: https://github.com/TimUntersberger/neogit#configuration
    auto_refresh = true,
    use_magit_keybindings = true,
  }
end

function setup_emmet()
  vim.g.user_emmet_expandabbr_key = '<Tab>'
end

-- Remap initialization
function init_keymaps()
  local telescope = setup_telescope()
  setup_harpoon(telescope)
  setup_neogit()
  setup_personal_remaps()
  setup_emmet()
end
