" if tabular
vnoremap a= :Tabularize /=<CR>
vnoremap a; :Tabularize /::<CR>
vnoremap a- :Tabularize /-><CR>

nnoremap <C-p> :FZF<CR>
nnoremap <C-l> :Rg<CR>
let g:fzf_layout = { 'down': '~15%' }

colorscheme dim
" transparent background
hi Normal guibg=NONE ctermbg=NONE

let mapleader = ","
let maplocalleader="\\"

" noremap <Leader>h :<C-u>split<CR>
" noremap <Leader>v :<C-u>vsplit<CR>
noremap <Leader>gs :Git<CR>
noremap <Leader>gc :Git commit<CR>
noremap <leader>n :bn<CR>
noremap <leader>p :bp<CR>
noremap <leader>c :bd<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>t :Tags<CR>

" reindent whole file
noremap <leader>i mzgg=G`z

" replace all
nnoremap S :%s//g<Left><Left>

nnoremap <Leader>a <Plug>(ale_hover)
nnoremap <Leader>d <Plug>(ale_go_to_definition_in_tab)
nnoremap <Leader>rf <Plug>(ale_find_references)

" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim

filetype plugin indent on
set autoindent
set notitle
set nospell
set smartcase ignorecase " you need these two
set backspace=indent,eol,start
set hidden
set ruler
set shiftwidth=2 tabstop=2 expandtab
set laststatus=1
set number
set path+=**
set splitbelow splitright
set wildmenu wildmode=longest,list,full
set shortmess+=aI
set nowritebackup noswapfile
set mouse=a
set showmatch
set encoding=utf8 ffs=unix,dos,mac
set smartindent
set wrap
set nohlsearch
set clipboard=unnamedplus
set nopaste
set list listchars=tab:⇥\ ,extends:❯,precedes:❮,nbsp:␣,trail:· showbreak=¬
set foldlevelstart=30

iabbrev ddate <C-R>=strftime("%F")<CR>
iabbrev dtime <C-R>=strftime("%F %T")<CR>

let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1 " open splits to the right
let g:netrw_liststyle=3 " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

call matchadd('colorcolumn', '\%101v', 100)
highlight colorcolumn ctermbg=red

" undofile - This allows you to use undos after exiting and restarting
" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
" :help undo-persistence
if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=~/.vim/undo/
  set undofile
endif

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

command! RandomLine execute 'normal! '.(system('/bin/sh -c "echo -n $RANDOM"') % line('$')).'G'

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()

" BACKGROUND COLOR TOGGLE
function! s:toggle_background()
  if &background ==# "light"
    set background=dark
  elseif &background ==# "dark"
    set background=light
  endif
endfunction
command! ToggleBackground call s:toggle_background()
inoremap <F12> <C-O>:ToggleBackground<CR>
nnoremap <F12> :ToggleBackground<CR>

augroup filetypes
  autocmd!
  autocmd bufnewfile,bufread *.4th set filetype=forth
  autocmd bufnewfile,bufread *.asm set filetype=nasm
  autocmd bufnewfile,bufread *.c set keywordprg=man\ 3
  autocmd bufnewfile,bufread *.h set keywordprg=man\ 3
  autocmd bufnewfile,bufread *.conf set filetype=conf
  autocmd bufnewfile,bufread *.nix packadd vim-nix | set filetype=nix | set path+=/var/src
  autocmd bufnewfile,bufread *.rust packadd rust-vim
  autocmd bufnewfile,bufread *.csv packadd csv.vim | set filetype=csv
  autocmd bufnewfile,bufread *.tex packadd vimtex | set filetype=tex
  autocmd bufnewfile,bufread *.ics packadd icalendar.vim | set filetype=icalendar
  autocmd bufnewfile,bufread *.ts packadd typescript-vim | set filetype=typescript
  autocmd bufnewfile,bufread *.jq packadd jq.vim
  autocmd bufnewfile,bufread *.journal packadd vim-ledger | set filetype=ledger shiftwidth=4
  autocmd bufnewfile,bufread urls,config set filetype=conf
  autocmd bufnewfile,bufread *.elm packadd elm-vim | set filetype=elm shiftwidth=4
  autocmd bufnewfile,bufread *.md packadd vim-pandoc | packadd vim-pandoc-syntax | set filetype=pandoc
  autocmd filetype haskell packadd haskell-vim | set keywordprg=hoogle\ -i
  autocmd filetype javascript packadd vim-javascript
  autocmd filetype make setlocal noexpandtab
  autocmd filetype html packadd emmet-vim
  autocmd filetype gitcommit setlocal spell spelllang=en
  autocmd filetype mail setlocal spell spelllang=de textwidth=0
augroup end


autocmd bufreadpost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal! g`\"" |
      \ endif
autocmd bufreadpre * setlocal foldmethod=indent

set completeopt=noinsert,menuone,noselect
set complete+=kspell

let g:SuperTabDefaultCompletionType = 'context'

let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1

let g:pandoc#syntax#conceal#use = 0
let g:pandoc#modules#disabled = []
let g:pandoc#spell#default_langs = ['en', 'de']

let g:ale_linters = {
      \ 'css': ['csslint'],
      \ 'haskell': ['ghc', 'cabal-ghc', 'hlint', 'ormolu'],
      \ 'html': ['tidy', 'proselint'],
      \ 'latex': ['lacheck', 'chktex', 'proselint'],
      \ 'pandoc': ['proselint'],
      \ 'ruby': ['rubocop'],
      \ 'json': ['jsonlint'],
      \ 'rust': ['cargo'],
      \ 'python': ['pyls'],
      \}
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'css': ['prettier'],
      \ 'html': ['prettier'],
      \ 'json': ['jq'],
      \ 'python': ['black'],
      \ 'rust': ['rustfmt']
      \}
let g:ale_set_quickfix = 1

let g:ale_fix_on_save = 1
autocmd bufnewfile,bufread elm.json let g:ale_fix_on_save = 0

let g:ale_completion_enabled = 1

let g:vimwiki_list = [{'path': '~/notes/',
      \ 'syntax': 'markdown', 'ext': '.md'}]
