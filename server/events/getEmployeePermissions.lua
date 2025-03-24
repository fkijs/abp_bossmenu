local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterServerEvent('bossmenu:getEmployeePermissions')
AddEventHandler('bossmenu:getEmployeePermissions', function(citizenId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if IsPlayerBoss(Player) then
        local permissions = {} -- Aquí deberías obtener los permisos del empleado desde la base de datos
        debugPrint('Enviando permisos de empleado a cliente: ' .. json.encode(permissions))
        TriggerClientEvent('bossmenu:setEmployeePermissions', src, {
            citizenId = citizenId,
            permissions = permissions
        })
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.ErrorUpdatedPermision, 'error')
    end
end)