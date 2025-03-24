local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('bossmenu:withdrawSocietyMoney')
AddEventHandler('bossmenu:withdrawSocietyMoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobName = Player.PlayerData.job.name

    if IsPlayerBoss(Player) then
        local bankingExport = Config.UseRenewedBanking and exports['Renewed-Banking'] or exports[Config.Export.WithdrawMoney]
        local money = bankingExport:getAccountMoney(jobName)
        if money and money >= amount then
            if bankingExport:removeAccountMoney(jobName, amount) then
                Player.Functions.AddMoney('cash', amount)
                bankingExport:handleTransaction(
                    jobName, 
                    'Society Account', 
                    amount, 
                    'Withdrawal from Society', 
                    jobName, 
                    Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname, 
                    'withdraw'
                )
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.WithdrawSuccess, 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.WithdrawFailed, 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Notifications.InsuficientMoneySociety, 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoPermisionMoney, 'error')
    end
end)