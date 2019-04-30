let s:save_cpo = &cpo
set cpo&vim

let g:textobj#anyblock#blocks = get(g:, 'textobj#anyblock#blocks',
            \ [ '(', '{', '[', '"', "'", '<', '`' ])
let g:textobj#anyblock#min_block_size = get(g:, 'textobj#anyblock#min_block_size', 2)
let g:textobj#anyblock#inner_block_mapping = get(g:, 'textobj#anyblock#inner_block_mapping', 'i')
let g:textobj#anyblock#outer_block_mapping = get(g:, 'textobj#anyblock#outer_block_mapping', 'a')
let g:textobj#anyblock#no_remap_block_mapping = get(g:, 'textobj#anyblock#inner_block_mapping', 0)

function! textobj#anyblock#select_i() abort
    return s:select(g:textobj#anyblock#inner_block_mapping)
endfunction

function! textobj#anyblock#select_a() abort
    return s:select(g:textobj#anyblock#outer_block_mapping)
endfunction

function! s:restore_screen_pos(before_screen_begin) abort
    let line_diff = line('w0') - a:before_screen_begin
    if line_diff > 0
        keepjumps execute 'normal!' line_diff."\<C-y>"
    elseif line_diff < 0
        keepjumps execute 'normal!' (-line_diff)."\<C-e>"
    endif
endfunction

function! s:select(chunk) abort
    let save_screen_begin = line('w0')
    let min_region = [getpos('.'), getpos('.')]
    let is_inner = a:chunk ==# g:textobj#anyblock#inner_block_mapping
    for block in get(b:, 'textobj_anyblock_local_blocks', []) + g:textobj#anyblock#blocks
        let r = s:get_region(a:chunk . block)
        if s:is_empty_region(r) || s:cursor_is_out_of_region(r, is_inner)
            continue
        endif

        let e = s:region_extent(r)
        if e < g:textobj#anyblock#min_block_size
            continue
        endif

        if !exists('l:min_region_extent') || min_region_extent > e
            let min_region_extent = e
            let min_region = r
        endif
    endfor
    call s:restore_screen_pos(save_screen_begin)
    if min_region[0] == min_region[1]
      return 0
    else
      return ['v', min_region[0], min_region[1]]
    endif
endfunction

function! s:region_extent(region) abort
    let extent = 0

    for line in range(a:region[0][1], a:region[1][1])
        let line_width = strlen(getline(line))
        let width = line_width

        if line == a:region[0][1]
            let width -= a:region[0][2] - 1
        endif

        if line == a:region[1][1]
            let width -= line_width - a:region[1][2]
        endif

        let extent += width
    endfor

    return extent
endfunction

function! s:get_region(textobj) abort
    let pos = getpos('.')
    normal! v

    let saved_vb = &vb
    let saved_t_vb = &t_vb

    " When 'i' is mapped to another mapping, :normal is not available (#13)
    if g:textobj#anyblock#no_remap_block_mapping
        let normal = 'normal!'
    else
        let normal = 'normal'
    endif

    try
        set vb t_vb=
        keepjumps execute 'silent' normal  a:textobj
        keepjumps execute 'silent' 'normal!' "\<Esc>"
    finally
        let &vb = saved_vb
        let &t_vb = saved_t_vb
    endtry

    call setpos('.', pos)
    return [getpos("'<"), getpos("'>")]
endfunction

function! s:is_empty_region(region) abort
    return a:region[1][1] < a:region[0][1] || (a:region[0][1] == a:region[1][1] && a:region[1][2] <= a:region[0][2])
endfunction


function! s:cursor_is_out_of_region(region, is_inner) abort
    let [_, line, col, _] = getpos('.')
    let outside_surround_len = a:is_inner ? 1 : 0

    if line < a:region[0][1] || (line == a:region[0][1] && col < a:region[0][2] - outside_surround_len)
        return 1
    endif

    if line > a:region[1][1] || (line == a:region[1][1] && col > a:region[1][2] + outside_surround_len)
        return 1
    endif

    return 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
