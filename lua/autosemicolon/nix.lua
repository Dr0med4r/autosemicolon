M = {}
local ts = vim.treesitter


local query_string = [[
((_
    function:(_) @wrong
    argument:(_))
(ERROR))
]]

M.add_semicolon = function(args)
    local parser = assert(ts.get_parser(args.buf))
    local tree = parser:parse()[1]
    local root = tree:root()
    local lang = parser:lang()
    local query = ts.query.parse(lang, query_string)
    for _, match, _ in query:iter_matches(root, args.buf) do
        for _, nodes in pairs(match) do
            for _, node in pairs(nodes) do
                local row, column, _ = node:end_()
                vim.api.nvim_buf_set_text(args.buf, row, column, row, column, { ";" })
            end
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
