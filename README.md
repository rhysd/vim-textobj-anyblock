One Text Object for Quotes, Parentheses and Braces
==================================================
[![Build Status][]][Travis CI]

This plugin provides text object mappings `ib` and `ab`.

- `ib` is a union of `i(`, `i{`, `i[`, `i'`, `i"` and `i<`.
- `ab` is a union of `a(`, `a{`, `a[`, `a'`, `a"` and `a<`.

`ib` and `ab` match any of the text objects. If multiple text objects are matched, it selects one
covering the most narrow region. For example, when the current line is `['abc', 'def']` and the
cursor is at `e`, `vib` selects `def`.

This plugin depends on [vim-textobj-user](https://github.com/kana/vim-textobj-user).
Please install it in advance.

If you want to change the blocks which `ib` and `ab` match, define `g:textobj#anyblock#blocks`.
For example, if you install [vim-textobj-between](https://github.com/thinca/vim-textobj-between) and
want to match `` `...` ``, set ``[ '(', '{', '[', '"', "'", '<' , 'f`']`` to it.

If you want to define buffer local blocks, set them to `b:textobj_anyblock_buffer_local_blocks` as
list of string on `FileType` autocmd event.

### License

Distributed under [MIT License](http://opensource.org/licenses/MIT).

```
Copyright (c) 2013 rhysd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

[Build Status]: https://travis-ci.org/rhysd/vim-textobj-anyblock.png?branch=master
[Travis CI]: https://travis-ci.org/rhysd/vim-textobj-anyblock
