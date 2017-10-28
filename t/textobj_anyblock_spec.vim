let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir

set rtp +=~/.vim/bundle/vim-textobj-user
set rtp +=~/.vim/bundle/vim-vspec-matchers

runtime! plugin/textobj/anyblock.vim
call vspec#matchers#load()

describe 'Default settings'

    it 'provide default <Plug> mappings'
        Expect '<Plug>(textobj-anyblock-i)' to_be_mapped
        Expect '<Plug>(textobj-anyblock-a)' to_be_mapped
        Expect 'ib' to_map_to '<Plug>(textobj-anyblock-i)', 'xo'
        Expect 'ab' to_map_to '<Plug>(textobj-anyblock-a)', 'xo'
    end

    it 'provide autoload functions'
        silent! call textobj#anyblock#select_i()
        Expect '*textobj#anyblock#select_i' to_exist
        Expect '*textobj#anyblock#select_a' to_exist
    end

    it 'provide variables to customize'
        Expect 'g:textobj#anyblock#blocks' to_exist_and_default_to [ '(', '{', '[', '"', "'", '<', '`' ]
        Expect 'g:textobj#anyblock#min_block_size' to_exist_and_default_to 2
    end
end

function! AddLine(str)
    put! =a:str
endfunction

describe '<Plug>(textobj-anyblock-a)'

    before
        new
        call AddLine('(a{b"c''d[e<f>]''"})')
        normal! gg0ff
    end

    after
        close!
    end

    it 'makes '''', "", <>, {} and () a object'
        normal dab
        Expect getline('.') ==# '(a{b"c''d[e]''"})'
        normal dab
        Expect getline('.') ==# '(a{b"c''d''"})'
        normal dab
        Expect getline('.') ==# '(a{b"c"})'
        normal dab
        Expect getline('.') ==# '(a{b})'
        normal dab
        Expect getline('.') ==# '(a)'
        normal dab
        Expect getline('.') ==# ''
    end
end

describe '<Plug>(textobj-anyblock-i)'

    before
        new
        call AddLine('(a{b"c''d[e<f>]''"})')
        normal! gg0ff
        let g:textobj#anyblock#min_block_size = 0
    end

    after
        close!
        let g:textobj#anyblock#min_block_size = 2
    end

    it 'makes '''', "", <>, {} and () inner object'
        normal dib
        Expect getline('.') ==# '(a{b"c''d[]''"})'
        normal dib
        Expect getline('.') ==# '(a{b"c''''"})'
        normal dib
        Expect getline('.') ==# '(a{b"c"})'
        normal dib
        Expect getline('.') ==# '(a{})'
        normal dib
        Expect getline('.') ==# '()'
    end
end

describe 'issues'
    before
        new
    end

    after
        close!
    end

    it 'considers length of surround at "i" object (#9)'
        call AddLine('(b(aaa)b)')
        normal! gg0f)
        normal dib
        Expect getline('.') ==# '(b()b)'
    end
end
