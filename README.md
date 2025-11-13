# Autosemicolon

This neovim plugin aims to add missing semicolons in nix files.

## Notes

Works not all the time because of the treesitter grammar for nix. For example,
if after binding expressions. For now only in the nix language the missing
semicolon is at the end of an attrset it does not work because the grammar is
not different from the valid case.
