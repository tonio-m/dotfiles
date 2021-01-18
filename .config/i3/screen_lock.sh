#!/bin/sh
rm -f /tmp/screen_lock_screenshot.png && \
scrot /tmp/screen_lock_screenshot.png && \
python ${HOME}/.config/i3/pixel_displace.py /tmp/screen_lock_screenshot.png && \
i3lock -i /tmp/screen_lock_screenshot.png


