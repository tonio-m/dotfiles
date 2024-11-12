local cmp = require('cmp')
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local minuet = require('minuet')

minuet.setup {
    enabled = true,
    add_single_line_entry = false,
    n_completions = 1,
    provider = 'claude',
    provider_options = {
        model = 'claude-3-5-haiku-20241022',
        stream = true,
    },
    throttle = 1000,
}

cmp.setup({
    view = { entries = 'wildmenu' },
    experimental = {
        ghost_text = true,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-x>"] = minuet.make_cmp_map(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        -- { name = 'minuet' }, -- I want it to be manual Ctrl+x
        {name = 'nvim_lsp'},
        { name = 'buffer'}
    }),
    performance = {
        fetching_timeout = 2000,
    },
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
