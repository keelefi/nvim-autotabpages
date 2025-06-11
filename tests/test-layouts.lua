local layoutsModule = require('autotabpages.layouts')

describe('Verify Layouts Tests', function()
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

    --after_each(function()
    --    vim.treesitter.language.get_filetypes:clear()
    --    vim.list_contains:clear()
    --end)

    it('Test Default Layout Is Valid', function()
        local layouts = layoutsModule.defaults()

        layoutsModule.verify(layouts)

        assert.spy(vim.treesitter.language.get_filetypes).was.called_with('c')
        assert.spy(vim.list_contains).was.called(4)
    end)

    it('Test C Layout Is Valid', function()
        local layouts = {
            c = {
                left = {'*.c'},
                right = {'*.h'},
            },
        }

        layoutsModule.verify(layouts)

        assert.spy(vim.treesitter.language.get_filetypes).was.called_with('c')
        assert.spy(vim.list_contains).was.called(4)
    end)

    it('Test C And C++ Layout Is Valid', function()
        local layouts = {
            c = {
                left = {'*.c'},
                right = {'*.h'},
            },
            cpp = {
                left = {'*.cpp', '*.cc'},
                right = {'*.h', '*.hh', '*.hpp'},
            },
        }

        layoutsModule.verify(layouts)

        assert.spy(vim.treesitter.language.get_filetypes).was.called_with('c')
        assert.spy(vim.treesitter.language.get_filetypes).was.called_with('cpp')
        assert.spy(vim.list_contains).was.called(11)
    end)

    it('Test Incorrect Filetype', function()
        _G.vim.treesitter.language.get_filetypes = function(str) return nil end

        local layouts = {
            abc = {
                left = {'*.c'},
                right = {'*.h'},
            },
        }

        local expectedErr = 'Language `abc` is not supported'
        local ok, err = pcall(layoutsModule.verify, layouts)

        assert.is.Not.True(ok)

        local actualErr = string.sub(err, -#expectedErr)
        assert.is.same(actualErr, expectedErr)
    end)

    it('Test Incorrect Split', function()
        local layouts = {
            c = {
                left = {'*.c'},
                east = {'*.h'},
            },
        }

        local expectedErr = 'Split `east` is not supported'
        local ok, err = pcall(layoutsModule.verify, layouts)

        assert.is.Not.True(ok)

        local actualErr = string.sub(err, -#expectedErr)
        assert.is.same(actualErr, expectedErr)
    end)

    it('Test Overlapping Pattern', function()
        local layouts = {
            c = {
                left = {'*.c', '*.a'},
                right = {'*.h', '*.a'},
            },
        }

        local expectedErr = 'Pattern `*.a` found in multiple splits'
        local ok, err = pcall(layoutsModule.verify, layouts)

        assert.is.Not.True(ok)

        local actualErr = string.sub(err, -#expectedErr)
        assert.is.same(actualErr, expectedErr)
    end)
end)

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

        local tabLayoutFunc = spy.new(function(layout, capture) return expectedTabLayout.splits end)

        local actualTabLayout = layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.c, 'src/foo')
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
            function(layout, capture)
                if layout == layouts.cpp then
                    return expectedTabLayout.splits
                end

                return nil
            end
        )

        local actualTabLayout = layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.cpp, 'src/foo')
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
            function(layout, capture)
                if layout == layouts.cpp then
                    return expectedTabLayout.splits
                end

                return nil
            end
        )

        local actualTabLayout = layoutsModule.getLayoutMatch(fileFullname, layouts, tabLayoutFunc)

        assert.spy(tabLayoutFunc).was.called_with(layouts.cpp, 'src/foo')
    end)
end)
