function s:getDefaultChoice()
  let l:choice = g:buf_kill_default_choice
  if l:choice == "save"
    return 1
  elseif l:choice == "discard"
    return 2
  endif
  return 3
endfunction

function s:doSave()
  let l:name = bufname('%')
  if len(name) > 0
    execute 'silent! w'
    return 1
  endif

  let l:filename = input('Save as: ', '', 'dir')
  if filename == ""
    " user didn't enter a name. probably pressed escape.
    echom 'Buffer delete aborted.'
    return 0
  else
    execute 'silent! w ' . filename
  endif
  return 1
endfunction

function s:doPrompt()
  let l:default_choice = s:getDefaultChoice()
  let l:choice = confirm('Modified buffer.', "&Save\n&Discard changes\n&Cancel", default_choice)

  " save...
  if l:choice == 1
    return s:doSave()
  endif

  " discard...
  if l:choice == 2
    return 1
  endif

  " cancel...
  if l:choice == 3 
    return 0
  endif

  " shouldn't get here but...
  return 1
endfunction

function s:checkSave()
  " these don't need to be saved
  if !&modified || &readonly || &buftype == 'terminal'
    return 1
  endif

  let l:action = g:buf_kill_default_action

  if action == "discard"
    return 1
  endif

  if action == "save"
    return s:doSave()
  endif

  " prompt is default
  return s:doPrompt()
endfunction


function s:killBuffer()
  let l:ok = s:checkSave()
  if !l:ok
    return
  endif

  " " if readonly, just delete and return
  " if &readonly || &buftype == "terminal"
  "   execute 'bd!'
  "   return
  " endif

  let l:openCount = len(win_findbuf(bufnr('%')))
  let l:buffers = getbufinfo({'buflisted': 1})
  let l:count = len(l:buffers)
  if l:count == 1
    " last buffer open
    execute 'bd!'
  else
    if l:openCount > 1
      " edge case: starting off with duplicate buffers in a split
      " need to go back one
      execute 'bp'
      return
    endif

    " swap this buffer with previous buffer and delete this.
    execute 'bp|bd! #'
    " update these after deleting
    let l:count -= 1
    let l:openCount = len(win_findbuf(bufnr('%')))
    if l:openCount > 1
      " swapped buffer is already open in another tab
      if l:count == 1
        " this is the last buffer, kill the split
        execute 'only'
      else 
        " there is another open buffer, so switch to it.
        execute 'bp'
      endif
    endif
  endif
endfunction

let g:buf_kill_default_choice = "cancel"
let g:buf_kill_default_action = "prompt"
command! -nargs=0 KillBuffer call s:killBuffer()
