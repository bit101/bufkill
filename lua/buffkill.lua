function killBuffer()
  -- if terminal, just delete and return
  if vim.o.buftype == 'terminal' then
    vim.cmd('bd!')
    return
  end

  -- if buffer is modified...
  if vim.o.modified then
    -- if it has a name, save it
    name = vim.call("bufname")
    if string.len(name) > 0 then
      vim.cmd('w')
    else
      -- if no name, ask if we should discard changes
      choice = vim.fn.confirm('Discard changes? ', '&Yes\n&No', 2)
      if choice ~= 1 then
        return
      end
    end 
  end

  -- if this is last buffer, just delete it
  buffers = vim.fn.getbufinfo({buflisted = 1})
  count = #buffers
  if count == 1 then
    vim.cmd('bd!')
  else
    -- switch to previous buffer and then delete this buffer (new previous)
    vim.cmd('bp|bd! #')
    count = count - 1
    -- if not the last buffer and this buffer is a terminal then go to new prev
    if count > 1 and vim.o.buftype == 'terminal' then
      vim.cmd('bp')
    end
  end
end

