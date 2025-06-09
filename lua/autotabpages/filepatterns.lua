local M = {}

function M.getFilePatterns(layouts)
    if layouts == nil then
        local config = require('autotabpages.config')

        layouts = config.options.layouts
    end

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

return M
