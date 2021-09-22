# https://github.com/jmackie/nixos-networkmanager-profiles/
{ lib, config, ... }:
with lib;
let
  nm = config.networking.networkmanager;

  mkProfile = profileAttrs:
    if !(isAttrs profileAttrs) then
      throw "error 1"
    else {
      enable = true;
      mode = "0400"; # readonly (user)
      text = (foldlAttrs (accum:
        { name, value }: ''
          ${accum}

          [${name}] ${mkProfileEntry value}'')
        "# Generated by nixos-networkmanager-profiles" profileAttrs) + "\n";
    };

  mkProfileEntry = entryAttrs:
    if !(isAttrs entryAttrs) then
      throw "error 2"
    else
      foldlAttrs (accum:
        { name, value }: ''
          ${accum}
          ${name}=${toString value}'') "" entryAttrs;

  foldlAttrs = op: nul: attrs:
    foldl (accum: { fst, snd }: op accum (nameValuePair fst snd)) nul
    (lists.zipLists (attrNames attrs) (attrValues attrs));

  attrLength = attrs: length (attrValues attrs);

in {
  options.networking.networkmanager.profiles = mkOption {
    type = types.attrs;
    default = { };
  };

  config = mkIf (attrLength nm.profiles > 0) {
    environment.etc = (foldlAttrs (accum:
      { name, value }:
      accum // {
        "NetworkManager/system-connections/${name}.nmconnection" =
          mkProfile value;
      }) { } nm.profiles);
  };
}
