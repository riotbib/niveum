{
  config,
  pkgs,
  ...
}: let
  inherit (import <niveum/lib>) colours;
in {
  home-manager.users.me.programs.rofi = {
    enable = true;
    font = "Monospace 10";
    theme = "${pkgs.rofi}/share/rofi/themes/Arc.rasi";
    pass = {
      enable = true;
      extraConfig = ''
        USERNAME_field='login'
        help_color="#FF0000"
      ''; # help_color set by https://github.com/mrossinek/dotfiles/commit/13fc5f24caa78c8f20547bf473266879507f13bf
    };
    plugins = [pkgs.rofi-calc];
  };
}
