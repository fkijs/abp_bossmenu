local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterNetEvent('bossmenu:getSocietyMoney')
AddEventHandler('bossmenu:getSocietyMoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobName = Player.PlayerData.job.name

    if IsPlayerBoss(Player) then
        local money = 0
        if Config.UseRenewedBanking then
            money = exports['Renewed-Banking']:getAccountMoney(jobName)
        else
            money = exports[Config.Export.SocietyMoney]:getAccountMoney(jobName)
        end

        debugPrint('Dinero de la sociedad: ' .. (money or 0))

        if money ~= nil then
            TriggerClientEvent('bossmenu:setSocietyMoney', src, money)
        else
            TriggerClientEvent('bossmenu:setSocietyMoney', src, 0)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoPermisionMoneySociety, 'error')
    end
end)