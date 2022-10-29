let g:bufkill_default_choice = "cancel"
let g:bufkill_default_action = "prompt"
let g:bufkill_ignore_splits = 0
command! -nargs=0 KillBuffer call bufkill#KillBuffer()
