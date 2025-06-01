return {
    "supermaven-inc/supermaven-nvim",
    keys = {
        { "<leader>st", ":SupermavenToggle<CR>", desc = "Toggle Supermaven" },
    },
    config = function()
        require("supermaven-nvim").setup({})
    end,
}

