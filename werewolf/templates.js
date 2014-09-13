/*
_________  ________      _____      _____  ___________ _______  _________ ___________
\_   ___ \ \_____  \    /     \    /     \ \_   _____/ \      \ \_   ___ \\_   _____/
/    \  \/  /   |   \  /  \ /  \  /  \ /  \ |    __)_  /   |   \/    \  \/ |    __)_
\     \____/    |    \/    Y    \/    Y    \|        \/    |    \     \____|        \
 \______  /\_______  /\____|__  /\____|__  /_______  /\____|__  /\______  /_______  /
        \/         \/         \/         \/        \/         \/        \/        \/
                                       /\
                                      ( ;`~v/~~~ ;._
                                   ,/'"/^) ' < o\  '".~'\\\--,
                                 ,/",/W  u '`. ~  >,._..,   )'
                                ,/'  w  ,U^v  ;//^)/')/^\;~)'
                             ,/"'/   W` ^v  W |;         )/'
                           ;''  |  v' v`" W }  \\
                          "    .'\    v  `v/^W,) '\)\.)\/)
                                   `\   ,/,)'   ''')/^"-;'
                                        \
                                         '". _
                                              \
 __      __________  .____   ______________________ _______  .___ _______    ________
/  \    /  \_____  \ |    |  \_   _____/\_   _____/ \      \ |   |\      \  /  _____/
\   \/\/   //   |   \|    |   |    __)   |    __)_  /   |   \|   |/   |   \/   \  ___
 \        //    |    \    |___|     \    |        \/    |    \   /    |    \    \_\  \
  \__/\  / \_______  /_______ \___  /   /_______  /\____|__  /___\____|__  /\______  /
       \/          \/        \/   \/            \/         \/            \/        \/
*/

module.exports = {
  _join: {
    full: "Sorry, this game is full. Consider adding more roles to the pool.",
    present: "@<%= mention %>: You're already in this game!",
    joined: "@<%= mention %>: joined the game.",
    filled: 'Game is full, run "@<%= botname %> <%= listenWord %> start" to begin, or add more roles to accomodate more players.'
  },
  quit: {
    na: "@<%= mention %>, you weren't in this one to begin with!",
    left: "@<%= mention %> left the game."
  },
  players: {
    empty: "No players have signed up yet.",
    moreReq: "<%= needed %> more players required to begin."
  },
  roles: {
    invalid: 'Invalid role name: "<%= wrong %>". Available roles: <%= validRoles %>.',
    tooMany: "Cannot add <%= name %>: cannot exceed the maximum limit. (<%= max %>)",
    tooFew: "Cannot drop <%= name %>: cannot exceed the minimum limit. (<%= min %>)",
    addSuccess: "Added <%= name %> to the role pool.",
    dropSuccess: "Dropped <%= name %> from the role pool.",
    minRoles: "You can't have less than 6 roles. (minimum for 3 players)"
  },
  help: {
    main: "/quote\r\nType \"@<%= botname %> <%= listenWord %> <command>\" to do the following actions:\r\n\r\njoin             - public, private - join the currently queuing game\r\nquit             - public, private - quit the currently queueing game\r\nplayers          - public          - see a list of the players that have joined\r\nrole list        - public          - see what roles have been selected\r\nrole add <role>  - public          - add role to pool\r\nrole drop <role> - public          - remove role from pool\r\nstart            - public          - begin the game once it has filled"
  },
  _default: 'Werewolf command not recognized. Type "@<%= botname %> <%= listenWord %> help" for a list of commands.',
  startBanner: '/quote\r\n_________  ________      _____      _____  ___________ _______  _________ ___________\r\n\\_   ___ \\ \\_____  \\    \/     \\    \/     \\ \\_   _____\/ \\      \\ \\_   ___ \\\\_   _____\/\r\n\/    \\  \\\/  \/   |   \\  \/  \\ \/  \\  \/  \\ \/  \\ |    __)_  \/   |   \\\/    \\  \\\/ |    __)_\r\n\\     \\____\/    |    \\\/    Y    \\\/    Y    \\|        \\\/    |    \\     \\____|        \\\r\n \\______  \/\\_______  \/\\____|__  \/\\____|__  \/_______  \/\\____|__  \/\\______  \/_______  \/\r\n        \\\/         \\\/         \\\/         \\\/        \\\/         \\\/        \\\/        \\\/\r\n                                       \/\\\r\n                                      ( ;`~v\/~~~ ;._\r\n                                   ,\/\'\"\/^) \' < o\\  \'\".~\'\\\\\\--,\r\n                                 ,\/\",\/W  u \'`. ~  >,._..,   )\'\r\n                                ,\/\'  w  ,U^v  ;\/\/^)\/\')\/^\\;~)\'\r\n                             ,\/\"\'\/   W` ^v  W |;         )\/\'\r\n                           ;\'\'  |  v\' v`\" W }  \\\\\r\n                          \"    .\'\\    v  `v\/^W,) \'\\)\\.)\\\/)\r\n                                   `\\   ,\/,)\'   \'\'\')\/^\"-;\'\r\n                                        \\\r\n                                         \'\". _\r\n                                              \\\r\n __      __________  .____   ______________________ _______  .___ _______    ________\r\n\/  \\    \/  \\_____  \\ |    |  \\_   _____\/\\_   _____\/ \\      \\ |   |\\      \\  \/  _____\/\r\n\\   \\\/\\\/   \/\/   |   \\|    |   |    __)   |    __)_  \/   |   \\|   |\/   |   \\\/   \\  ___\r\n \\        \/\/    |    \\    |___|     \\    |        \\\/    |    \\   \/    |    \\    \\_\\  \\\r\n  \\__\/\\  \/ \\_______  \/_______ \\___  \/   \/_______  \/\\____|__  \/___\\____|__  \/\\______  \/\r\n       \\\/          \\\/        \\\/   \\\/            \\\/         \\\/            \\\/        \\\/'
};