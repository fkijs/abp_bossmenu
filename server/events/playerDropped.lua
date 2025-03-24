local QBCore = exports['qb-core']:GetCoreObject()
local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local playerName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
        local citizenId = Player.PlayerData.citizenid
        local job = Player.PlayerData.job.name
        local time = os.date("%Y-%m-%d %H:%M:%S")
        
        exports.oxmysql:single('SELECT start_time FROM attendance WHERE citizenid = ? ORDER BY start_time DESC LIMIT 1', {citizenId}, function(result)
            if result then
                local startTimeStr = tostring(result.start_time)
                local year, month, day, hour, min, sec = startTimeStr:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
                if year and month and day and hour and min and sec then
                    local startTime = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec})
                    local endTime = os.time()
                    local totalTime = math.floor(os.difftime(endTime, startTime) / 60) -- en minutos

                    local message = string.format("Desconexión: %s | ID: %s | Empleado: %s | Citizen ID: %s | Tiempo en servicio: %d minutos", time, src, playerName, citizenId, totalTime)
                    exports.oxmysql:insert('INSERT INTO attendance (citizenid, name, job, end_time, total_time) VALUES (?, ?, ?, ?, ?)', {citizenId, playerName, job, time, totalTime}, function(id)
                        if id then
                            TriggerEvent('svwebhook:sendWebhook', job, message)
                        end
                    end)
                else
                    debugPrint("Error: Incorrect date format in start_time")
                end
            else
                debugPrint("Error: No start_time found for citizenid " .. citizenId)
            end
        end)
    end
end)