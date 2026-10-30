{
  # inputs,
  # config,
  pkgs,
  ...
}:

{
  imports = [
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
      cat = "bat";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "tokyo-night";
      font-size = 12;
      background-opacity = 0.95;
    };
  };

  # programs.obs-studio = {
  #   enable = true;
  #   package = pkgs.obs-studio;
  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     obs-vaapi
  #     obs-gstreamer
  #     obs-vkcapture
  #     droidcam-obs
  #   ];
  # };

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
    moc
    fzf
    # python3Packages.pynvim
    # python3Packages.jupytext
    # python3Packages.jupyter-client
    # protolint
    # clang-tools
    jetbrains-mono
    # ruff
    # pyright
    # hadolint
    # nurl
    # nixpkgs-fmt
    # nixpkgs-review
    xclip
    # tflint
    # pylint
    bat
    # black
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
    # clang-tools
    # pyright
    nixfmt-tree
    nil
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
    lfs.enable = true;
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
