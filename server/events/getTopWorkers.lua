local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('bossmenu:getTopWorkers')
AddEventHandler('bossmenu:getTopWorkers', function()
    local src = source
    exports.oxmysql:execute('SELECT name, total_time FROM attendance ORDER BY total_time DESC LIMIT 3', {}, function(results)
        if results then
            TriggerClientEvent('bossmenu:sendTopWorkers', src, results)
        else
            TriggerClientEvent('QBCore:Notify', src, 'No se pudo obtener el top 3 de trabajadores', 'error')
        end
    end)
end)