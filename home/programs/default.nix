{ config, pkgs, ... }: {
  imports = [
    ./asdf.nix
    ./crystal.nix
    ./direnv
    ./doom
    ./nodejs.nix
    ./prettier
    ./python
    ./ranger
    ./ripgrep.nix
    ./ruby.nix
    ./rust
    ./scripts
    ./topgrade
    ./zathura.nix
    ./zsh
  ];

  programs = {
    crystal.enable = false;
    direnv.enable = true;
    doom.enable = true;
    emacs = { 
      enable = true;
      # package = pkgs.emacsMacport;
    };
    go.enable = true;
    nodejs = {
      enable = true;
      yarn.enable = true;
    };
    python = {
      enable = true;
      extraPackages = with pkgs.python3Packages; [
        codecov
        grip
        mypy
        # nvchecker
        poetry
        # python-language-server
      ];
      black.enable = true;
      pipx.enable = true;
      pylint.enable = true;
    };
    topgrade = {
      enable = true;
      config = {
        disable = [ "emacs" "gem" ];
        gitRepos = [ "~/.emacs.d" ];
      };
    };
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
    zsh.enable = true;
  };
}
