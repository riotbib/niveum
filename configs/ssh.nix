{pkgs, ...}: let
  inherit (import ../lib) sshPort kieran;
  externalNetwork = import ../lib/external-network.nix;
in {
  users.users.me.openssh.authorizedKeys.keys = kieran.sshKeys pkgs;

  home-manager.users.me = {
    services.gpg-agent = rec {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtlSsh = 2 * 60 * 60;
      maxCacheTtlSsh = 4 * defaultCacheTtlSsh;
      sshKeys = [
        "568047C91DE03A23883E340F15A9C24D313E847C"
        "BB3EE102DB8CD45540A78A6B18B511B67061F6B4" # kfm@manakish ed25519
        "3F8986755818B5762A096BE212777EAAC441DD9D" # fysiweb rsa
        "0E4ABD229432486CC432639BB0986B2CDE365105" # agenix ed25519
        "A1E8D32CBFCDBD2DE798E2298D795CCFD785AE06" # kfm@kabsa ed25519
      ];
    };
  };

  environment.extraInit = ''
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
      export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    fi
  '';

  environment.interactiveShellInit = ''
    GPG_TTY="$(tty)"
    export GPG_TTY
    ${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
  '';

  home-manager.users.me.programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };
      zaatar = {
        hostname = "zaatar.r";
        user = "root";
        port = sshPort;
      };
      makanek = {
        hostname = externalNetwork.makanek;
        user = "root";
        port = sshPort;
      };
      ful = {
        hostname = externalNetwork.ful;
        user = "root";
        port = sshPort;
      };
      tahina = {
        hostname = "tahina.r";
        user = "root";
        port = sshPort;
      };
      tabula = {
        hostname = "tabula.r";
        user = "root";
        port = sshPort;
      };
      manakish = {
        hostname = "manakish.r";
        user = "kfm";
        port = sshPort;
      };
      kabsa = {
        hostname = "kabsa.r";
        user = "kfm";
        port = sshPort;
      };
      fatteh = {
        hostname = "fatteh.hr";
        user = "kfm";
        port = sshPort;
      };
    };
  };
}
