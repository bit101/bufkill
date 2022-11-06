function! s:GetDefaultChoice()
  let choice = g:bufkill_default_choice
  if choice == "save"
    return 1
  elseif choice == "discard"
    return 2
  endif
  return 3
endfunction

function! s:DoSave()
  let name = bufname('%')
  if len(name) > 0
    execute 'silent! w'
    return 1
  endif

  let filename = input('Save as: ', '', 'dir')
  if filename == ""
    " user didn't enter a name. probably pressed escape.
    return 0
  else
    execute 'silent! w ' . filename
  endif
  return 1
endfunction

function! s:DoPrompt()
  let default_choice = s:GetDefaultChoice()
  let choice = confirm('Modified buffer.', "&Save\n&Discard changes\n&Cancel", default_choice)

  " escape, CTRL-C, other interrupt...
  if choice == 0
    return 0
  endif

  " save...
  if choice == 1
    return s:DoSave()
  endif

  " discard...
  if choice == 2
    return 1
  endif

  " cancel...
  if choice == 3 
    return 0
  endif

  " shouldn't get here, but...
  return 0
endfunction

function! s:CheckSave()
  " confirm closing terminal
  if &buftype == 'terminal'
    if g:bufkill_close_terminal
      return 1
    endif

    let choice = confirm('OK to close terminal?', "&Yes\n&No", 2)
    if choice == 1 
      return 1
    endif
    return 0
  endif

  " these don't need to be saved
  if !&modified || &readonly
    return 1
  endif

  let action = g:bufkill_default_action

  if action == "discard"
    return 1
  endif

  if action == "save"
    return s:DoSave()
  endif

  " prompt is default
  return s:DoPrompt()
endfunction

function! s:swapAndKill()
  " swap this buffer with previous buffer and delete this.
  execute 'bp|bd! #'
  let bufferCount = len(getbufinfo({'buflisted': 1}))
  let openCount = len(win_findbuf(bufnr('%')))

  if openCount > 1
    " swapped buffer is already open in another split
    if bufferCount == 1
      " this is the last buffer, kill the split
      execute 'only'
    else 
      " there is another open buffer, so switch to it.
      execute 'bp'
    endif
  endif
endfunction

function! s:Kill()
  " ignore the fancy split handling. just delete.
  if g:bufkill_ignore_splits
    execute 'bd!'
    return
  endif

  let bufferCount = len(getbufinfo({'buflisted': 1}))
  let openCount = len(win_findbuf(bufnr('%')))

  if bufferCount == 1
    " last buffer open
    execute 'bd!'
  elseif openCount > 1
    " edge case: starting off with duplicate buffers in a split
    " we'll just show the previous buffer and not close anything
    execute 'bp'
  else
    call s:swapAndKill()
  endif
endfunction

function! bufkill#KillBuffer()
  let ok = s:CheckSave()

  " we might have abandoned in CheckSave()
  if ok
    call s:Kill()
  endif
endfunction

