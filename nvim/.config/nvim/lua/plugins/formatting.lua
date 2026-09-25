return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        config = function()
            require("mason-tool-installer").setup({
                -- shfmt viene de pacman (dev-fullstack.pkglist)
                ensure_installed = { "stylua", "black", "prettier" },
            })
        end
    },

    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },

        config = function()
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black" },
                    javascript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescript = { "prettier" },
                    typescriptreact = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                    sh = { "shfmt" },
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>gf", function()
                conform.format({ async = true, lsp_fallback = true })
            end, { desc = "Format Code" }) -- Space g f
        end
    }
}
