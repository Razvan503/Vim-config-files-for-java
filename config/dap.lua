local dap = require('dap')

dap.adapters.java = {
  type = 'executable',
  command = 'java',
  args = {
    '-jar',
    vim.fn.stdpath('data') .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
  }
}

dap.configurations.java = {
  {
    type = 'java',
    request = 'launch',
    name = 'Debug (Attach) - Remote',
    hostName = '127.0.0.1',
    port = 5005,
  },
  {
    type = 'java',
    request = 'launch',
    name = 'Debug Current File',
    program = '${file}',
    javaExec = 'java',
  },
}

vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
