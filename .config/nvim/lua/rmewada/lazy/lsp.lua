-- return {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--         "williamboman/mason.nvim",
--         "williamboman/mason-lspconfig.nvim",
--         "hrsh7th/cmp-nvim-lsp",
--         "hrsh7th/cmp-buffer",
--         "hrsh7th/cmp-path",
--         "hrsh7th/cmp-cmdline",
--         "hrsh7th/nvim-cmp",
--         "L3MON4D3/LuaSnip",
--         "saadparwaiz1/cmp_luasnip",
--         "j-hui/fidget.nvim",
--     },
--
--     config = function()
--         local cmp = require('cmp')
--         local cmp_lsp = require("cmp_nvim_lsp")
--         local capabilities = vim.tbl_deep_extend(
--             "force",
--             {},
--             vim.lsp.protocol.make_client_capabilities(),
--             cmp_lsp.default_capabilities())
--
--         require("fidget").setup({})
--         require("mason").setup()
--         require("mason-lspconfig").setup({
--             ensure_installed = {
--                 "lua_ls",
--                 "rust_analyzer",
--                 "gopls",
--                 "ts_ls",
--                 "eslint",
--                 "tailwindcss",
--                 "jsonls",
--             },
--             handlers = {
--                 function(server_name) -- default handler (optional)
--                     require("lspconfig")[server_name].setup {
--                         capabilities = capabilities
--                     }
--                 end,
--
--                 ["lua_ls"] = function()
--                     local lspconfig = require("lspconfig")
--                     lspconfig.lua_ls.setup {
--                         capabilities = capabilities,
--                         settings = {
--                             Lua = {
--                                 diagnostics = {
--                                     globals = { "vim", "it", "describe", "before_each", "after_each" },
--                                 }
--                             }
--                         }
--                     }
--                 end,
--
--                 ["eslint"] = function()
--                     require("lspconfig").eslint.setup {
--                         capabilities = capabilities,
--                         on_attach = function(client, bufnr)
--                             vim.api.nvim_create_autocmd("BufWritePre", {
--                                 buffer = bufnr,
--                                 command = "EslintFixAll",
--                             })
--                         end,
--                         settings = {
--                             codeActionOnSave = { enable = true, mode = "all" }
--                         }
--                     }
--                 end,
--             }
--         })
--
--         local cmp_select = { behavior = cmp.SelectBehavior.Select }
--
--         cmp.setup({
--             snippet = {
--                 expand = function(args)
--                     require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--                 end,
--             },
--             mapping = cmp.mapping.preset.insert({
--                 ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--                 ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--                 ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--                 ["<C-Space>"] = cmp.mapping.complete(),
--             }),
--             sources = cmp.config.sources({
--                 { name = 'path' },
--                 { name = 'nvim_lsp' },
--                 { name = 'luasnip' }, -- For luasnip users.
--             }, {
--                 { name = 'buffer' },
--             }),
--             window = {
--                 documentation = cmp.config.window.bordered()
--             },
--             formatting = {
--                 fields = { 'menu', 'abbr', 'kind' }
--             },
--         })
--
--         vim.diagnostic.config({
--             -- update_in_insert = true,
--             float = {
--                 focusable = false,
--                 style = "minimal",
--                 border = "rounded",
--                 source = "always",
--                 header = "",
--                 prefix = "",
--             },
--         })
--     end
-- }
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "nvimtools/none-ls.nvim",
            "nvim-lua/plenary.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },
        config = function()
            --local capabilities = vim.lsp.protocol.make_client_capabilities()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())


            -- Function to check if prettier is configured in ESLint
            local function has_eslint_prettier_config(bufnr)
                local function file_exists(filename)
                    local stat = vim.loop.fs_stat(filename)
                    return stat and stat.type or false
                end

                local eslintrc_files = {
                    ".eslintrc",
                    ".eslintrc.js",
                    ".eslintrc.json",
                    ".eslintrc.yaml",
                    ".eslintrc.yml",
                }

                -- Check for ESLint config files
                local has_eslint = false
                for _, file in ipairs(eslintrc_files) do
                    if file_exists(file) then
                        has_eslint = true
                        break
                    end
                end

                if not has_eslint then
                    return false
                end

                -- Check package.json for ESLint prettier config
                local package_json = file_exists("package.json") and vim.fn.json_decode(vim.fn.readfile("package.json"))
                if package_json and package_json.devDependencies then
                    return package_json.devDependencies["eslint-config-prettier"] ~= nil
                end

                return false
            end

            -- Set up none-ls
            local null_ls = require("null-ls")
            local prettier = null_ls.builtins.formatting.prettier.with({
                prefer_local = "node_modules/.bin",
                -- Only run prettier if there's a config file
                condition = function(utils)
                    return utils.has_file({ ".prettierrc", ".prettierrc.js", ".prettierrc.json" })
                end,
            })

            null_ls.setup({
                sources = { prettier },
            })

            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "gopls",
                    "ts_ls",
                    "eslint",
                    "tailwindcss",
                    "jsonls",
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,

                    ["ts_ls"] = function()
                        require("lspconfig").ts_ls.setup {
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                -- Disable ts_ls formatting
                                client.server_capabilities.documentFormattingProvider = false

                                -- Set up format on save for this buffer
                                if not has_eslint_prettier_config(bufnr) then
                                    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
                                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                                    vim.api.nvim_create_autocmd("BufWritePre", {
                                        group = augroup,
                                        buffer = bufnr,
                                        callback = function()
                                            vim.lsp.buf.format({
                                                bufnr = bufnr,
                                                filter = function(client)
                                                    return client.name == "null-ls"
                                                end
                                            })
                                        end,
                                    })
                                end
                            end
                        }
                    end,

                    ["eslint"] = function()
                        require("lspconfig").eslint.setup {
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    command = "EslintFixAll",
                                })
                            end,
                            settings = {
                                codeActionOnSave = { enable = true, mode = "all" }
                            }
                        }
                    end,
                }
            })
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                }),
                window = {
                    documentation = cmp.config.window.bordered()
                },
                formatting = {
                    fields = { 'menu', 'abbr', 'kind' }
                },
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    }
}
