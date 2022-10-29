#buff-kill

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

`buf-kill` handles all this pretty well for the most part.

- Read-only buffers and terminal buffers are closed directly without saving.
- Modified buffers will prompt you to Save or Discard changes.
- Named buffers are saved as is.
- For un-named buffers, you are prompted for a path/filename to save the buffer as.

## Splits

My personal use case for this plugin is that I often use a vsplit - code files in the left split and a terminal buffer in the right split.

By default, if you close a buffer in a split, it kills the split, and the content from the other part of the split takes over the whole window.

`buf-kill` will preserve that split and keep the terminal buffer in the right pane right up until that terminal buffer is the last buffer alive.
