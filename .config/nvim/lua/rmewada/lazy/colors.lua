function ColorMyPencils(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "transparent"
                },
                on_colors = function(colors)
                    colors.bg = "#000000"
                    colors.bg_dark = "#000000"
                    colors.bg_statusline = nil
                end,
                on_highlights = function(hl, colors)
                    hl.LineNr = { fg = colors.orange }

                    hl.GitSignsAdd = { fg = "#a4cf69" }
                    hl.GitSignsChange = { fg = "#63c1e6" }
                    hl.GitSignsDelete = { fg = "#d74f56" }

                    hl.TroubleCount = { bg = "#000000", fg = "#bb9af7" }
                    hl.TroubleNormal = { bg = "#000000", fg = "#c0caf5" }
                    hl.TroubleText = { bg = "#000000", fg = "#a9b1d6" }

                    hl.DiagnosticVirtualTextError = { bg = nil, fg = "#db4b4b" }
                    hl.DiagnosticVirtualTextHint = { bg = nil, fg = "#1abc9c" }
                    hl.DiagnosticVirtualTextInfo = { bg = nil, fg = "#0db9d7" }
                    hl.DiagnosticVirtualTextWarn = { bg = nil, fg = "#e0af68" }
                end,
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
            })

            vim.cmd("colorscheme rose-pine")
            ColorMyPencils()
        end
    }
}
