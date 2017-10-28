Make Quotes, Parenthesis, Braces as the Same Text Object
========================================================
 [![Build Status](https://travis-ci.org/rhysd/vim-textobj-anyblock.png?branch=master)](https://travis-ci.org/rhysd/vim-textobj-anyblock)

This plugin provides text object mappings `ib` and `ab`.

- `ib` is a union of `i(`, `i{`, `i[`, `i'`, `i"` and `i<`.
- `ab` is a union of `a(`, `a{`, `a[`, `a'`, `a"` and `a<`.

`ib` and `ab` match all of them.

This plugin depends on [vim-textobj-user](https://github.com/kana/vim-textobj-user).
Please install it in advance.

If you want to change the blocks which `ib` and `ab` match, define `g:textobj#anyblock#blocks`.
For example, if you install [vim-textobj-between](https://github.com/thinca/vim-textobj-between) and
want to match `` `...` ``, set ``[ '(', '{', '[', '"', "'", '<' , 'f`']`` to it.

If you want to define buffer local blocks, set them to `b:textobj_anyblock_buffer_local_blocks` as
list of string.

### License

Copyright (c) 2013 rhysd [MIT License](http://opensource.org/licenses/MIT).
