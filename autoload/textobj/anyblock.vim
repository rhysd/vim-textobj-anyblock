let g:textobj#anyblock#blocks = get(g:, 'textobj#anyblock#blocks',
            \ [ '(', '{', '[', '"', "'", '<' ])
let g:textobj#anyblock#min_block_size = get(g:, 'textobj#anyblock#min_block_size', 2)

function! textobj#anyblock#select_i()
    return s:select('i')
endfunction

function! textobj#anyblock#select_a()
    return s:select('a')
endfunction

function! s:select(chunk)
    let min_region = [getpos('.'), getpos('.')]
    for block in g:textobj#anyblock#blocks + get(b:, 'textobj#anyblock#local_blocks', [])
        let r = s:get_region(a:chunk.block)
        if s:is_empty_region(r) || s:cursor_is_out_of_region(r)
            continue
        endif

        let e = s:region_extent(r)
        if e < g:textobj#anyblock#min_block_size
            continue
        endif

        if !exists('min_region_extent') || min_region_extent > e
            let min_region_extent = e
            let min_region = r
        endif
    endfor
    return ['v', min_region[0], min_region[1]]
endfunction

function! s:region_extent(region)
    let extent = 0

    for line in range(a:region[0][1], a:region[1][1])
        let line_width = len(getline(line))
        let width = line_width

        if line == a:region[0][1]
            let width -= a:region[0][2]
        endif

        if line == a:region[1][1]
            let width -= line_width - a:region[1][2]
        endif

        let extent += width
    endfor

    return extent
endfunction

function! s:get_region(textobj)
    let pos = getpos('.')
    execute 'silent' 'normal' 'v'.a:textobj
    execute 'silent' 'normal!' "\<Esc>"
    call setpos('.', pos)
    return [getpos("'<"), getpos("'>")]
endfunction

function! s:is_empty_region(region)
    return a:region[1][1] < a:region[0][1] || (a:region[0][1] == a:region[1][1] && a:region[1][2] <= a:region[0][2])
endfunction


function! s:cursor_is_out_of_region(region)
    let [_, line, col, _] = getpos('.')

    if line < a:region[0][1] || (line == a:region[0][1] && col < a:region[0][2])
        return 1
    endif

    if line > a:region[1][1] || (line == a:region[1][1] && col > a:region[1][2])
        return 1
    endif

    return 0
endfunction
