function killBuffer()
  -- if readonly, just delete and return
  if vim.o.readonly then
    vim.cmd('bd!')
    return
  end

  -- buffer is modified
  if vim.o.modified then
    choice = vim.fn.confirm('Modified file.', '&Save\n&Discard changes\n&Cancel', 3)

    -- discard does nothing and the buffer will be deleted below

    -- cancel...
    if choice == 3 then
      return
    end

    -- save...
    if choice == 1 then
      name = vim.fn.bufname()
      if string.len(name) > 0 then
        -- has a name
        vim.cmd('silent! w')
      else
        -- needs a name
        filename = vim.fn.input('Save as: ', '', 'dir')
        if filename == "" then
          -- user aborted
          print('Buffer delete aborted.')
          return
        else
          vim.cmd('silent! w ' .. filename)
        end
      end 
    end
  end

  buffers = vim.fn.getbufinfo({buflisted = 1})
  count = #buffers
  if count == 1 then
    -- last buffer open
    vim.cmd('bd!')
  else
    -- swap this buffer with previous buffer and delete this.
    vim.cmd('bp|bd! #')
    count = count - 1
    if count > 1 and vim.o.buftype == 'terminal' then
      -- swapped buffer is a terminal, but there's another buffer in the list
      -- switch to it.
      vim.cmd('bp')
    end
  end
end

