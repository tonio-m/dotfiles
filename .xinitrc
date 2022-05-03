flameshot &
blueman-applet &
~/.config/dwm-bar/dwm_bar.sh &
(sleep 2 && clipmenud) &
# disable idle sleep
(sleep 2 && xset s off && xset -dpms) &
exec dwm
