{ pkgs, lib, config, ... }:
{
  imports = [
    <modules/constants.nix>
    {
      services.dbus.packages = [ pkgs.gnome3.dconf ];
    }
    <home-manager/nixos>
    # <configs/mopidy.nix>
    <configs/bash.nix>
    <configs/bluetooth.nix>
    <configs/chromium.nix>
    <configs/cloud.nix>
    <configs/compton.nix>
    <configs/default.nix>
    # <configs/home-assistant.nix>
    <configs/distrobump.nix>
    <configs/docker.nix>
    <configs/dunst.nix>
    <configs/fonts.nix>
    <configs/git.nix>
    <configs/hledger.nix>
    <configs/htop.nix>
    <configs/hu-berlin.nix>
    <configs/i3.nix>
    <configs/kdeconnect.nix>
    <configs/keybase.nix>
    <configs/keyboard.nix>
    <configs/mail.nix>
    <configs/mpv.nix>
    <configs/nano.nix>
    <configs/neovim.nix>
    <configs/nixpkgs-unstable.nix>
    <configs/packages>
    <configs/printing.nix>
    <configs/random-background.nix>
    <configs/redshift.nix>
    <configs/retiolum.nix>
    <configs/rofi.nix>
    <configs/sncli.nix>
    <configs/ssh.nix>
    <configs/sudo.nix>
    <configs/themes/owickstrom-dark.nix>
    <configs/theming.nix>
    <configs/tmux.nix>
    <configs/todo-txt.nix>
    <configs/traadfri.nix>
    <configs/unclutter.nix>
    <configs/urxvt.nix>
    <configs/vscode.nix>
    <configs/xautolock.nix>
    <configs/xresources.nix>
    <configs/zsh.nix>
    {
      niveum.user = {
        github = "kmein";
        email = "kieran.meinhardt@gmail.com";
        name = "Kierán Meinhardt";
      };

      niveum.applications = rec {
        fileManager = "${config.niveum.applications.terminal} -e ${pkgs.ranger}/bin/ranger";
      };

      niveum.theme = {
        gtk = { name = "Arc"; package = pkgs.arc-theme; };
        icon = { name = "Arc"; package = pkgs.arc-icon-theme; };
        cursor = { name = "capitaine-cursors"; package = pkgs.capitaine-cursors; };
      };
    }
    {
      nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          python3Packages = pkgs.python3Packages.override {
            overrides = new: old: {
              spotify-cli-linux = new.callPackage <packages/spotify-cli-linux.nix> {};
              instaloader = new.callPackage <packages/instaloader.nix> {};
              sncli = new.callPackage <packages/sncli.nix> {};
            };
          };
          haskellPackages = pkgs.haskellPackages.override {
            overrides = new: old: {
              blessings = new.callPackage <packages/blessings.nix> {};
              scanner = new.callPackage <stockholm/krebs/5pkgs/haskell/scanner.nix> {};
            };
          };
          git-quick-stats = pkgs.callPackage <packages/git-quick-stats.nix> {};
          writeDash = pkgs.writers.writeDash;
          writeDashBin = pkgs.writers.writeDashBin;
          iolanguage = pkgs.callPackage <packages/iolanguage.nix> {};
          nix-git = pkgs.callPackage <packages/nix-git.nix> {};

          kmein = {
            autorenkalender = pkgs.callPackage <packages/autorenkalender.nix> {};
            bvg = pkgs.callPackage <packages/bvg.nix> {};
            daybook = pkgs.callPackage <packages/daybook.nix> {};
            font-size = pkgs.callPackage <packages/font-size.nix> { font = config.niveum.fonts.terminal; };
            genius = pkgs.callPackage <packages/genius.nix> {};
            instaget = pkgs.callPackage <packages/instaget.nix> {};
            literature-quote = pkgs.callPackage <packages/literature-quote.nix> {};
            n = pkgs.callPackage <packages/n.nix> {};
            depp = pkgs.callPackage <packages/depp.nix> {};
            odyssey = pkgs.callPackage <packages/odyssey.nix> {};
            wttr = pkgs.callPackage <packages/wttr.nix> {};
            nav = pkgs.callPackage <packages/nav.nix> {};
            slide =
              let slide-package = pkgs.fetchFromGitHub {
                owner = "kmein";
                repo = "slide";
                rev = "0470583d22212745eab4f46076267addf4d2346c";
                sha256 = "0skcp3va9v4hmxy5ramghpz53gnyxv10wsacgmc2jr0v1wrqlzbh";
              };
              in pkgs.callPackage slide-package {};
            haskellPackages.mnemosyne =
              let mnemosyne-package = pkgs.fetchFromGitHub {
                repo = "mnemosyne";
                owner = "kmein";
                rev = "6bfa13c88db176af80be90840ff03573d67d679f";
                sha256 = "1rimv5c5q9602y501hbkgkfbimqnmdkcr5hp1434q06gcazhjhca";
              };
              in pkgs.haskellPackages.callPackage mnemosyne-package {};
          };
        };
      };
    }
    {
      boot.cleanTmpDir = true;
      boot.loader.timeout = 1;
      boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    }
    {
      time.timeZone = "Europe/Berlin";
    }
    {
      home-manager.users.me = {
        programs.zathura = {
          enable = true;
          options.selection-clipboard = "clipboard";
        };
      };
    }
    {
      users.mutableUsers = false;

      users.users.me = {
        name = "kfm";
        description = config.niveum.user.name;
        home = "/home/kfm";
        createHome = true;
        group = "users";
        hashedPassword = "$6$w9hXyGFl/.IZBXk$5OiWzS1G.5hImhh1YQmZiCXYNAJhi3X6Y3uSLupJNYYXPLMsQpx2fwF4Xr2uYzGMV8Foqh8TgUavx1APD9rcb/";
        shell = pkgs.zsh;
      };
    }
    {
      sound.enable = true;

      hardware.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull; # for bluetooth sound output
      };

      users.users.me.extraGroups = [ "audio" ];

      environment.systemPackages = [ pkgs.pavucontrol pkgs.pamixer ];
    }
    {
      environment.systemPackages = [
        (pkgs.writers.writeDashBin "niveum-deploy" ''
          NIVEUM_DIR=/home/kfm/prog/git/niveum

          [ $# -eq 1 ] || echo >&2 "Usage: niveum-deploy SYSTEM"

          eval $(nix-build --no-out-link "$NIVEUM_DIR/deploy.nix" -A "$1")
        '')
        (pkgs.writers.writeDashBin "niveum-update" ''
          NIVEUM_DIR=/home/kfm/prog/git/niveum

          nix-prefetch-git --url https://github.com/NixOS/nixpkgs-channels --rev refs/heads/nixos-${config.system.stateVersion} > "$NIVEUM_DIR/nixpkgs.json"
        '')
      ];
    }
    {
      environment.interactiveShellInit = "export PATH=$PATH:$HOME/.cargo/bin";
      environment.shellAliases = {
        clipboard = "${pkgs.xclip}/bin/xclip -se c";
        o = "${pkgs.xdg_utils}/bin/xdg-open";
        tmux = "${pkgs.tmux}/bin/tmux -2";
        ip = "${pkgs.iproute}/bin/ip -c";
        ns = "nix-shell --run zsh";
        nixi = ''nix repl "<nixpkgs>"'';
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        l = "${pkgs.exa}/bin/exa -a";
        ls = "${pkgs.exa}/bin/exa";
        ll = "${pkgs.exa}/bin/exa -l";
        la = "${pkgs.exa}/bin/exa -la";
        dig = "dig +short";
      };
    }
    {
      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        networks = {
          "Aether".pskRaw = "e1b18af54036c5c9a747fe681c6a694636d60a5f8450f7dec0d76bc93e2ec85a";
          "Asoziales Netzwerk".pskRaw = "8e234041ec5f0cd1b6a14e9adeee9840ed51b2f18856a52137485523e46b0cb6";
          "EasyBox-927376".pskRaw = "dbd490ab69b39bd67cfa06daf70fc3ef3ee90f482972a668ed758f90f5577c22";
          "FlixBus Wi-Fi" = {};
          "FlixBus" = {};
          "FlixTrain" = {};
          "Libertarian WiFi".pskRaw = "e9beaae6ffa55d10e80b8a2e7d997411d676a3cc6f1f29d0b080391f04555050";
          "Ni/Schukajlow".pskRaw = "ffc47f6829da59c48aea878a32252223303f5c47a3859edc90971ffc63346781";
          "WIFIonICE" = {};
          "WLAN-914742".psk = "67647139648174545446";
          "WLAN-XVMU6T".pskRaw = "46ea807283255a3d7029233bd79c18837df582666c007c86a8d591f65fae17cc";
          "c-base-public" = {};
          "discord".psk = "baraustrinken";
          "security-by-obscurity".psk = "44629828256481964386";
        };
      };

      environment.systemPackages = [ pkgs.wpa_supplicant_gui ];
    }
    {
      networking.hosts = {
        "192.168.178.1" = [ "fritz.box" ];
        "192.168.178.21" = [ "scardanelli" ];
        "192.168.178.22" = [ "homeros" ];
        "192.168.178.24" = [ "catullus" ];
      };
    }
    {
      i18n.defaultLocale = "en_GB.UTF-8";
    }
    {
      services.illum.enable = true;
    }
    {
      services.xserver = {
        enable = true;
        displayManager.lightdm = {
          enable = true;
          autoLogin.enable = true;
          autoLogin.user = config.users.users.me.name;
          greeters.gtk = {
            enable = true;
            indicators = [ "~spacer" "~host" "~spacer" "~session" "~power" ];
          };
        };
        desktopManager.default = "none";
      };
    }
    {
      security.wrappers = {
        pmount.source = "${pkgs.pmount}/bin/pmount";
        pumount.source = "${pkgs.pmount}/bin/pumount";
      };
    }
    {
      programs.command-not-found.enable = true;
    }
    {
      programs.java = {
        enable = true;
        package = pkgs.openjdk;
      };
    }
  ];
}
