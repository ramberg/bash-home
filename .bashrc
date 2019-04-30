# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace:ignoreboth #:erasedups

# append to the history file, don't overwrite it
shopt -s histappend
#PROMPT_COMMAND="history -n;history -a;history -c;history -r" 
PROMPT_COMMAND="history -n;history -a"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

###############################
# Exports                     #
###############################

# PS1
col_green="\[\e[32m\]"
col_white="\[\e[0m\]"
col_blue="\[\e[34;1m\]"
col_reset="\[\e[0m\]"
export PS1="[${col_green}\u${col_white}@${col_blue}\h${col_reset} \W]\$ "

PATH=$PATH:$HOME/bin
export PATH
export EDITOR=vim


###############################
# Alias'                      #
###############################

alias most='less -S -N -# 10'
alias rcp='rsync -lKHpEogt --progress --stats'


###############################
# Functions                   #
###############################

function chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

function ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


###############################
# TMUX                        #
###############################

if [ "$TERM" != "screen" ] &&  [ "$TERM" != "dumb" ] && [ "$SSH_CONNECTION" != "" ] && [ "$TERM" != "screen-256color" ]; then
   screens=$(/usr/bin/tmux ls | grep -oP '^[^:]*')
   PS3="Which screen: "
   select get in None $screens New
   do
      case "$get" in
         None)   echo "Well then"; break;;
         New)    echo -n "Name: "; read x; /usr/bin/tmux -2 new -s $x && exit;;
         "")     echo "Not in List";;
         *)      /usr/bin/tmux detach -s $get; /usr/bin/tmux -2 a -t $get && exit;;
      esac
   done
fi


###############################
# Last Words                  #
###############################

if [ -f ~/.bashinc ]; then
        . ~/.bashinc
fi

#export LC_ALL=de_DE.utf8
umask 077
