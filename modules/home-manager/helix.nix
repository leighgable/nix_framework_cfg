{ pkgs, ... }:
{
  programs.helix = with pkgs; {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      schemat
      clang-tools
      marksman
      futhark
      nil
      nixpkgs-fmt
      (python3.withPackages (
        p:
        (with p; [
          black
          isort
          python-lsp-black
          ruff
        ])
      ))
      rust-analyzer
    ];

    settings = {
      theme = "snazzy";

      editor = {
        color-modes = true;
        cursorline = true;
        bufferline = "multiple";

        soft-wrap.enable = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          ignore = false;
        };

        indent-guides = {
          character = "┊";
          render = true;
          skip-levels = 1;
        };

        lsp = {
          display-inlay-hints = true;
          display-messages = true;
          display-signature-help-docs = true;
        };

        statusline = {
          left = [
            "mode"
            "file-name"
            "spinner"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "file-type"
            "file-line-ending"
            "position"
          ];
          mode.normal = "N";
          mode.insert = "I";
          mode.select = "S";
        };
      };
    };
    languages = {
      language-server.ruff = {
        command = lib.getExe pkgs.ruff;
        args = [ "server" ];
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt;
        }
        {
          name = "python";
          language-servers = [ "ruff" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.ruff;
            args = [
              "check"
              "--select"
              "I"
              "--fix"
              "--stdin-filename"
              "%{buffer_name}"
            ];
          };
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "c";
          auto-format = true;
        }
        {
          name = "cpp";
          auto-format = true;
        }
        {
          name = "scheme";
          auto-format = true;
          formatter.command = lib.getExe pkgs.schemat;
        }
        {
          name = "futhark";
          scope = "source.futhark";
          file-types = [ "fut" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.futhark;
            args = [ "fmt" ];
          };
        }
      ];
    };
  };
}
