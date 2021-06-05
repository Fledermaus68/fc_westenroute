ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function isConfigItem(itemName)
    for k, v in pairs(Config.Herstellung) do
           if itemName == v.itemName then
            return true
           end
        end
    return false
end

AddEventHandler('fc_westenroute:giveItem')
RegisterNetEvent('fc_westenroute:giveItem', function(itemName)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    if not isConfigItem(itemName) then
        xPlayer.kick("FiveCity | Du wurdest vom Server gekickt! Grund: Modding")
        return
    end

    xPlayer.addInventoryItem(itemName, 1)
end)

AddEventHandler('fc_westenroute:alarmCops')
RegisterNetEvent('fc_westenroute:alarmCops', function(selected)

    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
           TriggerClientEvent('esx:showNotification', xPlayers[i], '~r~Alarm: ~w~Eine Person wurde beim Klauen von ~b~' .. selected.label .. ' ~w~erwischt!')
           TriggerClientEvent('fc_westenroute:blip', xPlayers[i], selected.coords)
           SetTimeout(180000, function()
            TriggerClientEvent('fc_westenroute:delblip', xPlayers[i])
           end)
       end
   end
end)

ESX.RegisterUsableItem("bulletproof_small", function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('bulletproof_small', 1)
    xPlayer.showNotification('Du hast dir eine ~b~leichte~w~ Schutzweste angezogen!')
    TriggerClientEvent('fc_westenroute:bulletproof_small', playerId)
end)

ESX.RegisterUsableItem("bulletproof_normal", function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('bulletproof_normal', 1)
    xPlayer.showNotification('Du hast dir eine ~b~mittlere~w~ Schutzweste angezogen!')
    TriggerClientEvent('fc_westenroute:bulletproof_normal', playerId)
end)

ESX.RegisterUsableItem("bulletproof_high", function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('bulletproof_high', 1)
    xPlayer.showNotification('Du hast dir eine ~b~schwere~w~ Schutzweste angezogen!')
    TriggerClientEvent('fc_westenroute:bulletproof_high', playerId)
end)

AddEventHandler('fc_westenroute:craftWest')
RegisterNetEvent('fc_westenroute:craftWest', function(type)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local kevlar = xPlayer.getInventoryItem("kevlar")
    local material = xPlayer.getInventoryItem("material")
    local ceramic = xPlayer.getInventoryItem("ceramic")

    if type == "Schwer" then
        if kevlar.count >= 20 and material.count >= 40 and ceramic.count >= 40 then
            xPlayer.removeInventoryItem("kevlar", 20)
            xPlayer.removeInventoryItem("material", 40)
            xPlayer.removeInventoryItem("ceramic", 40)
            xPlayer.addInventoryItem('bulletproof_high', 1)
            xPlayer.showNotification('Du hast erfolgreich eine ~y~schwere Schutzweste ~w~hergestellt.')
            TriggerClientEvent('fc_westenroute:closeMenu', xPlayer.source)
            else
            xPlayer.showNotification('~r~Du hast nicht genügend Materialien!')
            TriggerClientEvent('fc_westenroute:closeMenu', xPlayer.source)
            end
    else if type == "Mittel" then
        if kevlar.count >= 10 and material.count >= 20 and ceramic.count >= 20 then
            xPlayer.removeInventoryItem("kevlar", 10)
            xPlayer.removeInventoryItem("material", 20)
            xPlayer.removeInventoryItem("ceramic", 20)
            xPlayer.addInventoryItem('bulletproof_normal', 1)
            xPlayer.showNotification('Du hast erfolgreich eine ~y~mittlere Schutzweste ~w~hergestellt.')
            TriggerClientEvent('fc_westenroute:closeMenu', xPlayer.source)
            else
            xPlayer.showNotification('~r~Du hast nicht genügend Materialien!')
            TriggerClientEvent('fc_westenroute:closeMenu', xPlayer.source)
            end
    else if type == "Leicht" then
        if kevlar.count >= 5 and material.count >= 10 and ceramic.count >= 10 then
            xPlayer.removeInventoryItem("kevlar", 5)
            xPlayer.removeInventoryItem("material", 10)
            xPlayer.removeInventoryItem("ceramic", 10)
            xPlayer.addInventoryItem('bulletproof_small', 1)
            xPlayer.showNotification('Du hast erfolgreich eine ~y~leichte Schutzweste ~w~hergestellt.')
            TriggerClientEvent('fc_westenroute:closeMenu', xPlayer.source)
            else
            xPlayer.showNotification('~r~Du hast nicht genügend Materialien!')
            TriggerClientEvent('fc_westenroute:closeMenu', xPlayer.source)
            end
        end
    end
  end
end)


