local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('trackallplayers', 'track all players', {}, false, function(source)
    local players = QBCore.Functions.GetPlayers()
    TriggerClientEvent('tofu-satellite:open', source, players, 0)
end, 'admin')

QBCore.Commands.Add('trackallplayerstimeout', 'track all players for 30 seconds', {}, false, function(source)
    local players = QBCore.Functions.GetPlayers()
    TriggerClientEvent('tofu-satellite:open', source, players, 30)
end, 'admin')

QBCore.Commands.Add('trackphone', 'track player by phone', {}, false, function(source, args)
    local player = QBCore.Functions.GetPlayerByPhone(args[1])
    if player ~= nil then
        TriggerClientEvent('tofu-satellite:open', source, { player }, 0)
    end
end, 'admin')

QBCore.Commands.Add('manualtracking', 'manual control of satellite', {}, false, function(source)
    TriggerClientEvent('tofu-satellite:open', source, {}, 0)
end, 'admin')
