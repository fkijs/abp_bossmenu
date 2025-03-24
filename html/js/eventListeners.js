document.addEventListener('DOMContentLoaded', function() {
    const closeMenuButton = document.getElementById('closeMenu');
    const hirePlayerButton = document.getElementById('hirePlayer');
    const confirmGiveBonusButton = document.getElementById('confirmGiveBonusButton');
    const markAttendanceInButton = document.getElementById('markAttendanceIn');
    const markAttendanceOutButton = document.getElementById('markAttendanceOut');
    const depositButton = document.getElementById('depositButton');
    const withdrawButton = document.getElementById('withdrawButton');

    if (closeMenuButton) {
        closeMenuButton.addEventListener('click', closeMenu);
    }
    if (hirePlayerButton) {
        hirePlayerButton.addEventListener('click', hirePlayer);
    }
    if (confirmGiveBonusButton) {
        confirmGiveBonusButton.addEventListener('click', giveBonus);
    }
    if (markAttendanceInButton) {
        markAttendanceInButton.addEventListener('click', () => markAttendance('in'));
    }
    if (markAttendanceOutButton) {
        markAttendanceOutButton.addEventListener('click', () => markAttendance('out'));
    }

    if (depositButton) {
        depositButton.addEventListener('click', depositMoney);
    } else {
        console.error('Elemento depositButton no encontrado');
    }

    if (withdrawButton) {
        withdrawButton.addEventListener('click', withdrawMoney);
    } else {
        console.error('Elemento withdrawButton no encontrado');
    }

    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeMenu();
        }
    });

    window.addEventListener('message', function(event) {
        if (event.data.action === 'openBossMenu') {
            document.querySelector('.container-custom').style.display = 'block';
            openTab('home'); // Abrir la pestaña de inicio por defecto
            fetchPlayers();
            fetchSocietyMoney();
            fetchDashboardData();
            fetchPermissions();
            fetchEmployeeWithMostTime();
            fetchTransactions();
            fetchTopWorkers();
        } else if (event.data.action === 'closeBossMenu') {
            document.querySelector('.container-custom').style.display = 'none';
        } else if (event.data.action === 'setEmployeeWithMostTime') {
            if (event.data.employee && typeof event.data.employee === 'object') {
                document.getElementById('employee-name').textContent = `Nombre: ${event.data.employee.name}`;
                document.getElementById('employee-time').textContent = `Tiempo trabajado ${event.data.employee.time.split(' ')[0]} minutos`;
            } else {
                document.getElementById('employee-name').textContent = 'Nombre: No disponible';
                document.getElementById('employee-time').textContent = 'Tiempo trabajado: No disponible';
                console.error('Expected an object with employee data but got:', event.data.employee);
            }
        } else if (event.data.action === 'setTopWorkers') {
            const workerList = document.getElementById('workerList');
            workerList.innerHTML = '';
            if (Array.isArray(event.data.workers)) {
                event.data.workers.forEach(worker => {
                    const li = document.createElement('li');
                    li.textContent = `Nombre: ${worker.name}, Tiempo trabajado: ${worker.total_time} minutos`;
                    workerList.appendChild(li);
                });
            } else {
                console.error('Expected an array of top workers but got:', event.data.workers);
            }
        } else if (event.data.action === 'setPlayers') {
            const employeeList = document.getElementById('employeeList');
            employeeList.innerHTML = '';
            if (Array.isArray(event.data.players)) {
                event.data.players.forEach(player => {
                    const li = document.createElement('li');
                    li.className = 'list-group-item';
                    li.innerHTML = `
                        <span>${player.name} - ${player.job} (Grado: ${player.grade})</span>
                        <div class="actions">
                            <button class="btn btn-success btn-sm mr-2" onclick="promotePlayer('${player.citizenId}')">Promover</button>
                            <button class="btn btn-warning btn-sm mr-2" onclick="demotePlayer('${player.citizenId}')">Degradar</button>
                            <button class="btn btn-danger btn-sm mr-2" onclick="firePlayer('${player.citizenId}')">Despedir</button>
                            <button class="btn btn-info btn-sm" onclick="showBonusModal('${player.citizenId}')">Dar Bono</button>
                        </div>`;
                    employeeList.appendChild(li);
                });
            } else {
                console.error('Expected an array of players but got:', event.data.players);
            }
        } else if (event.data.action === 'setSocietyMoney') {
            if (typeof event.data.money === 'number') {
                document.getElementById('societyMoney').textContent = `$${event.data.money}`;
                document.getElementById('societyMoneyDisplay').textContent = `Dinero de la Sociedad: $${event.data.money}`;
            } else {
                console.error('Expected a number for society money but got:', event.data.money);
            }
        } else if (event.data.action === 'setDashboardData') {
            if (typeof event.data === 'object' && event.data !== null) {
                document.getElementById('totalEmployees').textContent = event.data.totalEmployees;
                document.getElementById('onlineNow').textContent = event.data.onlineNow;
                document.getElementById('yourRank').textContent = event.data.yourRank;
                renderChart(event.data.employees);
            } else {
                console.error('Expected an object for dashboard data but got:', event.data);
            }
        } else if (event.data.action === 'setPermissions') {
            const permissionsList = document.getElementById('permissionsList');
            permissionsList.innerHTML = '';
            if (Array.isArray(event.data.permissions)) {
                event.data.permissions.forEach(permission => {
                    const li = document.createElement('li');
                    li.className = 'list-group-item';
                    li.innerHTML = `
                        <span>${permission.name}</span>
                        <div class="actions">
                            <button class="btn btn-success btn-sm mr-2" onclick="togglePermission('${permission.id}', true)">Conceder</button>
                            <button class="btn btn-danger btn-sm" onclick="togglePermission('${permission.id}', false)">Revocar</button>
                        </div>`;
                    permissionsList.appendChild(li);
                });
            } else {
                console.error('Expected an array of permissions but got:', event.data.permissions);
            }
        } else if (event.data.action === 'setTransactions') {
            if (Array.isArray(event.data.transactions)) {
                renderTransactionsChart(event.data.transactions);
            } else {
                console.error('Expected an array of transactions but got:', event.data.transactions);
            }
        }
    });
});