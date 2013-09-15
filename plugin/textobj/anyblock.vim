if exists('g:loaded_textobj_anyblock')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:textobj_anyblock_blocks = get(g:, 'textobj_anyblock_blocks',
            \ [ '(', '{', '[', '"', "'", '<' ])

call textobj#user#plugin('anyblock', {
    \ '-' : {
    \      'select-a' : 'ab', '*select-a-function*' : 'textobj#anyblock#select_a',
    \      'select-i' : 'ib', '*select-i-function*' : 'textobj#anyblock#select_i',
    \   },
    \ })

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_textobj_anyblock = 1
