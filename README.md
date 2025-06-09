# AutoTabPages

`AutoTabPages` is a [NeoVim](https://neovim.io/) plugin that automatically sets up a tabpage layout when a new tab is
opened. It does so by matching file patterns to the file opened and files available on the system.

## Configuration

Configure `AutoTabPages` with [lazy.nvim](https://lazy.folke.io/) as follows:

```
local M = {
    'https://github.com/keelefi/nvim-autotabpages',
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
