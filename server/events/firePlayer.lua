local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('bossmenu:firePlayer')
AddEventHandler('bossmenu:firePlayer', function(target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Employee = QBCore.Functions.GetPlayerByCitizenId(target)

    if IsPlayerBoss(Player) then
        if Employee then
            Employee.Functions.SetJob('unemployed', 0)
            TriggerClientEvent('QBCore:Notify', src, 'Has despedido a ' .. Employee.PlayerData.charinfo.firstname .. ' ' .. Employee.PlayerData.charinfo.lastname, 'success')
            TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, 'Has sido despedido', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'No tienes permisos para despedir', 'error')
    end
end)