local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('bossmenu:depositSocietyMoney')
AddEventHandler('bossmenu:depositSocietyMoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobName = Player.PlayerData.job.name

    if IsPlayerBoss(Player) then
        if Player.Functions.RemoveMoney('cash', amount) then
            local bankingExport = Config.UseRenewedBanking and exports['Renewed-Banking'] or exports[Config.Export.DepositMoney]
            if bankingExport:addAccountMoney(jobName, amount) then
                bankingExport:handleTransaction(
                    jobName, 
                    'Society Account', 
                    amount, 
                    'Deposit to Society', 
                    Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname, 
                    jobName, 
                    'deposit'
                )
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.DepositSuccess, 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.DepositFailed, 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Notifications.DepositFailed, 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoPermisionMoneyDep, 'error')
    end
end)