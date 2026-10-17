-- [[ Configure Treesitter ]]
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then return end

    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if not lang then return end

    local ok, added = pcall(vim.treesitter.language.add, lang)
    if ok and added then
      vim.treesitter.start(buf, lang)
    end
  end,
})
