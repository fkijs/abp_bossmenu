local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterNetEvent('bossmenu:getPermissions')
AddEventHandler('bossmenu:getPermissions', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if IsPlayerBoss(Player) then
        local employees = {}
        for _, player in ipairs(GetPlayers()) do
            local Target = QBCore.Functions.GetPlayer(player)
            if Target and Target.PlayerData.job.name == Player.PlayerData.job.name then
                table.insert(employees, {
                    name = Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname,
                    citizenId = Target.PlayerData.citizenid
                })
            end
        end
        debugPrint('Enviando permisos a cliente: ' .. json.encode(employees))
        TriggerClientEvent('bossmenu:setPermissions', src, employees)
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoErrorPermision, 'error')
    end
end)