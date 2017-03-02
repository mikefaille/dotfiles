#!/usr/bin/env bash
[[ $- = *i* ]] && source ~/.bashrc.d/bash-sensible/sensible.bash
[[ $- = *i* ]] && export TERM=xterm-256color        # for common 256 color terminals (e.g. gnome-terminal)
[[ $- = *i* ]] && source ~/.bashrc.d/liquidprompt/liquidprompt
[[ $- = *i* ]] && eval `dircolors ~/.bashrc.d/dircolors-solarized/dircolors.ansi-dark`
[[ $- = *i* ]] && export LP_ENABLE_SVN=0
