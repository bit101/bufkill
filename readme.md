# buf-kill

A vim plugin for intelligent deletion of buffers.

This plugin was created with specific needs in mind, so it may or may not be what you need.

The goal is to have a simple command for closing (deleting) buffers that works intelligently in many different complex situations.

## Deleting buffers

If you want to delete a regular, unmodified buffer, it's a pretty simple command:

```
:bd
```

### Complications

- What if the buffer has unsaved changes? Save those changes or discard them?
- What if the buffer is read-only? Saving is not an option.
- What if the buffer is a terminal? Even just trying to close it will warn you about terminating a process.
- What if the buffer is unnamed? Saving means you need to give it a name.
- What if the buffer is in one pane of a split and you want to delete the buffer but keep the split open?

### Back to simplicity

`buf-kill` handles all this pretty well:

- Read-only buffers and terminal buffers are closed directly without saving.
- Modified buffers will prompt you to Save or Discard changes.
- Named buffers are saved as is.
- For unnamed buffers, you are prompted for a path/file name to save the buffer as.

### Splits

Sometimes you have a split open with one buffer in one side of the split, maybe it's a terminal buffer or something else you want to keep right where it is.

To visualize, say your buffer list is `A, B, C, D, E, X` where `X` is the buffer you want to keep pinned. And you have a vsplit with `A` and `X` open:

```
| A | X |
```

You're done working on `A` so you close that buffer. By default, here's what you wind up with:

```
|   X   |
```

The vsplit is gone and the buffer from the other pane fills the window. Probably not what you want.

`buf-kill` will preserve that split and pin the buffer in the alternate pane right up until that buffer is the last one alive.

So as you call `KillBuffer` repeatedly, you'll get this sequence:

```
| A | X |
| B | X |
| C | X |
| D | X |
| E | X |
|   X   |
|       |
```

Of course this works for horizontal splits too, and it doesn't matter which pane of the split you want to pin. It's whichever pane you are NOT deleting from.

## Usage:

`buf-kill` exposes a command: `KillBuffer` which is explained in more detail below. You do a simple key mapping to be able to call it easily, for example:

```
nnoremap <Leader>d :KillBuffer<CR>
```

### Options

#### Default Action

`buf_kill_default_action`

By default, when you try to delete a modified buffer, `buf-kill` will prompt you to Save/Discard/Cancel. You can change that behavior to always `save`, always `discard`, or always `prompt` by setting `buf_kill_default_action` to one of those options. For example:

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

Once you are prompted with the the Save/Discard/Cancel options, you can choose one of the options by pressing `S`, `D` or `C`. Or you can press enter to accept the default choice. Out of the box, the default choice will always be `cancel`. You can change that default by setting the global opton `buf_kill_default_choice` to `save`, `discard` or `cancel`. For example:

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
- There may be issues if you have multiple/nested splits set up. These scenarios have not been thoroughly tested.
