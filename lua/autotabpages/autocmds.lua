local M = {}

local AutoGroupName = 'PluginAutoTabPages'

function M.enable()
    local group = vim.api.nvim_create_augroup(AutoGroupName, { clear = true })

    -- TODO: autocmd for file open
    -- BufNew ??

    vim.api.nvim_create_autocmd({'TabNewEntered'}, {
        group = group,
        pattern = require('autotabpages.filepatterns').getFilePatterns(),
        callback = require('autotabpages.main').newTabLayout,
        -- nested = true, ??
    })
end

function M.disable()
    vim.api.nvim_delete_augroup_by_name(AutoGroupName)
end

return M
