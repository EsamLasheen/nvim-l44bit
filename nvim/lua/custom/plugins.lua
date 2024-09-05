local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
  -- NvChad plugins
  "NvChad/nvcommunity",
  { import = "nvcommunity.git.diffview" },
  { import = "nvcommunity.git.lazygit" },

  -- Hop.nvim plugin for easy navigation
  {
    "smoka7/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine" },
    opts = { keys = "etovxqpdygfblzhckisuran" },
    init = function()
      local map = vim.keymap.set

      map("n", "<leader><leader>w", "<CMD> HopWord <CR>", { desc = "Hint all words" })
      map("n", "<leader><leader>t", "<CMD> HopNodes <CR>", { desc = "Hint Tree" })
      map("n", "<leader><leader>c", "<CMD> HopLineStart<CR>", { desc = "Hint Columns" })
      map("n", "<leader><leader>l", "<CMD> HopWordCurrentLine<CR>", { desc = "Hint Line" })
    end,
  },

  -- Satellite.nvim for visual indicators in the gutter
  {
    "lewis6991/satellite.nvim",
    event = "BufWinEnter",
    opts = { excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify", "neo-tree" } },
  },

  -- Rainbow Delimiters for colored brackets
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"
  
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- Hlargs.nvim for argument highlighting
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    config = function()
      require("hlargs").setup {
        hl_priority = 200,
      }
    end,
  },

  -- Nvim-biscuits plugin for code context
  {
    "code-biscuits/nvim-biscuits",
    event = "BufReadPost",
    opts = {
      show_on_start = false,
      cursor_line_only = true,
      default_config = {
        min_distance = 10,
        max_length = 50,
        prefix_string = "󰆘 ",
        prefix_highlight = "Comment",
        enable_linehl = true,
      },
    },
  },

  -- Beacon.nvim for cursor movement flash
  {
    "rainbowhxch/beacon.nvim",
    event = "CursorMoved",
    cond = function()
      return not vim.g.neovide  -- Disable in neovide
    end,
  },

  -- Live server
  {
    "barrett-ruth/live-server.nvim",
    build = 'pnpm add -g live-server',
    cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = true,
  },

  -- Discord presence plugin
  {
    "andweeb/presence.nvim",
    event = "VimEnter",
    opts = {},
  },

  -- Auto-save plugin
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      execution_message = {
        enabled = false,
      },
      callbacks = {
        before_saving = function()
          vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled
          vim.g.autoformat_enabled = false
          vim.g.OLD_AUTOFORMAT_BUFFERS = {}
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.b[bufnr].autoformat_enabled then
              table.insert(vim.g.OLD_AUTOFORMAT_BUFFERS, bufnr)
              vim.b[bufnr].autoformat_enabled = false
            end
          end
        end,
        after_saving = function()
          vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
          for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
            vim.b[bufnr].autoformat_enabled = true
          end
        end,
      },
    },
  },

  -- Codeium for AI code completion
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },

  -- Override nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },

  -- Override mason.nvim
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  -- Override nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  -- Override nvim-tree.lua
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install better-escape.nvim plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- Conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("custom.configs.conform")
    end,
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    event = "BufReadPost",
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
  },

  -- Treesitter context
  {
    "nvim-treesitter/nvim-treesitter-context",
    after = "nvim-treesitter",
    config = function()
      require("treesitter-context").setup()
    end,
  },

  -- Commenting helper
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "BufReadPost",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  -- Dashboard
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        -- your configuration options
      })
    end,
  },
}

return plugins
