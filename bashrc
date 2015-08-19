# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Vim keybindings at command line
set -o vi

# Make .bash_history store more and not store duplicates
export HISTCONTROL=ignoreboth
export HISTSIZE=500000
export HISTFILESIZE=500000

# Terminal config
export TERM=xterm-256color
export LC_CTYPE="en_US.UTF-8"

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ==============================================================================
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$PATH:~/scripts
# ==============================================================================

# ==============================================================================
# helpful aliases and functions
alias grep='grep --color=auto'
alias irc="mosh -- jzimmerm@oyster.club.cc.cmu.edu screen -dr"

alias ed='ed -p "ed> "'

alias ghc='ghc -fwarn-incomplete-patterns'
alias ghci='ghci -fwarn-incomplete-patterns'

# Clean up tex files (useful to do when done with a document, to save space)
function cltex() {
  for line in $(find . -maxdepth 1 -name "*.tex" | sed -e "s/.tex//"); do
    if [ -e $line.aux ]; then
      rm -v $line.{aux,log,out}
      rm -iv $line.pdf
    fi
  done
}

# Create a directory and cd into it
function mkcd() {
    mkdir ${*:1} && cd ${@: -1}
}

# Get the length of the longest line of a file. Useful for making sure you're
# always under a limit for line length. On some systems, this is wc -L, but not
# all support that.
alias wcL="awk ' { if ( length > x ) { x = length } }END{ print x }'"

# Arrow keys are nice
alias python='rlwrap python'

# Rarely do I want to overwrite with these commands; confirmation is useful.
alias mv='mv -i'
alias cp='cp -i'
# ==============================================================================

# ==============================================================================
# Some things differ between Mac OS and Linux configurations.
if [[ `uname` = "Darwin" ]]
then
  # Stop OS X from using the GUI dialog box (which disallows pasting) for SSH
  # passphrases
  alias nosock="SSH_AUTH_SOCK=''"

  # Mac OS doesn't support --color flag for ls, needs -G instead.
  alias ls='ls -G'

  # Grumble, why does OS X's rm not support -I?
  function rm () {
    OPTIND=1
    OPTERR=0
    recursive=0
    force=0
    while getopts "rf" opt; do
      case "$opt" in
        r)  recursive=1
          ;;
        f)  force=1
          ;;
        *) ;;
      esac
    done

    if [ $# -gt 3 ] && [ $force -eq 0 ]; then
      read -p "rm: remove all arguments? " a
      if [ "$a" = "y" ] || [ "$a" == "Y" ]; then
        /bin/rm "$@"
      fi
    elif [ $recursive -eq 1 ] && [ $force -eq 0 ]; then
      read -p "rm: remove all arguments recursively? " a
      if [ "$a" = "y" ] || [ "$a" == "Y" ]; then
        /bin/rm "$@"
      fi
    else
      /bin/rm "$@"
    fi
  }

  alias vim='mvim -p'
  alias objdump='gobjdump'
  export EDITOR='mvim -f'

  export PATH=$PATH:/usr/local/texlive/2010/bin/x86_64-darwin:
else
  alias ls='ls --color=auto'
  alias vim='gvim -p'
  alias ack='ack-grep'
  export EDITOR='vim'

  # Less intrusive than -i, still will hopefully catch dumb mistakes.
  alias rm='rm -I'
fi
# ==============================================================================

# ==============================================================================
# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind "set completion-ignore-case on"
# ==============================================================================

# ==============================================================================
# PS1 setup

# Color Variables
BOLD=$(tput bold)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

function ps1ify () {
  echo "\[$1\]"
}
PS1_BOLD=$(ps1ify $BOLD)
PS1_RED=$(ps1ify $RED)
PS1_GREEN=$(ps1ify $GREEN)
PS1_BLUE=$(ps1ify $BLUE)
PS1_RESET=$(ps1ify $RESET)

PS1_USER_HOST="\u@\h"
PS1_DATE="(\t)"
PS1_PWD="\w"
PS1_CHROOT="${debian_chroot:+($debian_chroot)}"
# Set term window title
export PS1_BASE="$PS1_DATE\[\e]0;$PS1_USER_HOST:$PS1_PWD\a\]"
# Add chroot indicator, if relevant
export PS1="$PS1_BASE$PS1_CHROOT"
PS1_PRE_COLON=$PS1_BOLD$PS1_GREEN$PS1_USER_HOST$PS1_RESET
export PS1_BASE="$PS1_BASE $PS1_PRE_COLON:$PS1_BOLD$PS1_BLUE$PS1_PWD$PS1_RESET\$ "
# add elapsed time to PS1

function timer_start {
    timer=${timer:-$SECONDS}
}
function timer_stop {
    timer_show=$(($SECONDS - $timer))
    unset timer
}
function convertsecs() {
    m=$((($1/60)))
    s=$(($1%60))
    printf "%02d:%02d" $m $s
}

trap 'timer_start' DEBUG

# Add an indicator of an error code to the PS1
function error_code() {
  if [[ $1 != 0 ]]; then
    echo -n "$PS1_BOLD$PS1_RED($1)$PS1_RESET "
  fi
}

function finalize_ps1() {
  status=$?
  timer_stop
  # Add elapsed time and error code
  PS1="$(error_code $status)($(convertsecs $timer_show)) $PS1_BASE"
}
PROMPT_COMMAND=finalize_ps1

# ==============================================================================
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -e ~/dotfiles/goog_bashrc.bash ]; then
  source ~/dotfiles/goog_bashrc.bash
fi
