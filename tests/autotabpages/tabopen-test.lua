---@diagnostic disable:param-type-mismatch

local tabopen = require('autotabpages.tabopen')

describe('Test TabOpen', function()
    before_each(function()
        _G.vim = {
            api = {
                ---@diagnostic disable-next-line:unused-local
                nvim_open_win = spy.new(function(buf, enter, config) return 0 end),
            },
            fn = {
                ---@diagnostic disable-next-line:unused-local
                win_execute = spy.new(function(winid, cmd) end),
                getwininfo = spy.new(
                    ---@diagnostic disable-next-line:unused-local
                    function(winid)
                        return { { bufnr = 0 } }
                    end
                ),
            },
            fs = {
                abspath = spy.new(
                    function(filename)
                        local prefix = '/home/user/'
                        if string.find(filename, prefix) then
                            return string.sub(filename, #prefix+1)
                        end
                        return filename
                    end
                ),
            },
            treesitter = {
                ---@diagnostic disable-next-line:unused-local
                start = spy.new(function(bufid, lang) end),
            },
        }
    end)

    it('Test C Layout, Open Left', function()
        local tabLayout = {
            language = 'c',
            splits = {
                left = 'left.c',
                right = 'right.h',
            },
        }

        tabopen.tabopen('left.c', tabLayout)

        assert.spy(vim.api.nvim_open_win).was.called_with(0, false, {noautocmd = true, split = 'right'})
        assert.spy(vim.fn.win_execute).was.called_with(0, 'edit right.h')
    end)

    it('Test C Layout, Open Right', function()
        local tabLayout = {
            language = 'c',
            splits = {
                left = 'left.c',
                right = 'right.h',
            },
        }

        tabopen.tabopen('right.h', tabLayout)

        assert.spy(vim.api.nvim_open_win).was.called_with(0, false, {noautocmd = true, split = 'left'})
        assert.spy(vim.fn.win_execute).was.called_with(0, 'edit left.c')
    end)

    it('Test Lua Layout, Open Left', function()
        local tabLayout = {
            language = 'lua',
            splits = {
                left = 'lua/autotabpages/verify.lua',
                right = 'tests/autotabpages/verify-test.lua',
            },
        }

        tabopen.tabopen('lua/autotabpages/verify.lua', tabLayout)

        assert.spy(vim.api.nvim_open_win).was.called_with(0, false, {noautocmd = true, split = 'right'})
        assert.spy(vim.fn.win_execute).was.called_with(0, 'edit tests/autotabpages/verify-test.lua')
    end)

    it('Test Lua Layout, Open Right', function()
        local tabLayout = {
            language = 'lua',
            splits = {
                left = 'lua/autotabpages/verify.lua',
                right = 'tests/autotabpages/verify-test.lua',
            },
        }

        tabopen.tabopen('tests/autotabpages/verify-test.lua', tabLayout)

        assert.spy(vim.api.nvim_open_win).was.called_with(0, false, {noautocmd = true, split = 'left'})
        assert.spy(vim.fn.win_execute).was.called_with(0, 'edit lua/autotabpages/verify.lua')
    end)

    it('Test Lua Layout, Full Filepath', function()
        local tabLayout = {
            language = 'lua',
            splits = {
                left = 'lua/autotabpages/verify.lua',
                right = 'tests/autotabpages/verify-test.lua',
            },
        }

        tabopen.tabopen('/home/user/lua/autotabpages/verify.lua', tabLayout)

        assert.spy(vim.api.nvim_open_win).was.called_with(0, false, {noautocmd = true, split = 'right'})
        assert.spy(vim.fn.win_execute).was.called_with(0, 'edit tests/autotabpages/verify-test.lua')
    end)
end)
