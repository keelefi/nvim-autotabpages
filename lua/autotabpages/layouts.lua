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

local function patternHasQuestionmarks(pattern)
    return string.find(pattern, '?', 0, true)
end

function M.findFilesForTabLayout(layout, capture, prefix)
    local result = {}

    for split,patternList in pairs(layout) do
        result[split] = ""

        for _,pattern in ipairs(patternList) do
            local filename
            if patternHasQuestionmarks(pattern) then
                filename = string.gsub(pattern, "%?", capture)
            else
                filename = string.gsub(pattern, "%*", capture)
            end

            if prefix then
                filename = string.format("%s/%s", prefix, filename)
            end

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
                local matcher
                if patternHasQuestionmarks(pattern) then
                    matcher = string.gsub(pattern, "%?", "(.*)")
                else
                    matcher = string.gsub(pattern, "%*", "(.*)")
                    matcher = "^" .. matcher .. "$"
                end

                local capture = string.match(fileFullname, matcher)

                if capture then
                    local prefix = nil
                    if patternHasQuestionmarks(pattern) then
                        local patternFilled = string.gsub(pattern, "%?", capture)
                        local prefixLength = string.find(fileFullname, patternFilled)
                        if prefixLength and prefixLength > 1 then
                            prefix = string.sub(fileFullname, 1, prefixLength-2)
                        end
                    end

                    local func = tabLayoutFunc or M.findFilesForTabLayout
                    local tabLayout = func(layout, capture, prefix)
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
