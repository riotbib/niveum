{ config, pkgs, lib, ... }:
let
  bvg = pkgs.callPackage <packages/bvg.nix> {};
  daybook = pkgs.callPackage <packages/daybook.nix> {};
  iolanguage = pkgs.callPackage <packages/iolanguage.nix> {};
  sncli = pkgs.python3Packages.callPackage <packages/sncli.nix> {};
  todoist = pkgs.callPackage <packages/todoist> {};
  spotify-cli-linux = pkgs.python3Packages.callPackage <packages/spotify-cli-linux.nix> {};
  instaloader = pkgs.python3Packages.callPackage <packages/instaloader.nix> {};
  haskells = import <dot/haskells.nix>;
  unstable = import <nixos-unstable> {};
  executables = pkgs.haskell.lib.justStaticExecutables;
in with pkgs;
{
  nixpkgs.config.allowUnfree = true;

  fonts.enableDefaultFonts = true;
  fonts.fonts = [
    corefonts
    eb-garamond
    fira
    libertine
    lmodern
    noto-fonts
    roboto
    xlibs.fontschumachermisc
    ubuntu_font_family
  ];

  environment.systemPackages = [
  ] ++ [ # office
    abiword
    gnumeric
    # typora
  ] ++ [ # theme
    config.constants.theme.gtk.package
    config.constants.theme.icon.package
    config.constants.theme.cursor.package
  ] ++ [ # internet
    aria2
    chromium
    firefox
    tor-browser-bundle-bin
    thunderbird
    tdesktop
    w3m
    wget
    httpie
    whois
    ddgr
    instaloader
  ] ++ [ # media
    ffmpeg
    mpv
    pamixer
    pavucontrol
    gthumb
    imagemagick
    sxiv
    blueman
    zathura
  ] ++ [ # archive
    unzip
    unrar
    p7zip
    zip
  ] ++ [ # monitor
    htop
    iotop
    iftop
    lsof
    psmisc
  ] ++ [ # shell
    bat
    dos2unix
    du-dust
    exa
    fd
    file
    git
    gitAndTools.hub
    gitAndTools.git-extras
    gitstats
    jq
    manpages
    moreutils
    patch
    patchutils
    posix_man_pages
    ranger
    ripgrep
    rlwrap
    tree
  ] ++ [ # hardware
    pmount
    usbutils
    pciutils
  ] ++ [ # graphical
    arandr
    libnotify
    xclip
    xorg.xkill
    wpa_supplicant_gui
  ];

  security.wrappers = {
    pmount.source = "${pkgs.pmount}/bin/pmount";
    pumount.source = "${pkgs.pmount}/bin/pumount";
  };

  programs.command-not-found.enable = true;
  programs.java = {
    enable = true;
    package = pkgs.openjdk;
  };
  virtualisation.docker.enable = true;
  services.urxvtd.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  users.users.kfm.packages = [
  ] ++ [ # typesetting
    (texlive.combine {
      inherit (pkgs.texlive) scheme-full texdoc latex2e-help-texinfo;
      pkgFilter = pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "latex2e-help-texinfo";
    })
    pandoc
    (executables haskellPackages.pandoc-citeproc)
    (executables haskellPackages.patat)
    asciidoctor
    proselint
  ] ++ [ # programming
    vscode
    tokei
    gnumake
    cabal2nix
    chicken
    clojure
    gcc
    binutils-unwrapped
    (haskellPackages.ghcWithHoogle haskells)
    (executables haskellPackages.cabal-install)
    (executables haskellPackages.ghcid)
    (executables haskellPackages.hakyll)
    (haskellPackages.brittany)
    (executables haskellPackages.hfmt)
    (executables haskellPackages.hasktags)
    # (executables haskellPackages.hindent)
    (executables haskellPackages.pointfree)
    (executables haskellPackages.pointful)
    (executables haskellPackages.hlint)
    (executables haskellPackages.hpack)
    htmlTidy
    iolanguage
    lua
    mypy
    nix-prefetch-git
    nodejs
    nodePackages.csslint
    nodePackages.prettier
    nodePackages.jsonlint
    ocaml
    python3
    python3Packages.black
    python3Packages.python-language-server
    python3Packages.pyls-mypy
    python3Packages.flake8
    # python3Packages.jedi
    ruby
    rubocop
    rustup
    # rustracer
    scala
    shellcheck
  ] ++ [ # media
    audacity
    calibre
    inkscape
    xpdf
    pdfgrep
    pdftk
    spotify
    spotify-cli-linux
    youtubeDL
  ] ++ [ # cloud
    dropbox-cli
    grive2
    seafile-client
  ] ++ [ # math
    bc
    graphviz
    maxima
  ] ++ [ # shell
    # todoist
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.la
    bvg
    daybook
    gnupg
    jo
    memo
    par
    fzf
    (pass.withExtensions (ext: [ext.pass-otp]))
    qrencode
    sncli
    tmuxp
    unstable.hledger
    wordnet
    xsv
  ] ++ (if config.networking.hostName == "homeros" then [ unstable.zeroad ] else []);
}
