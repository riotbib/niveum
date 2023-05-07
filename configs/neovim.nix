{
  pkgs,
  niveumPackages,
  ...
}: {
  environment.variables.EDITOR = pkgs.lib.mkForce "nvim";
  environment.shellAliases.vi = "nvim";
  environment.shellAliases.vim = "nvim";
  environment.shellAliases.view = "nvim -R";

  environment.systemPackages = [
    (pkgs.writers.writeDashBin "vim" ''neovim "$@"'')
    (pkgs.neovim.override {
      configure = {
        customRC = ''
          source ${../lib/vim/init.vim}

          luafile ${../lib/vim/init.lua}
        '';
        packages.nvim = with pkgs.vimPlugins; {
          start = [
            ale
            fzf-vim
            fzfWrapper
            supertab
            undotree
            tabular
            # vimwiki
            niveumPackages.vimPlugins-vim-colors-paramount
            nvim-lspconfig
            vim-commentary
            vim-css-color
            vim-eunuch
            niveumPackages.vimPlugins-vim-fetch
            vim-fugitive
            vim-gitgutter
            vim-repeat
            vim-sensible
            vim-surround
            (pkgs.vimUtils.buildVimPlugin rec {
              pname = "vim-dim";
              version = "1.1.0";
              name = "${pname}-${version}";
              src = pkgs.fetchFromGitHub {
                owner = "jeffkreeftmeijer";
                repo = pname;
                rev = version;
                sha256 = "sha256-lyTZUgqUEEJRrzGo1FD8/t8KBioPrtB3MmGvPeEVI/g=";
              };
            })
          ];
          opt = [
            csv
            elm-vim
            emmet-vim
            haskell-vim
            niveumPackages.vimPlugins-icalendar-vim
            niveumPackages.vimPlugins-jq-vim
            rust-vim
            typescript-vim
            vim-javascript
            vim-ledger
            vim-nix
            vimtex
            vim-pandoc
            vim-pandoc-syntax
            niveumPackages.vimPlugins-vim-256noir
            niveumPackages.vimPlugins-typst-vim
          ];
        };
      };
    })
  ];
}
