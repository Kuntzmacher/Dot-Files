" set leader key
let mapleader = " "
let maplocalleader = " "

" reload vimrc keybinding
nnoremap <leader>r :source $MYVIMRC<CR>

if exists('g:vscode')

  " quick open in vscode
  nnoremap <silent> <leader><leader> :call VSCodeNotify('workbench.action.quickOpen')<CR>

else

  " set jk to escape (for vscode it is set in the settings)
  inoremap <silent> jk <Esc>

endif

" window navigation
if exists('g:vscode')
  nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
  nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
  nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
  nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.focusRightGroup')<CR>
else
  nnoremap <silent> <C-h> <C-w>h
  nnoremap <silent> <C-j> <C-w>j
  nnoremap <silent> <C-k> <C-w>k
  nnoremap <silent> <C-l> <C-w>l
endif

" split windows
if exists('g:vscode')
  nnoremap <silent> <leader>sb :call VSCodeNotify('workbench.action.splitEditorDown')<CR>
  nnoremap <silent> <leader>sv :call VSCodeNotify('workbench.action.splitEditorRight')<CR>
else
  nnoremap <silent> <leader>sb :split<CR>
  nnoremap <silent> <leader>sv :vsplit<CR>
endif

" force cursor shape changes in terminal vim
if exists('&t_SI') && exists('&t_EI')
  "insert mode: bar cursor
  let &t_SI = "\<Esc>[6 q"

  " normal mode: steady block
  let &t_EI = "\<Esc>[2 q"
endif

" smart search
set ignorecase
set smartcase

" enable mouse
set mouse=a

" line numbers
set relativenumber

" make sure guicursor is not cleared
set guicursor&
