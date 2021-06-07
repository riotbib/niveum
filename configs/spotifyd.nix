{ config, pkgs, lib, ... }:
{
  services.spotifyd = {
    enable = true;
    config = builtins.readFile ((pkgs.formats.toml {}).generate "spotifyd.toml" {
      global = {
        username = lib.strings.fileContents <secrets/spotify/username>;
        password = lib.strings.fileContents <secrets/spotify/password>;
        backend = "pulseaudio";
        bitrate = 320;
        device_type = "s_t_b"; # set-top box
        device_name = config.networking.hostName;
      };
    });
  };

  # ref https://github.com/NixOS/nixpkgs/issues/71362#issuecomment-753461502
  hardware.pulseaudio.extraConfig = ''
    unload-module module-native-protocol-unix
    load-module module-native-protocol-unix auth-anonymous=1
  '';

  systemd.services.spotifyd.serviceConfig.Restart = "always";
}
