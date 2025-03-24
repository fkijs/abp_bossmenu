local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('bossmenu:hirePlayer')
AddEventHandler('bossmenu:hirePlayer', function(citizenid)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)

    if IsPlayerBoss(Player) then
        if Target then
            Target.Functions.SetJob(Player.PlayerData.job.name, 0)
            TriggerClientEvent('QBCore:Notify', src, 'Has contratado a ' .. Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname, 'success')
            TriggerClientEvent('QBCore:Notify', Target.PlayerData.source, 'Has sido contratado como ' .. Player.PlayerData.job.label, 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'No se pudo encontrar al jugador', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'No tienes permisos para contratar', 'error')
    end
end)