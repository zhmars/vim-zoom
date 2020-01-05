if exists('g:loaded_zoom')
  finish
endif

let g:loaded_zoom = 1

if !has('gui_running') && !has('nvim')
  finish
endif

let s:cpoptions = &cpoptions
set cpoptions&vim

command! ZoomIn    :call zoom#in()
command! ZoomOut   :call zoom#out()
command! ZoomReset :call zoom#reset()

nnoremap <silent> <Plug>(zoom-in)    :<C-u>call zoom#in()<CR>
nnoremap <silent> <Plug>(zoom-out)   :<C-u>call zoom#out()<CR>
nnoremap <silent> <Plug>(zoom-reset) :<C-u>call zoom#reset()<CR>

if get(g:, 'zoom#enable_default_keymap', 1) == 1
  nmap <silent> <C-+>      <Plug>(zoom-in)
  nmap <silent> <C-->      <Plug>(zoom-out)
  nmap <silent> <C-0>      <Plug>(zoom-reset)

  " keypad
  nmap <silent> <C-kPlus>  <Plug>(zoom-in)
  nmap <silent> <C-kMinus> <Plug>(zoom-out)
  nmap <silent> <C-k0>     <Plug>(zoom-reset)
endif

let &cpoptions = s:cpoptions
unlet s:cpoptions
