-- if not install delve via mason, do `pacman -S delve` or `go install github.com/go-delve/delve/cmd/dlv@latest`
-- Linux Go 环境变量设置
--export GOROOT=/usr/lib/go -- go语言安装目录
--export GOPATH=~/Projects/go -- go语言工作区
--export GOBIN=$GOPATH/bin -- 存放go语言可执行文件目录
--export PATH=$PATH:$GOROOT/bin:$GOBIN --为了随地调用go语言命令和go编译后的可执行文件，可以将$GOROOT/bin和$GOBIN加入到PATH


return {
  adapters = function(callback, _) -- _ = config
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = {nil, stdout},
      args = {"dap", "-l", "127.0.0.1:" .. port},
      detached = true
    }
    handle, pid_or_err =
    vim.loop.spawn(
    "dlv",
    opts,
    function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end
    )
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(
    function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(
        function()
          require("dap.repl").append(chunk)
        end
        )
      end
    end
    )
    -- Wait for delve to start
    vim.defer_fn(
    function()
      callback({type = "server", host = "127.0.0.1", port = port})
    end,
    500
    )
  end,
  configurations = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
  }
}
