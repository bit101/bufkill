" bufkill - An intelligent buffer deleter
" Maintainer:   Keith Peters (http://bit-101.com)
" Version:      1.1.1

if exists('g:loaded_bufkill')
  finish
endif
let g:loaded_bufkill = 1

if !exists('g:bufkill_default_choice')
  let g:bufkill_default_choice = "cancel"
endif
if !exists('g:bufkill_default_action')
  let g:bufkill_default_action = "prompt"
endif
if !exists('g:bufkill_close_terminal')
  let g:bufkill_close_terminal = 1
endif
if !exists('g:bufkill_ignore_splits')
  let g:bufkill_ignore_splits = 0
endif

command! -nargs=0 KillBuffer call bufkill#KillBuffer()
