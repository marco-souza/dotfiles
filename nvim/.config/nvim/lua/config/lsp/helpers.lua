local nnoremap = require("config.shared.remap").nnoremap
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Autocomplete
local function setup_auto_complete()
  -- Set up nvim-cmp.
  local cmp = require 'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

-- LSP servers
local function setup_language_servers(lsp_list, on_attach)
  setup_auto_complete()

  local lsp_flags = { debounce_text_changes = 100 }
  local lspconfig = require('lspconfig')

  for _i, lsp_pair in ipairs(lsp_list) do
    local lsp_name, lsp_config = unpack(lsp_pair)

    lsp_config['capabilities'] = capabilities
    lsp_config['on_attach'] = on_attach
    lsp_config['flags'] = lsp_flags

    lspconfig[lsp_name].setup(lsp_config)
  end
end

-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap('gD', vim.lsp.buf.declaration, bufopts)
  nnoremap('gd', vim.lsp.buf.definition, bufopts)
  nnoremap('K', vim.lsp.buf.hover, bufopts)
  nnoremap('gi', vim.lsp.buf.implementation, bufopts)
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts)
  nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  nnoremap('<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts)
  nnoremap('<space>rn', vim.lsp.buf.rename, bufopts)
  nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts)
  nnoremap('gr', vim.lsp.buf.references, bufopts)
  nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  -- Enable fold by syntax
  vim.opt.foldmethod = "syntax"
end

-- Initialize LSP
function init_lsp(lsp_list)
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  nnoremap('<space>e', vim.diagnostic.open_float)
  nnoremap('[d', vim.diagnostic.goto_prev)
  nnoremap(']d', vim.diagnostic.goto_next)
  nnoremap('<space>q', vim.diagnostic.setloclist)

  setup_language_servers(lsp_list, on_attach)

  print("LSP server is running!")
end
