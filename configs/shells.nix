{ pkgs, ... }:
let scripts = import ../dot/scripts.nix { inherit pkgs; };
in {
  environment.shellAliases =
    let rlwrap = cmd: "${pkgs.rlwrap}/bin/rlwrap ${cmd}";
    in {
      ":r" = ''echo "You stupid!"'';
      clipboard = "${pkgs.xclip}/bin/xclip -se c";
      external-ip = "${pkgs.dnsutils}/bin/dig +short myip.opendns.com @resolver1.opendns.com";
      ip = "${pkgs.iproute}/bin/ip -c";
      ocaml = rlwrap "${pkgs.ocaml}/bin/ocaml";
      tmux = "${pkgs.tmux}/bin/tmux -2";
    } // scripts;

  environment.interactiveShellInit = "export PATH=$PATH:$HOME/.local/bin";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "cursor" "root" "line" ];
    interactiveShellInit = ''
      setopt INTERACTIVE_COMMENTS
      setopt MULTIOS
      setopt AUTO_NAME_DIRS
      setopt PUSHD_MINUS PUSHD_TO_HOME AUTO_PUSHD
    '';
    promptInit = ''
      PROMPT="%{$fg_bold[white]%}%~ \$([[ \$? == 0 ]] && echo \"%{$fg_bold[green]%}\" || echo \"%{$fg_bold[red]%}\")%#%{$reset_color%} "
      RPROMPT='$(git_prompt_info)'
      ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[cyan]%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
    '';
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "common-aliases" ];
  };

  programs.bash = {
    promptInit = ''PS1="$(tput bold)\w \$([[ \$? == 0 ]] && echo \"\[\033[1;32m\]\" || echo \"\[\033[1;31m\]\")\$$(tput sgr0) "'';
    enableCompletion = true;
  };

}
