" Enable Mouse
set mouse=a

" Background color
set background=dark

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    GuiFont Hack Nerd Font Mono:h16
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

" Default shell to use for terminal mode should be git bash since it has the
" most unix feel
" ginit.vim - GUI-specific settings for nvim-qt
"
" " Set Git Bash as the default shell
 let &shell = 'C:/Program Files/Git/bin/bash.exe'
 let &shellcmdflag = '-c'
 let &shellquote = ''
 let &shellxquote = ''

