{ catullus-ssh ? "root@catullus.r"
, scardanelli-ssh ? "root@scardanelli.r:22022"
, homeros-ssh ? "root@homeros.r:22022"
}:
let
  krops = builtins.fetchGit {
    url = "https://cgit.krebsco.de/krops/";
  };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" {};
  importJson = (import <nixpkgs> {}).lib.importJSON;

  source = {path, other ? {}}: lib.evalSource [({
    nixpkgs.git = {
      url = https://github.com/NixOS/nixpkgs-channels;
      ref = (importJson ./nixpkgs.json).rev;
    };
    nixos-unstable.git = {
      url = https://github.com/NixOS/nixpkgs-channels;
      ref = "nixos-unstable";
    };
    home-manager.git = {
      url = https://github.com/rycee/home-manager;
      ref = "2ccbf43";
    };
    stockholm.git = {
      url = https://cgit.krebsco.de/stockholm;
      ref = "7e1b197dab13d024ba491c96dc959306324943c0";
    };
    nix-writers.git = {
      url = https://cgit.krebsco.de/nix-writers;
      ref = "c528cf970e292790b414b4c1c8c8e9d7e73b2a71";
    };
    system.file = toString path;
    art.file = toString ./art;
    lib.file = toString ./lib;
    packages.file = toString ./packages;
    systems.file = toString ./systems;
    configs.file = toString ./configs;
    dot.file = toString ./dot;
    modules.file = toString ./modules;

    nixos-config.symlink = "system/configuration.nix";
  } // other)];

  systems.scardanelli = pkgs.krops.writeDeploy "deploy-scardanelli" {
    source = source { path = ./systems/scardanelli; };
    target = scardanelli-ssh;
  };

  systems.homeros = pkgs.krops.writeDeploy "deploy-homeros" {
    source = source { path = ./systems/homeros; };
    target = homeros-ssh;
  };

  systems.catullus = pkgs.krops.writeDeploy "deploy-catullus" {
    source = source {
      path = ./systems/catullus;
      other = {
        secrets.pass = {
          dir = toString ~/.password-store;
          name = "catullus";
        };
      };
    };
    target = catullus-ssh;
  };
in systems // {
  all = pkgs.writeScript "deploy-all" (lib.concatStringsSep "\n" (lib.attrValues systems));
}
