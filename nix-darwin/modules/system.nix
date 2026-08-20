{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    tmux
    ripgrep
    fd
    fzf
    bat
    eza
    jq
    btop
    ffmpeg
    fastfetch
    yazi
    typst
    starship
    nixfmt
    lazygit
  ];

  nix.package = pkgs.lix;

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  system.primaryUser = "aashay";

  system.defaults = {
   dock = {
    autohide = true;
    autohide-delay = 0.0;
    };
   };

  users.users.aashay = {
    name = "aashay";
    home = "/Users/aashay";
  };

  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
