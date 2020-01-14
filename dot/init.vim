" if tabular
vnoremap a= :Tabularize /=<CR>
vnoremap a; :Tabularize /::<CR>
vnoremap a- :Tabularize /-><CR>

nnoremap <C-p> :FZF<CR>
let g:fzf_layout = { 'down': '~15%' }

" colorscheme delek hipster
" colorscheme 256_noir
colorscheme paramount
set background=dark

let mapleader = ","
" let maplocalleader="\\"

noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <leader>n :bn<CR>
noremap <leader>p :bp<CR>
noremap <leader>c :bd<CR>

" reindent whole file
noremap <leader>i mzgg=G`z

nnoremap <Leader>a <Plug>(ale_hover)
nnoremap <Leader>d <Plug>(ale_go_to_definition_in_tab)
nnoremap <Leader>rf <Plug>(ale_find_references)

filetype plugin indent on
set notitle
set nocompatible
set smartcase
set shiftwidth=2 tabstop=2 expandtab
set laststatus=1
set number
set path+=**
set splitbelow
set splitright
set wildmenu
set shortmess+=aI
set nowritebackup noswapfile
set mouse=a
set showmatch
set encoding=utf8 ffs=unix,dos,mac
set smartindent
set nowrap
set nohlsearch
set clipboard=unnamedplus
set nopaste
set list listchars=tab:⇥\ ,extends:❯,precedes:❮,nbsp:␣,trail:· showbreak=↪
set foldlevelstart=30

iabbrev ddate <C-R>=strftime("%F")<CR>

" if exists("g:loaded_netrwPlugin")
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1 " open splits to the right
let g:netrw_liststyle=3 " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" endif

" call matchadd('colorcolumn', '\%101v', 100)
" highlight colorcolumn ctermbg=red

" undofile - This allows you to use undos after exiting and restarting
" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
" :help undo-persistence
if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

nnoremap <C-j> ddp | vnoremap <C-j> xp`[V`]
nnoremap <C-k> ddkP | vnoremap <C-k> xkP`[V`]

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

command! RandomLine execute 'normal! '.(system('/bin/sh -c "echo -n $RANDOM"') % line('$')).'G'

" function! <SID>StripTrailingWhitespaces()
"   let _s=@/
"   let l=line(".")
"   let c=col(".")

"   %s/\s\+$//e

"   let @/=_s
"   call cursor(l,c)
" endfunction

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()

if has("autocmd")
  autocmd bufnewfile,bufread *.4th set filetype=forth
  autocmd bufnewfile,bufread *.asm set filetype=nasm
  autocmd bufnewfile,bufread *.c set keywordprg=man\ 3
  autocmd bufnewfile,bufread *.conf set filetype=conf
  autocmd bufnewfile,bufread *.fs packadd vim-fsharp | set filetype=fsharp
  autocmd bufnewfile,bufread *.h set keywordprg=man\ 3
  autocmd bufnewfile,bufread *.nix packadd vim-nix | set filetype=nix | set path+=/var/src
  autocmd bufnewfile,bufread *.rust packadd rust-vim " | packadd deoplete-rust
  autocmd bufnewfile,bufread *.csv packadd csv-vim | set filetype=csv
  autocmd bufnewfile,bufread *.toml packadd vim-toml | set filetype=toml
  autocmd bufnewfile,bufread *.tex packadd vimtex | set filetype=tex
  autocmd bufnewfile,bufread *.ts packadd typescript-vim | set filetype=typescript
  autocmd bufnewfile,bufread *.purs packadd purescript-vim | set filetype=purescript
  autocmd bufnewfile,bufread *.jq packadd jq.vim
  autocmd bufnewfile,bufread *.journal packadd vim-ledger | set filetype=ledger shiftwidth=4
  autocmd bufnewfile,bufread config set filetype=conf
  autocmd bufnewfile,bufread *.elm packadd elm-vim | set filetype=elm shiftwidth=4
  autocmd bufnewfile,bufread *.dhall packadd dhall-vim | set filetype=dhall
  autocmd bufnewfile,bufread *todo.txt packadd todo.txt-vim | set filetype=todo.txt
  autocmd filetype haskell packadd haskell-vim | set keywordprg=hoogle\ -i
  autocmd filetype javascript packadd vim-javascript
  autocmd filetype make setlocal noexpandtab
  autocmd filetype html packadd emmet-vim
  autocmd bufreadpost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" |
        \ endif
  autocmd bufreadpre * setlocal foldmethod=indent
  " autocmd bufwritepre * :call <SID>StripTrailingWhitespaces()
  autocmd bufwinenter * if &fdm == 'indent' | setlocal foldmethod=manual | endif

  autocmd VimEnter * UpdateRemotePlugins
endif

"if exists("g:loaded_startify")
let g:startify_custom_header = ''
"endif

" if exists("g:loaded_deoplete")
let g:deoplete#enable_at_startup = 1
set completeopt=noinsert,menuone,noselect
let g:deoplete#sources = {}
let g:deoplete#sources._ = ['ale', 'file', 'omni', 'buffer']
" endif
"
" let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
" let g:deoplete#sources#rust#rust_source_path = substitute(system('rustc --print sysroot'), '\n$', '', '') . '/lib/rustlib/src/rust/src'

let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1

" if exists("g:loaded_ale")
let g:ale_linters = {
      \ 'css': ['csslint'],
      \ 'haskell': ['ghc', 'cabal-ghc', 'hlint'],
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
      \ 'haskell': ['brittany'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'css': ['prettier'],
      \ 'html': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'json': ['jq'],
      \ 'python': ['black'],
      \ 'rust': ['rustfmt']
      \}
let g:ale_set_quickfix = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
" endif

"if exists("g:loaded_airline")
" set noshowmode laststatus=0 noruler
let g:airline#extensions#tabline#close_symbol = 'X'
let g:airline#extensions#tabline#enabled = 0
"let g:airline#extensions#tabline#left_alt_sep = ''
"let g:airline#extensions#tabline#left_sep = ''
"let g:airline#extensions#tabline#right_alt_sep = ''
"let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#tab_nr_type = 0
let g:airline#extensions#tmuxline#enabled = 0
"let g:airline#extensions#wordcount#enabled = 1
"let g:airline_left_alt_sep = ''
"let g:airline_left_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_right_sep = ''
let g:airline_section_z = '%{line(".")}/%{line("$")} %{col(".")}'
"endif
"if exists("g:loaded_airline_themes")
let g:airline_theme='base16'
"endif
