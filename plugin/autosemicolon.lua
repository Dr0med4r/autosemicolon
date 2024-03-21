if vim.g.loaded_autosemicolon then
    return
end

vim.g.loaded_autosemicolon = true

require("autosemicolon.nix").autocmd()
