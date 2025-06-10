local M = {}

function M.tabopen(originalFile, tabLayout)
    for split,filename in pairs(tabLayout.splits) do
        if filename ~= originalFile then   -- skip original because it's already opened
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
