#!/usr/bin/python3
# 0 9 * * * /usr/bin/python3 $HOME/.config/scripts/unsnoozer.py >> $HOME/.config/scripts/unsnoozer.log 2>&1
import os
from datetime import datetime, timedelta
import logging

logging.basicConfig(level=logging.INFO)

VAULT_HOME = f"{os.environ.get('HOME')}/Obsidian/marco_vault/"
SNOOZE_DIR = '004_snooze'
INBOX_DIR = '000_inbox' 


if __name__ == '__main__':
    now = datetime.now()
    snooze_max_time = timedelta(days=1)
    snooze_dir_full_path = os.path.join(VAULT_HOME,SNOOZE_DIR)
    inbox_dir_full_path = os.path.join(VAULT_HOME,INBOX_DIR)
    
    counter = 0

    for f in os.listdir(snooze_dir_full_path):
        f_full_path = os.path.join(snooze_dir_full_path,f)
        f_timestamp = datetime.fromtimestamp(os.path.getmtime(f_full_path))
        f_type = 'File' if os.path.isfile(f_full_path) \
        else 'Folder' if os.path.isdir(f_full_path) \
        else 'Object'

        if (now - f_timestamp) > snooze_max_time:
            new_path = os.path.join(inbox_dir_full_path,f)
            logging.info(f'{f_type} "{f}" has run out of Snooze time, moving it to {new_path}')
            os.utime(f_full_path, None)
            os.rename(f_full_path,new_path)
            counter += 1

    logging.info(f'Script finished. {counter} Objects were unsnoozed.')
