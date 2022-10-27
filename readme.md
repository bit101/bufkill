#buff-kill

A lua-based neovim plugin for intelligent deletion of buffers.

This plugin is very tailored to my own needs.

You probably don't want this, but if you find it useful, that's great.

The problem(s) this plugin solves for me:

1. If I delete an unsaved buffer, I want to save the changes there first. This is my personal preference and not everyone would agree, but this is how I want it to work. So this is what it does.
2. If I run across an unnamed buffer, trying to save that will give me a "no file name" error. So I don't want to save those.
3. I often have terminal buffers open. Can't save them, so it has to differentiate and only save the non-terminal buffers, just closing the terminal buffers.
4. My terminal buffers are usually open in the right-hand side of a vsplit. If I delete the buffer in the left-hand side of that split, the default behavior is to do away with the split and have the content in the right-hand split take over the full nvim window. That's not what I want. I want the split to remain open and the terminal buffer to remain where it is, and the left-hand side of the split to be replaced by the previously active buffer. So that's what this does.

Todo:

1. If an unnamed buffer has unsaved content, we should not just throw away that content. At least prompt "is it ok to delete this buffer?"
2. When deleting buffers, sometimes the terminal buffer IS the previous buffer and it takes over the full vim window anyway. Not a huge problem, but it would be better if we could cycle through all the non-terminal buffers first, saving the terminal buffer for last.
