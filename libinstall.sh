#!/bin/bash
# -*- shell-script -*-

#
# libinstall.sh -- インストールスクリプト用 bash ライブラリ
#

#set -x    # デバッグ時には -x オプションをつける
#set -e    # source して使うときは、-e をつけない

[[ -z $_PROGNAME ]] && _PROGNAME="install"
[[ -z $SRC_DIR   ]] && SRC_DIR=$(pwd)
[[ -z $_FORCE    ]] && _FORCE="false"
[[ -z $_VERBOSE  ]] && _VERBOSE="true"

_C_GRE=$(tput setaf 2)               # green
_C_YEL=$(tput setaf 3)               # yellow
_C_RED=$(tput setaf 1)               # red
_C_GRB=$(tput setaf 2; tput bold)    # bold green
_C_YEB=$(tput setaf 3; tput bold)    # bold yellow
_C_REB=$(tput setaf 1; tput bold)    # bold red
_C_RES=$(tput sgr0)                  # reset

if [ "$_VERBOSE" = "true" ]; then
    function _info(){    echo "$_C_GRE[$_PROGNAME] $@$_C_RES"; }
    function _warn(){    echo "$_C_YEL[$_PROGNAME] $@$_C_RES"; }
    function _error(){   echo "$_C_RED[$_PROGNAME] $@$_C_RES"; }
    function _message(){ echo "$_C_GRB[$_PROGNAME] $@$_C_RES"; }
    function _prompt(){  read -p "$_C_GRB$1$_C_RES" $2; }
else
    function _info(){    :; }
    function _warn(){    :; }
    function _error(){   :; }
    function _message(){ :; }
    function _prompt(){  :; }
fi

function _do_install(){
    pkgs="$@"
    [[ -z $pkgs ]] && return
    _info "$pkgs をインストールします..."
    brew install $pkgs
    _info "$(brew list --formula --versions $pkgs) をインストールしました"
}

function _do_install_cask(){
    pkgs="$@"
    [[ -z $pkgs ]] && return
    _info "$pkgs をインストールします..."
    brew install --cask $pkgs
    _info "$(brew list --cask --versions $pkgs) をインストールしました"
}

function _install(){
    pkgs="$@"
    if [ "$_VERBOSE" = "true" ]; then
        _message "$pkgs のインストール"
        _prompt "    続行しますか? (全て:[a]ll / 個別:[e]ach / 中止:[q]uit / スキップ: [s]kip) " ans
        case "$ans" in
            [Aa]|[Aa]ll)
                for pkg in $pkgs; do
                    if [ ! -d "/usr/local/Cellar/$pkg" ]; then
                        _do_install $pkg
                    else
                        _info "$(brew list --formula --versions $pkg) はインストール済みです"
                    fi
                done
                ;;
            [Ee]|[Ee]ach)
                for pkg in $pkgs; do
                    if [ ! -d "/usr/local/Cellar/$pkg" ]; then
                        _info "$pkg のインストール"
                        _prompt "    続行しますか? (はい:[y]es / いいえ:[n]o / 中止: [q]uit) " anser
                        case "$anser" in
                            [Yy]|[Yy]es)  _do_install $pkg ;;
                            [Nn]|[Nn]o)   continue ;;
                            [Qq]|[Qq]uit) exit 0 ;;
                            *)            exit 0 ;;
                        esac
                    else
                        _info "$(brew list --formula --versions $pkg) はインストール済みです"
                    fi
                done
                ;;
            [Qq]|[Qq]uit) exit 0 ;;
            [Ss]|[Ss]kip) continue 0 ;;
            *)            exit 0 ;;
        esac
    else
        for pkg in $pkgs; do
            if [ ! -d "/usr/local/Cellar/$pkg" ]; then
                _do_install $pkg
            else
                _info "$(brew list --formula --versions $pkg) はインストール済みです"
            fi
        done
    fi
}

