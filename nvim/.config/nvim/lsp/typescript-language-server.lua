-- Install with: npm install -g typescript-language-server typescript

---@type vim.lsp.Config
return {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact'
    },
    -- Neovim 0.11+ natively handles root directory detection using these markers
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}
