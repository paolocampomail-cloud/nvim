return {
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Note: The keybinds you set in lsp.lua (LspAttach) will usually work here automatically.
            -- However, specific Rust commands can be added here if needed.
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        },
        -- DAP configuration (Debug Adapter)
        dap = {
        },
      }
    end
  }
}
