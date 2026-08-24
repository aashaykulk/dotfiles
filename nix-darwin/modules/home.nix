{ pkgs, ... }:

{
  home.homeDirectory = "/Users/aashay";
  home.stateVersion = "26.05";
  home.sessionPath = [
    "/etc/profiles/per-user/aashay/bin"
  ];
  programs.tmux = {
    enable = true;

    terminal = "screen-256color";

    extraConfig = ''
      set -g mouse on
      set -g history-limit 100000

      setw -g mode-keys vi
      set -g status-position top

      set -g window-status-format " #I: #W "
      set -g window-status-current-format "#[bg=#E6C384,fg=#1F1F28,bold] #I: #W #[default]"

      set -g status-style "bg=#1F1F28,fg=#DCD7BA"
      set -g status-left "#[fg=#7E9CD8] #S "
      set -g status-right "#[fg=#98BB6C] %H:%M "
    '';
  };
  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      blink-cmp
      nvim-lspconfig
      fzf-lua
      friendly-snippets
      nvim-web-devicons
      conform-nvim
      nvim-lint
      kanagawa-nvim
      oil-nvim
      lualine-nvim
      gitsigns-nvim
      typst-preview-nvim

      (nvim-treesitter.withPlugins (
        p: with p; [
          c
          cpp
          lua
          nix
          python
          rust
          typescript
          typst
        ]
      ))
    ];

    initLua = ''
                      vim.g.mapleader = " "
                      vim.g.maplocalleader = " "

                      vim.opt.number = true
                      vim.opt.relativenumber = true
                      vim.opt.swapfile = false

                      vim.opt.timeout = true
                      vim.opt.timeoutlen = 1000
            	  vim.opt.clipboard = "unnamedplus"

                      -- Line numbers
                      vim.keymap.set("n", "<leader>n", function()
                        vim.wo.number = not vim.wo.number
                      end, { desc = "Toggle line numbers" })

                      vim.keymap.set("n", "<leader>rn", function()
                        vim.wo.relativenumber = not vim.wo.relativenumber
                      end, { desc = "Toggle relative numbers" })

                      -- Buffers
                      vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", {
                        desc = "Next buffer",
                      })

                      vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", {
                        desc = "Previous buffer",
                      })

                      -- fzf-lua
                      require("fzf-lua").setup({})

                      vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", {
                        desc = "Find files",
                      })

                      vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", {
                        desc = "Live grep",
                      })

                      vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", {
                        desc = "Find buffers",
                      })

                      -- Oil
                      require("oil").setup({
                        view_options = {
                          show_hidden = true,
                        },
                      })

                      vim.keymap.set("n", "<leader>e", function()
                    	if vim.bo.filetype == "oil" then
                      	vim.cmd("bd")
                    	else
                      	vim.cmd("Oil")
                    	end
                  	end, { desc = "Toggle file explorer" })

                      require("lualine").setup({
                    options = {
                      theme = "kanagawa",
                      icons_enabled = true,
                      section_separators = "",
                      component_separators = "",
                      },
                      })
                      
                      -- Formatting
                      require("conform").setup({
                        formatters_by_ft = {
                          lua = { "stylua" },
                          nix = { "nixfmt" },
                          c = { "clang_format" },
                          cpp = { "clang_format" },
                        },
                      })

                      vim.keymap.set("n", "<leader>cf", function()
                        require("conform").format({
                          async = true,
                          lsp_format = "fallback",
                        })
                      end, { desc = "Format file" })

                      -- Linting
                      local lint = require("lint")

                      lint.linters_by_ft = {
                        lua = { "luacheck" },
                      }

                      vim.api.nvim_create_autocmd({
                        "BufEnter",
                        "BufWritePost",
                        "InsertLeave",
                      }, {
                        callback = function()
                          lint.try_lint()
                        end,
                      })

                      require("gitsigns").setup({
                    signs = {
                      add = { text = "+" },
                      change = { text = "~" },
                      delete = { text = "_" },
                      topdelete = { text = "‾" },
                      changedelete = { text = "~" },
                    },
                  })

                    vim.keymap.set("n", "]h", function()
                    require("gitsigns").next_hunk()
                    end, { desc = "Next Git hunk" })

                    vim.keymap.set("n", "[h", function()
                    require("gitsigns").prev_hunk()
                    end, { desc = "Previous Git hunk" })

                    vim.keymap.set("n", "<leader>gp", function()
                    require("gitsigns").preview_hunk()
                    end, { desc = "Preview Git hunk" })

                    vim.keymap.set("n", "<leader>gb", function()
                    require("gitsigns").blame_line()
                    end, { desc = "Git blame line" })

      require("blink.cmp").setup({
        keymap = {
          preset = "default",

          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
                      -- CUDA filetypes
                      vim.filetype.add({
                        extension = {
                          cu = "cpp",
                          cuh = "cpp",
                        },
                      })

                      -- Treesitter
                      vim.api.nvim_create_autocmd("FileType", {
                        pattern = {
                          "c",
                          "cpp",
                          "lua",
                          "nix",
                          "python",
                          "rust",
                          "typescript",
            	      "typst"
                        },

                        callback = function()
                          vim.treesitter.start()

                          if vim.bo.filetype ~= "python" then
                            vim.bo.indentexpr =
                              "v:lua.require'nvim-treesitter'.indentexpr()"
                          end
                        end,
                      })

                      -- LSP
                      vim.lsp.config("lua_ls", {
                        settings = {
                          Lua = {
                            diagnostics = {
                              globals = { "vim" },
                            },
                          },
                        },
                      })

                      vim.lsp.enable("lua_ls")
                      vim.lsp.enable("nil_ls")
                      vim.lsp.enable("clangd")
            	  vim.lsp.enable("tinymist")

                      -- LSP keymaps
                      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
                        desc = "Go to definition",
                      })

                      vim.keymap.set("n", "gr", vim.lsp.buf.references, {
                        desc = "References",
                      })

                      vim.keymap.set("n", "K", vim.lsp.buf.hover, {
                        desc = "Hover",
                      })

                      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
                        desc = "Rename symbol",
                      })

                      vim.keymap.set(
                        { "n", "v" },
                        "<leader>ca",
                        vim.lsp.buf.code_action,
                        {
                          desc = "Code action",
                        }
                      )

                      vim.keymap.set("n", "]d", function()
                       vim.diagnostic.jump({ count = 1 })
                      end, { desc = "Next diagnostic" })

                     vim.keymap.set("n", "[d", function()
                      vim.diagnostic.jump({ count = -1 })
                     end, { desc = "Previous diagnostic" })

                     vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {
                      desc = "Show diagnostic",
                  })

                      -- Theme
                      require("kanagawa").setup({
                        compile = false,
                        transparent = false,
                      })

                      vim.cmd.colorscheme("kanagawa")
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

  xdg.configFile."rift/config.toml".text = ''
      [settings]
      animate = true
      animation_duration = 0.2
      animation_fps = 120.0
      default_disable = false

      focus_follows_mouse = false
      mouse_follows_focus = false
      mouse_hides_on_focus = false

      [virtual_workspaces]
      enabled = true
      default_workspace_count = 9
      preserve_focus_per_workspace = true

      [keys]
      "Alt + H" = { move_focus = "left" }
      "Alt + J" = { move_focus = "down" }
      "Alt + K" = { move_focus = "up" }
      "Alt + L" = { move_focus = "right" }

      "Alt + Shift + H" = { move_node = "left" }
      "Alt + Shift + J" = { move_node = "down" }
      "Alt + Shift + K" = { move_node = "up" }
      "Alt + Shift + L" = { move_node = "right" }

    "Alt + 1" = { switch_to_workspace = 0 }
    "Alt + 2" = { switch_to_workspace = 1 }
    "Alt + 3" = { switch_to_workspace = 2 }
    "Alt + 4" = { switch_to_workspace = 3 }
    "Alt + 5" = { switch_to_workspace = 4 }
    "Alt + 6" = { switch_to_workspace = 5 }
    "Alt + 7" = { switch_to_workspace = 6 }
    "Alt + 8" = { switch_to_workspace = 7 }
    "Alt + 9" = { switch_to_workspace = 8 }

    "Alt + Shift + 1" = { move_window_to_workspace = 0 }
    "Alt + Shift + 2" = { move_window_to_workspace = 1 }
    "Alt + Shift + 3" = { move_window_to_workspace = 2 }
    "Alt + Shift + 4" = { move_window_to_workspace = 3 }
    "Alt + Shift + 5" = { move_window_to_workspace = 4 }
    "Alt + Shift + 6" = { move_window_to_workspace = 5 }
    "Alt + Shift + 7" = { move_window_to_workspace = 6 }
    "Alt + Shift + 8" = { move_window_to_workspace = 7 }
    "Alt + Shift + 9" = { move_window_to_workspace = 8 }
  '';

}
