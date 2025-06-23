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

            local windowInfo = vim.fn.getwininfo(windowID)
            if windowInfo and windowInfo[1] then
                local bufferID = windowInfo[1].bufnr
                vim.treesitter.start(bufferID, tabLayout.language)
            end
        end
    end
end

return M
