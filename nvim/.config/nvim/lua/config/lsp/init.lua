require "config.lsp.helpers"
local lspconfig = require('lspconfig')

local lsp_list = {
  { "gopls", {} },
  { "sumneko_lua", {} },
  { "pyright", {} },
  { "tsserver", {
    root_dir = lspconfig.util.root_pattern("package.json")
  } },
  { "tailwindcss", {
    root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.json", "twind.config.ts")
  } },
  { "denols", {
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    init_options = { enable = true, lint = true, unstable = true, fmt = true },
  } },
  { "rust_analyzer", {
    settings = {
      ["rust-analyzer"] = {}
    }
  } },
};

init_lsp(lsp_list)
