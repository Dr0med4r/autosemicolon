M = {}
local ts = vim.treesitter


local query_string = [[
((_
    function:(_) @function
    argument:(_) @argument)
(ERROR) @error)
]]

local function add_semicolon_after_node(buffer, node)
    local _, _, end_row, end_col = node:range()
    vim.api.nvim_buf_set_text(buffer, end_row, end_col, end_row, end_col, { ";" })
end

local function get_node_content(buffer, node)
    local start_row, start_col, end_row, end_col = node:range()
    return vim.api.nvim_buf_get_text(buffer, start_row, start_col, end_row, end_col, {})
end

M.add_semicolon = function(args)
    local parser = assert(ts.get_parser(args.buf))
    local tree = parser:parse()[1]
    local root = tree:root()
    local lang = parser:lang()
    local query = ts.query.parse(lang, query_string)
    for _, match, _ in query:iter_matches(root, args.buf) do
        -- assume the captures are always in the same order
        local function_node = match[1][1]
        local argument_node = match[2][1]
        local error_node = match[3][1]

        local error_node_content = get_node_content(args.buf, error_node)
        if error_node_content[1] == "=" then
            add_semicolon_after_node(args.buf, function_node)
        end
        if error_node_content[1] == "}" then
            add_semicolon_after_node(args.buf, argument_node)
        end
    end
end




M.autocmd = function()
    vim.api.nvim_create_autocmd(
        { "InsertLeave" },
        {
            group = vim.api.nvim_create_augroup("Autosemicolon", {}),
            pattern = { "*.nix" },
            callback = M.add_semicolon,
        }
    )
end
return M
