if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': './install ' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'zackhsi/fzf-tags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'rakr/vim-one'
call plug#end()

let mapleader=" "
set number
set relativenumber
set autoread
set hidden
set expandtab
set shiftwidth=4
set softtabstop=4
set spell!
set noswapfile
"===============
" THEMING
"===============
if (has("termguicolors"))
    set termguicolors
endif
colorscheme one
let g:airline_theme='onedark'

"====================
" COC
"====================
let g:coc_disable_startup_warning = 1

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Symbol renaming.
nmap <leader>n <Plug>(coc-rename)

:iabbrev pudb import pudb;pudb.set_trace()
"=================================================
"   FZF    (from Dorian Karter - doriankarter.com)
"=================================================
"
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': {'width': 0.8, 'height': 0.8}}
" [Tags] Command to generate tags file
if expand('%:p:h:h') == '/home/whe/src'
    cd ..
endif
set tags=.tags

fun! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GFiles
  endif
endfun
nnoremap <C-b> :Buffers<CR>
nnoremap <C-p> :call FzfOmniFiles()<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>r :BTags<CR>
nnoremap <leader>l :Lines<CR>
nmap <leader>gt <Plug>(fzf_tags)

"==================
" MISC
"==================
"open Tig blame
nmap <leader>b :Gblame<CR>
"close buffer
nmap <leader>w :bd<CR>
"clear previous search highlight
nmap <C-l> :noh<CR>
"save file
map <Esc><Esc> :w<CR>
" Trailing whitespace at save
autocmd BufWritePre * %s/\s\+$//e
map! <F9>   <NOP>
"==================
" Tree view
"==================
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_list_hide= '.*\.pyc$,_pycache__'
nnoremap <silent>- :Vex<CR>

"==================
" Greper
"===================
function! RgFzf(query)
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -g "*.{py,js,xml}" '.shellescape(a:query), 0, 0)
endfunction
command! -nargs=* -bang Grep call RgFzf(<q-args>)
nnoremap <Leader>/ :Grep<space>
nnoremap <leader>e/ :Grep raise [A-Z][a-z]+Error\(<CR>
nnoremap <Leader>gf :Grep <C-r><C-w><CR>

"==================
" Snippets
"===================
"" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<Tab>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
