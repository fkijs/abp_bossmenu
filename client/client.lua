local QBCore = exports['qb-core']:GetCoreObject()
local isInBossMenu = false
local tabletProp = nil

CreateThread(function()
    while true do
        if isInBossMenu then
            DisableControlAction(0, 1, true) -- Desactivar mouse look
            DisableControlAction(0, 2, true) -- Desactivar mouse look
            DisableControlAction(0, 3, true) -- Desactivar mouse look
            DisableControlAction(0, 4, true) -- Desactivar mouse look
            DisableControlAction(0, 5, true) -- Desactivar mouse look
            DisableControlAction(0, 6, true) -- Desactivar mouse look
            DisableControlAction(0, 263, true) -- Desactivar melee
            DisableControlAction(0, 264, true) -- Desactivar melee
            DisableControlAction(0, 257, true) -- Desactivar melee
            DisableControlAction(0, 140, true) -- Desactivar melee
            DisableControlAction(0, 141, true) -- Desactivar melee
            DisableControlAction(0, 142, true) -- Desactivar melee
            DisableControlAction(0, 143, true) -- Desactivar melee
            DisableControlAction(0, 177, true) -- Desactivar escape
            DisableControlAction(0, 200, true) -- Desactivar escape
            DisableControlAction(0, 202, true) -- Desactivar escape
            DisableControlAction(0, 322, true) -- Desactivar escape
            DisableControlAction(0, 245, true) -- Desactivar chat
        end
        Wait(3)
    end
end)

function startTabletAnim()
    local ped = PlayerPedId()
    Citizen.CreateThread(function()
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
            Citizen.Wait(0)
        end
        attachTablet()
        TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 50, 0, false, false, false)
    end)
end

function attachTablet()
    local ped = PlayerPedId()
    tabletProp = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(tabletProp, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopTabletAnim()
    local ped = PlayerPedId()
    StopAnimTask(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 50, 0, false, false, false)
    DeleteEntity(tabletProp)
    tabletProp = nil
end

RegisterNUICallback('closeBossMenu', function(data, cb)
    SetNuiFocus(false, false)
    stopTabletAnim()  -- Cambiado de StopTabletAnimation a stopTabletAnim
    isInBossMenu = false
    cb('ok')
end)

RegisterNetEvent('ox_inventory:useItem')
AddEventHandler('ox_inventory:useItem', function(data)
    local itemConfig = Config.Items[data.name]
    if itemConfig and type(itemConfig.action) == 'function' then
        itemConfig.action()
    else
        if Config.DebugMode then
            print('Item no configurado o acción inválida: ' .. tostring(data.name))
        end
    end
end)

function OpenBossMenu()
    isInBossMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openBossMenu'
    })
end

function GetGradeForPromotion(citizenid)
    -- Aquí puedes implementar la lógica para obtener el grado de promoción basado en la información del jugador
    -- Por ejemplo, incrementar el grado actual en 1
    local Player = QBCore.Functions.GetPlayerData()
    local job = Player.job
    local currentGrade = job.grade.level
    local newGrade = currentGrade + 1

    return newGrade
end

function GetGradeForDemotion(citizenid)
    -- Aquí puedes implementar la lógica para obtener el grado de degradación basado en la información del jugador
    -- Por ejemplo, disminuir el grado actual en 1
    local Player = QBCore.Functions.GetPlayerData()
    local job = Player.job
    local currentGrade = job.grade.level
    local newGrade = currentGrade - 1

    return newGrade
end

function GetGradeName(jobName, grade)
    local job = QBCore.Shared.Jobs[jobName]
    if job and job.grades then
        local gradeInfo = job.grades[tonumber(grade)]
        if gradeInfo then
            return gradeInfo.name
        end
    end
    return "Desconocido"
end

-- Comprobación de ítem antes de abrir el menú
RegisterNUICallback('closeBossMenu', function(data, cb)
    SetNuiFocus(false, false)
    isInBossMenu = false
    stopTabletAnim()
    cb('ok')
end)

RegisterNUICallback('getPlayers', function(data, cb)
    TriggerServerEvent('bossmenu:getPlayers')
    cb('ok')
end)

RegisterNUICallback('getSocietyMoney', function(data, cb)
    TriggerServerEvent('bossmenu:getSocietyMoney')
    cb('ok')
end)

RegisterNUICallback('getDashboardData', function(data, cb)
    TriggerServerEvent('bossmenu:getDashboardData')
    cb('ok')
end)

RegisterNUICallback('getPermissions', function(data, cb)
    TriggerServerEvent('bossmenu:getPermissions')
    cb('ok')
end)

