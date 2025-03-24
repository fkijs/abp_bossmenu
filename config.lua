local QBCore = exports['qb-core']:GetCoreObject()
Config = {}

Config.JobWhitelisted = {
    'police',
    'ambulance',
    'firefighter',
    'redcircle',
    -- Añadir más trabajos según sea necesario
}

Config.BossGrades = {
    police = 3,        -- Grado del jefe para la policía
    ambulance = 11,    -- Grado del jefe para los paramédicos
    firefighter = 5,   -- Grado del jefe para los bomberos
    redcircle = 4,     -- Grado del jefe para los trabajadores de la ciudad
    mechanic = 4,      -- Grado del jefe para los mecánicos
    -- Añadir más configuraciones según sea necesario
}

-- Configuración para items
Config.Items = {
    pixellaptop = {
        action = function()
            startTabletAnim()
            QBCore.Functions.Notify(Config.Notifications.OpenBossMenu, 'info')
            Citizen.Wait(2000)
            OpenBossMenu()
        end
    }
}

-- Nueva sección para configuración de asistencia
Config.Attendance = {
    TimeFormat = "%Y-%m-%d %H:%M:%S", -- Formato de fecha y hora
    WebhookMessages = {
        Entry = "Hora de entrada a servicio: %s | ID: %s | Empleado: %s | Citizen ID: %s",
        Exit = "Hora de salida de servicio: %s | ID: %s | Empleado: %s | Citizen ID: %s | Tiempo en servicio: %d minutos"
    },
    TimeUnit = "minutes" -- Unidad de tiempo para total_time (puede ser "minutes" o "seconds")
}

Config.DebugMode = false -- Cambiar a true para activar el modo de depuración

Config.UseRenewedBanking = true -- Cambiar a false para usar una exportación personalizada

Config.Export = {
    SocietyMoney = "YourExportSocietyMoney", -- export -- Obtener dinero de la sociedad
    DepositMoney = "YourExportDepositMoney", -- export -- Depositar dinero en la cuenta de la sociedad
    WithdrawMoney = "YourExportWithdrawMoney" -- export -- Retirar dinero de la cuenta de la sociedad
}

-- Notificaciones generales
Config.Notifications = {
    HireSuccess = '¡Jugador contratado con éxito!',
    HireFailed = '¡Error al contratar al jugador!',
    PromoteSuccess = '¡Jugador promovido con éxito!',
    PromoteFailed = '¡Error al promover al jugador!',
    DemoteSuccess = '¡Jugador degradado con éxito!',
    DemoteFailed = '¡Error al degradar al jugador!',
    FireSuccess = '¡Jugador despedido con éxito!',
    FireFailed = '¡Error al despedir al jugador!',
    BonusSuccess = '¡Bonificación otorgada con éxito!',
    PlayerNotFound = '¡Jugador no encontrado!',
    DepositSuccess = '¡Dinero depositado con éxito!',
    DepositFailed = '¡Error al depositar dinero!',
    WithdrawSuccess = '¡Dinero retirado con éxito!',
    WithdrawFailed = '¡Error al retirar dinero!',
    MarkSuccess = '¡Marcado con éxito!',
    MarkFailed = '¡Error al marcar!',
    PermissionUpdated = 'Permiso actualizado correctamente',
    webhookerror = '¡Error al registrar la salida!',
    errortransaction = 'No tienes permisos para ver las transacciones',
    entrancerror = '¡Error al obtener la hora de entrada!',
    NoPermissionUpdated = '¡No tienes permisos para actualizar los permisos!',
    CreatePermisionErorr = '¡Error al crear el permiso!',
    ErrorPermisions = '¡Error al actualizar los permisos!',
    ErrorUpdatedPermision = '¡No tienes permisos para ver los permisos de este empleado!',
    NoErrorPermision = '¡No tienes permisos para ver los permisos de los empleado!',
    NoPermisionDashboard = '¡No tienes permisos para ver el Dashboard!',
    InsuficientMoneySociety = '¡No tienes suficiente dinero en la sociedad!',
    NoPermisionMoney = '¡No tienes permisos para retirar dinero!',
    NoPermisionMoneyDep = '¡No tienes permisos para depositar dinero!',
    NoPermisionMoneySociety = '¡No tienes permisos para ver el dinero de la sociedad!',
    NoPermisionListPlayer = '¡No tienes permisos para ver la lista de jugadores!',
    NoPermisionBonus = '¡No tienes permisos para dar bonificaciones!',
    ErrorDespedir = '¡No tienes permisos para despedir a jugadores!',
    ErrorCiudadano = '¡No tienes permisos para despedir a este ciudadano!',
    ErrorDespedido = '¡Has sido despedido!',
    EmployerDespedido = '¡Has despedido a un empleado!',
    NoYouDespedir = '¡No puedes despedirte a ti mismo!',
    OpenBossMenu = 'Abriendo menú del jefe...',
    -- Nuevas notificaciones para asistencia
    EntrySuccess = 'Entrada marcada con éxito',
    EntryFailed = 'Error al registrar la entrada',
    ExitSuccess = 'Salida marcada con éxito',
    ExitFailed = 'Error al registrar la salida',
    NoEntryFound = 'No se pudo encontrar la hora de entrada',
    InvalidTimeFormat = 'Formato de hora de entrada incorrecto'
}