local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('bossmenu:promotePlayer')
AddEventHandler('bossmenu:promotePlayer', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Employee = QBCore.Functions.GetPlayerByCitizenId(data.citizenid)

    if IsPlayerBoss(Player) then
        if Employee then
            local newGrade = Employee.PlayerData.job.grade.level + 1
            Employee.Functions.SetJob(Player.PlayerData.job.name, newGrade)
            TriggerClientEvent('QBCore:Notify', src, 'Has promovido a ' .. Employee.PlayerData.charinfo.firstname .. ' ' .. Employee.PlayerData.charinfo.lastname .. ' a ' .. Employee.PlayerData.job.label, 'success')
            TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, 'Has sido promovido a ' .. Employee.PlayerData.job.label, 'success')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'No tienes permisos para promover', 'error')
    end
end)