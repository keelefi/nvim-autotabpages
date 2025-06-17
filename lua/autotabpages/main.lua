local M = {}

function M.newTabLayout(args)
    local filename = args.file
    local fileFullname = vim.fs.abspath(filename)

    --local basename = vim.fs.basename(args.file)
    --local fullpath = fileFullname:sub(1, #fileFullname-#basename)

    local config = require('autotabpages.config')

    local tabLayout = require('autotabpages.layouts').getLayoutMatch(fileFullname, config.options.layouts)
    if not tabLayout then
        return
    end

    -- TODO: check if layout was already open

    require('autotabpages.tabopen').tabopen(fileFullname, tabLayout)
end

return M
