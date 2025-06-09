local filepatterns = require('autotabpages.filepatterns')

describe('File pattern tests', function()
    it('Test layout with C', function()
        local layouts = {
            c = {
                left = {'*.c'},
                right = {'*.h'},
            },
        }

        local expected = {'*.c', '*.h'}
        local actual = filepatterns.getFilePatterns(layouts)
        table.sort(actual)

        assert.are.same(expected, actual)
    end)
end)
