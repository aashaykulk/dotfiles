{ pkgs, ... }:

{
  home.username = "aashay";
  home.homeDirectory = "/Users/aashay";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Fish
  programs.fish = {
    enable = true;

    shellInit = ''
      fish_add_path /etc/profiles/per-user/aashay/bin
    '';
  };

  # Starship
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

  # tmux
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    mouse = true;
    historyLimit = 100000;
    keyMode = "vi";

    extraConfig = ''
      set -g status-position top

      if-shell "[ -f ~/.config/tmux/theme-generated.conf ]" \
        "source-file ~/.config/tmux/theme-generated.conf"

      set -g status-left " DOTFILES "
      set -g status-right " %H:%M "

      set -g window-status-format " #I: #W "
      set -g window-status-current-format " #I: #W "
    '';

  };

  # Yazi
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # Neovim
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

      oil-nvim
      lualine-nvim
      gitsigns-nvim
      typst-preview-nvim

      tokyonight-nvim
      kanagawa-nvim
      catppuccin-nvim
      rose-pine
      gruvbox-nvim
      everforest
      nord-nvim
      onedark-nvim
      dracula-nvim
      nightfox-nvim
      oxocarbon-nvim

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
                                                                  --------------------------------------------------
                                                                  -- General
                                                                  --------------------------------------------------

                                                                  vim.g.mapleader = " "
                                                                  vim.g.maplocalleader = " "

                                                                  vim.opt.number = true
                                                                  vim.opt.relativenumber = true

                                                                  vim.opt.swapfile = false

                                                                  vim.opt.timeout = true
                                                                  vim.opt.timeoutlen = 1000

                                                                  -- Use macOS system clipboard
                                                                  vim.opt.clipboard = "unnamedplus"


                                                                  --------------------------------------------------
                                                                  -- Filetypes
                                                                  --------------------------------------------------

                                                                  vim.filetype.add({
                                                                    extension = {
                                                                      cu = "cpp",
                                                                      cuh = "cpp",
                                                                    },
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Treesitter
                                                                  --------------------------------------------------

                                                                  vim.api.nvim_create_autocmd("FileType", {
                                                                    pattern = {
                                                                      "c",
                                                                      "cpp",
                                                                      "lua",
                                                                      "nix",
                                                                      "python",
                                                                      "rust",
                                                                      "typescript",
                                                                      "typst",
                                                                    },

                                                                    callback = function()
                                                                      vim.treesitter.start()

                                                                      if vim.bo.filetype ~= "python" then
                                                                        vim.bo.indentexpr =
                                                                          "v:lua.require'nvim-treesitter'.indentexpr()"
                                                                      end
                                                                    end,
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Kanagawa
                                                                  --------------------------------------------------

                                                                  require("kanagawa").setup({
                                                                    compile = false,
                                                                    transparent = false,
                                                                  })



                                                                  --------------------------------------------------
                                                                  -- Lualine
                                                                  --------------------------------------------------

                                                                  require("lualine").setup({
                                                                    options = {
                                                                      theme = "auto",
                                                                      icons_enabled = true,

                                                                      section_separators = "",
                                                                      component_separators = "",
                                                                    },
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Oil
                                                                  --------------------------------------------------

                                                                  require("oil").setup({
                                                                    view_options = {
                                                                      show_hidden = true,
                                                                    },

                                                                    float = {
                                                                      padding = 2,
                                                                      max_width = 80,
                                                                      max_height = 30,
                                                                      border = "rounded",

                                                                      win_options = {
                                                                        winblend = 0,
                                                                      },
                                                                    },
                                                                  })

                                                                  vim.keymap.set("n", "<leader>e", function()
                                                                    require("oil").toggle_float()
                                                                  end, {
                                                                    desc = "Toggle floating file explorer",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- fzf-lua
                                                                  --------------------------------------------------

                                                                  local fzf = require("fzf-lua")

                                                                  vim.keymap.set("n", "<leader>ff", fzf.files, {
                                                                    desc = "Find files",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>fg", fzf.live_grep, {
                                                                    desc = "Live grep",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>fb", fzf.buffers, {
                                                                    desc = "Buffers",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- blink.cmp
                                                                  --------------------------------------------------
      							      require("blink.cmp").setup({
      								keymap = {
      								  preset = "default",

      								  ["<Tab>"] = {
      								    "select_next",
      								    "fallback",
      								  },

      								  ["<S-Tab>"] = {
      								    "select_prev",
      								    "fallback",
      								  },
      								 ["<CR>"] = {
      								    "accept",
      								    "fallback",
      								  },
      								},

      								completion = {
      								  list = {
      								    selection = {
      								      preselect = false,
      								      auto_insert = false,
      								    },
      								  },
      								},

      								sources = {
      								  default = {
      								    "lsp",
      								    "path",
      								    "snippets",
      								    "buffer",
      								  },
      								},
      							      })


                                                                  --------------------------------------------------
                                                                  -- LSP
                                                                  --------------------------------------------------

                                                                  vim.lsp.config("lua_ls", {
                                                                    settings = {
                                                                      Lua = {
                                                                        diagnostics = {
                                                                          globals = {
                                                                            "vim",
                                                                          },
                                                                        },
                                                                      },
                                                                    },
                                                                  })

                                                                  vim.lsp.enable("lua_ls")
                                                                  vim.lsp.enable("nil_ls")
                                                                  vim.lsp.enable("clangd")
                                                                  vim.lsp.enable("tinymist")


                                                                  --------------------------------------------------
                                                                  -- LSP keymaps
                                                                  --------------------------------------------------

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
                                                                    desc = "Rename",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
                                                                    desc = "Code action",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Diagnostics
                                                                  --------------------------------------------------

                                                                  vim.keymap.set("n", "]d", function()
                                                                    vim.diagnostic.jump({
                                                                      count = 1,
                                                                    })
                                                                  end, {
                                                                    desc = "Next diagnostic",
                                                                  })

                                                                  vim.keymap.set("n", "[d", function()
                                                                    vim.diagnostic.jump({
                                                                      count = -1,
                                                                    })
                                                                  end, {
                                                                    desc = "Previous diagnostic",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>cd", function()
                                                                    vim.diagnostic.open_float()
                                                                  end, {
                                                                    desc = "Diagnostic details",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Formatting
                                                                  --------------------------------------------------

                                                                  require("conform").setup({
                                                                    formatters_by_ft = {
                                                                      lua = {
                                                                        "stylua",
                                                                      },

                                                                      nix = {
                                                                        "nixfmt",
                                                                      },

                                                                      c = {
                                                                        "clang_format",
                                                                      },

                                                                      cpp = {
                                                                        "clang_format",
                                                                      },
                                                                    },
                                                                  })

                                                                  vim.keymap.set("n", "<leader>cf", function()
                                                                    require("conform").format({
                                                                      async = true,
                                                                      lsp_format = "fallback",
                                                                    })
                                                                  end, {
                                                                    desc = "Format file",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Linting
                                                                  --------------------------------------------------

                                                                  local lint = require("lint")

                                                                  lint.linters_by_ft = {
                                                                    lua = {
                                                                      "luacheck",
                                                                    },
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


                                                                  --------------------------------------------------
                                                                  -- Gitsigns
                                                                  --------------------------------------------------

                                                                  local gitsigns = require("gitsigns")

                                                                  gitsigns.setup({
                                                                    signs = {
                                                                      add = {
                                                                        text = "+",
                                                                      },

                                                                      change = {
                                                                        text = "~",
                                                                      },

                                                                      delete = {
                                                                        text = "_",
                                                                      },

                                                                      topdelete = {
                                                                        text = "‾",
                                                                      },

                                                                      changedelete = {
                                                                        text = "~",
                                                                      },
                                                                    },
                                                                  })

                                                                  vim.keymap.set("n", "]h", function()
                                                                    gitsigns.next_hunk()
                                                                  end, {
                                                                    desc = "Next Git hunk",
                                                                  })

                                                                  vim.keymap.set("n", "[h", function()
                                                                    gitsigns.prev_hunk()
                                                                  end, {
                                                                    desc = "Previous Git hunk",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, {
                                                                    desc = "Preview Git hunk",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, {
                                                                    desc = "Git blame line",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Buffers
                                                                  --------------------------------------------------

                                                                  vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", {
                                                                    desc = "Next buffer",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", {
                                                                    desc = "Previous buffer",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", {
                                                                    desc = "Close buffer",
                                                                  })


                                                                  --------------------------------------------------
                                                                  -- Line-number toggles
                                                                  --------------------------------------------------

                                                                  vim.keymap.set("n", "<leader>n", function()
                                                                    vim.wo.number = not vim.wo.number
                                                                  end, {
                                                                    desc = "Toggle line numbers",
                                                                  })

                                                                  vim.keymap.set("n", "<leader>rn", function()
                                                                    vim.wo.relativenumber = not vim.wo.relativenumber
                                                                  end, {
                                                                    desc = "Toggle relative line numbers",
                                                                  })
                                                	--------------------------------------------------
                                                	-- Theme picker + persistence
                                                	--------------------------------------------------
                              local state_dir = vim.fn.stdpath("state")
                              local theme_state = state_dir .. "/theme"

                              local ghostty_theme_file =
                                vim.fn.expand("~/.config/ghostty/theme-generated")

                              local tmux_theme_file =
                                vim.fn.expand("~/.config/tmux/theme-generated.conf")

                              vim.fn.mkdir(state_dir, "p")
                              vim.fn.mkdir(vim.fn.expand("~/.config/tmux"), "p")

                                                	vim.fn.mkdir(state_dir, "p")

                                    local themes = {
                                      {
                                        name = "Tokyo Night",
                                        nvim = "tokyonight-night",
                                        ghostty = "TokyoNight Night",
                                        tmux = {
                                          bg = "#1a1b26",
                                          fg = "#c0caf5",
                                          accent = "#7aa2f7",
                                          green = "#9ece6a",
                                        },
                                      },

                                      {
                                        name = "Tokyo Night Storm",
                                        nvim = "tokyonight-storm",
                                        ghostty = "TokyoNight Storm",
                                        tmux = {
                                          bg = "#24283b",
                                          fg = "#c0caf5",
                                          accent = "#7aa2f7",
                                          green = "#9ece6a",
                                        },
                                      },

                                      {
                                        name = "Kanagawa Wave",
                                        nvim = "kanagawa-wave",
                                        ghostty = "Kanagawa Wave",
                                        tmux = {
                                          bg = "#1f1f28",
                                          fg = "#dcd7ba",
                                          accent = "#7e9cd8",
                                          green = "#98bb6c",
                                        },
                                      },

                                      {
                                        name = "Kanagawa Dragon",
                                        nvim = "kanagawa-dragon",
                                        ghostty = "Kanagawa Dragon",
                                        tmux = {
                                          bg = "#181616",
                                          fg = "#c5c9c5",
                                          accent = "#8ba4b0",
                                          green = "#87a987",
                                        },
                                      },

                                      {
                                        name = "Catppuccin Mocha",
                                        nvim = "catppuccin-mocha",
                                        ghostty = "Catppuccin Mocha",
                                        tmux = {
                                          bg = "#1e1e2e",
                                          fg = "#cdd6f4",
                                          accent = "#89b4fa",
                                          green = "#a6e3a1",
                                        },
                                      },

                                      {
                                        name = "Catppuccin Macchiato",
                                        nvim = "catppuccin-macchiato",
                                        ghostty = "Catppuccin Macchiato",
                                        tmux = {
                                          bg = "#24273a",
                                          fg = "#cad3f5",
                                          accent = "#8aadf4",
                                          green = "#a6da95",
                                        },
                                      },

                                      {
                                        name = "Rose Pine",
                                        nvim = "rose-pine",
                                        ghostty = "rose-pine",
                                        tmux = {
                                          bg = "#191724",
                                          fg = "#e0def4",
                                          accent = "#c4a7e7",
                                          green = "#9ccfd8",
                                        },
                                      },

                                      {
                                        name = "Gruvbox",
                                        nvim = "gruvbox",
                                        ghostty = "Gruvbox Dark",
                                        tmux = {
                                          bg = "#282828",
                                          fg = "#ebdbb2",
                                          accent = "#fabd2f",
                                          green = "#b8bb26",
                                        },
                                      },

                                      {
                                        name = "Everforest",
                                        nvim = "everforest",
                                        ghostty = "Everforest Dark Hard",
                                        tmux = {
                                          bg = "#2b3339",
                                          fg = "#d3c6aa",
                                          accent = "#7fbbb3",
                                          green = "#a7c080",
                                        },
                                      },

                                      {
                                        name = "Nord",
                                        nvim = "nord",
                                        ghostty = "Nord",
                                        tmux = {
                                          bg = "#2e3440",
                                          fg = "#d8dee9",
                                          accent = "#88c0d0",
                                          green = "#a3be8c",
                                        },
                                      },

                                      {
                                        name = "OneDark",
                                        nvim = "onedark",
                                        ghostty = "OneDark",
                                        tmux = {
                                          bg = "#282c34",
                                          fg = "#abb2bf",
                                          accent = "#61afef",
                                          green = "#98c379",
                                        },
                                      },

                                      {
                                        name = "Dracula",
                                        nvim = "dracula",
                                        ghostty = "Dracula",
                                        tmux = {
                                          bg = "#282a36",
                                          fg = "#f8f8f2",
                                          accent = "#bd93f9",
                                          green = "#50fa7b",
                                        },
                                      },

                                      {
                                        name = "Nightfox",
                                        nvim = "nightfox",
                                        ghostty = "Nightfox",
                                        tmux = {
                                          bg = "#192330",
                                          fg = "#cdcecf",
                                          accent = "#719cd6",
                                          green = "#81b29a",
                                        },
                                      },

                                      {
                                        name = "Carbonfox",
                                        nvim = "carbonfox",
                                        ghostty = "Carbonfox",
                                        tmux = {
                                          bg = "#161616",
                                          fg = "#f2f4f8",
                                          accent = "#78a9ff",
                                          green = "#42be65",
                                        },
                                      },

                                      {
                                        name = "Oxocarbon",
                                        nvim = "oxocarbon",
                                        ghostty = "Oxocarbon",
                                        tmux = {
                                          bg = "#161616",
                                          fg = "#f2f4f8",
                                          accent = "#78a9ff",
                                          green = "#42be65",
                                        },
                                      },
                                    }
                                                	local function save_theme(theme)
                                                	  local file = assert(io.open(theme_state, "w"))
                                                	  file:write(theme.nvim)
                                                	  file:close()
                                                	end

                                                	local function write_ghostty_theme(theme)
                                                	  local file = assert(io.open(ghostty_theme_file, "w"))
                                                	  file:write("theme = " .. theme.ghostty .. "\n")
                                                	  file:close()
                                                	end
                                          local function reload_ghostty()
                                            vim.fn.jobstart({
                                              "osascript",
                                              "-e",
                                              'tell application "Ghostty" to perform action "reload_config"',
                                            }, {
                                              detach = true,
                                            })
                                          end
                        local function write_tmux_theme(theme)
                          local file = assert(io.open(tmux_theme_file, "w"))

                          file:write(
                            'set -g status-style "bg='
                              .. theme.tmux.bg
                              .. ',fg='
                              .. theme.tmux.fg
                              .. '"\n'
                          )

                          file:write(
                            'set -g status-left-style "fg='
                              .. theme.tmux.accent
                              .. '"\n'
                          )

                          file:write(
                            'set -g status-right-style "fg='
                              .. theme.tmux.green
                              .. '"\n'
                          )

                          file:write(
                            'set -g window-status-current-style "bg='
                              .. theme.tmux.accent
                              .. ',fg='
                              .. theme.tmux.bg
                              .. ',bold"\n'
                          )

                          file:close()
                        end

                        local function reload_tmux()
                          if vim.env.TMUX then
                            vim.fn.jobstart({
                              "tmux",
                              "source-file",
                              tmux_theme_file,
                            })
                          end
                        end

                                                	local function apply_theme(theme, persist)
                                                	  local ok = pcall(vim.cmd.colorscheme, theme.nvim)

                                                	  if not ok then
                                                	    vim.notify(
                                                	      "Could not load Neovim theme: " .. theme.nvim,
                                                	      vim.log.levels.ERROR
                                                	    )
                                                	    return
                                                	  end
                  if persist then
                    save_theme(theme)

                    write_ghostty_theme(theme)
                    reload_ghostty()

                    write_tmux_theme(theme)
                    reload_tmux()
                  end
                                                	end

                                                	local function find_theme(name)
                                                	  for _, theme in ipairs(themes) do
                                                	    if theme.nvim == name then
                                                	      return theme
                                                	    end
                                                	  end
                                                	end

                                                	local function load_saved_theme()
                                                	  local file = io.open(theme_state, "r")

                                                	  if not file then
                                                	    return themes[1]
                                                	  end

                                                	  local saved = file:read("*l")
                                                	  file:close()

                                                	  return find_theme(saved) or themes[1]
                                                	end

                                                	apply_theme(load_saved_theme(), false)

                                                	vim.keymap.set("n", "<leader>th", function()
                                                	  local names = {}

                                                	  for _, theme in ipairs(themes) do
                                                	    table.insert(names, theme.name)
                                                	  end

                                                	  require("fzf-lua").fzf_exec(names, {
                                                	    prompt = "Theme> ",

                                                	    actions = {
                                                	      ["default"] = function(selected)
                                                		local selected_name = selected[1]

                                                		for _, theme in ipairs(themes) do
                                                		  if theme.name == selected_name then
                                                		    apply_theme(theme, true)
                                                		    break
                                                		  end
                                                		end
                                                	      end,
                                                	    },
                                                	  })
                                                	end, {
                                                	  desc = "Theme picker",
                                                	})
    '';
  };
  # Rift
  #
  # Home Manager owns:
  # ~/.config/rift/config.toml

  xdg.configFile."rift/config.toml".text = ''
    [settings]
    animate = true
    animation_duration = 0.2
    animation_fps = 120.0

    # Manage new macOS Spaces automatically.
    default_disable = false

    focus_follows_mouse = false
    mouse_follows_focus = false
    mouse_hides_on_focus = false

    # Automatically reload Rift when this file changes.
    hot_reload = true


    # --------------------------------------------------
    # Virtual workspaces
    # --------------------------------------------------

    [virtual_workspaces]

    # Enable Rift's own virtual workspace system.
    enabled = true

    # Create workspaces 0 through 9.
    # This gives us bindings for Option+0 through Option+9.
    default_workspace_count = 10

    # Workspace selected when Rift starts.
    default_workspace = 1

    # Remember which window was focused in each workspace.
    preserve_focus_per_workspace = true

    # Do not automatically place apps into particular workspaces.
    auto_assign_windows = false

    # Pressing the current workspace key again returns to
    # the previously active workspace.
    workspace_auto_back_and_forth = false

    # No application-specific workspace rules for now.
    app_rules = []


    # --------------------------------------------------
    # Reusable modifier combinations
    # --------------------------------------------------

    [modifier_combinations]

    # Used for moving windows between workspaces.
    move_workspace = "Alt + Shift"


    # --------------------------------------------------
    # Keybindings
    # --------------------------------------------------

    [keys]


    # --------------------------------------------------
    # Focus windows
    # --------------------------------------------------

    "Alt + H" = { move_focus = "left" }
    "Alt + J" = { move_focus = "down" }
    "Alt + K" = { move_focus = "up" }
    "Alt + L" = { move_focus = "right" }


    # --------------------------------------------------
    # Move windows inside current workspace
    # --------------------------------------------------

    "Alt + Shift + H" = { move_node = "left" }
    "Alt + Shift + J" = { move_node = "down" }
    "Alt + Shift + K" = { move_node = "up" }
    "Alt + Shift + L" = { move_node = "right" }


    # --------------------------------------------------
    # Switch workspaces
    #
    # Option + number
    # --------------------------------------------------

    "Alt + 0" = { switch_to_workspace = 0 }
    "Alt + 1" = { switch_to_workspace = 1 }
    "Alt + 2" = { switch_to_workspace = 2 }
    "Alt + 3" = { switch_to_workspace = 3 }
    "Alt + 4" = { switch_to_workspace = 4 }
    "Alt + 5" = { switch_to_workspace = 5 }
    "Alt + 6" = { switch_to_workspace = 6 }
    "Alt + 7" = { switch_to_workspace = 7 }
    "Alt + 8" = { switch_to_workspace = 8 }
    "Alt + 9" = { switch_to_workspace = 9 }


    # --------------------------------------------------
    # Move focused window to workspace
    #
    # Option + Shift + number
    # --------------------------------------------------

    "move_workspace + 0" = { move_window_to_workspace = 0 }
    "move_workspace + 1" = { move_window_to_workspace = 1 }
    "move_workspace + 2" = { move_window_to_workspace = 2 }
    "move_workspace + 3" = { move_window_to_workspace = 3 }
    "move_workspace + 4" = { move_window_to_workspace = 4 }
    "move_workspace + 5" = { move_window_to_workspace = 5 }
    "move_workspace + 6" = { move_window_to_workspace = 6 }
    "move_workspace + 7" = { move_window_to_workspace = 7 }
    "move_workspace + 8" = { move_window_to_workspace = 8 }
    "move_workspace + 9" = { move_window_to_workspace = 9 }


    # --------------------------------------------------
    # Workspace navigation
    # --------------------------------------------------

    # Return to the previously active workspace.
    "Alt + Tab" = "switch_to_last_workspace"

    # Cycle through workspaces.
    "Alt + U" = "prev_workspace"
    "Alt + I" = "next_workspace"


    # --------------------------------------------------
    # Rift management
    # --------------------------------------------------

    # Toggle management of the current macOS Space.
    "Alt + Z" = "toggle_space_activated"
  '';

}
