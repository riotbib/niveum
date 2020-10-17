{ pkgs, lib, config, options, ... }:
let inherit (lib.strings) makeBinPath;
in {
  imports = [
    <niveum/modules/constants.nix>
    <home-manager/nixos>
    {
      niveum.user = {
        github = "kmein";
        email = "kmein@posteo.de";
        name = "Kierán Meinhardt";
      };

      niveum.applications = rec {
        fileManager = "$TERMINAL -e ${pkgs.ranger}/bin/ranger";
      };

      niveum.theme = {
        gtk = {
          name = "Adwaita-dark";
          package = pkgs.gnome3.gnome-themes-extra;
        };
        icon = {
          name = "Adwaita";
          package = pkgs.gnome3.adwaita-icon-theme;
        };
        cursor = {
          name = "capitaine-cursors-white";
          package = pkgs.capitaine-cursors;
        };
      };
    }
    {
      nix.nixPath = [
        "/var/src"
        "nixpkgs-overlays=${toString ../overlays}"
      ];
    }
    { services.dbus.packages = [ pkgs.gnome3.dconf ]; }
    {
      environment.systemPackages = [
        (pkgs.writers.writeDashBin "x-www-browser" ''
          for browser in $BROWSER firefox chromium google-chrome google-chrome-stable opera vivaldi qupzilla iceweasel konqueror firefox-aurora google-chrome-beta opera-beta vivaldi-beta google-chrome-dev opera-developer vivaldi-snapshot luakit midori epiphany lynx w3m dillo elinks vimb; do
            if command -v $browser > /dev/null 2>&1; then
              exec $browser "$@"
            fi
          done
          exit 1
        '')
      ];
    }
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          packageOverrides = pkgs: {
            nur = import (builtins.fetchTarball
              "https://github.com/nix-community/NUR/archive/aea85375c7a82297d977904de8dd7f41baf2d59a.tar.gz") {
                inherit pkgs;
              };
            writeDashBin = pkgs.writers.writeDashBin;
            writeDash = pkgs.writers.writeDash;
            gfs-fonts = pkgs.callPackage <niveum/packages/gfs-fonts.nix> {
              scardanelli = config.networking.hostName == "scardanelli";
            };
            iolanguage = pkgs.callPackage <niveum/packages/iolanguage.nix> { };
            ix = pkgs.callPackage <niveum/packages/ix.nix> { };
          };
        };
        overlays = [
          (self: super: {
            scripts = import <niveum/packages/scripts> { pkgs = super; lib = super.lib; };
          })
          (import <niveum/overlays/toml.nix>)
          (import <stockholm/krebs/5pkgs/haskell>)
          (import <stockholm/submodules/nix-writers/pkgs>)
          (import <stockholm/krebs/5pkgs/override>)
        ];
      };
    }
    {
      boot.cleanTmpDir = true;
      boot.loader.timeout = 1;
      boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    }
    {
      time.timeZone = "Europe/Berlin";
      location = {
        latitude = 52.517;
        longitude = 13.3872;
      };
    }
    {
      home-manager.users.me = {
        programs.zathura = {
          enable = true;
          options = {
            selection-clipboard = "clipboard";
            # first-page-column = "1:1"; # makes side-by-side mode start on the left side
          };
        };
      };
    }
    {
      users.mutableUsers = false;

      users.defaultUserShell = pkgs.zsh;

      users.users.me = {
        name = "kfm";
        description = config.niveum.user.name;
        hashedPassword =
          "$6$w9hXyGFl/.IZBXk$5OiWzS1G.5hImhh1YQmZiCXYNAJhi3X6Y3uSLupJNYYXPLMsQpx2fwF4Xr2uYzGMV8Foqh8TgUavx1APD9rcb/";
        isNormalUser = true;
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
      environment.interactiveShellInit =
        "export PATH=$PATH:$HOME/projects/niveum";
      environment.shellAliases = let
        wcd = pkgs.writers.writeDash "wcd" ''
          cd "$(readlink "$(${pkgs.which}/bin/which --skip-alias "$1")" | xargs dirname)/.."
        '';
        where = pkgs.writers.writeDash "where" ''
          readlink "$(${pkgs.which}/bin/which --skip-alias "$1")" | xargs dirname
        '';
        take = pkgs.writers.writeDash "take" ''
          mkdir "$1" && cd "$1"
        '';
        swallow = command: "${pkgs.scripts.swallow}/bin/swallow ${command}";
      in {
        "ß" = "${pkgs.utillinux}/bin/setsid";
        cat = "${pkgs.bat}/bin/bat --style=plain";
        chromium-incognito =
          "chromium --user-data-dir=$(mktemp -d /tmp/chr.XXXXXX) --no-first-run --incognito";
        cp = "cp -i";
        dig = "dig +short";
        ip = "${pkgs.iproute}/bin/ip -c";
        l = "${pkgs.exa}/bin/exa -s type -a";
        la = "${pkgs.exa}/bin/exa -s type -la";
        ll = "${pkgs.exa}/bin/exa -s type -l";
        ls = "${pkgs.exa}/bin/exa -s type";
        mv = "mv -i";
        nixi = "nix repl '<nixpkgs>'";
        ns = "nix-shell --run zsh";
        o = "${pkgs.xdg_utils}/bin/xdg-open";
        pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard -in";
        pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -out";
        rm = "rm -i";
        s = "${pkgs.systemd}/bin/systemctl";
        take = "source ${take}";
        tmux = "${pkgs.tmux}/bin/tmux -2";
        tree = "${pkgs.exa}/bin/exa --tree";
        sxiv = swallow "${pkgs.sxiv}/bin/sxiv";
        zathura = swallow "${pkgs.zathura}/bin/zathura";
        us = "${pkgs.systemd}/bin/systemctl --user";
        wcd = "source ${wcd}";
        weechat = "${pkgs.openssh}/bin/ssh kmein@prism.r -t tmux attach";
        where = "source ${where}";
        yt =
          "${pkgs.youtube-dl}/bin/youtube-dl --add-metadata -ic"; # Download video link
        yta =
          "${pkgs.youtube-dl}/bin/youtube-dl --add-metadata -xic"; # Download with audio
      };
    }
    {
      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        networks = {
          "Aether" = {
            pskRaw = "e1b18af54036c5c9a747fe681c6a694636d60a5f8450f7dec0d76bc93e2ec85a";
            priority = 10;
          };
          "Asoziales Netzwerk" = {
            pskRaw = "8e234041ec5f0cd1b6a14e9adeee9840ed51b2f18856a52137485523e46b0cb6";
            priority = 10;
          };
          "Libertarian WiFi" = {
            pskRaw = "e9beaae6ffa55d10e80b8a2e7d997411d676a3cc6f1f29d0b080391f04555050";
            priority = 9;
          };
          "EasyBox-927376".pskRaw = "dbd490ab69b39bd67cfa06daf70fc3ef3ee90f482972a668ed758f90f5577c22";
          "FlixBus Wi-Fi" = { };
          "FlixBus" = { };
          "FlixTrain" = { };
          "BVG Wi-Fi" = { };
          "wannseeforum" = { }; # login via curl -XPOST http://WannseeLancom.intern.:80/authen/login/ -d userid=$USER_ID -d password=$PASSWORD
          "Hotel_Krone" = { }; # login: http://192.168.10.1/
          "Ni/Schukajlow".pskRaw = "ffc47f6829da59c48aea878a32252223303f5c47a3859edc90971ffc63346781";
          "WIFIonICE" = { }; # login: http://10.101.64.10/
          "WLAN-914742".psk = "67647139648174545446";
          "KDG-CEAA4".psk = "PBkBSmejcvM4";
          "KDG-4ECF7".psk = "Gdbwh7afw2Bx";
          "WLAN-XVMU6T".pskRaw =
            "46ea807283255a3d7029233bd79c18837df582666c007c86a8d591f65fae17cc";
          "c-base-public" = { };
          "discord".psk = "baraustrinken";
          "GoOnline".psk = "airbnbguest";
          "security-by-obscurity".psk = "44629828256481964386";
          "Mayflower".psk = "Fr31EsLan";
          "Born11".psk = "56LMVLbw840EGNWk0RYRqvgicx3FSO";
          "FactoryCommunityGuest".psk = "Factory4ever";
          "krebs".psk = "aidsballs";
        };
      };

      environment.systemPackages = [ pkgs.wpa_supplicant_gui ];
    }
    {
      networking.hosts = {
        "192.168.178.1" = [ "fritz.box" ];
        "192.168.178.24" = [ "catullus.local" ];
      };
    }
    { i18n.defaultLocale = "en_GB.UTF-8"; }
    { services.illum.enable = true; }
    {
      services.xserver = {
        enable = true;
        displayManager.lightdm = {
          enable = true;
          autoLogin = {
            enable = true;
            user = config.users.users.me.name;
          };
          greeters.gtk = {
            enable = true;
            indicators = [ "~spacer" "~host" "~spacer" "~session" "~power" ];
          };
        };
      };
    }
    {
      security.wrappers = {
        pmount.source = "${pkgs.pmount}/bin/pmount";
        pumount.source = "${pkgs.pmount}/bin/pumount";
      };
    }
    { programs.command-not-found.enable = true; }
    {
      programs.gnupg.agent.enable = true;

      environment.systemPackages = [ pkgs.gnupg pkgs.pass ];
    }
    {
      services.atd.enable = true;
    }
    {
      services.mingetty = {
        greetingLine = lib.mkForce "";
        helpLine = lib.mkForce "";
      };
    }
    ./alacritty.nix
    ./bash.nix
    ./bluetooth.nix
    ./ccc.nix
    ./kleiter.nix
    ./calcurse.nix
    ./chromium.nix
    ./cloud.nix
    ./compton.nix
    ./direnv.nix
    ./distrobump.nix
    ./docker.nix
    ./dunst.nix
    ./flix.nix
    ./fonts.nix
    ./fzf.nix
    ./gaslight.nix
    ./git.nix
    ./hledger.nix
    ./htop.nix
    ./hu-berlin.nix
    ./i3.nix
    ./keybase.nix
    ./keyboard.nix
    ./mail.nix
    ./mpv.nix
    ./mime.nix
    ./nano.nix
    ./neovim.nix
    ./newsboat.nix
    ./flameshot-once.nix
    ./nixpkgs-unstable.nix
    ./packages
    ./printing.nix
    ./wallpaper.nix
    ./redshift.nix
    ./retiolum.nix
    ./rofi.nix
    ./spotify.nix
    ./ssh.nix
    ./sudo.nix
    ./sxiv.nix
    ./themes/mac-os.nix
    ./theming.nix
    ./tmux.nix
    ./todo-txt.nix
    ./traadfri.nix
    ./unclutter.nix
    ./version.nix
    ./vscode.nix
    ./xautolock.nix
    ./zsh.nix
  ];
}
