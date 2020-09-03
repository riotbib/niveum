{ pkgs, lib, ... }:
let
  inherit (lib.strings) fileContents;
  eduroam = {
    identity = fileContents <shared-secrets/eduroam/identity>;
    password = fileContents <shared-secrets/eduroam/password>;
  };
  eduroamAuth = ''
    key_mgmt=WPA-EAP
    eap=TTLS
    proto=RSN
    identity="${eduroam.identity}"
    anonymous_identity="anonymous@wlan.hu-berlin.de"
    altsubject_match="DNS:srv1-radius.cms.hu-berlin.de;DNS:srv2-radius.cms.hu-berlin.de"
    password="${eduroam.password}"
    ca_cert="${
      pkgs.fetchurl {
        url =
          "https://www.cms.hu-berlin.de/de/dl/netze/wlan/config/eduroam/t-telesec_globalroot_class_2.pem";
        sha256 = "0if8aqd06sid7a0vw009zpa087wxcgdd2x6z2zs4pis5kvyqj2dk";
      }
    }"
    phase2="auth=PAP"
  '';
in {
  networking.wireless.networks = {
    eduroam_5GHz.auth = eduroamAuth;
    eduroam.auth = eduroamAuth;
  };

  environment.systemPackages = [
    (pkgs.writers.writeDashBin "hu-vpn" ''
      ${pkgs.openfortivpn}/bin/openfortivpn -p "${eduroam.password}" -c ${pkgs.writeText "hu-berlin.config" ''
        host = forti-ssl.vpn.hu-berlin.de
        port = 443
        trusted-cert = e5a7d56543002ffe1e8962caa5fd6d94053aa702381458247b670877a66f3c6f
        username = ${eduroam.identity}
      ''}
    '')
  ];

  services.openvpn.servers.hu-berlin = {
    autoStart = false;
    authUserPass = {
      username = eduroam.identity;
      password = eduroam.password;
    };
    config = fileContents (pkgs.fetchurl {
      url =
        "https://www.cms.hu-berlin.de/de/dl/netze/vpn/openvpn/hu-berlin.ovpn";
      sha256 = "15b55aibik5460svjq2gwxrcyh6ay4k8savd6cd5lncgndmd8p8h";
    });
  };
}
