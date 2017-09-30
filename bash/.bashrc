#!/usr/bin/env bash

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

[[ $- = *i* ]] && source ~/.bashrc.d/bash-sensible/sensible.bash
[[ $- = *i* ]] && export TERM=xterm-256color        # for common 256 color terminals (e.g. gnome-terminal)
[[ $- = *i* ]] && source ~/.bashrc.d/liquidprompt/liquidprompt
[[ $- = *i* ]] && eval `dircolors ~/.bashrc.d/dircolors-solarized/dircolors.ansi-dark`
[[ $- = *i* ]] && export LP_ENABLE_SVN=0
