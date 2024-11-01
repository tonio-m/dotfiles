local cmp = require('cmp')
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-Tab>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}
    }, {
        { name = 'buffer'}
    })
})

-- npm install -g pyright
lspconfig.pyright.setup({
    capabilities = cmp_nvim_lsp.default_capabilities(),
    settings = {
      pyright = {
          typeCheckingMode = 'off',
          reportUnusedImport = 'none',
          reportUnusedVariable = 'none',
          reportGeneralTypeIssues = 'none',
          reportUnknownMemberType = 'none',
        },
    },
})

-- brew install lua-language-server
lspconfig.lua_ls.setup({
    capabilities = cmp_nvim_lsp.default_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim'},  -- Recognize the `vim` global variable
                disable = {'lowercase-global'},  -- Disable specific diagnostics
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),  -- Make the server aware of Neovim runtime files
                checkThirdParty = false,  -- Disable checking third-party libraries
            },
            telemetry = {
                enable = false,  -- Disable telemetry data collection
            },
        },
    },
})

-- brew install llvm
lspconfig.clangd.setup({
    capabilities = cmp_nvim_lsp.default_capabilities(),
})
