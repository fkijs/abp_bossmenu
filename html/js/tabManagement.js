function openTab(tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tab-pane");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].classList.remove("show", "active");
    }
    tablinks = document.getElementsByClassName("nav-link");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].classList.remove("active");
    }
    document.getElementById(tabName).classList.add("show", "active");
    document.querySelector(`[data-toggle="pill"][href="#${tabName}"]`).classList.add("active");
}

function renderChart(data) {
    const ctx = document.getElementById('employeeChart').getContext('2d');

    if (employeeChart && typeof employeeChart.destroy === 'function') {
        employeeChart.destroy();
    }

    employeeChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Array.isArray(data) ? data.map(employee => employee.name) : [],
            datasets: [{
                label: 'Rendimiento',
                data: Array.isArray(data) ? data.map(employee => employee.performance) : [],
                backgroundColor: 'rgba(231, 76, 60, 0.5)',
                borderColor: 'rgba(231, 76, 60, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

function renderTransactionsChart(transactions) {
    const ctx = document.getElementById('transactionsChart').getContext('2d');

    if (transactionsChart && typeof transactionsChart.destroy === 'function') {
        transactionsChart.destroy();
    }

    transactionsChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: transactions.map(t => t.date),
            datasets: [{
                label: 'Transacciones',
                data: transactions.map(t => t.amount),
                backgroundColor: 'rgba(46, 204, 113, 0.5)',
                borderColor: 'rgba(46, 204, 113, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}