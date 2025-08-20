-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
    },

    -- change trouble config
    {
        "folke/trouble.nvim",
        -- opts will be merged with the parent spec
        opts = { use_diagnostic_signs = true },
    },

    -- disable trouble
    { "folke/trouble.nvim", enabled = false },

    -- override nvim-cmp and add cmp-emoji
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-emoji" },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            table.insert(opts.sources, { name = "emoji" })
        end,
    },

    -- change some telescope options and a keymap to browse plugin files
    {
        "nvim-telescope/telescope.nvim",
        keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
        },
        -- change some options
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
            extensions = {
                fzf = {},
            },
        },
    },

    -- add pyright to lspconfig
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- pyright will be automatically installed with mason and loaded with lspconfig
                pyright = {},
            },
        },
    },

    -- add tsserver and setup with typescript.nvim instead of lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/typescript.nvim",
            init = function()
                require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
                    vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
                end)
            end,
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- tsserver will be automatically installed with mason and loaded with lspconfig
                tsserver = {},

                ltex = {
                    settings = {
                        ltex = {
                            language = "en", -- или "ru" если нужна русская орфография (см. ниже)
                            enabled = { "latex", "markdown", "text" },
                            diagnosticSeverity = "information",
                            additionalRules = {
                                languageModel = "~/ngrams", -- можно убрать
                            },
                            dictionary = {
                                ["en-US"] = { "Neovim", "lazygit", "qt" },
                                ["ru-RU"] = { "Нейровим", "Киргизия" },
                            },
                        },
                    },
                    filetypes = { "markdown", "text", "tex", "org" },
                },

                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=never",
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    root_dir = require("lspconfig.util").root_pattern(
                        "compile_commands.json",
                        "compile_flags.txt",
                        ".git"
                    ),
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                tsserver = function(_, opts)
                    require("typescript").setup({ server = opts })
                    return true
                end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
    },

    -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
    -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
    { import = "lazyvim.plugins.extras.lang.typescript" },

    -- add more treesitter parsers
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "yaml",
                "cpp",
                "cmake",
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui" },
        config = function()
            local dap = require("dap")
            dap.adapters.lldb = {
                type = "executable",
                command = "/usr/bin/lldb-vscode",
                name = "lldb",
            }
            dap.configurations.cpp = {
                {
                    name = "Launch Qt App",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/MyApp", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
            }
        end,
    },

    -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
    -- would overwrite `ensure_installed` with the new value.
    -- If you'd rather extend the default config, use the code below instead:
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- add tsx and treesitter
            vim.list_extend(opts.ensure_installed, {
                "tsx",
                "typescript",
            })
        end,
    },

    -- the opts function can also be used to change the default opts:
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, "😄")
        end,
    },

    -- or you can return new options to override all the defaults
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            return {
                --[[add your custom lualine config here]]
            }
        end,
    },

    -- use mini.starter instead of alpha
    { import = "lazyvim.plugins.extras.ui.mini-starter" },

    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },

    -- add any tools you want to have installed below
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "flake8",
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            window = {
                mappings = {
                    ["<cr>"] = "open",
                    ["o"] = "open",
                },
            },
            filesystem = {
                hijack_netrw_behavior = "open_current", -- Не открывать новое окно
                follow_current_file = {
                    enabled = true, -- Фокус на текущий файл
                    leave_dirs_open = false,
                },
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        -- Закрывать Neo-tree после открытия файла
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
            },
        },
    },
}
