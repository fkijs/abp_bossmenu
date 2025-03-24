local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterNetEvent('bossmenu:getPlayers')
AddEventHandler('bossmenu:getPlayers', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jobName = Player.PlayerData.job.name

    if IsPlayerBoss(Player) then
        local players = {}
        local allPlayers = QBCore.Functions.GetQBPlayers()

        for _, player in pairs(allPlayers) do
            if player.PlayerData.job.name == jobName then
                table.insert(players, {
                    name = GetPlayerName(player.PlayerData.source),
                    job = player.PlayerData.job.label,
                    grade = player.PlayerData.job.grade.name,
                    citizenId = player.PlayerData.citizenid
                })
            end
        end

        debugPrint('Enviando jugadores a cliente: ' .. json.encode(players))
        TriggerClientEvent('bossmenu:setPlayers', src, players)
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoPermisionListPlayer, 'error')
    end
end)