const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'zr_arsenal';

window.addEventListener('message', function(event) {
    if (event.data.showMenu) {
        let app = document.getElementById('app');
        
        // SÓ reseta para 'rifles' se o menu estava fechado. 
        // Se já estava aberto, mantém onde estás.
        if (app.style.display !== 'flex') {
            changeCategory('rifles');
        }

        app.style.display = 'flex';
        
        // Garante que os ícones (incluindo o do sidebar) carreguem
        if (window.lucide) lucide.createIcons(); 
    } else if (event.data.type === 'close') {
        closeMenu();
    }
});

document.onkeyup = function(data) {
    if (data.which == 27) {
        closeMenu();
    }
};

function closeMenu() {
    document.getElementById('app').style.display = 'none';
    fetch(`https://${resourceName}/NUIFocusOff`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    }).catch(err => console.log('Erro ao fechar:', err));
}

function changeCategory(categoryName) {
    document.querySelectorAll('.category-group').forEach(el => el.classList.add('hidden'));
    document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.remove('active'));

    let target = document.getElementById(categoryName);
    if (target) target.classList.remove('hidden');

    const btnIndex = { 'rifles': 0, 'pistolas': 1, 'utilitarios': 2 };
    let btns = document.querySelectorAll('.nav-btn');
    if (btns[btnIndex[categoryName]]) {
        btns[btnIndex[categoryName]].classList.add('active');
    }

    if (window.lucide) lucide.createIcons();
}

function handleAction(action, element) {
    fetch(`https://${resourceName}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ action: action })
    }).catch(err => console.error('Erro no fetch:', err));

    // Feedback Visual no Botão (o elemento passado agora é o próprio botão)
    let btn = element;

    if (btn) {
        let originalText = btn.textContent;
        
        btn.classList.add('success');
        
        if (action === 'Limpar') {
            btn.innerHTML = 'LIMPO!'; 
        } else {
            btn.innerHTML = 'EQUIPADO!'; 
        }

        setTimeout(() => {
            btn.classList.remove('success');
            btn.textContent = originalText;
        }, 1000);
    }
}