// Función para cerrar el menú
function closeMenu() {
    document.querySelector('.container-custom').style.display = 'none';
    fetch(`https://abp_bossmenu/closeBossMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error closing menu:', error.message, error));
}

// Función para obtener los mejores trabajadores
function fetchTopWorkers() {
    fetch(`https://abp_bossmenu/getTopWorkers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        }
    }).catch(error => console.error('Error fetching top workers:', error.message, error));
}

// Función para contratar un jugador
function hirePlayer() {
    const citizenid = document.getElementById('recruitID').value;
    if (citizenid) {
        fetch(`https://abp_bossmenu/hirePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ citizenid: citizenid }),
        }).catch(error => console.error('Error hiring player:', error.message, error));
    }
}

// Función para promover un jugador
function promotePlayer(citizenid) {
    if (citizenid) {
        fetch(`https://abp_bossmenu/promotePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ citizenid: citizenid }),
        }).catch(error => console.error('Error promoting player:', error.message, error));
    }
}

// Función para degradar un jugador
function demotePlayer(citizenid) {
    if (citizenid) {
        fetch(`https://abp_bossmenu/demotePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ citizenid: citizenid }),
        }).catch(error => console.error('Error demoting player:', error.message, error));
    }
}

// Función para despedir un jugador
function firePlayer(citizenid) {
    if (citizenid) {
        fetch(`https://abp_bossmenu/firePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ citizenid: citizenid }),
        }).catch(error => console.error('Error firing player:', error.message, error));
    }
}

// Función para mostrar el modal de bonificación
function showBonusModal(citizenid) {
    document.getElementById('bonusCitizenId').value = citizenid;
    $('#bonusModal').modal('show'); // Requiere jQuery y Bootstrap
}

// Función para cerrar el modal de bonificación
function closeBonusModal() {
    $('#bonusModal').modal('hide'); // Requiere jQuery y Bootstrap
}

// Función para otorgar un bono
function giveBonus() {
    const citizenid = document.getElementById('bonusCitizenId').value;
    const bonusAmount = document.getElementById('bonusModalAmount').value;
    if (citizenid && bonusAmount) {
        fetch(`https://abp_bossmenu/giveBonus`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ citizenid: citizenid, bonusAmount: parseInt(bonusAmount) }),
        })
        .then(response => {
            if (response.ok) {
                closeBonusModal();
                return response.json();
            } else {
                throw new Error('Error giving bonus');
            }
        })
        .then(data => {
            if (data.success) {
                console.log('Bono otorgado exitosamente');
            } else {
                console.log('Error al otorgar bono');
            }
        })
        .catch(error => console.error('Error giving bonus:', error.message, error));
    }
}

// Función para marcar asistencia
function markAttendance(type) {
    fetch(`https://abp_bossmenu/markAttendance`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ type: type }),
    }).catch(error => console.error('Error marking attendance:', error.message, error));
}

// Función para obtener la lista de jugadores
function fetchPlayers() {
    fetch(`https://abp_bossmenu/getPlayers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error fetching players:', error.message, error));
}

// Función para obtener el dinero de la sociedad
function fetchSocietyMoney() {
    fetch(`https://abp_bossmenu/getSocietyMoney`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error fetching society money:', error.message, error));
}

// Función para obtener datos del dashboard
function fetchDashboardData() {
    fetch(`https://abp_bossmenu/getDashboardData`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error fetching dashboard data:', error.message, error));
}

// Función para obtener permisos
function fetchPermissions() {
    fetch(`https://abp_bossmenu/getPermissions`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error fetching permissions:', error.message, error));
}

// Función para obtener el empleado con más tiempo
function fetchEmployeeWithMostTime() {
    fetch(`https://abp_bossmenu/getEmployeeWithMostTime`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error fetching employee with most time:', error.message, error));
}

// Función para obtener transacciones
function fetchTransactions() {
    fetch(`https://abp_bossmenu/getTransactions`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    }).catch(error => console.error('Error fetching transactions:', error.message, error));
}

// Función para alternar permisos
function togglePermission(permissionId, grant) {
    fetch(`https://abp_bossmenu/togglePermission`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ permissionId: permissionId, grant: grant }),
    }).catch(error => console.error('Error toggling permission:', error.message, error));
}

// Función para validar el monto
function isValidAmount(amount) {
    const parsedAmount = parseFloat(amount);
    return !isNaN(parsedAmount) && parsedAmount > 0 && amount !== '' && amount !== null && amount !== undefined;
}

// Función para verificar la respuesta del fetch
function checkResponse(response) {
    if (!response.ok) {
        throw new Error(`Error HTTP: ${response.status}`);
    }
    return response.json(); // Devuelve los datos en formato JSON si la respuesta es válida
}

// Función para enviar notificaciones al cliente (FiveM)
function sendNotification(message, type) {
    fetch(`https://abp_bossmenu/notify`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ message: message, type: type }),
    })
    .catch(error => console.error('Error sending notification:', error.message, error));
}

// Función para depositar dinero
function depositMoney() {
    const amount = document.getElementById('depositAmount').value;
    if (isValidAmount(amount)) {
        fetch(`https://abp_bossmenu/depositSocietyMoney`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ amount: parseFloat(amount) }),
        })
        .then(checkResponse)
        .then((data) => {
            fetchSocietyMoney(); // Actualizar el dinero de la sociedad después de depositar
            sendNotification('Depósito exitoso', 'success');
        })
        .catch(error => {
            console.error('Error depositing money:', error.message, error);
            sendNotification('Error al depositar dinero', 'error');
        });
    } else {
        console.error('Cantidad inválida para depositar');
        sendNotification('Cantidad inválida para depositar', 'error');
    }
}

// Función para retirar dinero
function withdrawMoney() {
    const amount = document.getElementById('withdrawAmount').value;
    if (isValidAmount(amount)) {
        fetch(`https://abp_bossmenu/withdrawSocietyMoney`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ amount: parseFloat(amount) }),
        })
        .then(checkResponse)
        .then((data) => {
            fetchSocietyMoney(); // Actualizar el dinero de la sociedad después de retirar
            sendNotification('Retiro exitoso', 'success');
        })
        .catch(error => {
            console.error('Error withdrawing money:', error.message, error);
            sendNotification('Error al retirar dinero', 'error');
        });
    } else {
        console.error('Cantidad inválida para retirar');
        sendNotification('Cantidad inválida para retirar', 'error');
    }
}