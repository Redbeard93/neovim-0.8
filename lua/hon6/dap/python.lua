-- python3 -m pip install debugpy
local home = vim.loop.os_homedir()
local utils = require("hon6.bsc.utils")

-- PATH Of PYTHON
local PYTHON_PATH = (function()
  if utils.is_win then
    return home .. "/AppData/Local/nvim-data/mason/packages/debugpy/venv/Scripts/python"
  elseif utils.is_mac then
    return home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
  else
    return home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
  end
end)()

return {
  adapters = {
    type = "executable",
    command = PYTHON_PATH,
    args = {"-m", "debugpy.adapter"}
  },
  configurations = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        return PYTHON_PATH
      end
    }
  }
}
