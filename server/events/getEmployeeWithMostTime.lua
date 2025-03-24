local QBCore = exports['qb-core']:GetCoreObject()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterNetEvent('bossmenu:getEmployeeWithMostTime')
AddEventHandler('bossmenu:getEmployeeWithMostTime', function()
    local src = source
    local jobName = QBCore.Functions.GetPlayer(src).PlayerData.job.name
    exports.oxmysql:single('SELECT citizenid, name, SUM(total_time) as total_time FROM attendance WHERE job = ? GROUP BY citizenid ORDER BY total_time DESC LIMIT 1', {jobName}, function(result)
        if result then
            debugPrint('Enviando empleado con más tiempo a cliente: ' .. json.encode(result))
            TriggerClientEvent('bossmenu:setEmployeeWithMostTime', src, {
                name = result.name,
                time = result.total_time
            })
        else
            TriggerClientEvent('bossmenu:setEmployeeWithMostTime', src, {
                name = 'No disponible',
                time = 'No disponible'
            })
        end
    end)
end)