---@diagnostic disable:param-type-mismatch

local layoutsModule = require('autotabpages.layouts')

describe('Layout Match Tests', function()
    --[[
    before_each(function()
        _G.vim = {
            treesitter = {
                language = {
                    get_filetypes = spy.new(function(str) return {'.c', '.h'} end),
                },
            },
            list_contains = spy.new(
                function(tbl, item)
                    for _,tblItem in ipairs(tbl) do
                        if tblItem == item then
                            return true
                        end
                    end
                end
            ),
        }
    end)
    ]]

    --after_each(function()
    --    vim.treesitter.language.get_filetypes:clear()
    --    vim.list_contains:clear()
    --end)

    it('Test C Layout', function()
        local layouts = {
            c = {
                left = { '*.c' },
                right = { '*.h' },
            },
        }

        local fileFullname = 'src/foo.c'

        local expectedTabLayout = {
            language = 'c',
            splits = {
                left = 'src/foo.c',
                right = 'src/foo.h',
            }
        }

        ---@diagnostic disable-next-line:unused-local
        local tabLayoutFunc = spy.new(function(layout, capture, prefix) return expectedTabLayout.splits end)

        layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.c, 'src/foo', nil)
    end)

    it('Test C++ Layout, .cpp file', function()
        local layouts = {
            c = {
                left = { '*.c' },
                right = { '*.h' },
            },
            cpp = {
                left = {'*.cpp', '*.cc'},
                right = {'*.h', '*.hh', '*.hpp'},
            },
        }

        local fileFullname = 'src/foo.cpp'

        local expectedTabLayout = {
            language = 'cpp',
            splits = {
                left = 'src/foo.cpp',
                right = 'src/foo.h',
            }
        }

        local tabLayoutFunc = spy.new(
            ---@diagnostic disable-next-line:unused-local
            function(layout, capture, prefix)
                if layout == layouts.cpp then
                    return expectedTabLayout.splits
                end

                return nil
            end
        )

        layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.cpp, 'src/foo', nil)
    end)

    it('Test C++ Layout, .h file', function()
        local layouts = {
            c = {
                left = { '*.c' },
                right = { '*.h' },
            },
            cpp = {
                left = {'*.cpp', '*.cc'},
                right = {'*.h', '*.hh', '*.hpp'},
            },
        }

        local fileFullname = 'src/foo.h'

        local expectedTabLayout = {
            language = 'cpp',
            splits = {
                left = 'src/foo.cpp',
                right = 'src/foo.h',
            }
        }

        local tabLayoutFunc = spy.new(
            ---@diagnostic disable-next-line:unused-local
            function(layout, capture, prefix)
                if layout == layouts.cpp then
                    return expectedTabLayout.splits
                end

                return nil
            end
        )

        layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.cpp, 'src/foo', nil)
    end)

    it('Test Lua Layout', function()
        local layouts = {
            lua = {
                left = {'lua/?.lua'},
                right = {'tests/?-test.lua'},
            },
        }

        local fileFullname = 'lua/autotabpages/foo.lua'

        local expectedTabLayout = {
            language = 'lua',
            splits = {
                left = 'lua/autotabpages/foo.lua',
                right = 'tests/autotabpages/foo-test.lua',
            }
        }

        ---@diagnostic disable-next-line:unused-local
        local tabLayoutFunc = spy.new(function(layout, capture, prefix) return expectedTabLayout.splits end)

        layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.lua, 'autotabpages/foo', nil)
    end)

    it('Test Lua Layout, Open Test', function()
        local layouts = {
            lua = {
                left = {'lua/?.lua'},
                right = {'tests/?-test.lua'},
            },
        }

        local fileFullname = 'tests/autotabpages/foo-test.lua'

        local expectedTabLayout = {
            language = 'lua',
            splits = {
                left = 'lua/autotabpages/foo.lua',
                right = 'tests/autotabpages/foo-test.lua',
            }
        }

        ---@diagnostic disable-next-line:unused-local
        local tabLayoutFunc = spy.new(function(layout, capture, prefix) return expectedTabLayout.splits end)

        layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.lua, 'autotabpages/foo', nil)
    end)

    it('Test Lua Layout, Subdir', function()
        local layouts = {
            lua = {
                left = {'lua/?.lua'},
                right = {'tests/test-?.lua'},
            },
        }

        local fileFullname = 'autotabpages/lua/foo.lua'

        local expectedTabLayout = {
            language = 'lua',
            splits = {
                left = 'autotabpages/lua/autotabpages/foo.lua',
                right = 'autotabpages/tests/test-foo.lua',
            }
        }

        ---@diagnostic disable-next-line:unused-local
        local tabLayoutFunc = spy.new(function(layout, capture, prefix) return expectedTabLayout.splits end)

        layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.lua, 'foo', 'autotabpages')
    end)
