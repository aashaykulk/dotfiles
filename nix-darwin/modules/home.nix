{ pkgs, ... }:

{
  home.username = "aashay";
  home.homeDirectory = "/Users/aashay";
  home.stateVersion = "26.05";
  programs.tmux = {
    enable = true;

    terminal = "screen-256color";

    extraConfig = ''
      set -g mouse on
      set -g history-limit 100000

      setw -g mode-keys vi
    '';
  };

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      fzf-lua
    ];

    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.swapfile = false

      vim.g.mapleader = " "

      require("fzf-lua").setup({})

      vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")
      vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")
      vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      add_newline = false;

      character = {
        success_symbol = "[λ](bold)";
        error_symbol = "[λ](bold)";
      };

      git_branch = {
        format = "[$branch]($style) ";
      };
    };
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}
