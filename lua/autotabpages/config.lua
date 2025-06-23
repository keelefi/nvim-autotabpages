local layouts = require("autotabpages.layouts")

local M = {}

M.options = {
    layouts = layouts.defaults(),
}

local defaults = vim.deepcopy(M.options)

function M.defaults(opts)
    M.options =
        vim.deepcopy(vim.tbl_deep_extend("keep", opts or {}, defaults or {}))

    require('autotabpages.verify').verify(M.options.layouts)

    return M.options
end

function M.setup(opts)
    M.options = M.defaults(opts or {})

    return M.options
end

return M
