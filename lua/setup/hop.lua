local hop = require('hop')

vim.keymap.set(
    '', 's',
    function()
        hop.hint_char1({})
    end,
    { remap = true }
)

vim.keymap.set(
    '', 'S',
    function()
        hop.hint_lines({})
    end,
    { remap = true }
)
