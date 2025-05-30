require('lualine').setup {
    options = {
        theme = vim.g.color_name,
        icons_enabled = true,
        section_separators = { left = '▒', right = '▒' },
        component_separators = { left = '', right = '' }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            {
                symbols = {
                    modified = '',      -- Text to show when the file is modified.
                    readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[No Name]', -- Text to show for unnamed buffers.
                },
                'filename',
                file_status = true,      -- Displays file status (readonly status, modified status)
                path = 1,                -- 0: Just the filename
                shorting_target = 40,    -- Shortens path to leave 40 spaces in the window

            }
        },
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
}
