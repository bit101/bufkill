# buff-kill

A lua-based neovim plugin for intelligent deletion of buffers.

This plugin is very tailored to my own needs.

You probably don't want this, but if you find it useful, that's great.

The problem(s) I wanted to solve:



### Attempting to delete a modified buffer will just complain about unsaved changes.

I'd rather just have it save the changes and then delete the buffer. That may not be what everyone would want, but it's what I want.

This is easy enough to accomplish for most buffers just by having a function that writes then deletes.

But...


### Attempting to save a modified un-named buffer will complain that it has no name.

OK, so we need to check the buffer's name before we try to save it.

If it's modified and un-named we can either discard those changes with `bd!`, or quit the process and give the user a chance to save the buffer.


### Attempting to save a terminal buffer will complain that it's read only.

OK, so we need to check if it's a terminal buffer and if so, don't try to save it, just close it.


### Additionally, trying to close a terminal buffer with `bd` will give you a warning about killing a process.

So, we force close terminals with `bd!`



So far, so good. Now comes the complex part...

### I often have a terminal buffer open in the right-hand pane of a vsplit. If I close the buffer in the left-hand pane, I lose the split and the terminal fills the window.

When you close a buffer in one side of a split, vim will just close the split, leaving you with the contents of the other pane filling the window. Now you have to close that terminal, and recreate the split with a new terminal, or do some other acrobatics to get back where you want.

What I want is to keep the split alive, with that terminal pinned in the right-hand until that terminal is the only buffer left.

That's the majority of the work this plugin does.