function _install_cask(){
    pkgs="$@"
    if [ "$_VERBOSE" = "true" ]; then
        _message "$pkgs のインストール"
        _prompt "    続行しますか? (全て:[a]ll / 個別:[e]ach / 中止:[q]uit / スキップ:[s]kip) " ans
        case "$ans" in
            [Aa]|[Aa]ll)
                for pkg in $pkgs; do
                    if [ ! -d "/usr/local/Caskroom/$pkg" ]; then
                        _do_install_cask $pkg
                    else
                        _info "$(brew list --cask --versions $pkg) はインストール済みです"
                    fi
                done
                ;;
            [Ee]|[Ee]ach)
                for pkg in $pkgs; do
                    if [ ! -d "/usr/local/Caskroom/$pkg" ]; then
                        _info "$pkg のインストール"
                        _prompt "    続行しますか? (はい:[y]es / いいえ:[n]o / 中止: [q]uit) " anser
                        case "$anser" in
                            [Yy]|[Yy]es)  _do_install_cask $pkg ;;
                            [Nn]|[Nn]o)   continue ;;
                            [Qq]|[Qq]uit) exit 0 ;;
                            *)            exit 0 ;;
                        esac
                    else
                        _info "$(brew list --cask --versions $pkg) はインストール済みです"
                    fi
                done
                ;;
            [Qq]|[Qq]uit) exit 0 ;;
            *)            exit 0 ;;
        esac
    else
        for pkg in $pkgs; do
            if [ ! -d "/usr/local/Caskroom/$pkg" ]; then
                _do_install_cask $pkg
            else
                _info "$(brew list --cask --versions $pkg) はインストール済みです"
            fi
        done
    fi
}

function _deploy(){
    ln -sf $1 $2
    _info "$2 は $1 を参照しています。"
}

# brew
function install_homebrew(){
    pkgs="Homebrew"
    if [ ! -x "/usr/local/bin/brew" -o "$_FORCE" = "true" ]; then
        if [ "$_VERBOSE" = "true" ]; then
            _info "$pkgs のインストール"
            _prompt "    続行しますか? (はい:[y]es / いいえ:[n]o) " ans
            case "$ans" in
                [Yy]|[Yy]es) ;;
                [Nn]|[Nn]o)  exit 0 ;;
                *)           exit 0 ;;
            esac
        fi
        _info "$pkgs をインストールします..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew update
        _info "$(brew --version | head -1) をインストールしました"
    else
        _info "$(brew --version | head -1) はインストール済みです"
    fi
}

# bash
function install_bash(){
    pkgs="bash bash-completion grc mg"
    pkgs="$pkgs coreutils grep diffutils gnu-sed gawk grep make"
    pkgs="$pkgs tree htop neofetch"
    pkgs="$pkgs iproute2mac"
    _install $pkgs
    _warn "新しい bash をログインシェルにするには..."
    _warn "    以下を実行してください"
    _warn "    echo \"/usr/local/bin/bash\" | sudo tee /etc/shells"
    _warn "    passwd -s /usr/local/bin/bash"
    _warn "man で終了時に表示をクリアしないようにするには..."
    _warn "    以下を実行してください"
    _warn "    sudo mv /etc/man.conf /etc/man.conf.orig"
    _warn "    sed -e \"/^PAGER/s/\(less -is\)$/\1rX/\" -e \"/^BROWSER/s/\(less -is\$)/\1rX/\" /etc/man.conf.orig | sudo tee /etc/man.conf"
}
function deploy_bash(){
    dotfiles=".bash_profile .bashrc .bash_aliases .bash_completions"
    for f in $dotfiles; do
        _deploy $SRC_DIR/$f $HOME/$f
    done
}

# git
function install_git(){
    pkgs="git gh"
    _install $pkgs
    _warn "git の環境を設定するには..."
    _warn "    以下を実行してください"
    _warn "    git config --global user.name YOUR_NAME"
    _warn "    git config --global user.email MAIL@example.com"
    _warn "    git config --global core.editor YOUR_EDITOR"
    _warn "gh で github にログインするには..."
    _warn "    \`gh auth login\` を実行してください"
}

