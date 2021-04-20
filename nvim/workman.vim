
"    (Y)ank -> (H)aul
"    Search (N)ext -> (J)ump
"    (E)nd word -> brea(K) of word
"    (O)pen new line -> (L)ine

function Keyboard(type)
    if a:type == "workman"
        "(O)pen line -> (L)ine
        noremap l o
        noremap o l
        noremap L O
        noremap O L
        "Search (N)ext -> (J)ump
        noremap j n
        noremap n j
        noremap J N
        noremap N J
        "(E)nd of word -> brea(K) of word
        noremap k e
        noremap e k
        noremap K E
        noremap E <nop>
        noremap h y
        "(Y)ank -> (H)aul
        noremap y h
        noremap H Y
        noremap Y H
    else " qwerty
        call UnmapWorkman()
    endif
endfunction

function UnmapWorkman()
    "Unmaps Workman keys
    silent! unmap h
    silent! unmap j
    silent! unmap k
    silent! unmap l
    silent! unmap y
    silent! unmap n
    silent! unmap e
    silent! unmap o
    silent! unmap H
    silent! unmap J
    silent! unmap K
    silent! unmap L
    silent! unmap Y
    silent! unmap N
    silent! unmap E
    silent! unmap O
endfunction

call Keyboard('workman')