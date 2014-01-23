set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"let g:clang_library_path='/usr/lib/llvm/'
"let g:clang_use_library=1
let g:clang_complete_auto=1
let g:clang_complete_macros=1
"let g:clang_auto_select=2 "automatically select and insert first match
set conceallevel=2
set concealcursor=vin
let g:clang_snippets=1
let g:clang_conceal_snippets=1
" The single one that works with clang_complete
let g:clang_snippets_engine='clang_complete'
"let g:clang_user_options='|| exit 0'

" Complete options (disable preview scratch window, longest removed to aways
" show menu)
set completeopt=menu,menuone

" clang_autocomplete configuration
let g:SuperTabDefaultCompletionType="context"

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"set guifont=courier_new:h9
set guifont=Monospace\ 7
winpos 400 50
"set lines=65 columns=160 winwidth=80 winminwidth=30 
"set smarttab tabstop=4 shiftwidth=4 expandtab list textwidth=80
set smarttab tabstop=4 shiftwidth=4 expandtab list textwidth=0
set listchars=tab:>-,trail:-
set updatetime=1000
set ignorecase
set nobackup
set autochdir "automatically change directory to the current file in current window
set autoread "automatically read file if changed outside of Vim
set guioptions-=T "get rid of GUI buttons
set nu
set hid "change buffer - without saving
"set statusline=%<%f\ %h%m%r%=%-20.(line=%l,col=%c%V,totlin=%L%)\%h%m%r%=%-40(,cursor=%b\,0x%B,buf=%n%Y%)\%P
"set statusline=%<%f\ %h%m%r%=%-20.(line=%l,col=%c%V,totlin=%L%)\%h%m%r%=%-40(,cursor=%b\,0x%B,%Y%)\%P
set statusline=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
"set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
"set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set cursorline
set nowrapscan "don't wrap at the end of file when searching
set incsearch
set history=50

colorscheme wombat256 "darkburn
:copen

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

nnoremap <silent> <F2> :Explore<CR>
nnoremap <silent> <F4> :cn<CR>
nnoremap <silent> <S-F4> :cp<CR>
"
" maps NERDTree to F10
"
noremap <silent> <F10> :NERDTreeToggle<CR>
noremap! <silent> <F10> <ESC>:NERDTreeToggle<CR>


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
         \ | wincmd p | diffthis
endif

