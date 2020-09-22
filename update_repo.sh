#!/bin/bash
files=( \
    ~/.zshrc \
    ~/.xinitrc \
    ~/.config/i3 \
    ~/.config/kitty \
    ~/.config/i3blocks \
    ~/.config/nvim/init.vim \
    ~/.config/nvim/autoload/plug.vim \
)

length=${#files[@]}

for i in $( seq 0 $(($length-1)) )
do
    fullpath=${files[$i]}
    echo $fullpath

    if [ -e $fullpath -o -d $fullpath ]; then
        dirpath=$(dirname "$fullpath")
        mkdir -p ".$dirpath"
        cp -r "$fullpath" ".$dirpath"

    else
        echo "ERROR: path $fullpath does not exists"
    fi
done
