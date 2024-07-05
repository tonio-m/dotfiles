######## Simple version of the workflow:
# on run
#     tell application "System Events"
#         keystroke (the clipboard)
#     end tell
# end run


# Why?
# To paste text into windows that normally don't allow it or have access to the clipboard.
# Examples: Virtual machines that do not yet have tools installed, websites that hijack paste
#
# Extended vs Simple?
# * Includes an initial delay to allow you to change active windows
# * Adds small delay between keypresses for slower responding windows like SSH sessions
# * Better handling of numbers
# * VMWare bug fix
#
# Setup
# Apple Shortcuts app
#
# MAKE SURE YOUR CAPSLOCK IS OFF

on run
    tell application "System Events"
        delay 0.5 # DELAY BEFORE BEGINNING KEYPRESSES IN SECONDS
        repeat with char in (the clipboard)
            set cID to id of char

            if ((cID ≥ 48) and (cID ≤ 57)) then
                # Converts numbers to ANSI_# characters rather than ANSI_Keypad# characters
                # https://apple.stackexchange.com/a/227940
                key code {item (cID - 47) of {29, 18, 19, 20, 21, 23, 22, 26, 28, 25}}
            else if (cID = 46) then
                # Fix VMware Fusion period bug
                # https://apple.stackexchange.com/a/331574
                key code 47
            else
                keystroke char
            end if

            delay 0.05 # DELAY BETWEEEN EACH KEYPRESS IN SECONDS
        end repeat
    end tell
end run



