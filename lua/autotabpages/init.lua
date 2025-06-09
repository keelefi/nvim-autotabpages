local state = require('autotabpages.state')

local M = {}

function M.enable()
    if state.getEnabled() then return end

    require('autotabpages.autocmds').enable()

    state.setEnabled(true)
end

function M.disable()
    if not state.getEnabled() then return end

    require('autotabpages.autocmds').disable()

    state.setEnabled(false)
end

function M.toggle()
    if state.getEnabled() then
        M.disable()
    else
        M.enable()
    end
end

function M.setup(opts)
    --_G.AutoTabPages.config = require("autotabpages.config").setup(opts)
    require("autotabpages.config").setup(opts)

    M.enable()
end

--_G.AutoTabPages = M

--return _G.AutoTabPages
return M
