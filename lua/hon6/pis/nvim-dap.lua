local dap = require("dap")
-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
-- dap.defaults.fallback.focus_terminal = true
-- dap.defaults.fallback.external_terminal = {
--   command = '/opt/homebrew/bin/alacritty';
--   args = { '-e' };
-- }
--
-- LOAD ADAPTERS CONFIGURATIONS
local dap_config = {
  c = require("hon6.dap.codelldb"),
  go = require('hon6.dap.go'),
  python = require('hon6.dap.python'),
}

-- SETUP ADAPTERS
for dap_name, dap_options in pairs(dap_config) do
  dap.adapters[dap_name] = dap_options.adapters
  dap.configurations[dap_name] = dap_options.configurations
end

-- RUST & C & C++ USE THE SAME CONFIG FILE
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

local dapui = require("dapui")
dapui.setup({
  icons = { expanded = "", collapsed = "", current_frame = "" },
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        -- 'console',
      },
      size = 0.25,
      position = "bottom",
    },
  },
})

dap.defaults.fallback.terminal_win_cmd = "belowright 12new | set filetype=dap-terminal"

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

-- vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" })
-- vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='LspDiagnosticsSignHint', linehl='', numhl=''})
-- vim.fn.sign_define('DapLogPoint', {text='L', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='ﭦ', texthl='LspDiagnosticsSignInformation', linehl='DiagnosticUnderlineInfo', numhl='LspDiagnosticsSignInformation'})

vim.api.nvim_create_user_command("DapUiOpen", function()
  require("dapui").open({})
end, {})
vim.api.nvim_create_user_command("DapUiClose", function()
  require("dapui").close({})
end, {})
vim.api.nvim_create_user_command("DapUiToggle", function()
  require("dapui").toggle({})
end, {})

require("nvim-dap-virtual-text").setup({})
require("telescope").load_extension("dap")
