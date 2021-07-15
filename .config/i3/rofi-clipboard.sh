#!/bin/zsh
rofi \
-modi "clipboard:greenclip print" \
-show clipboard \
-run-command '{cmd}' \
-hide-scrollbar \
-line-margin 0 -line-padding 1 \
-color-window "argb:66222222, argb:66222222, #b1b4b3" \
-separator-style none -font "mono 10" -columns 1 -bw 0 \
-color-active "argb:66222222, argb:99ffffff, argb:66222222, #77003d, #b1b4b3" \
-color-normal "argb:66222222, argb:99ffffff, argb:66222222, #77003d, #b1b4b3" \
-color-urgent "argb:66222222, argb:99ffffff, argb:66222222, #77003d, #b1b4b3"
