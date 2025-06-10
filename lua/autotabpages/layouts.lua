local M = {}

local splits = {
    "left",
    "right",
    "below",
    "above",
}

function M.defaults()
    local defaultLayouts = {
        c = {
            left = { "*.c" },
            right = { "*.h" },
        },
    }

    return defaultLayouts
end

function M.verify(layouts)
    for language,layout in pairs(layouts) do
        local filetypes = vim.treesitter.language.get_filetypes(language)
        assert(filetypes, string.format("Language `%s` is not supported", language))

        local patterns = {}
        for split,patternList in pairs(layout) do
            assert(vim.list_contains(splits, split), string.format("Split `%s` is not supported", split))

            for _,pattern in ipairs(patternList) do
                assert(not vim.list_contains(patterns, pattern), string.format("Pattern `%s` found in multiple splits", pattern))

                table.insert(patterns, pattern)
            end
        end
    end
end

return M
