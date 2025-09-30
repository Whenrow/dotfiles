local M = {}
M.get_current_parent_name = function(type)
    local cursor_node = vim.treesitter.get_node()
    if not cursor_node or not type then return nil end

    -- Traverse up the tree to find the enclosing function node
    local function_node = cursor_node
    while function_node do
        local ftype = function_node:type()
        if ftype == type then
            break
        end
        function_node = function_node:parent()
    end

    local function_name = function_node and function_node:field("name")[1] or nil
    if not function_node then return nil end
    return vim.treesitter.get_node_text(function_name, 0)
end
vim.keymap.set('n', '<leader>cf', function()
    local func_name = M.get_current_parent_name("function_definition")
    print("Current function: " .. func_name)
end, { desc = "Show current function name" })
vim.keymap.set('n', '<leader>cp', function()
    local func_name = M.get_current_parent_name("function_definition")
    if func_name then
        vim.fn.setreg('+', func_name)
    end
end, { desc = "copy function in system clipboard" })
return M
