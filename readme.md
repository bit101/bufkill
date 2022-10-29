# buff-kill

A lua-based neovim plugin for intelligent deletion of buffers.

This plugin is very tailored to my own needs.

You probably don't want this, but if you find it useful, that's great.

The goal is to have a simple command for closing (deleting) buffers that works intelligently under most situations.

## Deleting buffers

If you want to delete a regular, unmodified buffer, it's a pretty simple command:

```
:bd
```

### Complications

- What if the buffer has un-saved changes? Save those changes or discard them?
- What if the buffer is read-only? Saving is not an option.
- What if the buffer is a terminal? Even just trying to close it will warn you about terminating a process.
- What if the buffer is un-named? Saving means you need to give it a name.

### Back to simplicity

`buf-kill` handles all this pretty well:

- Read-only buffers and terminal buffers are closed directly without saving.
- Modified buffers will prompt you to Save or Discard changes.
- Named buffers are saved as is.
- For un-named buffers, you are prompted for a path/filename to save the buffer as.

## Splits and terminals

My personal use case for this plugin is that I often use a vsplit - code files in the left split and a terminal buffer in the right split.

To visualize, say your buffer list is `A, B, C, D, E, T` where `T` is a terminal buffer. And you have buffer `A` and the terminal open in a a vsplit:

```
| A | T |
```

You're done working on `A` so you close that buffer. By default, here's what you wind up with:

```
|   T   |
```

The vsplit is gone and the terminal fills the window. Probably not what you want.

`buf-kill` will preserve that split and keep the terminal buffer in the right pane right up until that terminal buffer is the last buffer alive.

So as you call `KillBuffer` repeatedly, you'll get this sequence:

```
| A | T |
| B | T |
| C | T |
| D | T |
| E | T |
| T | T |
|       |
```

Note that this works for horizontal splits too, and it doesn't matter which pane of the split the terminal is in - it will just stay where it is.

## Usage:

`buf-kill` exposes a command: `KillBuffer` which is explained in more detail below. You do a simple key mapping to be able to call it easily, for example:

```
nnoremap <Leader>d :KillBuffer<CR>
```

### Options

#### Default Action

`buf_kill_default_action`

By default, when you try to delete a modifified buffer, `buf-kill` will prompt you to Save/Discard/Cancel. You can change that behavior to always save or always discard by setting `buf_kill_default_action`. For example:

vimscript:

```
let g:buf_kill_default_action = 'save'
let g:buf_kill_default_action = 'discard'
let g:buf_kill_default_action = 'prompt'
```

lua:

```
vim.g.buf_kill_default_action = 'save'
vim.g.buf_kill_default_action = 'discard'
vim.g.buf_kill_default_action = 'prompt'
```


#### Default Choice

`buf_kill_default_choice`

When prompted with the Save/Discard/Cancel options, the default (if you just hit enter) is to cancel. You can change that default by setting the global opton `buf_kill_default_choice` to `save` or `discard`. For example:

vimscript:

```
let g:buf_kill_default_choice = 'save'
let g:buf_kill_default_choice = 'discard'
let g:buf_kill_default_choice = 'cancel'
```

lua:

```
vim.g.buf_kill_default_choice = 'save'
vim.g.buf_kill_default_choice = 'discard'
vim.g.buf_kill_default_choice = 'cancel'
```

## Todo

- Option to show an "Are you sure" prompt when closing a terminal buffer, as it may have an important process running in it.
- Handle that second to last step in the sequence above, where you are left with the terminal buffer open in both sides of the split.
