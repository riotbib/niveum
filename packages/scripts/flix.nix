{pkgs}: let
  inherit (pkgs) lib;

  sendIRC = pkgs.writers.writeDash "send-irc" ''
    ${pkgs.ircaids}/bin/ircsink \
      --nick filmkritiker \
      --server irc.r \
      --port 6667 \
      --target '#flix' >/dev/null 2>&1
  '';

  messages.good = [
    "what a banger"
    "ooh i love this film"
    "this is top notch stuff!"
    "nice!"
    "noice!"
    "yesss!"
    "cool song!"
    "i like this"
    "that just sounds awesome!"
    "that's a good song!"
    "👍"
    "vibin'"
  ];
  messages.bad = [
    "how can anyone watch this?"
    "(╯°□°）╯ ┻━┻"
    "skip this!"
    "next, please! i'm suffering!"
    "that's just bad taste in movies"
    "nope"
    "that sucks!"
    "👎"
    "turn that down"
    "make it stooop"
    "noooo"
  ];

  messages.neutral = [
    "meh"
    "i have no opinion about this film"
    "idk man"
  ];
in
  pkgs.writers.writeDashBin "pls" ''
    case "$1" in
      good|like|cool|nice|noice|top|yup|yass|yes|+)
        ${pkgs.curl}/bin/curl -sS -XPOST "${playlistAPI}/good"
        echo ${lib.escapeShellArg (lib.concatStringsSep "\n" messages.good)} | shuf -n1 | ${sendIRC}
      ;;
      skip|next|bad|sucks|no|nope|flop|-)
        ${pkgs.curl}/bin/curl -sS -XPOST "${playlistAPI}/skip"
        echo ${lib.escapeShellArg (lib.concatStringsSep "\n" messages.bad)} | shuf -n1 | ${sendIRC}
      ;;
      0|meh|neutral)
        echo ${lib.escapeShellArg (lib.concatStringsSep "\n" messages.neutral)} | shuf -n1 | ${sendIRC}
      ;;
      say|msg)
        shift
        echo "$@" | ${sendIRC}
      ;;
    esac
    wait
  ''
