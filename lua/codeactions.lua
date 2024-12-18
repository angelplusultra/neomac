
vim.opt.updatetime = 10 -- 300ms for CursorHold event
local code_action_hint_ns = vim.api.nvim_create_namespace("CodeActionHint")

-- Function to check for code actions and show a hint
local function show_code_action_hint()
  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

  vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(responses)
    -- Clear any previous hints
    vim.api.nvim_buf_clear_namespace(0, code_action_hint_ns, 0, -1)

    for _, result in pairs(responses) do
      if result.result and #result.result > 0 then
        -- Add the hint on the current line
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        vim.api.nvim_buf_set_extmark(0, code_action_hint_ns, line, 0, {
          virt_text = { { "💡", "DiagnosticHint" } },
          virt_text_pos = "eol",
          hl_mode = "combine",
        })
        break
      end
    end
  end)
end

-- Autocommand to check for code actions when the cursor moves
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = {"*.rs", "*.lua", "*.js", "*.ts", "*.py"},
  callback = function()
    -- Check if the buffer is a normal file buffer
    if vim.bo.buftype == "" then
      show_code_action_hint()
    end
  end,
})
