local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterServerEvent('bossmenu:getTransactions')
AddEventHandler('bossmenu:getTransactions', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobName = Player.PlayerData.job.name

    if IsPlayerBoss(Player) then
        exports.oxmysql:execute('SELECT transactions FROM bank_accounts_new WHERE id = ?', {jobName}, function(result)
            if result[1] then
                debugPrint(result[1].transactions)  -- Imprime el JSON de transacciones para depuración
                local transactions = json.decode(result[1].transactions)
                if type(transactions) == "table" then
                    TriggerClientEvent('bossmenu:setTransactions', src, transactions)
                else
                    TriggerClientEvent('bossmenu:setTransactions', src, {})
                end
            else
                TriggerClientEvent('bossmenu:setTransactions', src, {})
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.errortransaction, 'error')
    end
end)