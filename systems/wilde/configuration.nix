{ config, pkgs, lib, ... }:

{
  imports = [
    <configs/default.nix>
    ./hardware-configuration.nix
    <stockholm/krebs/2configs/hw/x220.nix>
  ];

  niveum = {
    networkInterfaces.wireless = "wlp3s0";
    promptColours.success = "cyan";
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ tp_smapi acpi_call ];

  boot.kernelModules = [ "tp_smapi" "acpi_call" ];

  environment.systemPackages = [ pkgs.tpacpi-bat ];

  virtualisation.docker.enable = lib.mkForce false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "wilde";

  system.stateVersion = "19.03";
}
