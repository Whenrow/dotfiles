local server = '/home/user/.local/share/nvim/odoo/odoo_ls_server'
-- Get the default client capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Add your custom capability
capabilities.general.markdown = {
  parser = 'marked',
  version = ''
}
return {
  cmd = {server, '--stdlib', vim.fn.fnamemodify(server, ':h') .. '/typeshed/stdlib'},
  root_dir = '/home/whe/.local/share/nvim/odoo',
  filetypes = { 'python' },
  workspace_folders = {{
      uri = vim.uri_from_fname('/home/whe/src'),
      name = 'main_folder',
  }},
  capabilities = capabilities,
  settings = {
      Odoo = {
          selectedProfile = 'main',
      }
  },
}
