let isWorking = false;
let currentMinutes = 0;
let workTimerInterval = null;

window.addEventListener('message', function(event) {
    let item = event.data;

    if (item.action === "open") {
        setupTablet(item.data);
        $('#tablet-container').fadeIn(300);
    }
});

function setupTablet(data) {
    // Reseta Telas e Timers
    $('#login-screen').show();
    $('#dashboard-screen').hide();
    $('.fingerprint-container').css('border-color', 'rgba(255,255,255,0.2)');
    
    if(workTimerInterval) clearInterval(workTimerInterval);

    // Dados Básicos
    $('#player-name').text(data.playerName);
    $('#player-id').text(data.playerId);
    $('#job-name').text(data.jobName);
    
    // Stats e Finanças
    $('#online-count').text(data.onlineCount);
    let formatter = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' });
    $('#wallet-val').text(formatter.format(data.wallet || 0));
    $('#bank-val').text(formatter.format(data.bank || 0));

    // LÓGICA DO TEMPO (CORREÇÃO DE TRAVAMENTO)
    // Usamos o inteiro enviado pelo server para poder somar no JS
    currentMinutes = data.totalMinutesInt || 0;
    updateHoursDisplay(currentMinutes);

    isWorking = data.isWorking;

    if (isWorking) {
        // Se estiver trabalhando, inicia o contador local para subir os minutos na tela
        workTimerInterval = setInterval(() => {
            currentMinutes++;
            updateHoursDisplay(currentMinutes);
        }, 60000); // Soma 1 a cada 60 segundos

        $('#work-status-text').text("EM SERVIÇO");
        $('#status-ball').removeClass('off').addClass('on');
        $('#btn-ponto').text("FINALIZAR EXPEDIENTE").css('background', '#ff4757').css('color', 'white');
    } else {
        $('#work-status-text').text("DE FOLGA");
        $('#status-ball').removeClass('on').addClass('off');
        $('#btn-ponto').text("INICIAR EXPEDIENTE").css('background', '#2ed573').css('color', 'white');
    }

    // Lista de Líder
    if (data.isLeader) {
        $('#leader-area').fadeIn();
        let listHtml = '';
        if (data.workersList && data.workersList.length > 0) {
            data.workersList.forEach(w => {
                listHtml += `
                <div class="emp-item">
                    <div><span class="emp-status-dot"></span> ${w.name}</div>
                    <strong>${w.hours}</strong>
                </div>`;
            });
        } else {
            listHtml = '<p style="text-align:center; color:#aaa; margin-top:10px;">Nenhum oficial em serviço.</p>';
        }
        $('#employee-list').html(listHtml);
    } else {
        $('#leader-area').hide();
    }

    updateClock();
}

function updateHoursDisplay(totalMinutes) {
    let h = Math.floor(totalMinutes / 60);
    let m = totalMinutes % 60;
    // Formata com zero à esquerda
    let hStr = h.toString().padStart(2, '0');
    let mStr = m.toString().padStart(2, '0');
    $('#my-hours').text(`${hStr}h ${mStr}m`);
}

function autenticar() {
    $('.fingerprint-container').css('border-color', '#2ed573').css('box-shadow', '0 0 20px rgba(46, 213, 115, 0.4)');
    setTimeout(() => {
        $('#login-screen').fadeOut(300, function() {
            $('#dashboard-screen').fadeIn(300).css('display', 'flex');
        });
    }, 1000);
}

function baterPonto() {
    $.post('https://ghost_ponto/baterPonto', JSON.stringify({}));
    $('#tablet-container').fadeOut();
    if(workTimerInterval) clearInterval(workTimerInterval);
}

function fecharTablet() {
    $('#tablet-container').fadeOut();
    $.post('https://ghost_ponto/fechar', JSON.stringify({}));
    if(workTimerInterval) clearInterval(workTimerInterval);
}

function updateClock() {
    const now = new Date();
    const timeString = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
    $('#top-clock').text(timeString);
}
setInterval(updateClock, 10000);

document.onkeyup = function(data) {
    if (data.which == 27) {
        fecharTablet();
    }
};