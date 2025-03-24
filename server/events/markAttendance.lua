local QBCore = exports['qb-core']:GetCoreObject()

local function getCurrentTime()
    return os.date(Config.Attendance.TimeFormat)
end

RegisterServerEvent('bossmenu:markAttendance')
AddEventHandler('bossmenu:markAttendance', function(attendanceType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local firstName = Player.PlayerData.charinfo.firstname
    local lastName = Player.PlayerData.charinfo.lastname
    local playerName = firstName .. " " .. lastName
    local citizenId = Player.PlayerData.citizenid
    local job = Player.PlayerData.job.name
    local time = getCurrentTime()
    local message = ""

    if attendanceType == 'entrada' then
        exports.oxmysql:insert('INSERT INTO attendance (citizenid, name, job, start_time) VALUES (?, ?, ?, ?)', {citizenId, playerName, job, time}, function(id)
            if id then
                message = string.format(Config.Attendance.WebhookMessages.Entry, time, src, playerName, citizenId)
                TriggerEvent('svwebhook:sendWebhook', job, message)
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.EntrySuccess, 'success')
                Player.Functions.SetJobDuty(true) -- Poner al jugador en servicio
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.EntryFailed, 'error')
            end
        end)
    elseif attendanceType == 'salida' then
        exports.oxmysql:single('SELECT id, start_time FROM attendance WHERE citizenid = ? AND job = ? AND end_time IS NULL ORDER BY start_time DESC LIMIT 1', {citizenId, job}, function(result)
            if result then
                local endTime = getCurrentTime()
                local startTime = result.start_time
                local pattern = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
                local year, month, day, hour, min, sec = startTime:match(pattern)

                if year and month and day and hour and min and sec then
                    year = tonumber(year)
                    month = tonumber(month)
                    day = tonumber(day)
                    hour = tonumber(hour)
                    min = tonumber(min)
                    sec = tonumber(sec)

                    local startTimeNumber = os.time({year=year, month=month, day=day, hour=hour, min=min, sec=sec})
                    local totalTime = os.difftime(os.time(), startTimeNumber)
                    if Config.Attendance.TimeUnit == "minutes" then
                        totalTime = math.floor(totalTime / 60) -- Convertir a minutos y redondear
                    end -- Si es "seconds", se deja como está

                    message = string.format(Config.Attendance.WebhookMessages.Exit, endTime, src, playerName, citizenId, totalTime)
                    exports.oxmysql:update('UPDATE attendance SET end_time = ?, total_time = ? WHERE id = ?', {endTime, totalTime, result.id}, function(affectedRows)
                        if affectedRows > 0 then
                            TriggerEvent('svwebhook:sendWebhook', job, message)
                            TriggerClientEvent('QBCore:Notify', src, Config.Notifications.ExitSuccess, 'success')
                            Player.Functions.SetJobDuty(false) -- Sacar al jugador de servicio
                        else
                            TriggerClientEvent('QBCore:Notify', src, Config.Notifications.ExitFailed, 'error')
                        end
                    end)
                else
                    TriggerClientEvent('QBCore:Notify', src, Config.Notifications.InvalidTimeFormat, 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoEntryFound, 'error')
            end
        end)
    end
end)