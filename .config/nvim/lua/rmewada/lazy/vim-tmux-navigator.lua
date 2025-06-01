return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-ah>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-aj>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-ak>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-al>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
}
