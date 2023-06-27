{
  pkgs,
  niveumPackages,
  ...
}: let
  zip-font = name: arguments: let
    directory = pkgs.fetchzip arguments;
  in
    pkgs.runCommand name {} ''
      mkdir -p $out/share/fonts/{truetype,opentype,woff}
      ${pkgs.findutils}/bin/find ${directory} -name '*.ttf' -exec install '{}' $out/share/fonts/truetype \;
      ${pkgs.findutils}/bin/find ${directory} -name '*.otf' -exec install '{}' $out/share/fonts/opentype \;
      ${pkgs.findutils}/bin/find ${directory} -name '*.woff' -exec install '{}' $out/share/fonts/woff \;
    '';
  simple-ttf = name: arguments: let
    file = pkgs.fetchurl arguments;
  in
    pkgs.runCommand name {} ''
      mkdir -p $out/share/fonts/truetype
      install ${file} $out/share/fonts/truetype
    '';

  egyptianHiero = zip-font "EgyptianHiero" {
    url = "https://github.com/MKilani/Djehuty/archive/master.zip";
    sha256 = "sha256-KbY4vedm757NWfDlgmNhslbZd+2Vs+o5PjtMMGDt61Y=";
  };
  antinoou = zip-font "Antinoou" {
    url = "https://www.evertype.com/fonts/coptic/AntinoouFont.zip";
    sha256 = "0jwihj08n4yrshcx07dnaml2x9yws6dgyjkvg19jqbz17drbp3sw";
    stripRoot = false;
  };
  newGardiner = zip-font "NewGardiner" {
    url = "https://mjn.host.cs.st-andrews.ac.uk/egyptian/fonts/NewGardiner.zip";
    sha256 = "1jd0qa6shh9pqqyig2w43m9l9rv1i50l73jzkhb6g6mqxbhb1mip";
    stripRoot = false;
  };
  junicode2 = zip-font "JunicodeTwo" {
    url = "https://github.com/psb1558/Junicode-font/archive/48bf476db278c844c67542b04d1e0e4c71f139d2.zip";
    sha256 = "1ryicc155vkvgv3315ddliigwa01afwyb4c4f6pnqcns03af001i";
  };
  newAthenaUnicode = zip-font "NewAthenaUnicode" {
    url = "https://classicalstudies.org/sites/default/files/userfiles/files/NAU5_005.zip";
    sha256 = "1g7qk9gl4nq2dz41bvck1nzilhin44j8691cxax3dlp77bbn9bxr";
  };
  jsesh = simple-ttf "JSesh" {
    url = "http://files.qenherkhopeshef.org/jsesh/JSeshFont.ttf";
    sha256 = "1203jrk2xzvgckcc5hx88kja1i3h8gm1wiyla5j6gspc0hbv56ry";
  };
  egyptianText = simple-ttf "EgyptianText-1.0beta" {
    url = "http://c.krebsco.de/EgyptianText-v1.0-beta.ttf";
    sha256 = "0cfjbk7xxnxhlp6v922psm5j1xzrv6wfk226ji2wz2yfrnkbcbsv";
  };
in {
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      alegreya
      alegreya-sans
      amiri
      annapurna-sil
      antinoou
      cantarell-fonts
      cardo
      charis-sil
      doulos-sil
      newAthenaUnicode
      corefonts
      crimson
      eb-garamond
      ipaexfont
      jsesh
      egyptianHiero
      egyptianText
      font-awesome_6
      etBook
      newGardiner
      junicode2
      ezra-sil
      fira
      font-awesome
      galatia-sil
      gentium
      niveumPackages.gfs-fonts
      gyre-fonts
      ibm-plex
      jetbrains-mono
      libertinus
      libre-bodoni
      lmodern
      merriweather
      ocr-a
      roboto
      roboto-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto-slab
      scheherazade-new
      source-code-pro
      source-sans-pro
      source-serif-pro
      theano
      niveumPackages.tocharian-font
      vistafonts
      vollkorn
      zilla-slab
    ]; # google-fonts league-of-moveable-type
    fontconfig.defaultFonts = rec {
      monospace = ["Noto Sans Mono"] ++ emoji;
      serif = ["Noto Serif" "Noto Naskh Arabic" "Noto Serif Devanagari"];
      sansSerif = ["Noto Sans Display" "Noto Naskh Arabic" "Noto Sans Devanagari" "Noto Sans CJK JP" "Noto Sans Coptic"];
      emoji = ["Noto Color Emoji"];
    };
    # xelatex fails with woff files
    # ref https://tex.stackexchange.com/questions/392144/xelatex-and-fontspec-crash-trying-to-find-woff-file-for-some-fonts-but-not-other
    fontconfig.localConf = ''
      <fontconfig>
      <!-- Reject WOFF fonts We don't register WOFF(2) fonts with fontconfig because of the W3C spec -->
       <selectfont>
        <rejectfont>
         <glob>*.woff*</glob>
        </rejectfont>
       </selectfont>
      </fontconfig>
    '';
  };
}
