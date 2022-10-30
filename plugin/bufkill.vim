" bufkill - An intelligent buffer deleter
" Maintainer:   Keith Peters (http://bit-101.com)
" Version:      1.1

if exists('g:loaded_bufkill')
  finish
endif
let g:loaded_bufkill = 1

let g:bufkill_default_choice = "cancel"
let g:bufkill_default_action = "prompt"
let g:bufkill_close_terminal = 1
let g:bufkill_ignore_splits = 0

command! -nargs=0 KillBuffer call bufkill#KillBuffer()
