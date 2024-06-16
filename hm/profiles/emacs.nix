{
  config,
  lib,
  pkgs,
  ...
}:
let
  myEmacsConfig = pkgs.writeText "default.el" ''
    (eval-when-compile
      (require 'use-package))

    ;; load some packages

    (use-package company
      :bind ("<C-tab>" . company-complete)
      :diminish company-mode
      :commands (company-mode global-company-mode)
      :defer 1
      :config
      (global-company-mode))

    (use-package counsel
      :commands (counsel-descbinds)
      :bind (([remap execute-extended-command] . counsel-M-x)
             ("C-x C-f" . counsel-find-file)
             ("C-c g" . counsel-git)
             ("C-c j" . counsel-git-grep)
             ("C-c k" . counsel-ag)
             ("C-x l" . counsel-locate)
             ("M-y" . counsel-yank-pop)))

    (use-package flycheck
      :defer 2
      :config (global-flycheck-mode))

    (use-package ivy
      :defer 1
      :bind (("C-c C-r" . ivy-resume)
             ("C-x C-b" . ivy-switch-buffer)
             :map ivy-minibuffer-map
             ("C-j" . ivy-call))
      :diminish ivy-mode
      :commands ivy-mode
      :config
      (ivy-mode 1))

    (use-package magit
      :defer
      :if (executable-find "git")
      :bind (("C-x g" . magit-status)
             ("C-x G" . magit-dispatch-popup))
      :init
      (setq magit-completing-read-function 'ivy-completing-read))

    (use-package projectile
      :commands projectile-mode
      :bind-keymap ("C-c p" . projectile-command-map)
      :defer 5
      :config
      (projectile-global-mode))
  '';

  myEmacs = pkgs.emacs.pkgs.withPackages (
    epkgs:
    (with epkgs.melpaStablePackages; [
      # (pkgs.runCommand "default.el" {} ''
      #    mkdir -p $out/share/emacs/site-lisp
      #    cp ${myEmacsConfig} $out/share/emacs/site-lisp/default.el
      #  '')
      # company
      # counsel
      # flycheck
      # ivy
      # magit
      # projectile
      use-package
    ])
  );
in

{

  home.packages = [ myEmacs ];
  # programs.emacs = {
  #   enable = true;
  # };

}
