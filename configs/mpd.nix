{ config, pkgs, lib, ... }:
let
  playlists = import <niveum/lib/playlists.nix>;
  playlistFiles = lib.mapAttrs (name: {tracks, ...}: pkgs.writeText "${name}.m3u" (builtins.concatStringsSep "\n" (map ({url, ...}: url) tracks))) playlists;
  linkPlaylist = name: file: ''
    ln -sfn "${toString file}" "/var/lib/mpd/playlists/${name}.m3u"
  '';
  linkPlaylists = lib.concatStringsSep "\n" (lib.mapAttrsToList linkPlaylist playlistFiles);
in
{
  system.activationScripts.mpd-playlists = ''
    rm -rf /var/lib/mpd/playlists
    install -d /var/lib/mpd/playlists
    ${linkPlaylists}
  '';

  environment.systemPackages = [ pkgs.ncmpcpp pkgs.mpc_cli ];

  services.mpd.enable = true;
  services.ympd.enable = true;

  # dont let anyone outside localhost or local network in
  networking.firewall.extraCommands = let ympdPort = config.services.ympd.webPort; in ''
    ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport ${ympdPort} -s 192.168.0.0/16 -j ACCEPT
    ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport ${ympdPort} -s 127.0.0.0/8 -j ACCEPT
    ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport ${ympdPort} -j DROP
  '';
}
