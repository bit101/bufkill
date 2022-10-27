function killBuffer()
  buffers = vim.fn.getbufinfo({buflisted = 1})
  count = #buffers

  -- if terminal, just delete and return
  if vim.o.buftype == 'terminal' then
    vim.cmd("bd!")
    return
  end

  -- save buffer if it has a name
  name = vim.call("bufname")
  if string.len(name) > 0 then
    vim.cmd("w")
  end

  -- if this is last buffer, just delete it
  if count == 1 then
    vim.cmd("bd")
  else
    -- switch to previous buffer and then delete this buffer (new previous)
    vim.cmd("bp|bd #")
  end
end
