{
  writeText,
  lib,
  writers,
  mpv,
  dmenu,
  coreutils,
  gnused,
  di-fm-key-file,
}: let
  streams = import ../lib/streams.nix {
    di-fm-key = "%DI_FM_KEY%";
  };
  streams-tsv = writeText "streams.tsv" (lib.concatMapStringsSep "\n" ({
    desc ? "",
    stream,
    station,
    ...
  }: "${station}\t${desc}\t${stream}")
  streams);
in
  writers.writeDashBin "mpv-radio" ''
    export DI_FM_KEY=$(cat "${di-fm-key-file}")
    exec ${mpv}/bin/mpv --force-window=yes "$(
      ${dmenu}/bin/dmenu -i -l 5 < ${streams-tsv} \
        | ${coreutils}/bin/cut -f3 \
        | ${gnused}/bin/sed s/%DI_FM_KEY%/"$DI_FM_KEY"/
    )"
  ''
