#!/usr/local/bin/bash - .bash_aliases
# -*- shell-script -*-

# emacsclientのオプション
# -a "", --alternate-editor="" : もしemacs-daemonがいなかったら起動
# -n, --no-wait                : サーバを待ち合わせない
# -c, --create-frame           : 新しいGUIフレームを生成
# -nw, -t, --tty               : 新しいTerminalフレームを生成
# macOSでは以下のaliasは動かないので単にEmacs.appを起動する
#alias emc='emacsclient --alternate-editor "" --no-wait --create-frame "$@"'
alias emc='open -a /Applications/Emacs.app'
alias emt='emacsclient --alternate-editor "" --tty "$@"'
alias emkill='emacsclient -e "(save-buffers-kill-emacs)"'
export EDITOR=emt
export VISUAL=emt

# in macOS,
#   `diff` is in brew's diffutils
#   there is not `grep` in brew's PATH, if brew grep
#   no `ip` in macOS
#   `dmesg` has no color option
#   ls is in brew's coreutils as gls

# famous colorize
#alias diff='diff --color=auto'
alias grep='ggrep --color=auto'
# alias ip='ip --color=auto'
# alias dmesg='dmesg --color=auto'
alias ls='gls --color=auto'

# Homebrewは混乱する可能性のあるGNUユーティリティについては、頭に "g" をつけている。
alias make='gmake'
#alias less='less -X'    # -X means not to clear screen when exited.
export LESS='--no-init --LONG-PROMPT --shift 8 --quit-if-one-screen --RAW-CONTROL-CHARS'

# less extensioins...
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

GRC_ALIASES=true
[[ -r /usr/local/etc/grc.sh ]] && . /usr/local/etc/grc.sh

alias uman="MANPATH=$HOME/Dropbox/share/man: man"
