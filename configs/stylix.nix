{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  generatedWallpaper = pkgs.runCommand "wallpaper.png" {} ''
    ${inputs.wallpaper-generator.packages.x86_64-linux.wp-gen}/bin/wallpaper-generator lines \
      --output $out \
      ${lib.concatMapStringsSep " "
      (n: "--base0${lib.toHexString n}=${config.lib.stylix.colors.withHashtag."base0${lib.toHexString n}"}")
      (lib.range 0 15)}
  '';
in {
  # https://danth.github.io/stylix/tricks.html
  # stylix.image = inputs.wallpapers.outPath + "/meteora/rodrigo-soares-250630.jpg";
  stylix.image = generatedWallpaper;

  environment.etc."stylix/wallpaper.png".source = generatedWallpaper;

  # stylix.polarity = "either";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${
    {
      "0" = "synth-midnight-dark";
      "1" = "apprentice"; # https://romainl.github.io/Apprentice/
      "2" = "one-light";
      "3" = "onedark";
      "4" = "material"; # https://github.com/ntpeters/base16-materialtheme-scheme
      "5" = "material-palenight";
      "6" = "material-lighter";
      "7" = "tomorrow"; # https://github.com/chriskempson/tomorrow-theme
      "8" = "tomorrow-night";
      "9" = "gruvbox-light-medium"; # https://github.com/dawikur/base16-gruvbox-scheme
      "a" = "gruvbox-dark-medium";
      "b" = "selenized-light"; # https://github.com/jan-warchol/selenized
      "c" = "selenized-dark";
      "d" = "papercolor-light";
      "e" = "papercolor-dark";
      "f" = "dracula"; # https://draculatheme.com/
    }
    .${builtins.head (lib.stringToCharacters inputs.nixpkgs.rev)}
  }.yaml";

  stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    monospace = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      terminal = 6;
      applications = 10;
    };
  };
}
