ESX              = nil
local PlayerData = {}
local inMarker, inProgress, inCreator = false, false, false
local amount = 0
local blip = nil
local selected, selected2 = {}, {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        for k, v in pairs(Config.Herstellung) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(playerCoords, v.coords, true)

            if distance < 20 / 2 then
                DrawMarker(27, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 227, 199, 16, 100, false, true, 2, true, false, false, false)
            end

            if distance < 3 then
                inMarker = true
                ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um ~y~' .. v.label .. "~w~ zu klauen!")
                selected = v
                break
            else
                inMarker = false
            end
        end

        for k, v in pairs(Config.Hersteller) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(playerCoords, v.coords, true)

            if distance < 2 then
                inCreator = true
                ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um ~y~Schutzwesten ~w~ herzustellen!')
                selected2 = v
                break
            else
                inCreator = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Hersteller) do
        RequestModel(v.pedModel)
        while not HasModelLoaded(v.pedModel) do
            Wait(1.0)
        end

        RequestAnimDict("mini@strip_club@idles@bouncer@base")
        while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
            Wait(1)
        end

        ped = CreatePed(4, v.pedHash, v.coords, 10, false, true)
        SetEntityHeading(ped, v.heading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

function changeSkin()
    TriggerEvent("skinchanger:getSkin", function(skinData)
        if skinData ~= nil then
            skinData['bproof_1'] = 27
            skinData['bproof_2'] = 5
            TriggerEvent('skinchanger:loadSkin', skinData)
        end
    end)
end


RegisterNetEvent('fc_westenroute:bulletproof_small')
AddEventHandler('fc_westenroute:bulletproof_small', function()
    local playerPed = PlayerPedId()

    AddArmourToPed(playerPed, 25)
    SetPedArmour(playerPed, 25)
    changeSkin()
end)

RegisterNetEvent('fc_westenroute:bulletproof_normal')
AddEventHandler('fc_westenroute:bulletproof_normal', function()
    local playerPed = PlayerPedId()

    AddArmourToPed(playerPed, 50)
    SetPedArmour(playerPed, 50)
    changeSkin()
end)
RegisterNetEvent('fc_westenroute:bulletproof_high')
AddEventHandler('fc_westenroute:bulletproof_high', function()
    local playerPed = PlayerPedId()

    AddArmourToPed(playerPed,100)
    SetPedArmour(playerPed, 100)
    changeSkin()
end)

RegisterNetEvent('fc_westenroute:closeMenu')
AddEventHandler('fc_westenroute:closeMenu', function()
    RageUI.CloseAll()
end)

RegisterNetEvent('fc_westenroute:blip')
AddEventHandler('fc_westenroute:blip', function(position)
	blip = AddBlipForCoord(position)

	SetBlipSprite(blip, 271)
	SetBlipScale(blip, 1.0)
	SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Diebstahl gemeldet!")
    EndTextCommandSetBlipName(blip)
	PulseBlip(blip)
end)

RegisterNetEvent('fc_westenroute:delblip')
AddEventHandler('fc_westenroute:delblip', function()
    RemoveBlip(blip)
end)

RegisterNetEvent('fc_westenroute:openMenu')
AddEventHandler('fc_westenroute:openMenu', function()
        inMarker2 = false
        local menu = RageUI.CreateMenu("Herstellung", "Stelle Schutzwesten her!")

        RageUI.Visible(menu, not RageUI.Visible(menu))
        while true do
            Citizen.Wait(1.0)
            RageUI.IsVisible(menu, function()
                RageUI.Button("Typ:", "", {RightLabel=selected2.type}, true, {})
                RageUI.Button("Gewicht:", "", {RightLabel=selected2.weight}, true, {})
                RageUI.Button("Schutz:", "", {RightLabel=selected2.schutz}, true, {})
                RageUI.Button("Herstellen", "", {RightLabel="~b~→→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('fc_westenroute:craftWest', selected2.type)
                    end
                })
            end)
        end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        if IsControlJustPressed(1, 51) and inMarker and not inProgress then
            if amount > 8 then
                TriggerServerEvent('fc_westenroute:alarmCops', selected)
                Citizen.SetTimeout(8000, function()
                    amount = 0
                end)
            end
            inProgress = true
            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            TriggerEvent('progress', 7500, 'Herstellung')
            Citizen.Wait(10000)
            ESX.ShowNotification('Du hast ~y~' .. selected.label .. '~w~ aufgesammelt!')
            TriggerServerEvent('fc_westenroute:giveItem', selected.itemName)
            amount = amount + 1
            inProgress = false
        end

        if IsControlJustPressed(1, 51) and inCreator then
            TriggerEvent('fc_westenroute:openMenu')
        end
    end
end)