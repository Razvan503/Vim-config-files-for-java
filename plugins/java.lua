return {
  -- Java LSP and Tools
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',  -- Only load for Java files
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },

  -- Debugging support
  {
    'mfussenegger/nvim-dap',
    config = function()
      require('custom.config.dap')
    end,
  },
}
