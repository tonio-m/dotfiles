local db = require('dashboard')

-- Custom banner with ASCII art
local banner = {
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[ ↓↡↓Ὺɭ↓ɿ　↶　↓↓ 🌾 ↡ ↓↶↓↡ 　 ↶↓↡↡↓↓↓↓↡ⶫ↓ ↓ 　↓↡↓⇟  ↡↓↓↓ 🌷 ↓⇟↓🌿↡Ὺɭ↓ ]],
[[ ɭ   ________  ________  ________  ________   ________  ________     ]],
[[↡   /    /   \/        \/        \/    /   \ /        \/        \↓🌿↡]],
[[ Ὺ /         /   --    /    /    /         /_/       //         /↓↓↓ ]],
[[↓↓/         /      ___/    /    /\        //         /         / ↓↓↓ ]],
[[ ↓\__/_____/\________/\________/  \______/ \________/\__/__/__/  🌿↡ ]],
[[ ⚲↓ 丿↓↓⇟↓　 ↡↓Ր ↓ ↡↓↷↓Ὺ↓🌱↓ ↓　↓↶🌾↓↶↡↡丿 ↓Ὺ ɿ⇂↓ↆ↓↓ↆ　↡↓↓↓  ⇟↓↓ ↡↡  ]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
}

db.setup({
    theme = 'doom',
    config = {
        header = banner,
        center = {
            {
                icon = '  ',
                desc = (function()
                    local count = io.popen('ls ~/Obsidian/marco_vault/000_inbox/ | wc -l'):read("*n")
                    return count > 0 and ('Vault (' .. count .. '*)') or 'Vault'
                end)(),
                action = 'e ~/Obsidian/marco_vault/'
            },
            {
                icon = '  ',
                desc = 'Gobllm',
                action = 'Gobllm'
            },
            {
                icon = '  ',
                desc = 'Config',
                action = 'e ~/.config/nvim/init.lua'
            },
        },
        footer = {
            "tonio-m"
        }
    }
})
