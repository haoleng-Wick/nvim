-- Set up lsp-server
-- 加载并启动lsp-server
require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "clangd", "pyright" },
})

-- 加载并配置代码补全
-- Set up nvim-cmp.
local cmp = require'cmp'

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

cmp.setup({

formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
    ['<S-j>'] = cmp.mapping.select_next_item(),
    ['<S-k>'] = cmp.mapping.select_prev_item(),

    --['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<TAB>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    }),
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

-- Set up lspconfig.
-- lsp中各语言的设置
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')["lua_ls"].setup {
    capabilities = capabilities
}
require('lspconfig')["pyright"].setup {
    capabilities = capabilities
}
require('lspconfig')["clangd"].setup {
      cmd = {
        "clangd",
        "--header-insertion=never",
        "--query-driver=/opt/homebrew/opt/llvm/bin/clang",
        "--all-scopes-completion",
        "--completion-style=detailed",
      },
    capabilities = capabilities
}
