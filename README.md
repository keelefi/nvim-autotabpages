# AutoTabPages

[![Typecheck](https://github.com/keelefi/nvim-autotabpages/actions/workflows/luals.yml/badge.svg)](https://github.com/keelefi/nvim-autotabpages/actions/workflows/luals.yml)
[![Unit Tests](https://github.com/keelefi/nvim-autotabpages/actions/workflows/busted.yml/badge.svg)](https://github.com/keelefi/nvim-autotabpages/actions/workflows/busted.yml)

`AutoTabPages` is a [NeoVim](https://neovim.io/) plugin that automatically sets up a tabpage layout when a new tab is
opened. It does so by matching file patterns to the file opened and files available on the system.

## Configuration

Configure `AutoTabPages` with [lazy.nvim](https://lazy.folke.io/) as follows:

```
local M = {
    'keelefi/nvim-autotabpages',
    opts = {
        layouts = {
            c = {
                left = {"*.c"},
                right = {"*.h"},
            },
            cpp = {
                left = {"*.cpp", "*.cc"},
                right = {"*.h", "*.hh", "*.hpp"},
            },
        },
    },
}

return { M }
```
