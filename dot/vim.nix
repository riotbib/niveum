{ config, pkgs, ... }:
with import ../helpers.nix;
{
  startPackages = with pkgs.vimPlugins; [
    ale
    ctrlp
    deoplete-nvim
    supertab
    tabular
    tagbar
    vim-airline vim-airline-themes
    vim-grepper
    vim-commentary
    vim-eunuch
    vim-fugitive
    vim-gitgutter
    vim-pandoc vim-pandoc-after vim-pandoc-syntax
    vim-repeat
    vim-sensible
    vim-startify
    vim-surround
  ];
  optPackages = with pkgs.vimPlugins; [
    csv
    elm-vim
    deoplete-rust
    idris-vim
    vimtex
    # ghcmod-vim
    rust-vim
    typescript-vim
    haskell-vim
    vim-javascript
    vim-nix
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-ledger";
      src = pkgs.fetchFromGitHub {
        owner = "ledger";
        repo = "vim-ledger";
        rev = "6eb3bb21aa979cc295d0480b2179938c12b33d0d";
        sha256 = "0rbwyaanvl2bqk8xm4kq8fkv8y92lpf9xx5n8gw54iij7xxhnj01";
      };
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-fsharp";
      src = pkgs.fetchFromGitHub {
        owner = "fsharp";
        repo = "vim-fsharp";
        rev = "627db7d701747e8fd7924b6505c61e16a369fb72";
        sha256 = "00hhgn2p54faysx1ddccyhl9jnvddgxsczhv0np3mgzza6ls4838";
      };
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-hindent";
      src = pkgs.fetchFromGitHub {
        owner = "alx741";
        repo = "vim-hindent";
        rev = "f8e84c199fd00a3ccaf5bbbc97786bde9a4faa13";
        sha256 = "1y4nnz38zal1ffs5n751dn9p9apk8q7pq3cw79r5z6fsdp942ai6";
      };
    })
  ];
  vimrc = ''
    " if tabular
    vmap a= :Tabularize /=<CR>
    vmap a; :Tabularize /::<CR>
    vmap a- :Tabularize /-><CR>

    colorscheme delek

    filetype plugin indent on
    set title
    set nocompatible
    set smartcase
    set shiftwidth=2 tabstop=2 expandtab
    set number
    set path=$PWD/**
    set completeopt=menu,longest
    set wildmode=list:full wildignore+=${commaSep config.constants.ignore}
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

    if exists("g:loaded_netrwPlugin")
      let g:netrw_banner=0
      let g:netrw_browse_split=4
      let g:netrw_altv=1 " open splits to the right
      let g:netrw_liststyle=3 " tree view
      let g:netrw_list_hide=netrw_gitignore#Hide()
      let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
    endif

    call matchadd('colorcolumn', '\%101v', 100)
    highlight colorcolumn ctermbg=red

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

    nmap <C-j> ddp | vmap <C-j> xp`[V`]
    nmap <C-k> ddkP | vmap <C-k> xkP`[V`]

    nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
    vnoremap <Space> zf

    command! RandomLine execute 'normal! '.(system('/bin/sh -c "echo -n $RANDOM"') % line('$')).'G'

    function! <SID>StripTrailingWhitespaces()
      let _s=@/
      let l=line(".")
      let c=col(".")

      %s/\s\+$//e

      let @/=_s
      call cursor(l,c)
    endfunction

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
      autocmd bufnewfile,bufread *.fs :packadd vim-fsharp | set filetype=fsharp
      autocmd bufnewfile,bufread *.h set keywordprg=man\ 3
      autocmd bufnewfile,bufread *.md set filetype=markdown.pandoc | set nospell
      autocmd bufnewfile,bufread *.nix :packadd vim-nix | set filetype=nix
      autocmd bufnewfile,bufread *.rust :packadd rust-vim deoplete-rust
      autocmd bufnewfile,bufread *.csv :packadd csv
      autocmd bufnewfile,bufread *.tex :packadd vimtex | set filetype=tex
      autocmd bufnewfile,bufread *.ts :packadd vim-typescript
      autocmd bufnewfile,bufread *.journal :packadd vim-ledger | set filetype=ledger shiftwidth=4
      autocmd bufnewfile,bufread config set filetype=conf
      autocmd bufnewfile,bufread *.elm :packadd elm-vim | set filetype=elm shiftwidth=4
      autocmd filetype haskell :packadd haskell-vim | :packadd vim-hindent | set formatprg=hindent
      autocmd filetype python set formatprg=black
      autocmd filetype javascript *.js :packadd vim-javascript
      autocmd filetype make setlocal noexpandtab
      autocmd filetype markdown,text set formatoptions+=t
      autocmd filetype markdown,text set formatprg=par\ -w80
      autocmd filetype markdown,text set textwidth=80
      autocmd bufreadpost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \ exe "normal! g`\"" |
        \ endif
      autocmd bufreadpre * setlocal foldmethod=indent
      autocmd bufwritepre * :call <SID>StripTrailingWhitespaces()
      autocmd bufwinenter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
    endif

    if exists("g:loaded_startify")
      let g:startify_custom_header = \'\'
    endif

    if exists("g:loaded_deoplete")
      let g:deoplete#enable_at_startup = 1
    endif

    if exists("g:loaded_supertab")
      let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
    endif

    let g:haskell_enable_quantification = 1
    let g:haskell_enable_recursivedo = 1
    let g:haskell_enable_arrowsyntax = 1
    let g:haskell_enable_pattern_synonyms = 1

    if exists("g:loaded_ale")
      let g:ale_linters.haskell = ['hlint']
    endif

    let g:hindent_on_save = 1
    let g:hindent_line_length = 100

    if exists("g:loaded_grepper")
      nnoremap <leader>ga :Grepper<cr>
      nnoremap <leader>gb :Grepper -buffer<cr>
    endif

    "if exists("g:loaded_airline")
      set noshowmode laststatus=0 noruler
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
  '';
}
