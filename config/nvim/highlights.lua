-- described in https://github.com/neovim/neovim/pull/11113
--  :help lua-treesitter-highlight
    local query = [[
      "for" @keyword
      "if" @keyword
      "return" @keyword

      (string_literal) @string
      (number_literal) @number
      (comment) @comment

      ; uppercase maps directly to hl group names
      (preproc_function_def name: (identifier) @Identifier)

      ; ... more definitions
    ]]

    -- highlighter = vim.treesitter.TSHighlighter.new(query, bufnr, language)
    -- alternatively, to use the current buffer and its filetype:
    highlighter = vim.treesitter.TSHighlighter.new(query)

   -- Don't recreate the highlighter for the same buffer, instead
   -- modify the query like this:
   -- local query2 = [[ ... ]]
   -- highlighter:set_query(query2)
