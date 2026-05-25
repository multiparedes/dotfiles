return {
    {
        "moll/vim-bbye",
        lazy = true,
        cmd = { "Bdelete", "Bwipeout" },
        keys = {
            { "<leader>q", ":Bdelete<CR>", desc = "Cerrar buffer actual" },
        },
    },
}
