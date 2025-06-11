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

function M.findFilesForTabLayout(layout, capture)
    local result = {}

    for split,patternList in pairs(layout) do
        result[split] = ""

        for _,pattern in ipairs(patternList) do
            local filename = string.gsub(pattern, "%*", capture)

            if vim.uv.fs_stat(filename) then
                result[split] = filename
                break
            end
        end

        if result[split] == "" then
            return nil
        end
    end

    return result
end

function M.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)
    for entryName,layout in pairs(layouts) do
        for split,patternList in pairs(layout) do
            for _,pattern in ipairs(patternList) do
                local matcher = string.gsub(pattern, "%*", "(.*)")
                matcher = "^" .. matcher .. "$"

                local capture = string.match(fileFullname, matcher)

                if capture then
                    local func = tabLayoutFunc or M.findFilesForTabLayout
                    local tabLayout = func(layout, capture)
                    if tabLayout then
                        return { language = entryName, splits = tabLayout }
                    end
                end
            end
        end
    end

    return nil
end

return M
