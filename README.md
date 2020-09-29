# dotfiles

I use i3-gaps with i3blocks and rofi, and kitty as terminal emulator.
For editor I use neovim with the CoC plugin.

- copy_config.sh 

    Copies from the repo to your os

- update_repo.sh 

    Copies from your os to the repo.

    Inside the script there is a variable named `files` which contains all paths to be copied

are useful scripts to automatically

```
home
 └── user
     ├── .config
     │   ├── i3
     │   │   ├── config
     │   │   └── rofi.sh
     │   ├── i3blocks
     │   │   ├── batterybar
     │   │   ├── config
     │   │   ├── time
     │   │   └── wifi
     │   ├── kitty
     │   │   ├── kitty.conf
     │   │   └── theme.conf
     │   └── nvim
     │       ├── autoload
     │       │   └── plug.vim
     │       └── init.vim
     ├── .xinitrc
     └── .zshrc
```

