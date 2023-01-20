local ensure_packer = function ()
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify(install_path, vim.log.levels.INFO)
  fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  return true
end
return false
end

local packer_bootstrap = ensure_packer()

vim.cmd("packadd packer.nvim")

require("packer").startup({
  function(use)

    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    use({
      "nvim-lua/plenary.nvim",
      module = "plenary",
      opt = true,
    })

    use({
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      opt = true,
    })
                            ------- LSP -------
    use({
      "williamboman/mason.nvim",
      opt = true,
      module = "mason",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("mason.nvim")
      end,
      config = function()
        require("hon6.pis.mason")
      end,
    })

    use({
      "williamboman/mason-lspconfig.nvim",
      after = "mason.nvim",
      module = "mason-lspconfig",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("mason-lspconfig.nvim")
      end,
    })

    use({
      "neovim/nvim-lspconfig",
      after = "mason-lspconfig.nvim",
      module = "lspconfig",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-lspconfig")
      end,
      config = function()
        require("hon6.lsp")
      end,
    })

    -- java
    use({
      "mfussenegger/nvim-jdtls",
      opt = true,
      ft = "java",
      setup = function()
        -- 不加载 nvim-jdtls.vim
        vim.g.nvim_jdtls = 1
      end,
      config = function()
        require("hon6.lsp.java").setup()
      end,
    })

    --clang
    use 'p00f/clangd_extensions.nvim'

  --  use({
  --    "JavaHello/java-deps.nvim",
  --    opt = true,
  --    after = "nvim-jdtls",
  --    ft = { "java" },
  --    config = function()
  --      require("java-deps").setup()
  --    end,
  --  })

                            ------- CMP -------
    use({
      "rafamadriz/friendly-snippets",
      event = "InsertEnter",
    })

    -- nvim-cmp
    use({
      "hrsh7th/nvim-cmp",
      module = "cmp",
      after = "friendly-snippets",
    })

    -- LuaSnip
    use({
      "L3MON4D3/LuaSnip",
      module = "luasnip",
      wants = "friendly-snippets",
      after = "nvim-cmp",
      config = function()
        require("hon6.pis.luasnip")
      end,
    })

    use({
      "saadparwaiz1/cmp_luasnip",
      after = "LuaSnip",
    })

    use({
      "hrsh7th/cmp-nvim-lsp",
      module = "cmp_nvim_lsp",
      after = "cmp_luasnip",
    })

    use({
      "hrsh7th/cmp-buffer",
      after = "cmp-nvim-lsp",
    })

    use({
      "hrsh7th/cmp-path",
      after = "cmp-buffer",
    })

    -- lspkind
    use({
      "onsails/lspkind-nvim",
      after = "cmp-path",
      config = function()
        require("hon6.pis.nvim-cmp")
      end,
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      opt = true,
      setup = function()
        -- on_file_open("null-ls.nvim")
        require("hon6.bsc.utils.lazy_loading").async_load("null-ls.nvim")
      end,
      config = function()
        require("hon6.pis.null-ls")
      end,
      requires = { "nvim-lua/plenary.nvim" },
    })

    -- use 'hrsh7th/cmp-cmdline'  -- { name = 'cmdline' }

    -- vsnip
    -- use 'hrsh7th/cmp-vsnip'    -- { name = 'vsnip' }
    -- use 'hrsh7th/vim-vsnip'

    -- lsp 相关
    -- use 'folke/lsp-colors.nvim'
    -- use("folke/trouble.nvim")

    -- java 不友好
    -- use({ "glepnir/lspsaga.nvim", branch = "main" })
    -- use 'arkav/lualine-lsp-progress'
    -- use 'nvim-lua/lsp-status.nvim'

    -- use 'ray-x/lsp_signature.nvim'

    -- use 'RishabhRD/popfix'
    -- use 'RishabhRD/nvim-lsputils'

    -- 主题
    -- use 'morhetz/gruvbox'
    -- use({
    --   "ellisonleao/gruvbox.nvim",
    --   opt = true,
    --   module = "gruvbox",
    --   setup = function()
    --     require("hon6.bsc.utils.lazy_loading").sync_load("gruvbox.nvim")
    --   end,
    --   config = function()
    --     require("hon6.pis.gruvbox")
    --   end,
    -- })

    -- 文件管理
    -- use({
    --   "kyazdani42/nvim-tree.lua",
    --   requires = {
    --     "kyazdani42/nvim-web-devicons", -- optional, for file icon
    --   },
    --   opt = true,
    --   tag = "nightly",
    --   setup = function()
    --     require("hon6.bsc.utils.lazy_loading").async_load("nvim-tree.lua")
    --   end,
    --   config = function()
    --     require("hon6.pis.nvim-tree")
    --   end,
    -- })

                         ------- TREESITTER -------
    use({
      "nvim-treesitter/nvim-treesitter",
      module = "nvim-treesitter",
   -- after = "",
      run = ":TSUpdate",
      config = function()
        require("hon6.pis.nvim-treesitter")
      end,
    })

    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      opt = true,
      after = "nvim-treesitter",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").sync_load("nvim-treesitter-textobjects")
      end,
    })

    use({
      "nvim-treesitter/nvim-treesitter-context",
      opt = true,
      after = "nvim-treesitter",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-treesitter-context")
      end,
      config = function()
        require("hon6.pis.nvim-treesitter-context")
      end,
    })

                              ------- DEBUG -------
    use({
      "mfussenegger/nvim-dap",
      opt = true,
      module = "dap",
    })

    use({
      "rcarriga/nvim-dap-ui",
      opt = true,
      module = "dapui",
      after = "nvim-dap",
    })

    use({
      "theHamsta/nvim-dap-virtual-text",
      after = "nvim-dap-ui",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-dap-virtual-text")
      end,
      config = function()
        require("hon6.pis.nvim-dap")
      end,
    })

    -- rust
    use({
      "simrat39/rust-tools.nvim",
      opt = true,
      module = "rust-tools",
    })

    -- python
    use({
      "mfussenegger/nvim-dap-python",
      opt = true,
      module = "nvim-dap-python",
    })

    -- go
    use({
      "leoluz/nvim-dap-go",
      opt = true,
      module = "nvim-dap-go",
    })

                            ------- SEARCH -------
    use({
      "nvim-telescope/telescope.nvim",
      opt = true,
      module = "telescope",
     -- wants = "", -- 等待""加载完成再加载
     -- after = "",
      tag = "0.1.x",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("hon6.pis.telescope")
      end,
    })

    use({
      "nvim-telescope/telescope-ui-select.nvim",
      after = "telescope.nvim",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("telescope-ui-select.nvim")
      end,
      config = function()
        require("telescope").load_extension("ui-select")
      end,
    })

    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      --run = "make",
      run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      after = "telescope.nvim",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("telescope-fzf-native.nvim")
      end,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    })

    use({
      "nvim-telescope/telescope-dap.nvim",
      after = "telescope.nvim",
      opt = true,
    })

    use({
      "LinArcX/telescope-env.nvim",
      opt = true,
      after = "telescope.nvim",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("telescope-env.nvim")
      end,
      config = function()
        require("telescope").load_extension("env")
      end,
    })

    -- use 'GustavoKatel/telescope-asynctasks.nvim'
    -- use 'aloussase/telescope-gradle.nvim'
    -- use 'aloussase/telescope-mvnsearch'

                             ------- GIT -------
    use({
      "tpope/vim-fugitive",
      opt = true,
      cmd = { "Git" },
    })

    use({
      "sindrets/diffview.nvim",
      opt = true,
      module = "diffview",
      cmd = {
        "DiffviewClose",
        "DiffviewFileHistory",
        "DiffviewFocusFiles",
        "DiffviewLog",
        "DiffviewOpen",
        "DiffviewRefresh",
        "DiffviewToggleFiles",
      },
      config = function()
        require("hon6.pis.diffview")
      end,
    })

    use({
      "TimUntersberger/neogit",
      after = "diffview.nvim",
      opt = true,
      cmd = "Neogit",
      config = function()
        require("hon6.pis.neogit")
      end,
      requires = "nvim-lua/plenary.nvim",
    })

    -- git edit 状态显示插件
    use({
      "lewis6991/gitsigns.nvim",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("gitsigns.nvim")
      end,
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("hon6.pis.gitsigns")
      end,
    })

    -- 浮动窗口插件
   -- use({
   --   "akinsho/toggleterm.nvim",
   --   module = "toggleterm",
   --   opt = true,
   --   config = function()
   --     require("toggleterm").setup({
   --       shade_terminals = true,
   --       -- shade_filetypes = { "none", "fzf" },
   --       direction = "float",
   --       close_on_exit = true,
   --       float_opts = {
   --         border = "double",
   --         winblend = 0,
   --       },
   --     })
   --   end,
   -- })

    -- 异步任务执行插件
    -- use 'skywind3000/asynctasks.vim'
    -- use 'skywind3000/asyncrun.vim'

                           ------- DATABASES -------
    use({
      "nanotee/sqls.nvim",
      ft = { "sql", "mysql" },
      opt = true,
    })

    use({
      "tpope/vim-dadbod",
      opt = true,
    })

    use({
      "kristijanhusak/vim-dadbod-ui",
      opt = true,
      wants = "vim-dadbod",
      after = "vim-dadbod",
      cmd = {
        "DBUI",
        "DBUIToggle",
      },
      setup = function()
        require("hon6.pis.vim-dadbod")
      end,
    })

                            ------- PROJECT -------
    -- 项目管理
    use({
      "ahmedkhalf/project.nvim",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("project.nvim")
      end,
      config = function()
        require("project_nvim").setup({})
        require("telescope").load_extension("projects")
      end,
    })

                             ------- UI -------
    use({
      "akinsho/bufferline.nvim",
      opt = true,
      tag = "v2.*",
     -- wants = "",
     -- after = "",
      requires = "kyazdani42/nvim-web-devicons",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").sync_load("bufferline.nvim")
      end,
      config = function()
        require("hon6.pis.bufferline")
      end,
    })

    use({
      "lukas-reineke/indent-blankline.nvim",
      opt = true,
      setup = function()
        -- on_file_open("indent-blankline.nvim")
        require("hon6.bsc.utils.lazy_loading").async_load("indent-blankline.nvim")
      end,
      config = function()
        require("hon6.pis.indent-blankline")
      end,
    })

    -- A tree like view for symbols in Neovim using the Language Server Protocol. Supports all your favourite languages.
    use({
      "simrat39/symbols-outline.nvim",
      opt = true,
      cmd = {
        "SymbolsOutline",
        "SymbolsOutlineOpen",
        "SymbolsOutlineClose",
      },
      config = function()
        require("hon6.pis.symbols-outline")
      end,
    })

    -- 消息通知
    use({
      "rcarriga/nvim-notify",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-notify")
      end,
      config = function()
        require("hon6.pis.nvim-notify")
      end,
    })

    -- 颜色显示
    use({
      "norcalli/nvim-colorizer.lua",
      opt = true,
      setup = function()
        -- on_file_open("nvim-colorizer.lua")
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-colorizer.lua")
      end,
      config = function()
        require("hon6.pis.nvim-colorizer")
      end,
    })

    -- 选中高亮插件
    use({
      "RRethy/vim-illuminate",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("vim-illuminate")
      end,
      config = function()
        require("hon6.pis.vim-illuminate")
      end,
    })

    -- LSP 进度
    use({
      "j-hui/fidget.nvim",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("fidget.nvim")
      end,
      config = function()
        require("fidget").setup({
          window = {
            relative = "editor",
            -- 更改blend数值后要:PackerSync才能起效
            blend = 0,
            zindex = nil,
            border = "none",
          }
        })
      end,
    })

    -- fold
    use({
      "kevinhwang91/nvim-ufo",
      opt = true,
      require = "kevinhwang91/promise-async",
      after = "promise-async",
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-ufo")
      end,
      config = function()
        require("hon6.pis.nvim-ufo")
      end,
    })

                            ------- ELSE -------
    --Annotation Generator
    use({
      "danymat/neogen",
      opt = true,
      module = "neogen",
      config = function()
        require("hon6.pis.neogen")
      end,
    })

    -- markdown 预览插件
    use({
      "iamcco/markdown-preview.nvim",
      opt = true,
      ft = "markdown",
      run = "cd app && yarn install",
      config = function()
        require("hon6.pis.markdown-preview")
      end,
    })

    -- markdown cli 预览插件
    use({
      "ellisonleao/glow.nvim",
      opt = true,
      ft = "markdown",
      config = function()
        require("glow").setup({
          style = "dark",
          width = 120,
        })
      end,
    })

    -- pandoc 命令插件(用于md转pdf)
    use({
      "aspeddro/pandoc.nvim",
      opt = true,
      ft = "markdown",
      config = function()
        require("hon6.pis.pandoc")
      end,
    })

    -- 翻译插件
    use({
      "uga-rosa/translate.nvim",
      opt = true,
      setup = function()
        -- on_file_open("translate.nvim")
        require("hon6.bsc.utils.lazy_loading").async_load("translate.nvim")
      end,
      config = function()
        require("hon6.pis.translate")
      end,
    })

    -- 表格模式插件
    use({
      "dhruvasagar/vim-table-mode",
      opt = true,
      cmd = { "TableModeEnable" },
    })

    -- 任务插件
    use({
      "itchyny/calendar.vim",
      opt = true,
      cmd = {
        "Calendar",
      },
    })

    -- 查找替换
    use({
      "windwp/nvim-spectre",
      opt = true,
      setup = function()
        -- on_file_open("nvim-spectre")
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-spectre")
      end,
      config = function()
        require("spectre").setup()
      end,
    })

    use({
      "tversteeg/registers.nvim",
      opt = true,
      cmd = { "Registers" },
      keys = '"',
    })

    -- 浏览器搜索
    use({
      "lalitmee/browse.nvim",
      opt = true,
      cmd = {
        "Browse",
      },
      config = function()
        require("hon6.pis.browse-nvim")
      end,
    })

    -- 环绕输入
    use({
      "kylechui/nvim-surround",
      opt = true,
      setup = function()
        require("hon6.bsc.utils.lazy_loading").async_load("nvim-surround")
      end,
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    })

    --  Javascript
    use({
      "kevinhwang91/promise-async",
      opt = true,
      module = "promise",
    })

    use({
      "aklt/plantuml-syntax",
      opt = true,
      ft = "plantuml",
    })

    -- chatgpt
    use({
      "jackMort/ChatGPT.nvim",
      opt = true,
      cmd = {
        "ChatGPT",
      },
      config = function()
        require("chatgpt").setup({
          -- optional configuration
        })
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
    })

    -- ASCII 图
   -- use({
   --   "jbyuki/venn.nvim",
   --   opt = true,
   --   cmd = { "VBox" },
   -- })

   -- use({
   --   "jedrzejboczar/toggletasks.nvim",
   --   opt = true,
   --   after = "toggleterm.nvim",
   --   setup = function()
   --     require("hon6.bsc.utils.lazy_loading").async_load("toggletasks.nvim")
   --   end,
   --   requires = {
   --     "nvim-lua/plenary.nvim",
   --     "akinsho/toggleterm.nvim",
   --     "nvim-telescope/telescope.nvim",
   --   },
   --   config = function()
   --     require("hon6.pis.toggletasks")
   --   end,
   -- })

   -- use({
   --   "NTBBloodbath/rest.nvim",
   --   ft = "http",
   --   opt = true,
   --   requires = {
   --     "nvim-lua/plenary.nvim",
   --   },
   --   config = function()
   --     vim.cmd([[
   --       function! s:http_rest_init() abort
   --         lua require('hon6.pis.rest-nvim')
   --         lua require('hon6.bsc.kmaps').rest_nvim()
   --       endfunction
   --       augroup http_rest
   --           autocmd!
   --           autocmd FileType http call s:http_rest_init()
   --       augroup end
   --      ]])
   --   end,
   -- })

    -- 快速跳转
   -- use({
   --   "ggandor/leap.nvim",
   --   opt = true,
   --   setup = function()
   --     require("hon6.bsc.utils.lazy_loading").async_load("leap.nvim")
   --   end,
   --   config = function()
   --     require("leap").add_default_mappings()
   --     require("leap").opts.safe_labels = {}
   --     vim.keymap.del({ "x", "o" }, "x")
   --     vim.keymap.del({ "x", "o" }, "X")
   --   end,
   -- })

    -- 自动对齐插件
   -- use({
   --   "junegunn/vim-easy-align",
   --   opt = true,
   --   setup = function()
   --     -- on_file_open("vim-easy-align")
   --     require("hon6.bsc.utils.lazy_loading").async_load("vim-easy-align")
   --   end,
   -- })

    -- () 自动补全
   -- use({
   --   "windwp/nvim-autopairs",
   --   opt = true,
   --   after = "nvim-cmp",
   --   setup = function()
   --     require("hon6.bsc.utils.lazy_loading").async_load("nvim-autopairs")
   --   end,
   --   config = function()
   --     require("hon6.pis.nvim-autopairs")
   --   end,
   -- })

    -- 格式化插件 -> 使用 null-ls
   -- use 'mhartington/formatter.nvim'
   -- use 'sbdchd/neoformat'

    -- 快捷键查看
   -- use({
   --   "folke/which-key.nvim",
   --   opt = true,
   --   setup = function()
   --     require("hon6.bsc.utils.lazy_loading").async_load("which-key.nvim")
   --   end,
   --   config = function()
   --     require("hon6.pis.which-key")
   --   end,
   -- })

    -- 仪表盘
    -- use {'glepnir/dashboard-nvim'}
   -- use({
   --   "goolord/alpha-nvim",
   --   opt = true,
   --   requires = { "kyazdani42/nvim-web-devicons" },
   --   setup = function()
   --     require("hon6.bsc.utils.lazy_loading").sync_load("alpha-nvim")
   --   end,
   --   config = function()
   --     require("hon6.pis.alpha-nvim")
   --   end,
   -- })

                            ------- END -------
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
    max_jobs = 10,
  },
})

vim.schedule(function()
  require("hon6.bsc.kmaps").setup()
end)
