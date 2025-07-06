local function setup_jdtls()
  local jdtls = require('jdtls')

  -- Determine OS
  local os_config = "linux"
  if vim.fn.has('mac') == 1 then
    os_config = "mac"
  elseif vim.fn.has('win32') == 1 then
    os_config = "win"
  end

  -- Find root of project
  local root_markers = {'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}
  local root_dir = require('jdtls.setup').find_root(root_markers)
  if root_dir == "" then
    return
  end

  local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
  local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
  os.execute('mkdir -p ' .. workspace_dir)

  -- Get the mason install path
  local install_path = require('mason-registry').get_package('jdtls'):get_install_path()

  -- Setup config
  local config = {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', vim.fn.glob(install_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration', install_path .. '/config_' .. os_config,
      '-data', workspace_dir,
    },

    root_dir = root_dir,

    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.junit.Assume.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.junit.jupiter.api.Assumptions.*",
            "org.junit.jupiter.api.DynamicContainer.*",
            "org.junit.jupiter.api.DynamicTest.*",
            "org.mockito.Mockito.*",
            "org.mockito.ArgumentMatchers.*",
            "org.mockito.Answers.*"
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
          },
          hashCodeEquals = {
            useJava7Objects = true,
          },
          useBlocks = true,
        },
      }
    },

    init_options = {
      bundles = {}
    },
  }

  -- Keymaps
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
      local opts = { buffer = true }
      vim.keymap.set('n', '<leader>di', jdtls.organize_imports, opts)
      vim.keymap.set('n', '<leader>dt', jdtls.test_class, opts)
      vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
      vim.keymap.set('v', '<leader>de', jdtls.extract_variable, opts)
      vim.keymap.set('n', '<leader>de', jdtls.extract_variable, opts)
      vim.keymap.set('v', '<leader>dm', jdtls.extract_method, opts)
    end
  })

  -- Start the LSP
  require('jdtls').start_or_attach(config)
end

return {
  setup_jdtls = setup_jdtls
}
