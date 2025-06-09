local M = {}

function M.enable()
    vim.api.nvim_create_user_command(
            'AutoTabPages',
            require('autotabpages').toggle,
            {}
        )
end

function M.disable()
    vim.api.nvim_del_user_command('AutoTabPages')
end

return M
