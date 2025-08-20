return {
    "folke/edgy.nvim",
    opts = {
        left = {
            {
                title = "Neo-Tree",
                ft = "neo-tree",
                size = { width = 30 },
                pinned = true,
                open = "Neotree position=left",
            },
        },
        bottom = {
            {
                title = "Terminal",
                ft = "toggleterm", -- работает с lazyvim
                size = { height = 15 },
                filter = function(buf)
                    return vim.bo[buf].buftype == "terminal"
                end,
            },
        },
    },
}
