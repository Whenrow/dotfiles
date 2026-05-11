vim.cmd('colorscheme kanagawa-wave')
require('nvim-highlight-colors').setup{
    render = 'virtual', -- or 'foreground' or 'first_column'
    virtual_symbol = '■',
    virtual_symbol_position = 'inline',
    enable_named_colors = true,
    enable_tailwind = false,
    -- Available formats: rgb, hsl, hex, hwb, cmyk, hsv, hsluv, lab, lch, xyz
    -- Default format is rgb
    color_format = 'hex',
}