end)

describe('Tab Layout Creation Tests', function()
    before_each(function()
        _G.vim = {
            uv = {
                fs_stat = spy.new(
                    function(filename)
                        for _,file in ipairs(files) do
                            if file == filename then
                                return true
                            end
                        end

                        return false
                    end
                ),
            },
        }
    end)

    it('Test C Files', function()
        local capture = 'src/foo'
        _G.files = { 'src/foo.c', 'src/foo.h' }
        local layout = {
            left = { '*.c' },
            right = { '*.h' },
        }

        local expected = {
            left = 'src/foo.c',
            right = 'src/foo.h',
        }

        local actual = layoutsModule.findFilesForTabLayout(layout, capture)

        assert.is.same(expected, actual)

        assert.spy(vim.uv.fs_stat).was.called_with('src/foo.c')
        assert.spy(vim.uv.fs_stat).was.called_with('src/foo.h')
    end)

    it('Test C++ Files', function()
        local capture = 'src/foo'
        _G.files = { 'src/foo.cpp', 'src/foo.h' }
        local layout = {
            left = {'*.cpp', '*.cc'},
            right = {'*.h', '*.hh', '*.hpp'},
        }

        local expected = {
            left = 'src/foo.cpp',
            right = 'src/foo.h',
        }

        local actual = layoutsModule.findFilesForTabLayout(layout, capture)

        assert.is.same(expected, actual)

        ---@diagnostic disable-next-line:missing-parameter
        assert.spy(vim.uv.fs_stat).was.called()
    end)

    it('Test Lua Files', function()
        local capture = 'autotabpages/foo'
        _G.files = { 'lua/autotabpages/foo.lua', 'tests/autotabpages/foo-test.lua' }
        local layout = {
            left = {'lua/?.lua'},
            right = {'tests/?-test.lua'},
        }

        local expected = {
            left = 'lua/autotabpages/foo.lua',
            right = 'tests/autotabpages/foo-test.lua',
        }

        local actual = layoutsModule.findFilesForTabLayout(layout, capture)

        assert.is.same(expected, actual)

        ---@diagnostic disable-next-line:missing-parameter
        assert.spy(vim.uv.fs_stat).was.called()
    end)

    it('Test Files Mix', function()
        local capture = 'src/bar'
        _G.files = { 'src/foo.cpp', 'src/foo.h', 'src/bar.cpp', 'src/bar.h' }
        local layout = {
            left = {'*.cpp', '*.cc'},
            right = {'*.h', '*.hh', '*.hpp'},
        }

        local expected = {
            left = 'src/bar.cpp',
            right = 'src/bar.h',
        }

        local actual = layoutsModule.findFilesForTabLayout(layout, capture)

        assert.is.same(expected, actual)

        ---@diagnostic disable-next-line:missing-parameter
        assert.spy(vim.uv.fs_stat).was.called()
    end)

    it('Test Lua Files, Many', function()
        _G.files = {
            'lua/foo.lua',
            'lua/bar.lua',
            'lua/biz.lua',
            'tests/test-foo.lua',
            'tests/test-bar.lua',
            'tests/test-biz.lua',
        }
        local layout = {
            left = {'lua/?.lua'},
            right = {'tests/test-?.lua'},
        }

        local capture = 'foo'
        local expected = {
            left = 'lua/foo.lua',
            right = 'tests/test-foo.lua',
        }
        local actual = layoutsModule.findFilesForTabLayout(layout, capture)
        assert.is.same(expected, actual)

        capture = 'bar'
        expected = {
            left = 'lua/bar.lua',
            right = 'tests/test-bar.lua',
        }
        actual = layoutsModule.findFilesForTabLayout(layout, capture)
        assert.is.same(expected, actual)

        capture = 'biz'
        expected = {
            left = 'lua/biz.lua',
            right = 'tests/test-biz.lua',
        }
        actual = layoutsModule.findFilesForTabLayout(layout, capture)
        assert.is.same(expected, actual)
    end)

    it('Test Lua Files, Subdir', function()
        _G.files = {
            'autotabpages/lua/foo.lua',
            'autotabpages/tests/test-foo.lua',
        }
        local layout = {
            left = {'lua/?.lua'},
            right = {'tests/test-?.lua'},
        }

        local capture = 'foo'
        local prefix = 'autotabpages'
        local expected = {
            left = 'autotabpages/lua/foo.lua',
            right = 'autotabpages/tests/test-foo.lua',
        }
        local actual = layoutsModule.findFilesForTabLayout(layout, capture, prefix)
        assert.is.same(expected, actual)
    end)
end)
