# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-aa6beb1b-3e54-4a0e-ac9c-e0c007d73cd5".device = "/dev/disk/by-uuid/aa6beb1b-3e54-4a0e-ac9c-e0c007d73cd5";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/42b747ff-a432-4c0e-bb0a-59f0a68c44a2";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-67c1f7da-4318-49f7-bd98-cc731990b595".device = "/dev/disk/by-uuid/67c1f7da-4318-49f7-bd98-cc731990b595";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9051-0891";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/529a1893-773e-4d04-bf6c-16e67e1ed3c7";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
