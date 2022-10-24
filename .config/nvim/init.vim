call plug#begin('~/.config/nvim/plugged')
"======
"to remove later
"===========
Plug 'junegunn/fzf', { 'do': './install ' }
Plug 'junegunn/fzf.vim'
" Plug 'stsewd/fzf-checkout.vim'
" Plug 'zackhsi/fzf-tags'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'onsails/lspkind-nvim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'neovim/nvim-lspconfig',
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lewis6991/spellsitter.nvim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
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
let g:catppuccin_flavour = "mocha"
colorscheme catppuccin

lua require('whenrow')
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
    :Telescope find_files
  else
    :Telescope git_files
  endif
endfun
nnoremap <C-b> :Telescope buffers<CR>
nnoremap <C-p> :call FzfOmniFiles()<CR>
nnoremap <leader>t :Telescope tags<CR>
nnoremap <leader>r :BTags<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>T :Telescope<CR>
nnoremap gd: Telescope tags<CR><C-w><C-r>

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
" Open Git status menu
nnoremap <leader><leader> :Ge:<CR>
" Quickfix list
nmap <silent> ]c :cnext<CR>zz
nmap <silent> [c :cprevious<CR>zz
" split line at cursor
nnoremap K :i<CR><esc>
" Center next highlighted word
nnoremap n nzz
nnoremap N Nzz
" Reload nvim config
nnoremap <leader>cr :source $MYVIMRC<CR>
" use ' instead of "
nnoremap "' ysi"'ds"
" use " instead of '
nnoremap '" ysi'"ds'
"
" ----------------------
" Configuration shortcuts
" ----------------------
" edit vim config
nmap <leader>ce :e! ~/.config/nvim/init.vim<CR>
" edit lua config
nmap <leader>cl :e! ~/.config/nvim/lua/whenrow/init.lua<CR>
"open .config/ folder in FZF
nmap <leader>cc :lua require'telescope.builtin'.find_files({search_dirs={'~/.config/'},hidden=true})<cr>
"open zshrc
nmap <leader>cz :e ~/.zshrc<CR>
"

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
nnoremap <Leader>/ :Telescope live_grep<CR>
nnoremap <Leader>gf :Telescope grep_string<CR>

"==================
" Snippets
"===================
"" Use <C-l> for trigger snippet expand.
" imap <silent> <C-l> <Plug>(coc-snippets-expand)

