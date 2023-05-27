return {
    -- which-key
    "folke/which-key.nvim",
    -- nvim-lualine 底部状态栏
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end,
    },
    -- bufferline 顶部标签栏
    {
        "akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup{}
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require('nvim-autopairs').setup{}
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function()
          vim.fn["mkdp#util#install"]()
        end,
  },
}
