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
    moc
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
    clang-tools
    pyright
    nixfmt-tree
    nil
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-nox;

    extraPackages =
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        envrc
        flycheck
        nix-ts-mode
        magit
        geiser
        geiser-chibi
        futhark-mode
        python-mode
        auctex
        eglot
        sly
        evil
        evil-collection
        markdown-mode
        multiple-cursors
      ];
  }; # emacs

  home.file = {
    ".emacs.d/init.el".text = ''
      ;; Load the main configuration file
      (load (locate-user-emacs-file "custom.el"))
    '';

    ".emacs.d/custom.el".text = ''
            ;; Nix-managed entry point

            ;; Silence the system bell
            (setq ring-bell-function 'ignore)

            ;; Ensure the languages directory is in the load-path
            (add-to-list 'load-path (expand-file-name "languages" user-emacs-directory))

            ;; Environment management
            (require 'envrc)
            (setq envrc-show-event-buffer t) ; Keep this on to debug initialization
            (envrc-global-mode 1)

            ;; Evil Mode (Vim keybindings)
            (setq evil-want-integration t)
            (setq evil-want-keybinding nil)
            (require 'evil)
            (evil-mode 1)

            ;; Better Vim keys for other modes (Magit, Eglot, etc.)
            (require 'evil-collection)
            (evil-collection-init)

            (setq visible-bell nil)

            ;; Start/Restart Eglot after the Nix environment is fully loaded
            (defun my-eglot-envrc-sync ()
              "Ensure Eglot starts or restarts with the correct Nix environment."
              (when (and (bound-and-true-p envrc-mode)
                         (not (string= envrc-mode "none")))
                (eglot-ensure)))

            (add-hook 'envrc-after-update-hook #'my-eglot-envrc-sync)

            (menu-bar-mode -1)

           ;; Duplicate line
           (global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y")


            ;; Inspired by `sk-grow-frame' from Sarir Khamsi [sarir.khamsi@raytheon.com]
      ;;;###autoload
      (defun enlarge-frame (&optional increment frame) ; Suggested binding: `C-M-down'.
        "Increase the height of FRAME (default: selected-frame) by INCREMENT.
      INCREMENT is in lines (characters).
      Interactively, it is given by the prefix argument."
        (interactive "p")
        (set-frame-height frame (+ (frame-height frame) increment)))

      ;;;###autoload
      (defun enlarge-frame-horizontally (&optional increment frame) ; Suggested binding: `C-M-right'.
        "Increase the width of FRAME (default: selected-frame) by INCREMENT.
      INCREMENT is in columns (characters).
      Interactively, it is given by the prefix argument."
        (interactive "p")
        (set-frame-width frame (+ (frame-width frame) increment)))

      ;;;###autoload
      (defun shrink-frame (&optional increment frame) ; Suggested binding: `C-M-up'.
        "Decrease the height of FRAME (default: selected-frame) by INCREMENT.
      INCREMENT is in lines (characters).
      Interactively, it is given by the prefix argument."
        (interactive "p")
        (set-frame-height frame (- (frame-height frame) increment)))

      ;;;###autoload
      (defun shrink-frame-horizontally (&optional increment frame) ; Suggested binding: `C-M-left'.
        "Decrease the width of FRAME (default: selected-frame) by INCREMENT.
      INCREMENT is in columns (characters).
      Interactively, it is given by the prefix argument."
        (interactive "p")
        (set-frame-width frame (- (frame-width frame) increment)))


            (setq major-mode-remap-alist
              '((c-mode . c-ts-mode)
                (c++-mode . c++-ts-mode)
                (python-mode . python-ts-mode)
                (markdown-mode . markdown-ts-mode)
                (nix-mode . nix-ts-mode)))

          ;; Global indentation defaults
          (setq-default
            indent-tabs-mode nil
            tab-width 2
            standard-indent 2)

            (add-hook 'before-save-hook #'delete-trailing-whitespace)

            (setq c-ts-mode-indent-offset 2
              c++-ts-mode-indent-offset 2)

           (with-eval-after-load 'cc-mode
             (setq c-default-style "google"
               c-basic-offset 2))

            (require 'multiple-cursors)

            (when (fboundp 'mc/edit-lines)
            ;; Suggested bindings
            (global-set-key (kbd "C-M-<left>") #'shrink-frame-horizontally)
            (global-set-key (kbd "C-S-c C-S-c") #'mc/edit-lines)
            (global-set-key (kbd "C->")         #'mc/mark-next-like-this)
            (global-set-key (kbd "C-<")         #'mc/mark-previous-like-this)
            (global-set-key (kbd "C-c C-<")     #'mc/mark-all-like-this))

            (require 'setup-scheme)
            (require 'setup-futhark)
            (require 'setup-c-cpp)
            (require 'setup-python)
            (require 'setup-nix)
            (require 'setup-latex)
            (require 'setup-common-lisp)
            (require 'setup-markdown)
    '';

    ".emacs.d/languages/setup-nix.el".text = ''
            (require 'eglot)
            (add-hook 'nix-ts-mode-hook #'eglot-ensure)

            (add-hook 'nix-ts-mode-hook
                       (lambda ()
      		   (add-hook 'before-save-hook
      		         #'eglot-format-buffer
      			 nil t)))
            (provide 'setup-nix)
    '';

    ".emacs.d/languages/setup-scheme.el".text = ''
      (require 'geiser)
      (require 'geiser-chibi)

      (setq geiser-default-implementation 'chibi)

      (add-hook 'scheme-mode-hook #'geiser-mode)
      (setq lisp-indent-offset 2)
      (provide 'setup-scheme)
    '';

    ".emacs.d/languages/setup-futhark.el".text = ''
      (require 'futhark-mode)

      (defun my-futhark-style ()
        "Custom settings for Futhark buffers."
        (setq-local futhark-indent-level 2)
        (setq-local tab-width 2)
        (setq-local indent-tabs-mode nil))

      (add-hook 'futhark-mode-hook #'my-futhark-style)

      ;; Optional: Uncomment to start Eglot automatically
      ;; (add-hook 'futhark-mode-hook #'eglot-ensure)

      (add-to-list 'auto-mode-alist '("\\.fut\\'" . futhark-mode))
      (add-hook 'futhark-mode-hook 'futhark-fmt-on-save-mode)
      (provide 'setup-futhark)
    '';

    ".emacs.d/languages/setup-c-cpp.el".text = ''

      (require 'eglot)
      (require 'cc-mode)

      ;; Google style for classic cc-mode
      (setq c-default-style "google"
        c-basic-offset 2)

      ;; Tree-sitter indentation
      (when (fboundp 'c-ts-mode)
      (setq c-ts-mode-indent-offset 2
          c++-ts-mode-indent-offset 2))

      (provide 'setup-c-cpp)
    '';

    ".emacs.d/languages/setup-python.el".text = ''
      (require 'python)
      (require 'eglot)

      (setq python-indent-offset 4)
      (provide 'setup-python)
    '';

    ".emacs.d/languages/setup-latex.el".text = ''
        (require 'tex-site)

        (setq TeX-auto-save t
              TeX-parse-self t
              TeX-save-query nil)

      (add-hook 'LaTeX-mode-hook #'visual-line-mode)
      (add-hook 'LaTeX-mode-hook #'flyspell-mode)
      (provide 'setup-latex)
    '';

    ".emacs.d/languages/setup-common-lisp.el".text = ''
      (require 'sly)

      (setq lisp-indent-offset 2)
      (setq inferior-lisp-program "sbcl")

      (add-hook 'lisp-mode-hook #'sly-mode)
      (provide 'setup-common-lisp)
    '';

    ".emacs.d/languages/setup-markdown.el".text = ''
      (require 'markdown-mode)
      (setq markdown-list-indent-width 2)
      (add-hook 'markdown-mode-hook #'visual-line-mode)
      (provide 'setup-markdown)
    '';
  };

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
