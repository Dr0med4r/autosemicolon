# Autosemicolon

This neovim plugin aims to add missing semicolons in Nix files.

## Notes

Works not all the time because of the treesitter grammar for Nix.

For example, if the missing semicolon is at the end of an attrset the grammar
is not different from the valid case.
