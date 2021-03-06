;; magit
(add-hook! 'magit-mode-hook 'magit-todos-mode)


;; company
(add-hook 'text-mode-hook 'global-company-mode)

(setq company-idle-delay 0.2
      company-minimum-prefix-length 2)


;; flycheck
(setq-default flycheck-disabled-checkers
              '(python-flake8
                python-pycompile))


;; lsp
(setq lsp-dart-sdk-dir (getenv "DARTPATH"))

(use-package! lsp-mode
  :commands lsp
  :ensure t
  :diminish lsp-mode
  :hook
  (elixir-mode . 'lsp)
  :init
  (add-to-list
   'exec-path
   (concat (getenv "HOME") "/dev/elixir/elixir-ls/release")))

(setq lsp-gopls-codelens nil)

(add-hook! 'lsp-after-initialize-hook
  (run-hooks (intern (format "%s-lsp-hook" major-mode))))

(defun python-flycheck-setup ()
  "Setup Flycheck checkers for Python."
  (flycheck-add-next-checker 'lsp 'python-pylint 'python-mypy))

(add-hook 'python-mode-lsp-hook 'python-flycheck-setup)


;; snippets
(require 'yasnippet)
(doom-snippets-initialize)


;; prog
(add-hook 'prog-mode-hook 'smartparens-mode)


;; web-mode
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(after! web-mode
  (setq web-mode-enable-auto-pairing nil))

(sp-with-modes '(web-mode)
  (sp-local-pair "%" "%" :post-handlers '(("| " "SPC")))
  (sp-local-pair "=" "" :post-handlers '(("| " "SPC"))))

(sp-with-modes '(python-mode)
  (sp-local-pair "f\"" "\"" :post-handlers '(("| " "SPC")))
  (sp-local-pair "b\"" "\"" :post-handlers '(("| " "SPC"))))

(sp-local-pair 'web-mode "<" ">" :actions nil)

(add-hook 'web-mode-hook 'emmet-mode)


;; python
;; (setq pylint-options '("--rcfile=~/.config/pylint/pylintrc"))
(setq flycheck-pylintrc "~/.config/pylint/pylintrc")

(defun black-format ()
  "Format current file using Black formatter."
  (interactive)
  (print
   (shell-command-to-string
    (concat
     "black.sh "
     (store-substring
      (projectile-project-root)
      (- (length (projectile-project-root)) 1)
      " ")
     (buffer-file-name))))
  (revert-buffer))

(defun set-pylint-executable ()
  "Set pylint executable based on venv path."
  (setq venv-path (getenv "VIRTUAL_ENV"))
  (setq flycheck-python-pylint-executable
        (if venv-path
            (concat venv-path "/bin/pylint")
            "pylint")))

(add-hook 'python-mode-hook (λ! (electric-indent-local-mode -1)))
(add-hook 'python-mode-hook 'set-pylint-executable)


;; go
(add-to-list
   'exec-path
   (concat (getenv "HOME") "/go/bin"))

(defun gofmt ()
  "Format current file using golines and gofumpt formatters."
  (interactive)
  (shell-command-to-string
   (concat
    "golines -w -m 80 "
    (buffer-file-name)
    "&& gofumpt -w "
    (buffer-file-name)))
  (revert-buffer))

(defun gomodifytags ()
  "Add tags for all structs of the current buffer."
  (interactive)
  (shell-command-to-string
    (concat
      "gomodifytags -add-tags json -all -w -file "
      (buffer-file-name)))
  (revert-buffer))


;; js
(add-hook 'js2-mode-hook 'lsp)


;; protobuf
(add-hook 'protobuf-mode-hook 'display-line-numbers-mode)
(add-hook 'protobuf-mode-hook 'hl-line-mode)
