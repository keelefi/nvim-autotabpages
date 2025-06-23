local M = {}

local function layoutHasQuestionmarks(layouts)
    for _,layout in pairs(layouts) do
        for _,patternList in pairs(layout) do
            for _,pattern in ipairs(patternList) do
                if string.find(pattern, '?', 0, true) then
                    return true
                end
            end
        end
    end

    return false
end

local function parseHookPatterns(layouts)
    local hookPatterns = {}

    for _,layout in pairs(layouts) do
        for _,patternList in pairs(layout) do
            for _,pattern in ipairs(patternList) do
                local itemAdded = false
                for _,hookPattern in ipairs(hookPatterns) do
                    if pattern == hookPattern then
                        itemAdded = true
                        break
                    end
                end
                if not itemAdded then
                    table.insert(hookPatterns, pattern)
                end
            end
        end
    end

    return hookPatterns
end

local function createHookPatterns(layouts)
    local hookPatterns = {}

    for _,layout in pairs(layouts) do
        for _,patternList in pairs(layout) do
            for _,pattern in ipairs(patternList) do
                local lastDot = string.find(pattern, '%.%a+$')
                assert(type(lastDot) == 'number')
                local filetype = '*' .. string.sub(pattern, lastDot)

                local itemAdded = false
                for _,hookPattern in ipairs(hookPatterns) do
                    if filetype == hookPattern then
                        itemAdded = true
                        break
                    end
                end
                if not itemAdded then
                    table.insert(hookPatterns, filetype)
                end
            end
        end
    end

    return hookPatterns
end

function M.getFilePatterns(layouts)
    if layouts == nil then
        local config = require('autotabpages.config')

        layouts = config.options.layouts
    end

    local transformationNeeded = layoutHasQuestionmarks(layouts)

    if transformationNeeded then
        return createHookPatterns(layouts)
    else
        return parseHookPatterns(layouts)
    end
end

return M
