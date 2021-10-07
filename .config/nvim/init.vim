if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': './install ' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
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
let g:airline_theme='bubblegum'

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

"=================================================
"   FZF    (from Dorian Karter - doriankarter.com)
"=================================================
"
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': {'width': 0.8, 'height': 0.8}}
" If vim is opened inside /src/ dir, move up to take all dire into account
" (for tags and fuzzy finder)
if expand('%:p:h:h') == '/home/whe/src'
    cd ..
    let $FZF_DEFAULT_COMMAND = "rg --files -g '!*.po'"
endif
" [Tags] Command to generate tags file
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
nnoremap <leader>t :Tags<CR>
nnoremap <leader>r :BTags<CR>
nnoremap <leader>l :Lines<CR>
nmap gd <Plug>(fzf_tags)

"FZF Buffer Delete

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

"==================
" MISC
"==================
"open config files
nmap <leader>c :Files ~/.config/<CR>
"open zsh files
nmap <leader>z :e ~/.zshrc<CR>
"open Tig blame
nmap <leader>b :Git blame<CR>
"open git log
nmap <leader>gl :Glog -n 25<CR>
"close buffer
nmap <leader>w :bd<CR>
"clear previous search highlight
nmap <C-l> :noh<CR>
"save file
map <Esc><Esc> :w<CR>
" Trailing whitespace at save
autocmd BufWritePre * %s/\s\+$//e
" Python debugging made easy
:iabbrev pudb import pudb;pudb.set_trace()
" edit vim config
nmap <leader>e :e! ~/.config/nvim/init.vim<CR>
" Open Git status menu
nnoremap <leader><leader> :Ge:<CR>
" Quickfix list
nmap <silent> ]c :cnext<CR>zz
nmap <silent> [c :cprevious<CR>zz
" split line at cursor
nnoremap K :i<CR><esc>

" Use * command on visual selection
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  " Use this line instead of the above to match matches spanning across lines
  "let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
  call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>
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
    call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -g "*.{py,js,xml,scss}" '.shellescape(a:query), 0, 0)
endfunction
command! -nargs=* -bang Grep call RgFzf(<q-args>)
nnoremap <Leader>/ :Grep<space>
nnoremap <leader>e/ :Grep raise [A-Z][a-z]+Error\(<CR>
nnoremap <Leader>gf :Grep <C-r><C-w><CR>

"==================
" Snippets
"===================
"" Use <C-l> for trigger snippet expand.
imap <silent> <C-l> <Plug>(coc-snippets-expand)

