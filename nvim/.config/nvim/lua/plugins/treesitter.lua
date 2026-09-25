-- nvim-treesitter (rama main): setup() ya no acepta ensure_installed/highlight,
-- hay que instalar los parsers con install() y activar el resaltado por FileType.
-- Requiere tree-sitter-cli (pacman) para compilar los parsers.
local parsers = {
    "bash", "lua", "vim", "vimdoc", "query",
    "python", "javascript", "typescript", "tsx", "json", "yaml", "toml",
    "html", "css", "sql", "dockerfile", "gitcommit", "diff",
    "markdown", "markdown_inline",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if pcall(vim.treesitter.start, args.buf) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end
}
