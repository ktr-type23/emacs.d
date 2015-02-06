;; おまじない
(require 'cl)
;; Emacsからの質問をy/nで回答する
;; (fset 'yes-or-no-p 'y-or-n-p)
;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)

;;; load-pathの追加
(defun add-to-load-path (&rest paths)
  (let (path)
     (dolist (path paths paths)
       (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
         (add-to-list 'load-path default-directory)
         (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
             (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathに追加するフォルダ
;; 2つ以上指定する場合は -> (add-top-load-path "elisp" "xxx" "yyy")
(add-to-load-path "elisp" "elpa" "conf" "public_repos")

;;; auto-installの設定
;; (install-elisp-from-emacswiki "auto-install.el")
(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する 初期値は"~/.emacs.d/auto-install/"
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelispの名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;;(setq url-proxy-servies '(("http" . "localhost:8339")))
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))

(when (require 'package nil t)
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

;;; デフォルトインストールさているカラーテーマ
;; 一覧は以下
;; adwaita
;; deeper-blue
;; dichromacy
;; light-blue
;; manoj-dark
;; misterioso
;; tango
;; tango-dark
;; tsdh-dark
;; tsdh-light
;; wheatgrass
;; whiteboard
;; wombat
(load-theme 'misterioso t)

;;; スタートアップ非表示
(setq inhibit-startup-screen t)

;;; disabled tool bar
(tool-bar-mode 0)

;;; ファイルのフルパスをタイトルバーに表示
(setq frame-title-format
      (format "Emacs - %%f"))

;;; backupファイルとauto-saveファイルを"~/.emacs.d/backups/"へ集める
(add-to-list 'backup-directory-alist
    (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
    `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; backupファイルとauto-saveファイルをシステムのTempディレクトリに作成する場合
;;; backupファイルの作成場所をシステムのTempディレクトリに変更する
;(setq backup-directory-alist
;	  `((".*" . ,temporary-file-directory)))
;;; auto-saveファイルの作成場所をシステムのTempディレクトリに変更する
;(setq auto-save-file-name-transforms
;	  `((".*" ,temporary-file-directory t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; バックアップを有効にする場合は以下のコメントを復活
;;;; バックアップを残さない
;(setq make-bakup-files nil)
;;;; 終了時にオートセーブファイルを消す
;(setq delete-auto-save-files t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TAB の表示幅。
(setq-default tab-width 4)

;;; 左側行番号表示
;; (global-linum-mode t)
;;; スクロールで改行を入れない
(setq next-line-add-newlines nil)
;;; 行番号・カラム番号を表示
;(line-number-mode t)   ; 行番号はデフォルト表示なのでコメント
(column-number-mode t)

;;; ファイルサイズを表示
(size-indication-mode t)
;;; 時計を表示
;; 曜日・月・日を表示
(setq display-time-day-and-date t)
;; 24時表示
(setq display-time24hr-mode t)
(display-time-mode t)
;;; バッテリ残量を表示
;; ノートPC等でない場合はエラーになる
;; (display-battery-mode t)

;; 改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; ;;; 括弧の範囲内を強調表示
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#000")

;; ;;; 選択領域の色
(set-face-background 'region "#555")

;; カーソル行に下線を表示
(setq hl-line-face 'underline)
(global-hl-line-mode)

;;; カーソル行のハイライト
(defface my-hl-line-face
  '((((class color) (background dark))
    (:background "NavyBlue" t))
   (((class color) (background light))
    (:background "LightGoldenrodYellow" t))
   (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;;; font
;; rictyの場合、横幅が1:2になるのは主に以下のサイズ
(set-frame-font "ricty-13.5")
;; (set-frame-font "ricty-15")
;; (set-frame-font "ricty-18")
(set-fontset-font
    nil 'japanese-jisx0208
        (font-spec :family "Ricty"))

;;; 最近使ったファイルをメニューに表示
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(setq recentf-max-saved-items 100)

;; cua-mode
;; 矩形選択便利ツール
(cua-mode t)
(setq cua-enable-cua-keys nil) ; デフォルトキーバインドを無効化
(define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)

;; wdired.el
;; ディレクトリ内のファイル名をdiredバッファより直接実施する
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; M-x diff
;; diff を とるときに -u オプションをデフォルトにする
;; diff 箇所で C-c C-c で
(setq diff-switches "-u")

;; M-x ediff-files
;; 2つのファイルの相違点を取り込む(merge)・ハイライト表示する。
;; Ediff Control Panel 専用フレームを作成しない。
(setq ediff-window-setup-function 'ediff-setup-window-plain)



;; multi-shell.el
;; 複数のshellバッファを持ち切り替えられるようにする
;; M-x install-elisp-from-emacswiki multi-shell.el
;; ■使い方
;; M-x multi-shell-new：新しいshellを立ち上げる
;; M-x multi-shell-prev:前のshellバッファに切り替える
;; M-x multi-shell-next:次のshellバッファに切り替える
(require 'multi-shell)
;; 指定しない場合は環境変数SHELLのshellが使われる
;; (setq multi-shell-command "/bin/zsh")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; キーバインド

(define-key global-map (kbd "C-h") 'delete-backward-char) ; 削除
(define-key global-map (kbd "M-?") 'help-for-help)        ; ヘルプ
(define-key global-map (kbd "C-z") 'undo)                 ; undo
(define-key global-map (kbd "C-c C-i") 'hippie-expand)    ; 補完
(define-key global-map (kbd "C-c ;") 'comment-dwim)       ; コメントアウト
(define-key global-map (kbd "C-o") 'toggle-input-method)  ; 日本語入力切替
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(define-key global-map (kbd "C-S-k") (kbd "C-u 0 C-k"))   ; カーソルから行頭まで削除
(define-key global-map (kbd "C-t") 'other-window)         ; ウィンドウを切り替える(初期値はtranspose-chars)

;;; キーバインドここまで
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-installしたリストとその設定

;; redo
;; http://www.emacswiki.org/emacs/download/redo+.el
(when (require 'redo+ nil t)
  ;; redoに"C-."を割り当てる
  (global-set-key (kbd "C-.") `redo)
)

;; package.el
;;(auto-install-from-url "http://repo.or.cz/w/emacs.git/blob_plain/HEAD:/lisp/emacs-lisp/package.el")
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives
			   '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))

;; scala-mode
;; list-packageからインストール
(require 'scala-mode-auto)
(require 'scala-mode-feature-electric)
(add-hook 'scala-mode-hook
		  (lambda ()
			(scala-electric-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;; elpaを使ってインストール
;; auto-installを使う場合は以下のコマンド
;; M-x package-install RET -> auto-complete RET
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
			   "~/.emacs.d/elpa/auto-complete-1.4/dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (setq ac-use-menu-map t)
  (define-key ac-menu-map "\C-n" 'ac-next)
  (define-key ac-menu-map "\C-p" 'ac-previous)
  (ac-config-default))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; exec-path-from-shell-initialize
;; package-list-pacageでイントール
(exec-path-from-shell-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; anything
;; インストールコマンド
;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; ▼要拡張機能インストール▼
;;; P127-128 過去の履歴からペースト──anything-show-kill-ring
;; M-yにanything-show-kill-ringを割り当てる
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)
;; ▼要拡張機能インストール▼
;;; P128-129 moccurを利用する──anything-c-moccur
;;; インストールコマンド
;;; M-x auto-install-from-emacswiki RET color-moccur.el RET
(when (require 'anything-c-moccur nil t)
  (setq
   ;; anything-c-moccur用 `anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; バッファの情報をハイライトする
   anything-c-moccur-higligt-info-line-flag t
   ;; 現在選択中の候補の位置をほかのwindowに表示する
   anything-c-moccur-enable-auto-look-flag t
   ;; 起動時にポイントの位置の単語を初期パターンにする
   anything-c-moccur-enable-initial-pattern t)
  ;; C-M-oにanything-c-moccur-occur-by-moccurを割り当てる
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.4 検索と置換の拡張                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P132 検索結果をリストアップする──color-moccur
;; M-x auto-install-from-emacswiki RET color-moccur.el RET
;; color-moccurの設定
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; ▼要拡張機能インストール▼
;;; P133-134 moccurの結果を直接編集──moccur-edit
;; moccur-editの設定
;; M-x auto-install-from-emacswiki RET moccur-edit.el RET
(require 'moccur-edit nil t)
;; moccur-edit-finish-editと同時にファイルを保存する
;; (defadvice moccur-edit-change-file
;;   (after save-after-moccur-edit-buffer activate)
;;   (save-buffer))

;; ▼要拡張機能インストール▼
;;; P136 grepの結果を直接編集──wgrep
;; M-x package-install RET wgrep RET
;; wgrepの設定
(require 'wgrep nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.5 さまざまな履歴管理                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P137-138 編集履歴を記憶する──undohist
;; M-x install-elisp RET http://cx4a.org/pub/undohist.el
;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;; ▼要拡張機能インストール▼
;;; P138 アンドゥの分岐履歴──undo-tree
;; M-x package-install RET undo-tree RET
;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;; ▼要拡張機能インストール▼
;;; P139-140 カーソルの移動履歴──point-undo
;; M-x auto-install-from-emacswiki RET point-undo.el RET
;; point-undoの設定
(when (require 'point-undo nil t)
  ;; (define-key global-map [f5] 'point-undo)
  ;; (define-key global-map [f6] 'point-redo)
  (define-key global-map (kbd "<f9>") 'point-undo)
  (define-key global-map (kbd "s-<f9>") 'point-redo)
  )

;; goto-chg.el
;; M-x install-elisp-from-emacswiki RET goto-chg.el RET
(require 'goto-chg)
(define-key global-map (kbd "<f8>") 'goto-last-change)
(define-key global-map (kbd "s-<f8>") 'goto-last-change)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 自動コンパイル
;; バイトフィアルのコンパイルを実施を忘れた場合は
;; 古いファイルがロードされてしまう。
(require 'auto-async-byte-compile)
;; 自動コンパイルを無効にするファイル名の正規表現
;; (setq auto-async-byte-compile-exclude-files-regexp "")
;; (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 使わないバッファを自動的に消す
;; (install-elisp-from-emacswiki "tempbuf.el") 
(require 'tempbuf)
;; ファイルを開いたら自動的にtempbufを有効にする
(add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
;; diredバッファに対してtempbufを有効にする
(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; オマケ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; カーソル位置のファイルパスやアドレスを "C-x C-f" で開く
(ffap-bindings)


;;; 筆者のキーバインド設定
;; Mac の Command + f と C-x b で anything-for-files
(define-key global-map (kbd "s-f") 'anything-for-files)
(define-key global-map (kbd "C-x b") 'anything-for-files)
;; M-k でカレントバッファを閉じる
(define-key global-map (kbd "M-k") 'kill-this-buffer)
;; Mac の command + 3 でウィンドウを左右に分割
(define-key global-map (kbd "s-3") 'split-window-horizontally)
;; Mac の Command + 2 でウィンドウを上下に分割
(define-key global-map (kbd "s-2") 'split-window-vertically)
;; Mac の Command + 1 で現在のウィンドウ以外を閉じる
(define-key global-map (kbd "s-1") 'delete-other-windows)
;; Mac の Command + 0 で現在のウィンドウを閉じる
(define-key global-map (kbd "s-0") 'delete-window)
;; バッファを全体をインデント
(defun indent-whole-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))
;; C-<f8> でバッファ全体をインデント
(define-key global-map (kbd "C-<f8>") 'indent-whole-buffer)


;;; 改行やタブを可視化する whitespace-mode
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□]) ; zenkaku space
        (newline-mark 10 [8629 10]) ; newlne
        (tab-mark 9 [187 9] [92 9]) ; tab » 187
        )
      whitespace-style
      '(spaces
        ;; tabs
        trailing
        newline
        space-mark
        tab-mark
        newline-mark))
;; whitespace-modeで全角スペース文字を可視化　
(setq whitespace-space-regexp "\\(\x3000+\\)")
;; whitespace-mode をオン
(global-whitespace-mode t)
;; F5 で whitespace-mode をトグル
(define-key global-map (kbd "<f5>") 'global-whitespace-mode)


;;; Mac でファイルを開いたときに、新たなフレームを作らない
(setq ns-pop-up-frames nil)


;;; 最近閉じたバッファを復元
;; http://d.hatena.ne.jp/kitokitoki/20100608/p2
(defvar my-killed-file-name-list nil)

(defun my-push-killed-file-name-list ()
  (when (buffer-file-name)
    (push (expand-file-name (buffer-file-name)) my-killed-file-name-list)))

(defun my-pop-killed-file-name-list ()
  (interactive)
  (unless (null my-killed-file-name-list)
    (find-file (pop my-killed-file-name-list))))
;; kill-buffer-hook (バッファを消去するときのフック) に関数を追加
(add-hook 'kill-buffer-hook 'my-push-killed-file-name-list)
;; Mac の Command + z で閉じたバッファを復元する
(define-key global-map (kbd "s-z") 'my-pop-killed-file-name-list)

