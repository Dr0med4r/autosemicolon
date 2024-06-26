M = {}
local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")


local query_string = [[
((binding) @wrong
    (#not-match? @wrong ".*;"))
]]

M.add_semicolon = function(args)
    local parser = parsers.get_parser(args.buf)
    local tree = parser:parse()[1]
    local root = tree:root()
    local lang = parser:lang()
    local query = ts.query.parse(lang, query_string)
    for _, matches, _ in query:iter_matches(root, args.buf, 0, -1) do
        for _, match in pairs(matches) do
            local row, column, _ = match:end_()
            vim.api.nvim_buf_set_text(args.buf, row, column, row, column, { ";" })
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
