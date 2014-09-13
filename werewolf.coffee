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
        description: tpl.roles.villager.desc
    },
    {
        name: 'werewolf',
        min: 2,
        max: 2,
        description: tpl.roles.werewolf.desc
    },
    {
        name: 'seer',
        min: 0,
        max: 1,
        description: tpl.roles.seer.desc
    },
    {
        name: 'robber',
        min: 0,
        max: 1,
        description: tpl.roles.robber.desc
    },
    {
        name: 'troublemaker',
        min: 0,
        max: 1,
        description: tpl.roles.troublemaker.desc
    },
    {
        name: 'tanner',
        min: 0,
        max: 1,
        description: tpl.roles.tanner.desc
    },
    {
        name: 'drunk',
        min: 0,
        max: 1,
        description: tpl.roles.drunk.desc
    },
    {
        name: 'hunter',
        min: 0,
        max: 1,
        description: tpl.roles.hunter.desc
    },
    {
        name: 'mason',
        min: 0,
        max: 2,
        description: tpl.roles.mason.desc
    },
    {
        name: 'insomniac',
        min: 0,
        max: 1,
        description: tpl.roles.insomniac.desc
    },
    {
        name: 'minion',
        min: 0,
        max: 1,
        description: tpl.roles.minion.desc
    },
    {
        name: 'doppelganger',
        min: 0,
        max: 1,
        description: tpl.roles.doppelganger.desc
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