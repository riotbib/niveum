{ config, lib, pkgs, ... }:
let
  helpers = import ./helpers.nix;
in {
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
    ./options.nix
    configs/hu-berlin.nix
    configs/users.nix
    configs/shells.nix
    configs/editors.nix
    configs/graphics.nix
    configs/packages.nix
    configs/networks.nix
    configs/retiolum.nix
  ];

  time.timeZone = "Europe/Berlin";

  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # for bluetooth sound output
  };

  hardware.bluetooth = {
    enable = true;
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults pwfeedback
    '';
  };

  systemd.services.google-drive = {
    description = "Google Drive synchronisation service";
    wants = [ "network-online.target" ];
    script = ''
      ${pkgs.grive2}/bin/grive -p ${config.users.users.kfm.home}/cloud/gdrive
    '';
    startAt = "*:0/5";
    serviceConfig = {
      Restart = "on-failure";
      User = "kfm";
    };
  };

  programs.tmux = {
    enable = true;
    extraTmuxConf = import dot/tmux.nix;
    keyMode = "vi";
    terminal = "screen-256color";
  };

  home-manager.users.kfm = {
    programs.git = {
      enable = true;
      userName = config.constants.user.name;
      userEmail = config.constants.user.email;
      aliases = {
        br = "branch";
        co = "checkout";
        ci = "commit";
        amend = "commit --amend";
        st = "status";
        unstage = "reset HEAD --";
        sdiff = "diff --staged";
        last = "log -1 HEAD";
        pull-all = "!pull-all"; # from dot/scripts.nix
      };
      ignores = config.constants.ignore;
    };

    home.file = {
      ".config/mpv/input.conf".text = import dot/mpv.nix;
      ".config/Typora/themes/base.user.css".text = import dot/typora.nix;
      ".ghc/ghci.conf".text = import dot/ghci.nix { inherit pkgs; };
      ".stack/config.yaml".text = import dot/stack.nix { user = config.constants.user; };
      ".zshrc".text = "# nothing to see here";
    };
  };
}
