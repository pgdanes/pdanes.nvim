local h = require("harpoon")
h:setup()

vim.keymap.set("n", "<leader>ha",
    function()
        h:list():add()
    end,
    { desc = "[A]dd File to Harpoon" }
)

vim.keymap.set("n", "<leader>ho",
    function()
        h.ui:toggle_quick_menu(h:list())
    end,
    { desc = "[O]pen Menu" }
)

vim.keymap.set("n", "<leader>hp",
    function()
        h:list():prev()
    end,
    { desc = "[P]revious File" }
)

vim.keymap.set("n", "<leader>hn",
    function()
        h:list():next()
    end,
    { desc = "[N]ext File" }
)

local function add_harpoon_page_bind(page_num)
    vim.keymap.set("n", "<leader>h" .. page_num,
        function()
            h:list():select(page_num)
        end,
        { desc = "Goto file #[" .. page_num .. "]" }
    )
end

for i = 1, 4 do
    add_harpoon_page_bind(i)
end

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>hs",
    function() toggle_telescope(harpoon:list()) end,
    { desc = "[S]earch files" }
)
