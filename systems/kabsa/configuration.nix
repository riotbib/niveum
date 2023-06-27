{
  inputs,
  pkgs,
  ...
}: let
  inherit (import ../../lib) retiolumAddresses;
in {
  imports = [
    ./hardware-configuration.nix
    ../../configs/battery.nix
    ../../configs/default.nix
    ../../configs/networkmanager.nix # TODO how to get passwords into there?
  ];

  niveum = {
    batteryName = "BAT0";
    wirelessInterface = "wlp3s0";
    promptColours.success = "cyan";
  };

  nix.settings = {
    cores = 1;
    max-jobs = 2;
  };

  age.secrets = {
    retiolum-rsa = {
      file = inputs.secrets + "/kabsa-retiolum-privateKey-rsa.age";
      mode = "400";
      owner = "tinc.retiolum";
      group = "tinc.retiolum";
    };
    retiolum-ed25519 = {
      file = inputs.secrets + "/kabsa-retiolum-privateKey-ed25519.age";
      mode = "400";
      owner = "tinc.retiolum";
      group = "tinc.retiolum";
    };
    restic.file = inputs.secrets + "/restic.age";
    syncthing-cert.file = inputs.secrets + "/kabsa-syncthing-cert.age";
    syncthing-key.file = inputs.secrets + "/kabsa-syncthing-key.age";
  };

  environment.systemPackages = [pkgs.minecraft pkgs.zeroad];

  networking = {
    hostName = "kabsa";
    wireless.interfaces = ["wlp3s0"];
    retiolum = retiolumAddresses.kabsa;
  };

  system.stateVersion = "19.03";
}
