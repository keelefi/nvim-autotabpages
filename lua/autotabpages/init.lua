local M = {}

function M.enable()
    require('autotabpages.autocmds').enable()
end

function M.disable()
    require('autotabpages.autocmds').disable()
end

function M.setup(opts)
    --_G.AutoTabPages.config = require("autotabpages.config").setup(opts)
    require("autotabpages.config").setup(opts)

    M.enable()
end

--_G.AutoTabPages = M

--return _G.AutoTabPages
return M
