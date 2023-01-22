-- Initiate some utils for specific LSP
vim.schedule(function()
  require("hon6.lsp.utils.plantuml").setup()
  require("hon6.lsp.utils.maven").setup()
  require("hon6.lsp.utils.jdtls_clean").setup()
end)

                     ------- LSP -------

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  ensure_installed = {
    "sumneko_lua",
    "clangd",
    "gopls",
    "rust_analyzer",
    "pyright",
    --"codelldb",
    --"jdtls",
    --"java-test",
    --"java-debug-adapter",
    --"debugpy",
  },
})

-- 安装列表
-- { key: 语言 value: 配置文件 }
local server_configs = {
  sumneko_lua = require("hon6.lsp.sumneko_lua"), -- /lua/lsp/lua.lua
  clangd = require("hon6.lsp.clangd"),
  gopls = require("hon6.lsp.gopls"),
  pyright = require("hon6.lsp.pyright"),
  sqls = require("hon6.lsp.sqls"),
  rust_analyzer = require("hon6.lsp.rust_analyzer"),
  -- jdtls = require "lsp.java", -- /lua/lsp/jdtls.lua
  -- jsonls = require("lsp.jsonls"),
  --  tsserver = require("hon6.lsp.tsserver"),
  -- html = require("hon6.lsp.html"),
  --  kotlin_language_server = {},
  -- vuels = {},
}

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- 没有确定使用效果参数
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
local utils = require("hon6.bsc.utils")

require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    local lspconfig = require("lspconfig")

    -- tools config
    local cfg = utils.or_default(server_configs[server_name], {})

    -- lspconfig
    local lspcfg = utils.or_default(cfg.server, {})

    -- lspcfg = vim.tbl_deep_extend("force", server:get_default_options(), lspcfg)
    local on_attach = lspcfg.on_attach
    lspcfg.on_attach = function(client, buffer)

      -- 绑定快捷键
      require("hon6.bsc.kmaps").maplsp(client, buffer)
      -- if client.server_capabilities.documentSymbolProvider then
      --   require("nvim-navic").attach(client, buffer)
      -- end
      if on_attach then
        on_attach(client, buffer)
      end
    end

    lspcfg.flags = {
      debounce_text_changes = 150,
    }
    lspcfg.capabilities = capabilities

    --  rust-tools
    if server_name == "rust_analyzer" then
      -- Initialize the LSP via rust-tools instead
      cfg.server = lspcfg
      require("rust-tools").setup(cfg)
    else
      lspconfig[server_name].setup(lspcfg)
    end

    -- clangd_extensions
    if server_name == "clangd" then
      -- Initialize the LSP via clangd_extensions instead
      cfg.server = lspcfg
      require("clangd_extensions").setup(cfg)
    else
      lspconfig[server_name].setup(lspcfg)
    end
  end,
})

-- LSP 相关美化参考 https://github.com/NvChad/NvChad
local function lspSymbol(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

local lsp_ui = require("hon6.lsp.lsp_ui")
lspSymbol("Error", lsp_ui.diagnostics.icons.error)
lspSymbol("Warn", lsp_ui.diagnostics.icons.warning)
lspSymbol("Info", lsp_ui.diagnostics.icons.info)
lspSymbol("Hint", lsp_ui.diagnostics.icons.hint)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp_ui.hover_actions)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp_ui.hover_actions)

-- suppress error messages from lang servers
-- vim.notify = function(msg, log_level)
  --   if msg:match "exit code" then
  --     return
  --   end
  --   if log_level == vim.log.levels.ERROR then
  --     vim.api.nvim_err_writeln(msg)
  --   else
  --     vim.api.nvim_echo({ { msg } }, true, {})
  --   end
  -- end
