local M = {}

local function filesForAllSplits(layout, capture)
    local result = {}

    for split,patternList in pairs(layout) do
        result[split] = ""

        for _,pattern in ipairs(patternList) do
            local filename = string.gsub(pattern, "%*", capture)

            --if vim.fs.exists(filename) then
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

local function getLayoutMatch(fileFullname)
    local config = require('autotabpages.config')

    for entryName,layout in pairs(config.options.layouts) do
        for split,patternList in pairs(layout) do
            for _,pattern in ipairs(patternList) do
                local matcher = string.gsub(pattern, "%*", "(.*)")
                matcher = "^" .. matcher .. "$"

                local capture = string.match(fileFullname, matcher)

                if capture then
                    local splits = filesForAllSplits(layout, capture)
                    if splits then
                        return { language = entryName, splits = splits }
                    end
                end
            end
        end
    end

    return nil
end

function M.newTabLayout(args)
    local filename = args.file
    fileFullname = vim.fs.abspath(filename)

    --local basename = vim.fs.basename(args.file)
    --local fullpath = fileFullname:sub(1, #fileFullname-#basename)

    local tabLayout = getLayoutMatch(fileFullname)
    if not tabLayout then
        return
    end

    -- TODO: check if layout was already open

    require('autotabpages.tabopen').tabopen(fileFullname, tabLayout)
end

return M
