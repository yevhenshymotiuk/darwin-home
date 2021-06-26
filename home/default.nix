{ config, lib, pkgs, ... }:

{
  home-manager = {
    useUserPackages = false;
    users.yevhenshymotiuk = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}
