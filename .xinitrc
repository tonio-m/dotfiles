[ -x "$(command -v dunst)" ] && dunst &
[ -x "$(command -v picom)" ] && picom &
[ -x "$(command -v hsetroot)" ] && hsetroot &
[ -x "$(command -v flameshot)" ] && flameshot &
[ -x "$(command -v flameshot)" ] && blueman-applet &
[ -x "$(command -v clipmenud)" ] && (sleep 2 && clipmenud) &
[ -x "$(command -v xsetroot)" ] && ~/.config/dwm-bar/dwm_bar.sh &

# disable idle sleep
(sleep 2 && xset s off && xset -dpms) &

# disable middle click paste
[ -x "$(command -v xmousepasteblock)" ] && (sleep 2 && xmousepasteblock) &

# stupid script to play cat gif
 [ -x "$(command -v easyeffects)" ] && (sleep 2 && easyeffects) &

# stupid script to play cat gif
# [ -x "$(command -v mpv)" ] && (sleep 2 && mpv --no-osc --loop --alpha=yes ~/.config/wallpapers/catdance.gif) &

# x forwarding
xhost +local:user

exec dwm
