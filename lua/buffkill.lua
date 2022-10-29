local function getDefaultChoice()
  local choice = vim.g.buf_kill_default_choice
  if choice == "save" then
    return 1
  elseif choice == "discard" then
    return 2
  end
  return 3
end 

local function doSave()
  local name = vim.fn.bufname()
  if string.len(name) > 0 then
    vim.cmd('silent! w')
    return true
  end

  local filename = vim.fn.input('Save as: ', '', 'dir')
  if filename == "" then
    -- user didn't enter a name. probably pressed escape.
    print('Buffer delete aborted.')
    return false
  else
    vim.cmd('silent! w ' .. filename)
  end
  return true
end

local function doPrompt()
  local default_choice = getDefaultChoice()
  local choice = vim.fn.confirm('Modified buffer.', '&Save\n&Discard changes\n&Cancel', default_choice)

  -- save...
  if choice == 1 then
    return doSave()
  end

  -- discard...
  if choice == 2 then
    return true
  end

  -- cancel...
  if choice == 3 then
    return false
  end

  return true
end

local function checkSave()
  if not vim.o.modified then
    return true
  end

  local action = vim.g.buf_kill_default_action

  if action == "discard" then 
    return true
  end

  if action == "save" then
    return doSave()
  end
  -- prompt is default
  return doPrompt()
end


function killBuffer()
  -- if readonly, just delete and return
  if vim.o.readonly then
    vim.cmd('bd!')
    return
  end

  local ok = checkSave()
  if not ok then
    return
  end

  local buffers = vim.fn.getbufinfo({buflisted = 1})
  local count = #buffers
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

