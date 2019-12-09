{ config, lib, pkgs, ... }:
{
  imports = [
    <niveum/modules/seafile.nix>
    <niveum/modules/google-drive.nix>
    <niveum/modules/dropbox.nix>
  ];

  niveum = {
    dropbox.enable = true;
    seafile.enable = true;
    google-drive = {
      enable = true;
      directory = "${config.users.users.me.home}/cloud/gdrive";
    };
  };

  services.syncthing = rec {
    enable = true;
    user = "kfm";
    openDefaultPorts = true;
    configDir = "/home/kfm/.config/syncthing";
    dataDir = "/home/kfm/.config/syncthing";
    declarative = rec {
      cert = toString <secrets/syncthing/cert.pem>;
      key = toString <secrets/syncthing/key.pem>;
      devices = {
        homeros.id = "HSOL72W-MMN346W-C3WCWCH-OTRKJYG-MY2WWV6-P7JUHN7-5WYYYRV-ZMH4KAA";
        scardanelli.id = "7CZYHEX-3CSFDQU-PEEMYHG-6XGQ2ZD-KGVUWH5-GFRB2XK-FP57ERX-7APZUQU";
        rilke.id = "NYNNHXP-7JMSTXG-SVNOPWD-RWXCCCL-CBOVBEI-X4QPLF4-NJA5G2P-RSGYRQQ";
        wilde.id = "R6DEBD7-G5RYDKN-VFA3HPO-WX4DNVI-373F7OQ-AW5MZTT-3L4BDVW-Y6ROEAF";
      };
      folders = let syncthing-dir = "${config.users.users.me.home}/cloud/syncthing"; in {
        "${syncthing-dir}/common".devices = [ "homeros" "scardanelli" "wilde" ];
        "${syncthing-dir}/library".devices = lib.attrNames devices;
        "${syncthing-dir}/mundoiu".devices = lib.attrNames devices;
      };
    };
  };
}