# tmux
function install_tmux(){
    pkgs="tmux ncurses"
    _install $pkgs
    ver=$(brew list --versions ncurses | awk '{ print $2 }')
    mkdir -p $HOME/.terminfo/74
    target=$HOME/.terminfo/74/tmux-256color
    if [ ! -f "$target" ]; then
        # github tmux/tmux issue #1257 / github gist bbqtd/macos-tmux-256color.md から
        brew_infocmp=/usr/local/opt/ncurses/bin/infocmp
        mac_tic=/usr/bin/tic
        $brew_infocmp tmux-256color > $HOME/tmux-256color.info
        $mac_tic -xe tmux-256color $HOME/tmux-256color.info
        rm $HOME/tmux-256color.info
        _info "tmux 用の terminfo を \"\$HOME/.terminfo/74/tmux-256color\" に置きました"
        _info "使っているターミナルに合わせて、ファイルの置き場所が変わることがあります"
    fi
}
function deploy_tmux(){
    dotfiles=".tmux.conf"
    for f in $dotfiles; do
        _deploy $SRC_DIR/$f $HOME/$f
    done
}

# openssh
function install_openssh(){
    pkgs="openssh"
    _install $pkgs
    _warn "ssh 用の鍵ペアを作るには..."
    _warn "    \`ssh-keygen -C \"$USER@$(hostname) \$(date \"+%Y-%m-%d\")\"\` を実行してください"
    _warn "リモートホストに公開鍵を送るには..."
    _warn "    \`ssh-copy-id USER@REMOTEHOST\` を実行してください"
}

#
# ここから以降は、caskのセクション
#

# emacs
function install_emacs(){
    cpkgs="emacs-mac"
    tap=railwaycat/emacsmacport
    ! brew tap | grep "$tap" > /dev/null 2>&1 && brew tap $tap
    _install_cask $cpkgs
    mkdir -p $HOME/.emacs.d
    _info "emacs は、\"Emacs Mac Port\" を選択しています"
}
function deploy_emacs(){
    dotfiles=".emacs.d/init.el"
    mkdir -p $HOME/.emacs.d
    for f in $dotfiles; do
        _deploy $SRC_DIR/$f $HOME/$f
    done
}

# kitty
function install_kitty(){
    cpkgs="kitty"
    _install_cask $cpkgs
    mkdir -p .config/kitty
    curl -o $HOME/.config/kitty/kitty.conf.orig https://sw.kovidgoyal.net/kitty/_downloads/433dadebd0bf504f8b008985378086ce/kitty.conf
    _info "kitty の設定ファイルのオリジナルを \".config/kitty/kitty.conf.orig\" に置きました"
}
function deploy_kitty(){
    dotfiles=".config/kitty/kitty.conf"
    for f in $dotfiles; do
        _deploy $SRC_DIR/$f $HOME/$f
    done
}

# fonts
function install_fonts(){
    pkgs="fontconfig"
    cpkgs="font-noto-sans-cjk-jp font-noto-serif-cjk-jp font-mplus"
    _install $pkgs
    tap=homebrew/cask-fonts
    ! brew tap | grep "$tap" > /dev/null 2>&1 && brew tap $tap
    _install_cask $cpkgs
    fc-cache -fv > /dev/null 2>&1
    _info "フォントキャッシュを更新しました。"
}

# formulaのインストール用関数の雛形
function _install_pkgs(){
    pkgs=""
    _install $pkgs
}

# caskのインストール用関数の雛形
function _install_cask_pkgs(){
    pkgs=""
    _install $pkgs
}

# パッケージ用の dotfile をリンクする関数の雛形
function _deploy_pkgs(){
    dotfiles=""
    for f in $dotfiles; do
        _deploy $SRC_DIR/$f $HOME/$f
    done
}
