local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterNetEvent('bossmenu:giveBonus')
AddEventHandler('bossmenu:giveBonus', function(citizenid, bonusAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        if IsPlayerBoss(Player) then
            local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
            if targetPlayer then
                local jobName = Player.PlayerData.job.name
                local societyAccountBalance = tonumber(exports['Renewed-Banking']:getAccountMoney(jobName)) -- Convertir a número
                bonusAmount = tonumber(bonusAmount) -- Asegurarse de que bonusAmount es un número

                if societyAccountBalance and societyAccountBalance >= bonusAmount then
                    local removeMoneySuccess = exports['Renewed-Banking']:removeAccountMoney(jobName, bonusAmount)

                    if removeMoneySuccess then
                        targetPlayer.Functions.AddMoney('bank', bonusAmount)
                        TriggerClientEvent('QBCore:Notify', src, 'Bono otorgado exitosamente', 'success')
                        TriggerClientEvent('QBCore:Notify', targetPlayer.PlayerData.source, 'Has recibido un bono de $' .. bonusAmount, 'success')

                        -- Log the transaction
                        exports['Renewed-Banking']:handleTransaction(jobName, 'Bonificación', bonusAmount, 'Bono otorgado a ' .. targetPlayer.PlayerData.name, Player.PlayerData.name, targetPlayer.PlayerData.name, 'withdraw')
                    else
                        TriggerClientEvent('QBCore:Notify', src, 'Error al retirar dinero de la cuenta de la sociedad', 'error')
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Fondos insuficientes en la cuenta de la sociedad', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'Jugador no encontrado', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'No tienes permisos para dar bonos', 'error')
        end
    end
end)