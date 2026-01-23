{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
#    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leigh";
  home.homeDirectory = "/home/leigh";

  home.shell.enableBashIntegration = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoreboth" ];
    historyIgnore = [
      "ls"
      "cd"
    ];
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      vi = "nvim";
      vim = "nvim";
      cat = "bat";
    };
  };

  programs.doom-emacs = {
    enable = true;
    doomDir = ~/.doom/doom.d;
  };

  #  programs.vscode = {
  #  enable = true;
  #  profiles.default.extensions = with pkgs.vscode-extensions; [
  #    dracula-theme.theme-dracula
  #    vscodevim.vim
  #    kamadorueda.alejandra
  #    yzhang.markdown-all-in-one
  #    rust-lang.rust-analyzer
  #    vscjava.vscode-maven
  #    ms-python.flake8
  #    ms-python.black-formatter
  #    pylyzer.pylyzer
  #    llvm-vs-code-extensions.vscode-clangd
  #  ];
  #};

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
      droidcam-obs
    ];
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    tree-sitter
    fzf
    python3Packages.pynvim
    python3Packages.jupytext
    python3Packages.jupyter-client
    protolint
    clang-tools
    jetbrains-mono
    ruff
    pyright
    hadolint
    nurl
    nixpkgs-fmt
    nixpkgs-review
    xclip
    tflint
    pylint
    bat
    black
    nix-direnv
    screen
    fastfetch
    dmidecode
    eza
    tmux
    ripgrep
    google-chrome
    tree
    bat
    dust
    fd
    tldr
    bottom
    wl-clipboard
    glow
    zellij
    inputs.antigravity-nix.packages.x86_64-linux.default

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # # (pkgs.nerd-fonts.override { fonts =
    #  [
    #    "fira-code"
    #    "droid-sans-mono"
    #    "jetbrains-mono"
    #  ];
    # })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.tmux = {

    enable = true;
    shell = "bash";

  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  programs.bat.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Leigh Gable";
      user.email = "leighgable@gmail.com";
    };
    signing.key = "E0D973FDC7E09875";
  };
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/leigh/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
