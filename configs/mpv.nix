{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mpv
    mpv-poll
  ];

  environment.shellAliases.mpv = "${pkgs.utillinux}/bin/setsid -f ${pkgs.mpv}/bin/mpv";

  home-manager.users.me.xdg.configFile = {
    "mpv/input.conf".text = ''
      Alt+RIGHT add video-rotate 90
      Alt+LEFT add video-rotate -90
      Alt+- add video-zoom -0.25
      Alt+= add video-zoom 0.25
      Alt+l add video-pan-x -0.05
      Alt+h add video-pan-x 0.05
      Alt+k add video-pan-y 0.05
      Alt+j add video-pan-y -0.05
    '';
  };
}
