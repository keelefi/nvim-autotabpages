local layoutsModule = require('autotabpages.layouts')

--_G.vim = require('mock-vim')
_G.vim = {
    treesitter = {
        language = {
            get_filetypes = spy.new(function(str) return {'.c', '.h'} end),
        },
    },
    list_contains = spy.new(function(tbl, item) return item == "left" or item == "right" end),
}

describe('Layouts Tests', function()
    after_each(function()
        vim.treesitter.language.get_filetypes:clear()
        vim.list_contains:clear()
    end)

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
end)
