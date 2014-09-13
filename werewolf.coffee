# Description:
#   Werewolf!
#
# Dependencies:
#   "lodash":     "*"
#
# Configuration:
#   None
#
# Commands:
#   wolf help - Shows available commands for the werewolf application
#
# Author:
#   Alex Meswarb

_  = require 'lodash'
tpl = require './werewolf/templates'

listenWord = 'wolf'

gamestate = {
    status: 'open'
    game_timelimit: 21600,
    role_timelimit: 300,
    lone_wolf: true,
    roles: ['werewolf',
            'werewolf',
            'seer',
            'robber',
            'troublemaker',
            'villager',
            'villager'],
    players: []
}

roles = [
    {
        name: 'villager',
        min: 0,
        max: 3,
        description: 'Villagers team. Does nothing at night, knows nothing. Win if a werewolf is killed.'
    },
    {
        name: 'werewolf',
        min: 2,
        max: 2,
        description: 'Werewolves team. Know who each other are. Win if no werewolves are killed.'
    },
    {
        name: 'seer',
        min: 0,
        max: 1,
        description: "Villagers team. May look at two roles from the center or another player's role."
    },
    {
        name: 'robber',
        min: 0,
        max: 1,
        description: "May trade roles with another player and then view that role. Robber is the new role. Whoever winds up with the Robber card is on the Villagers team."
    },
    {
        name: 'troublemaker',
        min: 0,
        max: 1,
        description: "Villagers team. May swap two other players' roles."
    },
    {
        name: 'tanner',
        min: 0,
        max: 1,
        description: "Hates his life, wants to be mistaken for a werewolf. He alone wins if he is killed."
    },
    {
        name: 'drunk',
        min: 0,
        max: 1,
        description: "Swaps his role with a role from the center. Is not aware of his new role or what team that role is on."
    },
    {
        name: 'hunter',
        min: 0,
        max: 1,
        description: "Villagers team. If he is killed, whoever he targeted dies as well."
    },
    {
        name: 'mason',
        min: 0,
        max: 2,
        description: "Villagers team. Masons know who each other are. (if both roles are owned by players)"
    },
    {
        name: 'insomniac',
        min: 0,
        max: 1,
        description: "Villagers team. Views her card again after the night phase to see if it has changed."
    },
    {
        name: 'minion',
        min: 0,
        max: 1,
        description: "Werewolves team. Tries to take the fall for the werewolves. Wins if no werewolves are killed, even if he himself died."
    },
    {
        name: 'doppelganger',
        min: 0,
        max: 1,
        description: "Looks at another player's role, then assumes and is on the team of that role. Also any night phase actions the copied role would do."
    }
]

respondPrivately = (msg) ->
    # hack to allow direct replies (use msg.reply)
    msg.message.user.reply_to = msg.message.user.jid
    return msg


playersNeeded = () ->
    return gamestate.roles.length - gamestate.players.length - 3


joinGame = (msg) ->
    if _.find(gamestate.players, {id: msg.message.user.id})
        msg.send _.template(tpl._join.present, {mention: msg.message.user.mention_name})
        return

    if playersNeeded() < 1
        msg.send tpl._join.full
        return

    gamestate.players.push(msg.message.user)
    output = _.template(tpl._join.joined, {mention: msg.message.user.mention_name}) + ' '
    if playersNeeded() > 0
        output += _.template(tpl.players.moreReq, {needed: playersNeeded()})
    else
        output += _.template(tpl._join.filled, {botname: msg.robot.name, listenWord: listenWord})
    msg.send output


quitGame = (msg) ->
    i = _.findIndex(gamestate.players, {id: msg.message.user.id})
    if i < 0
        msg.send _.template(tpl.quit.na, {mention: msg.message.user.mention_name})
        return

    gamestate.players.splice(i, 1)
    msg.send _.template(tpl.quit.left, {mention: msg.message.user.mention_name})


currentPlayers = (msg) ->
    if gamestate.players.length < 1
        msg.send tpl.players.empty
        return

    playerList = ""
    _.each(gamestate.players, (player, index, list) ->
        playerList += player.name
        if index < list.length - 1
            playerList += ", "
    )
    msg.send "Current Players: " + playerList


roleHandler = (msg, params) ->
    switch params[1]
        when "list" then roleList msg
        when "add" then addRole(msg, params)
        when "drop" then dropRole(msg, params)
        else defaultMsg msg


roleList = (msg) ->
    _roles = ""
    _.each(gamestate.roles, (role, index, list) ->
        _roles += role
        if index < list.length - 1
            _roles += ", "
    )
    msg.send "Current Roles: " + _roles


getRole = (msg, name) ->
    console.log('--- getRole ---')
    role = _.find(roles, {name: name})
    if _.isUndefined role
        validRoles = _.pluck(roles, 'name').join(', ')
        msg.send _.template(tpl.roles.invalid, {wrong: name, validRoles: validRoles})
    return role


addRole = (msg, params) ->
    role = getRole(msg, params[2])
    if _.isUndefined role
        return

    qty = _.reject(gamestate.roles, (r) ->
                                        return r != role.name).length

    if qty >= role.max
        msg.send _.template(tpl.roles.tooMany, {name: role.name, max: role.max})
        return

    gamestate.roles.push role.name
    gamestate.roles.sort()

    msg.send _.template(tpl.roles.addSuccess, {name: role.name})
    roleList(msg)


dropRole = (msg, params) ->
    console.log('--- dropRole ---')
    role = getRole(msg, params[2])
    if _.isUndefined role
        return

    qty = _.reject(gamestate.roles, (r) ->
                                        return r != role.name).length

    if qty <= role.min
        msg.send _.template(tpl.roles.tooFew, {name: role.name, min: role.min})
        return

    if (gamestate.roles.length <= 6)
        msg.send tpl.roles.minRoles
        return

    gamestate.roles.splice(gamestate.roles.indexOf(role.name), 1)
    gamestate.roles.sort()

    msg.send _.template(tpl.roles.dropSuccess, {name: role.name})
    roleList(msg)


startMsg = (msg) ->
    msg.send tpl.startBanner


helpMsg = (msg) ->
    if !_.isUndefined(msg.message.user.room)
        msg = respondPrivately msg
    msg.send _.template(tpl.help.main, {botname: msg.robot.name, listenWord: listenWord})


defaultMsg = (msg) ->
    msg.send _.template(tpl._default, {botname: msg.robot.name, listenWord: listenWord})


module.exports = (robot) ->
  robot.respond new RegExp(listenWord, 'i'), (msg) ->
    cmdString = msg.message.text
    cmdString = cmdString.substr(cmdString.indexOf(listenWord) +
                                 listenWord.length + 1)
    params = cmdString.split ' '
    switch params[0]
        when "join" then joinGame msg
        when "quit" then quitGame msg
        when "players" then currentPlayers msg
        when "role" then roleHandler(msg, params)
        when "start" then startMsg msg
        when "help" then helpMsg msg
        else defaultMsg msg