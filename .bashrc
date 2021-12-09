#
# ~/.bashrc
#

# 対話環境でなければ何もしない。
[[ $- != *i* ]] && return

# bash options
#shopt -s autocd

# Tangoカラーパレット (http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines)
# 16進数でのRGB値を入れているので、使うときは例えば '#' を前置する。
export TANGO_WHITE=eeeeec        # alminium 1 (white)
export TANGO_LIGHTER_GRAY=d3d7cf # alminium 2 (lighter gray)
export TANGO_LIGHT_GRAY=babdb6   # alminium 3 (light gray)
export TANGO_DARK_GRAY=888a85    # alminium 4 (dark gray)
export TANGO_DARKER_GRAY=555753  # alminium 5 (darker gray
export TANGO_BLACK=2e3436        # alminium 6 (black)
export TANGO_LIGHT_YELLOW=fce94f # butter 1 (light yellow)
export TANGO_YELLOW=edd400       # butter 2 (yellow)
export TANGO_DARK_YELLOW=c4a000  # butter 3 (dark yellow)
export TANGO_LIGHT_GREEN=8ae234  # chameleon 1 (light green)
export TANGO_GRENN=73d216        # chameleon 2 (green)
export TANGO_DARK_GREEN=4e9a06   # chameleon 3 (dark green)
export TANGO_LIGHT_BROWN=e9b96e  # chocolate 1 基本16色にはない
export TANGO_BROWN=c17d11        # chocolate 2 基本16色にはない
export TANGO_DARK_BROWN=8f5902   # chocolate 3 基本16色にはない
export TANGO_LIGHT_ORANGE=fcaf3e # orange 1 基本16色にはない
export TANGO_ORANGE=f57900       # orange 2 基本16色にはない
export TANGO_DARK_ORANGE=ce5c00  # orange 3 基本16色にはない
export TANGO_LIGHT_MAGENTA=ad7fa8 # plum 1 (light magenta)
export TANGO_MAGENTA=75507b       # plum 2 (magenta)
export TANGO_DARK_MAGENTA=5c3566  # plum 3 (dark magenta)
export TANGO_LIGHT_RED=ef2929    # scarlet red 1 (light red)
export TANGO_RED=cc0000          # scarlet red 2 (red)
export TANGO_DARK_RED=a40000     # scarlet red 3 (dark red)
export TANGO_LIGHT_BLUE=729fcf   # sky blue 1 (light blue)
export TANGO_BLUE=3465a4         # sky blue 2 (blue)
export TANGO_DARK_BLUE=204a87    # sky blue 3 (dark blue)
export TANGO_LIGHT_CYAN=34e2e2   # TAMGOにはない (light cyan)
export TANGO_CYAN=06989a         # TANGOにはない (cyan)

# 現在の端末の16色を確認するには、以下を実行する。
# for c in {0..15}; do tput setab $c; echo -en "  $c  "; done; tput sgr0; echo ""
# 端末の16色を、ANSIエスケープシーケンスで設定する。
# $(echo -en "/e]PnRRGGBB") で、0-f の番号の色を設定する。
set_termcolor() { echo -en "\e]P"$1$2; }
case "$TERM" in
    xterm-color|*-256color|linux|fbterm)
        color_prompt=yes
        set_termcolor 0 $TANGO_DARKER_GRAY
        set_termcolor 1 $TANGO_LIGHT_RED
        set_termcolor 2 $TANGO_LIGHT_GREEN
        set_termcolor 3 $TANGO_LIGHT_YELLOE
        set_termcolor 4 $TANGO_LIGHT_BLUE
        set_termcolor 5 $TANGO_LIGHT_MAGENTA
        set_termcolor 6 $TANGO_LIGHT_CYAN
        set_termcolor 7 $TANGO_LIGHTER_GRAY
        set_termcolor 8 $TANGO_BLACK
        set_termcolor 9 $TANGO_RED
        set_termcolor 10 $TANGO_GREEN
        set_termcolor 11 $TANGO_YELLOW
        set_termcolor 12 $TANGO_BLUE
        set_termcolor 13 $TANGO_MAGENTA
        set_termcolor 14 $TANGO_CYAN
        set_termcolor 15 $TANGO_WHITE
        ;;
esac

# bashプロンプトに色をつける。 (ディレクトリが深くなってもいいように2行プロンプト。)
TPUT_GREEN="$(tput setaf 2; tput bold)"
TPUT_BLUE="$(tput setaf 4; tput bold)"
TPUT_RESET="$(tput sgr0)"
PS1='${TPUT_GREEN}\u@\h${TPUT_BLUE}:\w${TPUT_RESET}\n$ '

# エイリアスと補完をきくように。
[[ -r ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -r ~/.bash_completions ]] && source ~/.bash_completions

# ssh用の秘密鍵のパスワード入力の自動化。
( ! pgrep -u $USER ssh-agent > /dev/null ) && ssh-agent > ~/.ssh-agent-thing
[[ "$SSH_AGENT_PID" == "" ]] && eval $(<~/.ssh-agent-thing)
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
