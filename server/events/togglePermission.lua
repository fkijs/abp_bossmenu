local QBCore = exports['qb-core']:GetCoreObject()
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

RegisterServerEvent('bossmenu:togglePermission')
AddEventHandler('bossmenu:togglePermission', function(permissionId, citizenId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if IsPlayerBoss(Player) then
        exports.oxmysql:single('SELECT permissions FROM employee_permissions WHERE citizenid = ?', {citizenId}, function(result)
            if result then
                local permissions = result.permissions and result.permissions:split(',') or {}

                local hasPermission = false
                for _, perm in ipairs(permissions) do
                    if perm == permissionId then
                        hasPermission = true
                        break
                    end
                end

                if hasPermission then
                    for i, perm in ipairs(permissions) do
                        if perm == permissionId then
                            table.remove(permissions, i)
                            break
                        end
                    end
                else
                    table.insert(permissions, permissionId)
                end

                exports.oxmysql:update('UPDATE employee_permissions SET permissions = ? WHERE citizenid = ?', {table.concat(permissions, ','), citizenId}, function(affectedRows)
                    if affectedRows > 0 then
                        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.PermissionUpdated, 'success')
                    else
                        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.ErrorPermisions, 'error')
                    end
                end)
            else
                exports.oxmysql:insert('INSERT INTO employee_permissions (citizenid, permissions) VALUES (?, ?)', {citizenId, permissionId}, function(id)
                    if id then
                        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.PermissionUpdated, 'success')
                    else
                        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.CreatePermisionErorr, 'error')
                    end
                end)
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.NoPermissionUpdated, 'error')
    end
end)