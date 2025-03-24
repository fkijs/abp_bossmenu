local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('nwd_bossmenu:giveBonus') -- Corregido el nombre del evento
AddEventHandler('nwd_bossmenu:giveBonus', function(data) -- Cambiado a recibir un objeto 'data'
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        return -- Evitar errores si el jugador no existe
    end

    if not IsPlayerBoss(Player) then
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoPermisionBonus, 'error')
        TriggerClientEvent('nwd_bossmenu:notify', src, { message = Config.Notifications.NoPermisionBonus, type = 'error' })
        return
    end

    local citizenid = data.citizenid
    local bonusAmount = tonumber(data.bonusAmount)

    if not citizenid or not bonusAmount or bonusAmount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid citizen ID or bonus amount', 'error')
        TriggerClientEvent('nwd_bossmenu:notify', src, { message = 'Invalid citizen ID or bonus amount', type = 'error' })
        return
    end

    local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.PlayerNotFound, 'error')
        TriggerClientEvent('nwd_bossmenu:notify', src, { message = Config.Notifications.PlayerNotFound, type = 'error' })
        return
    end

    local jobName = Player.PlayerData.job.name
    local societyAccountBalance = tonumber(exports['Renewed-Banking']:getAccountMoney(jobName))

    if not societyAccountBalance or societyAccountBalance < bonusAmount then
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.InsuficientMoneySociety, 'error')
        TriggerClientEvent('nwd_bossmenu:notify', src, { message = Config.Notifications.InsuficientMoneySociety, type = 'error' })
        return
    end

    -- Intentar retirar dinero de la sociedad
    exports['Renewed-Banking']:removeAccountMoney(jobName, bonusAmount)
    -- Verificar si el saldo disminuyó correctamente (Renewed-Banking no devuelve éxito explícito)
    local newBalance = tonumber(exports['Renewed-Banking']:getAccountMoney(jobName))
    if newBalance and newBalance == societyAccountBalance - bonusAmount then
        targetPlayer.Functions.AddMoney('bank', bonusAmount, 'Bonus from boss')
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.BonusSuccess, 'success')
        TriggerClientEvent('QBCore:Notify', targetPlayer.PlayerData.source, 'You received a bonus of $' .. bonusAmount, 'success')
        TriggerClientEvent('nwd_bossmenu:notify', src, { message = Config.Notifications.BonusSuccess, type = 'success' })

        -- Registrar la transacción
        exports['Renewed-Banking']:handleTransaction(
            jobName,
            'Bonus',
            bonusAmount,
            'Bonus granted to ' .. targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname,
            Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname,
            'withdraw'
        )
    else
        TriggerClientEvent('QBCore:Notify', src, 'Error withdrawing money from society account', 'error')
        TriggerClientEvent('nwd_bossmenu:notify', src, { message = 'Error withdrawing money from society account', type = 'error' })
    end
end)