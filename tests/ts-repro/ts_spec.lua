local ts_utils = require("nvim-treesitter.ts_utils")

describe("treesitter-test", function()
  it("should find a nodes named sibling", function()
    vim.api.nvim_set_option_value("filetype", "clojure", {
      buf = 0,
    })

    local content = "(a) b c"

    vim.api.nvim_buf_set_lines(0, 0, -1, true, { content })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })

    vim.treesitter.get_parser(0):parse()

    local node = ts_utils.get_node_at_cursor()
    assert.not_nil(node)
    if not node then
      return
    end

    assert.are_equal("list_lit", node:type())

    local sibling = node:next_named_sibling()
    assert.not_nil(sibling)
    if not sibling then
      return
    end

    assert.are_equal("sym_lit", sibling:type())
  end)
end)
