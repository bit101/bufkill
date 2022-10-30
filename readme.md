# bufkill

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

`bufkill` handles all this pretty well:

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

`bufkill` will preserve that split and pin the buffer in the alternate pane right up until that buffer is the last one alive.

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

`bufkill` exposes a command: `KillBuffer` which is explained in more detail below. You can do a simple key mapping to be able to call it easily, for example:

```
nnoremap <Leader>d :KillBuffer<CR>
```

### Options

#### Default Action

`bufkill_default_action`

By default, when you try to delete a modified buffer, `bufkill` will prompt you to Save/Discard/Cancel. You can change that behavior to always `save`, always `discard`, or always `prompt` by setting `bufkill_default_action` to one of those options. For example:

vimscript:

```
let g:bufkill_default_action = 'save'
let g:bufkill_default_action = 'discard'
let g:bufkill_default_action = 'prompt'
```

lua:

```
vim.g.bufkill_default_action = 'save'
vim.g.bufkill_default_action = 'discard'
vim.g.bufkill_default_action = 'prompt'
```


#### Default Choice

`bufkill_default_choice`

Once you are prompted with the the Save/Discard/Cancel options, you can choose one of the options by pressing `S`, `D` or `C`. These choices will be indicated by parentheses and square brackets like so:

```
(S)ave, (D)iscard changes, [C]ancel: 
```

Note that the C option has square brackets rather thand parentheses. This indicates that it is the default choice - if you hit enter rather than pressing a key, it will cancel. Out of the box, the default choice will always be `cancel`. You can change that default by setting the global opton `bufkill_default_choice` to `save`, `discard` or `cancel`. For example:

vimscript:

```
let g:bufkill_default_choice = 'save'
let g:bufkill_default_choice = 'discard'
let g:bufkill_default_choice = 'cancel'
```

lua:

```
vim.g.bufkill_default_choice = 'save'
vim.g.bufkill_default_choice = 'discard'
vim.g.bufkill_default_choice = 'cancel'
```

If you change the default to `save` for example, the prompt will now look like this:

```
[S]ave, (D)iscard changes, (C)ancel: 
```

And if you hit enter, it `bufkill` will attempt to save the buffer and then close it.

Note that hitting the escape key, or Control-C or other possible interrupts will always be interpreted as `cancel`

#### Close Terminal

`bufkill_close_terminal`

By default, calling `KillBuffer` on a terminal buffer will close it straight away. If you want a warning and confirmation before closing terminal buffers, set `bufkill_close_terminal` to 0. It defaults to 1. Example:

vimscript:

```
let g:bufkill_close_terminal = 0
```

lua:

```
vim.g.bufkill_close_terminal = 0
```


#### Ignore Splits

`bufkill_ignore_splits`

In the event that you don't care about the fancy split handing (or you have a complex layout that it is breaking under), but you do want the ability to check for modified buffers and handle accordingly before deleting them, set `bufkill_ignore_splits` to 1. It defaults to 0. Examples:

vimscript:

```
let g:bufkill_ignore_splits = 1
```

lua:

```
vim.g.bufkill_ignore_splits = 1
```

Now `bufkill` will simply delete any buffer it can and prompt for those that need saving (or however you configured it), but it won't do any special handling for maintaining splits.

## Known issues

- There may be issues with split handling if you have multiple splits set up. Or have buffers open in other tabs. These scenarios have not been thoroughly tested. The split handing assumes a single split.
