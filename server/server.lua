local QBCore = exports['qb-core']:GetCoreObject()

-- Importar funciones
local isPlayerBossCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/IsPlayerBoss.lua')
local IsPlayerBoss = assert(load(isPlayerBossCode))()

local debugPrintCode = LoadResourceFile(GetCurrentResourceName(), 'server/functions/debugPrint.lua')
local debugPrint = assert(load(debugPrintCode))()

-- Registrar eventos cargando los archivos correspondientes
local hirePlayerCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/hirePlayer.lua')
assert(load(hirePlayerCode))()

local promotePlayerCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/promotePlayer.lua')
assert(load(promotePlayerCode))()

local demotePlayerCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/demotePlayer.lua')
assert(load(demotePlayerCode))()

local firePlayerCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/firePlayer.lua')
assert(load(firePlayerCode))()

local giveBonusCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/giveBonus.lua')
assert(load(giveBonusCode))()

local getPlayersCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getPlayers.lua')
assert(load(getPlayersCode))()

local getSocietyMoneyCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getSocietyMoney.lua')
assert(load(getSocietyMoneyCode))()

local depositSocietyMoneyCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/depositSocietyMoney.lua')
assert(load(depositSocietyMoneyCode))()

local withdrawSocietyMoneyCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/withdrawSocietyMoney.lua')
assert(load(withdrawSocietyMoneyCode))()

local getDashboardDataCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getDashboardData.lua')
assert(load(getDashboardDataCode))()

local getPermissionsCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getPermissions.lua')
assert(load(getPermissionsCode))()

local getEmployeePermissionsCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getEmployeePermissions.lua')
assert(load(getEmployeePermissionsCode))()

local togglePermissionCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/togglePermission.lua')
assert(load(togglePermissionCode))()

local getEmployeeWithMostTimeCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getEmployeeWithMostTime.lua')
assert(load(getEmployeeWithMostTimeCode))()

local getTopWorkersCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getTopWorkers.lua')
assert(load(getTopWorkersCode))()

local markAttendanceCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/markAttendance.lua')
assert(load(markAttendanceCode))()

local getTransactionsCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/getTransactions.lua')
assert(load(getTransactionsCode))()

local playerDroppedCode = LoadResourceFile(GetCurrentResourceName(), 'server/events/playerDropped.lua')
assert(load(playerDroppedCode))()