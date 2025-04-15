local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

RegisterServerEvent('bossmenu:getDashboardData')
AddEventHandler('bossmenu:getDashboardData', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end -- Verificación básica para evitar errores

    if IsPlayerBoss(Player) then
        local totalEmployees = 0
        local onlineNow = 0
        local yourRank = Player.PlayerData.job.grade.name -- Usamos el nombre del rango (grade.name)
        local yourName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname -- Nombre del personaje
        local employees = {}

        for _, player in pairs(QBCore.Functions.GetQBPlayers()) do
            if player.PlayerData.job.name == Player.PlayerData.job.name then
                totalEmployees = totalEmployees + 1
                if player.PlayerData.job.onduty then
                    onlineNow = onlineNow + 1
                end
                local charinfo = player.PlayerData.charinfo
                local fullName = charinfo.firstname .. ' ' .. charinfo.lastname
                table.insert(employees, {
                    name = fullName,
                    job = player.PlayerData.job.name,
                    grade = player.PlayerData.job.grade.name,
                    performance = player.PlayerData.performance or 0
                })
            end
        end

        local dashboardData = {
            totalEmployees = totalEmployees,
            onlineNow = onlineNow,
            yourRank = yourRank, -- Rango del jugador (ej. "Senior Officer", "Manager")
            yourName = yourName, -- Nombre del personaje (ej. "John Doe")
            employees = employees
        }

        debugPrint('Enviando datos del dashboard a cliente: ' .. json.encode(dashboardData))
        TriggerClientEvent('bossmenu:setDashboardData', src, dashboardData)
    end
end)