local M = {}

function M.tabopen(originalFile, tabLayout)
    local originalFileAbsPath = vim.fs.abspath(originalFile)

    for split,filename in pairs(tabLayout.splits) do
        local filenameAbsPath = vim.fs.abspath(filename)

        if filenameAbsPath ~= originalFileAbsPath then   -- skip original because it's already opened
            local windowID = vim.api.nvim_open_win(0, false, {
                noautocmd = true,
                split = split,
            })

            vim.fn.win_execute(windowID, string.format('edit %s', filename))
        end
    end
end

return M