RegisterNUICallback('getEmployeeWithMostTime', function(data, cb)
    TriggerServerEvent('bossmenu:getEmployeeWithMostTime')
    cb('ok')
end)

RegisterNUICallback('hirePlayer', function(data, cb)
    TriggerServerEvent('bossmenu:hirePlayer', data.citizenid)
    cb('ok')
end)

RegisterNUICallback('promotePlayer', function(data, cb)
    local jobName = QBCore.Functions.GetPlayerData().job.name
    local promoteData = {
        citizenid = data.citizenid,
        job = jobName,
    }

    print("Promover datos enviados:", json.encode(promoteData)) -- Mensaje de depuración
    TriggerServerEvent('bossmenu:promotePlayer', promoteData)
    cb('ok')
end)

RegisterNUICallback('demotePlayer', function(data, cb)
    local jobName = QBCore.Functions.GetPlayerData().job.name
    local demoteData = {
        citizenid = data.citizenid,
        job = jobName,
    }

    print("Degradar datos enviados:", json.encode(demoteData)) -- Mensaje de depuración
    TriggerServerEvent('bossmenu:demotePlayer', demoteData)
    cb('ok')
end)

RegisterNUICallback('firePlayer', function(data, cb)
    TriggerServerEvent('bossmenu:firePlayer', data.citizenid)
    cb('ok')
end)

RegisterNUICallback('giveBonus', function(data, cb)
    TriggerServerEvent('bossmenu:giveBonus', data.citizenid, data.bonusAmount)
    cb('ok')
end)

RegisterNetEvent('bossmenu:sendTopWorkers', function(workers)
    SendNUIMessage({
        type = 'topWorkers',
        workers = workers
    })
end)

RegisterNUICallback('markAttendance', function(data, cb)
    if data.type == 'in' then
        data.type = 'entrada'
    elseif data.type == 'out' then
        data.type = 'salida'
    end
    TriggerServerEvent('bossmenu:markAttendance', data.type)
    cb('ok')
end)

RegisterNUICallback('togglePermission', function(data, cb)
    TriggerServerEvent('bossmenu:togglePermission', data.permissionId, data.citizenid)
    cb('ok')
end)

RegisterNUICallback('getTransactions', function(data, cb)
    TriggerServerEvent('bossmenu:getTransactions')
    cb('ok')
end)

RegisterNUICallback('depositSocietyMoney', function(data, cb)
    TriggerServerEvent('bossmenu:depositSocietyMoney', data.amount)
    cb('ok')
end)

RegisterNUICallback('withdrawSocietyMoney', function(data, cb)
    TriggerServerEvent('bossmenu:withdrawSocietyMoney', data.amount)
    cb('ok')
end)

RegisterNetEvent('bossmenu:setPlayers')
AddEventHandler('bossmenu:setPlayers', function(players)
    if type(players) == 'table' then
        SendNUIMessage({
            action = 'setPlayers',
            players = players
        })
    else
        print('Expected an array of players')
    end
end)

RegisterNetEvent('bossmenu:setSocietyMoney')
AddEventHandler('bossmenu:setSocietyMoney', function(money)
    if type(money) == 'number' then
        SendNUIMessage({
            action = 'setSocietyMoney',
            money = money
        })
    else
        print('Expected a number for society money')
    end
end)

RegisterNetEvent('bossmenu:setDashboardData')
AddEventHandler('bossmenu:setDashboardData', function(data)
    if type(data) == 'table' then
        SendNUIMessage({
            action = 'setDashboardData',
            totalEmployees = data.totalEmployees,
            onlineNow = data.onlineNow,
            yourRank = data.yourRank,
            employees = data.employees
        })
    else
        print('Expected an object for dashboard data')
    end
end)

RegisterNetEvent('bossmenu:setPermissions')
AddEventHandler('bossmenu:setPermissions', function(permissions)
    if type(permissions) == 'table' then
        SendNUIMessage({
            action = 'setPermissions',
            permissions = permissions
        })
    else
        print('Expected an array of permissions')
    end
end)

RegisterNetEvent('bossmenu:setEmployeeWithMostTime')
AddEventHandler('bossmenu:setEmployeeWithMostTime', function(data)
    if type(data) == 'table' then
        SendNUIMessage({
            action = 'setEmployeeWithMostTime',
            employee = data
        })
    else
        print('Expected an object with employee data')
    end
end)

RegisterNetEvent('bossmenu:setTransactions')
AddEventHandler('bossmenu:setTransactions', function(transactions)
    if type(transactions) == 'table' then
        SendNUIMessage({
            action = 'setTransactions',
            transactions = transactions
        })
    else
        print('Expected an array of transactions')
    end
end)