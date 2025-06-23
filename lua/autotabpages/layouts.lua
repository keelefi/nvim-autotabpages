local M = {}

function M.defaults()
    local defaultLayouts = {
        c = {
            left = { "*.c" },
            right = { "*.h" },
        },
    }

    return defaultLayouts
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
        for _,patternList in pairs(layout) do
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
