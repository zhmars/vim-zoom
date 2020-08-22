let s:cpoptions = &cpoptions
set cpoptions&vim

let s:gui_name =''
if !has('nvim')
  " for gVim
  let s:gui_name = has('win32') ? 'vim-win32'
    \ : has('macunix') ? 'vim-mac'
    \ : has('gui_gtk') ? 'vim-gtk' : 'vim-unkonwn'
  let s:guifont = &guifont
  let s:guifontwide = &guifontwide
elseif exists('*GuiName') && GuiName() ==# 'nvim-qt'
  " for equalsraf/neovim-qt
  let s:gui_name ='nvim-qt'
  let s:guifont = g:GuiFont
elseif exists('g:gonvim_running')
  " for akiyosi/goneovim
  let s:gui_name ='nvim-goneovim'
  let s:guifont = &guifont
endif

function! zoom#str2num(str) abort
  if stridx(a:str, '.') > -1
    return str2float(a:str)
  else
    return str2nr(a:str)
  endif
endfunction

function! zoom#font_size(gui_name, font_config) abort
  if a:gui_name =~# 'vim-win32\|vim-mac\|nvim-qt\|nvim-goneovim'
    return zoom#str2num(substitute(a:font_config, '\v^.*:h([^:]*).*$', '\1', ''))
  elseif a:gui_name ==# 'vim-gtk'
    return zoom#str2num(substitute(a:font_config, '\v^.* (\d*[.]?\d+)$', '\1', ''))
  endif
endfunction

function! zoom#font_config(gui_name, font_config, font_size) abort
  if type(a:font_size) == v:t_float
    let font_size = printf('%.1f', a:font_size)
  else
    let font_size = printf('%d', a:font_size)
  endif
  if a:gui_name =~# 'vim-win32\|vim-mac\|nvim-qt\|nvim-goneovim'
    return substitute(a:font_config, '\v:h([^:]*)', ':h' . font_size, '')
  elseif a:gui_name ==# 'vim-gtk'
    return substitute(a:font_config, '\v(\d*[.]?\d+)', font_size, '')
  endif
endfunction

" guifont size + 1
function! zoom#in(...) abort
  let step = a:0 ? a:1 : 1
  if !has('nvim')
    let font_size = zoom#font_size(s:gui_name, &guifont)
    let font_size += step
    let fontwide_size = zoom#font_size(s:gui_name, &guifontwide)
    let fontwide_size += step
    let guifont = zoom#font_config(s:gui_name, &guifont, font_size)
    let guifontwide = zoom#font_config(s:gui_name, &guifontwide, fontwide_size)
    let &guifont = guifont
    let &guifontwide = guifontwide
  elseif s:gui_name ==# 'nvim-qt'
    if !exists('g:GuiFont') | echo 'No GuiFont is set' | return | endif
    let font_size = zoom#font_size(s:gui_name, g:GuiFont)
    let font_size += step
    let guifont = zoom#font_config(s:gui_name, g:GuiFont, font_size)
    call rpcnotify(0, 'Gui', 'Font', guifont, 1)
  elseif s:gui_name ==# 'nvim-goneovim'
    if !len(&guifont) | echo 'No guifont is set' | return | endif
    let font_size = zoom#font_size(s:gui_name, &guifont)
    let font_size += step
    let guifont = zoom#font_config(s:gui_name, &guifont, font_size)
    let &guifont = guifont
  endif
endfunction

" guifont size - 1
function! zoom#out(...) abort
  let step = a:0 ? a:1 : -1
  call zoom#in(step)
endfunction

" guifont size reset
function! zoom#reset() abort
  if !has('nvim')
    let &guifont = s:guifont
    let &guifontwide = s:guifontwide
  elseif s:gui_name ==# 'nvim-qt'
    call rpcnotify(0, 'Gui', 'Font', s:guifont, 1)
  elseif s:gui_name ==# 'nvim-goneovim'
    let &guifont = s:guifont
  endif
endfunction

let &cpoptions = s:cpoptions
unlet s:cpoptions
