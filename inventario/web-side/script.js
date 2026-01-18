
// var weight_bar = new ldBar(".weight_bar",
//     {
//         "value": 50,
//         "fill-background-extrude": 0,
//         "fill-background": '#ffffff80',
//         "fill": 'blue',
//         "fill-dir": 'btt',
//         "type": 'fill',
//         "min": 1,
//         "max": 100,
//     }
// );

const imageURL = "http://127.0.0.1/inventario/"; // Coloque seu IP aqui

function milhar(n) {
    var n = '' + n, t = n.length - 1, novo = '';

    for (var i = t, a = 1; i >= 0; i--, a++) {
        var ponto = a % 3 == 0 && i > 0 ? '.' : '';
        novo = ponto + n.charAt(i) + novo;
    }
    return novo;
}

const mySlots = 50;
const inSlots = 150;

let shiftPressed = false;
let delay = false;

let progressBarInstance = null;

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* INIT */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
$(document).ready(function () {
    $(".inventory").hide(); // Garante que começa escondido
    window.addEventListener("message", function (event) {

        switch (event.data.action) {
            case "hideMenu":
                $(".inventory").css("display", "none")
                break;

            case "showMenu":
                updateMochila();
                $(".use").css("display", "block")
                $(".send").css("display", "block")
                $(".inventory").css("display", "flex")
                $(".myInfos2").html("");
                $(".amount").val(0);
                break;

            case "updateMochila":
                updateMochila();
                break;

            case "showProgress":
                // Mostra o container
                $(".progress-container").fadeIn(200);

                // Inicializa a barra se ainda não existe
                if (!progressBarInstance) {
                    progressBarInstance = new ldBar("#progressBar");
                }

                // Reseta a barra para 0
                progressBarInstance.set(0);

                // Animação manual para sincronizar perfeitamente com o tempo do servidor
                let duration = event.data.time;
                let startTime = Date.now();
                let interval = setInterval(() => {
                    let elapsed = Date.now() - startTime;
                    let progress = (elapsed / duration) * 100;

                    if (progress >= 100) {
                        progress = 100;
                        clearInterval(interval);
                        // Esconde a barra após completar
                        $(".progress-container").fadeOut(500);
                    }
                    
                    progressBarInstance.set(progress);
                }, 16); // Atualiza a cada ~16ms (60fps)
                break;  
                
                
                case "itemNotify":
            // Define o sinal (+ ou -) e a classe de cor
            let modeClass = event.data.mode === "adicionado" ? "add" : "rem";
            let symbol = event.data.mode === "adicionado" ? "+" : "-";
            
            // Define o IP para pegar a imagem (mesma lógica que usamos antes)
            // Se você já tem uma variável const imageURL definida, use ela.
            // Caso contrário, use o IP direto:
            let imgUrl = `http://127.0.0.1/inventario/${event.data.item}.png`; 

            // Cria o HTML do card
            let html = `
                <div class="item-notify ${modeClass}">
                    <img src="${imgUrl}" onerror="this.src='http://127.0.0.1/inventario/error.png'">
                    <div class="notify-info">
                        <span>${event.data.name}</span>
                        <small>${symbol} ${event.data.amount} ${event.data.mode}</small>
                    </div>
                </div>
            `;

            // Adiciona na tela
            let $element = $(html).appendTo("#notify-container");

            // Remove o elemento da tela depois de 4 segundos (tempo da animação + leitura)
            setTimeout(() => {
                $element.remove();
            }, 4000);
        break;

        case "showHotbar":
            // Alterna a classe 'active' (se tem tira, se não tem põe)
            let $hotbar = $(".hotbar-container");
            if ($hotbar.hasClass("active")) {
                $hotbar.removeClass("active");
            } else {
                $hotbar.addClass("active");
                // Opcional: Esconder automaticamente após 5 segundos
                /* setTimeout(() => {
                    $hotbar.removeClass("active");
                }, 5000); 
                */
            }
        break;

        case "updateHotbar":
                // Limpa os slots visualmente
                $(".hotbar-slot").css("background-image", "none").html(""); 

                // Recoloca os números dos slots (1, 2, 3, 4, 5)
                $(".hotbar-slot").each(function() {
                    $(this).text($(this).data("slot")); 
                });

                // Se receber itens, preenche os slots corretos
                if (event.data.items) {
                    $.each(event.data.items, function(slot, data) {
                        if (slot <= 5) { // Garante que é só até o slot 5
                            let $slot = $(`.hotbar-slot[data-slot='${slot}']`);
                            
                            // CORREÇÃO AQUI: Usamos a variável imageURL correta do seu script
                            $slot.css("background-image", `url('${imageURL}${data.item}.png')`);
                            
                            // Mostra a quantidade no cantinho
                            $slot.append(`<div class="hotbar-amount">${data.amount}x</div>`);
                        }
                    });
                }
            break;

            case "showVehicles":
                requestVehicles();
                $(".use").css("display", "none")
                $(".send").css("display", "none")
                $(".inventory").css("display", "flex")
                $(".myInfos2").html("");
                $(".amount").val(0);
                break;

            case "updateVehicles":
                requestVehicles();
                break;

            case "showOrgChest":
                requestOrgChest();
                $(".use").css("display", "none")
                $(".send").css("display", "none")
                $(".inventory").css("display", "flex")
                $(".myInfos2").html("");
                $(".amount").val(0);
                break;

            case "updateOrgChest":
                requestOrgChest();
                break;

            case "showChestHouse":
                requestHouseChest();
                $(".use").css("display", "none")
                $(".send").css("display", "none")
                $(".inventory").css("display", "flex")
                $(".myInfos2").html("");
                $(".amount").val(0);
                break;

            case "updateChestHouse":
                requestHouseChest();
                break;

            case "showStore":
                requestStore();
                $(".use").css("display", "none")
                $(".send").css("display", "none")
                $(".inventory").css("display", "flex")
                $(".myInfos2").html("");
                $(".amount").val(0);
                break;

            case "updateStore":
                requestStore();
                break;

            case "showRevistar":
                requestRevistar();
                $(".use").css("display", "none")
                $(".send").css("display", "none")
                $(".inventory").css("display", "flex")
                $(".myInfos2").html("");
                $(".amount").val(0);
                break;

            case "updateRevistar":
                requestRevistar();
                break;
        }
    });

    document.onkeydown = data => {
        const key = data.key;
        if (key === "Shift") {
            shiftPressed = true;
        }
    }

    document.onkeyup = data => {
        const key = data.key;
        if (key === "Escape") {
            $.post("http://inventario/invClose");
        } else if (key === "Shift") {
            shiftPressed = false;
        }
    };

    $('body').mousedown(e => {
        if (e.button == 1) return false;
    });

    $('.close').click(function () {
        $.post("http://inventario/invClose", JSON.stringify({}));
    });
});

/* ---------------------------------------------------------------------------------------
   SISTEMA DE MENU DE CONTEXTO (CORRIGIDO)
--------------------------------------------------------------------------------------- */
// Fecha o menu se o inventário for fechado pelo NUI
window.addEventListener("message", function (event) {
    if (event.data.action == "hideMenu" || event.data.action == "close") {
        $("#context-menu").hide();
    }
});

$(document).keyup(function(e) {
    if (e.key === "Escape") {
        $("#context-menu").hide();
        selectedItemData = null;
    }
});

/* ---------------------------------------------------------------------------------------
   SISTEMA DE MENU DE CONTEXTO (CORRIGIDO E TESTADO)
--------------------------------------------------------------------------------------- */
let selectedItemData = null; // Variável global para guardar o item selecionado

// Listener para abrir o menu com Botão Direito
$(document).on("contextmenu", ".item", function(e) {
    e.preventDefault(); // Impede o menu padrão do Windows

    // Tenta pegar os dados do item clicado
    // IMPORTANTE: Seu HTML usa data-item-key, não data-item
    const itemKey = $(this).data("item-key");
    const slot = $(this).data("slot");
    const amount = $(this).data("amount");

    // [BLINDAGEM] Se clicou num slot vazio ou sem item, não faz nada
    if (!itemKey || itemKey === undefined) {
        $("#context-menu").hide();
        return;
    }

    // Salva os dados para usarmos depois
    selectedItemData = { 
        item: itemKey, 
        slot: slot, 
        amount: amount 
    };

    // [DEBUG] Mostra no console (F8) o que você clicou, ajuda a ver se tá pegando certo
    // console.log("Abriu menu para:", itemKey);

    // Lógica para mostrar opções de arma
    // Usamos .toString() para garantir que é texto antes do toUpperCase
    if (itemKey.toString().toUpperCase().includes("WEAPON_")) {
        $(".weapon-only").show();
    } else {
        $(".weapon-only").hide();
    }

    // Cálculos para o menu não sair da tela
    let top = e.clientY;
    let left = e.clientX;
    
    // Se passar da largura/altura da tela, ajusta
    if (left + 180 > window.innerWidth) left = window.innerWidth - 190;
    if (top + 200 > window.innerHeight) top = window.innerHeight - 210;

    // Mostra o menu na posição correta
    $("#context-menu").css({
        "display": "block",
        "top": top + "px",
        "left": left + "px"
    });
});

$(document).on("click", function(e) {
    // Se o clique não foi DENTRO do menu, fecha ele
    if (!$(e.target).closest("#context-menu").length) {
        $("#context-menu").hide();
    }
});

// Ações do menu
$(".context-option").on("click", function() {
    // Pega qual ação foi clicada (data-action="use", etc)
    const action = $(this).data("action");
    
    // Se não tiver item selecionado (por algum bug), para
    if (!selectedItemData || !selectedItemData.item) return;

    // Executa a ação
    switch(action) {
        case "use":
            // Envia para o servidor usar o item
            $.post("http://inventario/useItem", JSON.stringify({
                item: selectedItemData.item,
                slot: selectedItemData.slot,
                amount: 1 // Usa 1 por padrão
            }));
            break;

        case "drop":
            // Dropa o item
            $.post("http://inventario/dropItem", JSON.stringify({
                item: selectedItemData.item,
                slot: selectedItemData.slot,
                amount: parseInt(selectedItemData.amount) // Dropa tudo ou ajuste se quiser perguntar qtd
            }));
            break;

        case "send":
            // Para enviar, geralmente precisa abrir um input de ID. 
            // Se ainda não tiver, deixe comentado ou implemente depois.
             $.post("http://inventario/sendItem", JSON.stringify({
                item: selectedItemData.item,
                slot: selectedItemData.slot,
                amount: parseInt(selectedItemData.amount)
            }));
            break;
            
        case "removeAmmo":
             $.post("http://inventario/removeAmmo", JSON.stringify({
                item: selectedItemData.item
            }));
            break;

        case "checkSerial":
             $.post("http://inventario/checkSerial", JSON.stringify({
                item: selectedItemData.item
            }));
            break;
    }

    // Fecha o menu e limpa a seleção
    $("#context-menu").hide();
    selectedItemData = null;
});


/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* SISTEMA DO INVENTARIO JOGADOR */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
let weightLeft = 0;
let maxWeightLeft = 0;

const colorPicker = (percent) => {
    var colorPercent = "#2e6e4c";

    if (percent >= 100)
        colorPercent = "rgba(255,255,255,0)";

    if (percent >= 51 && percent <= 75)
        colorPercent = "#fcc458";

    if (percent >= 26 && percent <= 50)
        colorPercent = "#fc8a58";

    if (percent <= 25)
        colorPercent = "#fc5858";

    return colorPercent;
}

const updateMochila = () => {
    $.post("http://inventario/requestMochila", JSON.stringify({}), (data) => {

        $(".invLeft").html("");
        $(".invRight").html("");
        $("#invpeso").html('CHÃO')

        // let porcentage = data.peso * 100 / data.maxpeso;

        // weight_bar.set(porcentage)
        $('.weight_info').html(`
            ${(data.peso).toFixed(2)}/${(data.maxpeso).toFixed(2)}
        `)

        $(".banco").html( " R$ " + milhar(data.banco) )

        $('.carteira').html( " R$ " + milhar(data.carteira) )

        // $(".banco").html("R$" + milhar(data.baco[2]))

        // $('.carteira').html(` ${(data.carteira).toFixed(2)} `)

        $(".on").removeClass('on');
        if (data.amountMoc == 1) {
            $(".one").addClass('on');
        } else if (data.amountMoc == 2) {
            $(".one").addClass('on');
            $(".two").addClass('on');
        } else if (data.amountMoc >= 3) {
            $(".one").addClass('on');
            $(".two").addClass('on');
            $(".tree").addClass('on');
        }

        const nameList2 = data.drop.sort((a, b) => (a.name > b.name) ? 1 : -1);
        for (let x = 1; x <= mySlots; x++) {
            const slot = x.toString();
            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                let barra = 2;
                var actualPercent = parseInt(newDurability * 100);


                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                       
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invLeft").append(item);
            }
        }

        for (let x = 1; x <= inSlots; x++) {
            const slot = x.toString();
            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                // durabilidade
               // console.log(v)
                 //console.log(JSON.stringify(v.tempo));
                 const maxDurability = 86400 * v.dias;
                 const newDurability = (maxDurability - (v.tempo ?? 0)) / maxDurability;
                 let barra = 2;
                 var actualPercent = parseInt(newDurability * 100);


                // durabilidade
                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-id="${v.id}" data-grid="${v.grid}" data-amount="${v.amount}" data-peso="${v.peso}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                        
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invRight").append(item);
            }
        }

        updateDrag();
    });
}

const updateDrag = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (ui.draggable.parent()[0] == undefined) return;

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            if (origin === "invRight" && tInv === "invRight") return;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const targetname = $(this).data('item-key');
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount | (itemData.key == "dinheiro" && origin === "invLeft" && tInv === "invLeft")) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }


            $('.populated, .empty, .use').off("draggable droppable");
            $('.populated, .empty, .send').off("draggable droppable");

            let clone1 = ui.draggable.clone();
            let slot2 = $(this).data("slot");
            if (amount == itemAmount) {
                let clone2 = $(this).clone();
                let slot1 = ui.draggable.data("slot");

                $(this).replaceWith(clone1);
                ui.draggable.replaceWith(clone2);

                $(clone1).data("slot", slot2);
                $(clone2).data("slot", slot1);
            } else {
                let newAmountOldItem = itemAmount - amount;
                let weight = parseFloat(ui.draggable.children(".top").children(".itemWeight").html());
                let weightPerItem = (weight / itemAmount).toFixed(2);
                let newWeightClone1 = (amount * weightPerItem).toFixed(2);
                let newWeightOldItem = (newAmountOldItem * weightPerItem).toFixed(2);

                ui.draggable.data("amount", newAmountOldItem);

                clone1.data("amount", amount);

                $(this).replaceWith(clone1);
                $(clone1).data("slot", slot2);

                ui.draggable.children(".top").children(".itemAmount").html(ui.draggable.data("amount") + "x");
                ui.draggable.children(".top").children(".itemWeight").html(newWeightOldItem);

                $(clone1).children(".top").children(".itemAmount").html(clone1.data("amount") + "x");
                $(clone1).children(".top").children(".itemWeight").html(newWeightClone1);
            }

            let futureWeightLeft = weightLeft;

            if (origin === "invLeft" && tInv === "invRight") {
                futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('peso')) * amount);
            } else if (origin === "invRight" && tInv === "invLeft") {
                futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('peso')) * amount);
            }

            weightLeft = futureWeightLeft;

            if (origin === "invLeft" && tInv === "invLeft") {
                $.post("http://inventario/updateSlot", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target
                }));
            } else if (origin === "invRight" && tInv === "invLeft") {
                const id = ui.draggable.data("id");
                const grid = ui.draggable.data("grid")
                $.post("http://inventario/pickupItem", JSON.stringify({
                    id: id,
                    grid: grid,
                    target: target,
                    amount: parseInt(amount)
                }));
            } else if (origin === "invLeft" && tInv === "invRight") {
                $.post("http://inventario/dropItem", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount)
                }));
            }

            updateDrag();
            updateMochila();
        }
    });

    $('.populated').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (ui.draggable.parent()[0] == undefined) return;

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            if (origin === "invRight" && tInv === "invRight") return;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');
            const targetname = $(this).data('item-key');
            const targetamount = $(this).data('amount');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if ($(".amount").val() == "" | parseInt($(".amount").val()) == 0 | itemData.key != targetname | shiftPressed) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (amount > itemAmount) {
                amount = itemAmount;
            }


            $('.populated, .empty, .use').off("draggable droppable");
            $('.populated, .empty, .send').off("draggable droppable");

            let futureWeightLeft = weightLeft;

            if (ui.draggable.data('item-key') == $(this).data('item-key')) {
                let newSlotAmount = amount + parseInt($(this).data('amount'));
                let newSlotWeight = parseFloat(ui.draggable.children(".top").children(".itemWeight").html()) + parseFloat($(this).children(".top").children(".itemWeight").html());

                $(this).data('amount', newSlotAmount);
                $(this).children(".top").children(".itemAmount").html(newSlotAmount + "x");
                $(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

                if (amount == itemAmount) {
                    ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
                } else {
                    let newMovedAmount = itemAmount - amount;
                    let newMovedWeight = newMovedAmount * parseFloat(ui.draggable.data("peso"));

                    ui.draggable.data('amount', newMovedAmount);
                    ui.draggable.children(".top").children(".itemAmount").html(newMovedAmount + "x");
                    ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
                }

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('peso')) * amount);
                } else if (origin === "invRight" && tInv === "invLeft") {
                    futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('peso')) * amount);
                }
            } else {
                if (origin === "invRight" && tInv === "invLeft") return;

                let clone1 = ui.draggable.clone();
                let clone2 = $(this).clone();

                let slot1 = ui.draggable.data("slot");
                let slot2 = $(this).data("slot");

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - parseFloat(ui.draggable.data('amount')) + parseFloat($(this).data('amount'));
                }

                ui.draggable.replaceWith(clone2);
                $(this).replaceWith(clone1);

                $(clone1).data("slot", slot2);
                $(clone2).data("slot", slot1);
            }

            if (origin === "invLeft" && tInv === "invLeft") {
                $.post("http://inventario/updateSlot", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            }

            updateDrag();
            updateMochila();
        }
    });

    $('.use').droppable({
        hoverClass: 'hoverControl',
        over: function (event, ui) {
            $('.use').addClass('select_hover');
        },
        out: function (event, ui) {
            $('.select_hover').removeClass('select_hover');
        },
        drop: function (event, ui) {
            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined || origin === "invRight") return;
            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

            if (itemData.key === undefined) return;

            $.post("http://inventario/useItem", JSON.stringify({
                item: itemData.key,
                slot: itemData.slot,
                amount: parseInt(parseInt($(".amount").val()))
            }));

            $('.select_hover').removeClass('select_hover');
        }
    });

    $('.send').droppable({
        hoverClass: 'hoverControl',
        over: function (event, ui) {
            $('.send').addClass('select_hover');
        },
        out: function (event, ui) {
            $('.select_hover').removeClass('select_hover');
        },
        drop: function (event, ui) {
            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined || origin === "invRight") return;
            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

            if (itemData.key === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            $.post("http://inventario/sendItem", JSON.stringify({
                item: itemData.key,
                slot: itemData.slot,
                amount: amount
            }));

            $('.select_hover').removeClass('select_hover');
        }
    });

    $(document).keyup(function(e) {
    if (e.key === "Escape") {
        $("#context-menu").hide();
    }
});

$(document).on("mousedown", function(e) {
    // Se o clique NÃO for dentro do menu de contexto, esconde ele
    if (!$(e.target).closest("#context-menu").length) {
        $("#context-menu").hide();
    }
});
}



//     $(".populated").on("auxclick", e => {
//         e.preventDefault();
//         if (e.which === 3) {
//             const item = e.target;
//             const origin = $(item).parent()[0].className;
//             if (origin === undefined || origin === "invRight") return;

//             itemData = { key: $(item).data('item-key'), slot: $(item).data('slot') };

//             if (itemData.key === undefined) return;

//             $.post("http://inventario/useItem", JSON.stringify({
//                 item: itemData.key,
//                 slot: itemData.slot,
//                 amount: parseInt(parseInt($(".amount").val()))
//             }));
//         }
//     });
// }

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* SISTEMA DE INVENTARIO VEICULOS */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
const requestVehicles = () => {
    $.post("http://inventario/requestVehicle", JSON.stringify({}), (data) => {

        // let porcentage = data.peso * 100 / data.maxpeso;
        // weight_bar.set(porcentage)
        $('.weight_info').html(`
            ${(data.peso).toFixed(2)}/${(data.maxpeso).toFixed(2)}
        `)

        $(".pesoBau").html(`
            ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}
		`);

        $("#invpeso").html(`VEICULO - ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}`)

        vehicleWeightLeft = data.peso2;
        vehicleMaxWeightLeft = data.maxpeso2;

        $(".on").removeClass('on');
        if (data.amountMoc == 1) {
            $(".one").addClass('on');
        } else if (data.amountMoc == 2) {
            $(".one").addClass('on');
            $(".two").addClass('on');
        } else if (data.amountMoc >= 3) {
            $(".one").addClass('on');
            $(".two").addClass('on');
            $(".tree").addClass('on');
        }

        $(".invLeft").html("");
        $(".invRight").html("");
        for (let x = 1; x <= mySlots; x++) {
            const slot = x.toString();

            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade
                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invLeft").append(item);
            }
        }


        for (let x = 1; x <= inSlots; x++) {
            const slot = x.toString();
            if (data.inventario2[slot] !== undefined) {
                const v = data.inventario2[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade
                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-size: 55% !important; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invRight").append(item);
            }
        }

        updateDragVehicles();
    });
}

const updateDragVehicles = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount | (itemData.key == "dinheiro" && origin === "invLeft" && tInv === "invLeft")) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (tInv === "invLeft") {
                if (origin === "invLeft") {
                    $.post("http://inventario/updateSlot", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invRight") {
                    $.post("http://inventario/takeVehicle", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }));
                }

            } else if (tInv === "invRight") {
                if (origin === "invRight") {
                    $.post("http://inventario/updateVehicleSlots", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invLeft") {
                    
                   // console.log(JSON.stringify(itemData));
                    $.post("http://inventario/storeVehicle", JSON.stringify({
                        item: itemData.key,
                        slot: target,
                        slot2: itemData.slot,
                        amount: amount
                    }));
                }
            }

            requestVehicles()
            updateDragVehicles()
        }
    });


    $('.populated').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            if (ui.draggable.parent()[0] == undefined) return;

            const origin = ui.draggable.parent()[0].className;


            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');
            const targetname = $(this).data('item-key');
            const targetamount = $(this).data('amount');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if ($(".amount").val() == "" | parseInt($(".amount").val()) == 0 | itemData.key != targetname | shiftPressed) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (amount > itemAmount) {
                amount = itemAmount;
            }

            let futureWeightLeft = weightLeft;

            if (ui.draggable.data('item-key') == $(this).data('item-key')) {
                let newSlotAmount = amount + parseInt($(this).data('amount'));
                let newSlotWeight = parseFloat(ui.draggable.children(".top").children(".itemWeight").html()) + parseFloat($(this).children(".top").children(".itemWeight").html());

                $(this).data('amount', newSlotAmount);
                $(this).children(".top").children(".itemAmount").html(newSlotAmount + "x");
                $(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

                if (amount == itemAmount) {
                    ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
                } else {
                    let newMovedAmount = itemAmount - amount;
                    let newMovedWeight = newMovedAmount * parseFloat(ui.draggable.data("peso"));

                    ui.draggable.data('amount', newMovedAmount);
                    ui.draggable.children(".top").children(".itemAmount").html(newMovedAmount + "x");
                    ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
                }

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('peso')) * amount);
                } else if (origin === "invRight" && tInv === "invLeft") {
                    futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('peso')) * amount);
                }
            } else {
                if (origin === "invRight" && tInv === "invLeft") return;

                let clone1 = ui.draggable.clone();
                let clone2 = $(this).clone();

                let slot1 = ui.draggable.data("slot");
                let slot2 = $(this).data("slot");

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - parseFloat(ui.draggable.data('amount')) + parseFloat($(this).data('amount'));
                }

                ui.draggable.replaceWith(clone2);
                $(this).replaceWith(clone1);

                $(clone1).data("slot", slot2);
                $(clone2).data("slot", slot1);
            }



            if (origin === "invLeft" && tInv === "invLeft") {
                $.post("http://inventario/updateSlot", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            } else if (origin === "invRight" && tInv === "invRight") {
                $.post("http://inventario/updateVehicleSlots", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            }

            requestVehicles()
            updateDragVehicles()
        }
    });

}

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* SISTEMA DE INVENTARIO DA ORGANIZACAO */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
const requestOrgChest = () => {
    $.post("http://inventario/requestOrgChest", JSON.stringify({}), (data) => {
        // let porcentage = data.peso * 100 / data.maxpeso;
        // weight_bar.set(porcentage)
        $('.weight_info').html(`
            ${(data.peso).toFixed(2)}/${(data.maxpeso).toFixed(2)}
        `)

        $(".pesoBau").html(`
            ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}
		`);

        $("#invpeso").html(`ORG ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}`)

        $(".on").removeClass('on');
        if (data.amountMoc == 1) {
            $(".one").addClass('on');
        } else if (data.amountMoc == 2) {
            $(".one").addClass('on');
            $(".two").addClass('on');
        } else if (data.amountMoc >= 3) {
            $(".one").addClass('on');
            $(".two").addClass('on');
            $(".tree").addClass('on');
        }

        $(".invRight").html("");
        $(".invLeft").html("");
        for (let x = 1; x <= mySlots; x++) {
            const slot = x.toString();

            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invLeft").append(item);
            }
        }


        for (let x = 1; x <= inSlots; x++) {
            const slot = x.toString();
            if (data.inventario2[slot] !== undefined) {
                const v = data.inventario2[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invRight").append(item);
            }
        }

        updateDragOrgChest();
    });
}

const updateDragOrgChest = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount | (itemData.key == "dinheiro" && origin === "invLeft" && tInv === "invLeft")) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }


            if (tInv === "invLeft") {
                if (origin === "invLeft") {
                    $.post("http://inventario/updateSlot", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invRight") {
                    $.post("http://inventario/takeOrgChest", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }));
                }

            } else if (tInv === "invRight") {
                if (origin === "invRight") {
                    $.post("http://inventario/updateOrgSlots", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invLeft") {
                    $.post("http://inventario/storeOrgChest", JSON.stringify({
                        item: itemData.key,
                        slot2: itemData.slot,
                        slot: target,
                        amount: amount
                    }));
                }
            }

            requestOrgChest()
            updateDragOrgChest()
        }
    });


    $('.populated').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            if (ui.draggable.parent()[0] == undefined) return;

            const origin = ui.draggable.parent()[0].className;


            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');
            const targetname = $(this).data('item-key');
            const targetamount = $(this).data('amount');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if ($(".amount").val() == "" | parseInt($(".amount").val()) == 0 | itemData.key != targetname | shiftPressed) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (amount > itemAmount) {
                amount = itemAmount;
            }

            let futureWeightLeft = weightLeft;


            if (ui.draggable.data('item-key') == $(this).data('item-key')) {
                let newSlotAmount = amount + parseInt($(this).data('amount'));
                let newSlotWeight = parseFloat(ui.draggable.children(".top").children(".itemWeight").html()) + parseFloat($(this).children(".top").children(".itemWeight").html());

                $(this).data('amount', newSlotAmount);
                $(this).children(".top").children(".itemAmount").html(newSlotAmount + "x");
                $(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

                if (amount == itemAmount) {
                    ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
                } else {
                    let newMovedAmount = itemAmount - amount;
                    let newMovedWeight = newMovedAmount * parseFloat(ui.draggable.data("peso"));

                    ui.draggable.data('amount', newMovedAmount);
                    ui.draggable.children(".top").children(".itemAmount").html(newMovedAmount + "x");
                    ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
                }

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('peso')) * amount);
                } else if (origin === "invRight" && tInv === "invLeft") {
                    futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('peso')) * amount);
                }
            } else {
                if (origin === "invRight" && tInv === "invLeft") return;

                let clone1 = ui.draggable.clone();
                let clone2 = $(this).clone();

                let slot1 = ui.draggable.data("slot");
                let slot2 = $(this).data("slot");

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - parseFloat(ui.draggable.data('amount')) + parseFloat($(this).data('amount'));
                }

                ui.draggable.replaceWith(clone2);
                $(this).replaceWith(clone1);

                $(clone1).data("slot", slot2);
                $(clone2).data("slot", slot1);
            }



            if (origin === "invLeft" && tInv === "invLeft") {
                $.post("http://inventario/updateSlot", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            } else if (origin === "invRight" && tInv === "invRight") {
                $.post("http://inventario/updateOrgSlots", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            }

            requestOrgChest()
            updateDragOrgChest()
        }
    });

}

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* SISTEMA DE INVENTARIO DO BAU DA CASA */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
const requestHouseChest = () => {
    $.post("http://inventario/requestHouseChest", JSON.stringify({}), (data) => {
        // let porcentage = data.peso * 100 / data.maxpeso;
        // weight_bar.set(porcentage)
        $('.weight_info').html(`
            ${(data.peso).toFixed(2)}/${(data.maxpeso).toFixed(2)}
        `)

        $(".pesoBau").html(`
            ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}
		`);

        $("#invpeso").html(`CASAS - ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}`)

        $(".invLeft").html("");
        $(".invRight").html("");
        for (let x = 1; x <= mySlots; x++) {
            const slot = x.toString();


            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade
                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? "#fc5858" : colorPicker(actualPercent)}"></div>
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invLeft").append(item);
            }
        }


        for (let x = 1; x <= inSlots; x++) {
            const slot = x.toString();
            if (data.inventario2[slot] !== undefined) {
                const v = data.inventario2[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? " #fc5858" : colorPicker(actualPercent)}" ></div >
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invRight").append(item);
            }
        }

        updateHouseChest();
    });
}

const updateHouseChest = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount | (itemData.key == "dinheiro" && origin === "invLeft" && tInv === "invLeft")) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (tInv === "invLeft") {
                if (origin === "invLeft") {
                    $.post("http://inventario/updateSlot", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invRight") {
                    $.post("http://inventario/takeHouseChest", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        
                        target: target,
                        amount: amount
                    }));
                }

            } else if (tInv === "invRight") {
                if (origin === "invRight") {
                    $.post("http://inventario/updateChestSlots", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invLeft") {
                    $.post("http://inventario/storeHouseChest", JSON.stringify({
                        item: itemData.key,
                        slot: target,
                        slot2: itemData.slot,
                        amount: amount
                    }));
                }
            }

            updateHouseChest()
            requestHouseChest()
        }
    });


    $('.populated').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            if (ui.draggable.parent()[0] == undefined) return;

            const origin = ui.draggable.parent()[0].className;


            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');
            const targetname = $(this).data('item-key');
            const targetamount = $(this).data('amount');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if ($(".amount").val() == "" | parseInt($(".amount").val()) == 0 | itemData.key != targetname | shiftPressed) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (amount > itemAmount) {
                amount = itemAmount;
            }

            let futureWeightLeft = weightLeft;

            if (ui.draggable.data('item-key') == $(this).data('item-key')) {
                let newSlotAmount = amount + parseInt($(this).data('amount'));
                let newSlotWeight = parseFloat(ui.draggable.children(".top").children(".itemWeight").html()) + parseFloat($(this).children(".top").children(".itemWeight").html());

                $(this).data('amount', newSlotAmount);
                $(this).children(".top").children(".itemAmount").html(newSlotAmount + "x");
                $(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

                if (amount == itemAmount) {
                    ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
                } else {
                    let newMovedAmount = itemAmount - amount;
                    let newMovedWeight = newMovedAmount * parseFloat(ui.draggable.data("peso"));

                    ui.draggable.data('amount', newMovedAmount);
                    ui.draggable.children(".top").children(".itemAmount").html(newMovedAmount + "x");
                    ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
                }

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('peso')) * amount);
                } else if (origin === "invRight" && tInv === "invLeft") {
                    futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('peso')) * amount);
                }
            } else {
                if (origin === "invRight" && tInv === "invLeft") return;

                let clone1 = ui.draggable.clone();
                let clone2 = $(this).clone();

                let slot1 = ui.draggable.data("slot");
                let slot2 = $(this).data("slot");

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - parseFloat(ui.draggable.data('amount')) + parseFloat($(this).data('amount'));
                }

                ui.draggable.replaceWith(clone2);
                $(this).replaceWith(clone1);

                $(clone1).data("slot", slot2);
                $(clone2).data("slot", slot1);
            }



            if (origin === "invLeft" && tInv === "invLeft") {
                $.post("http://inventario/updateSlot", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            } else if (origin === "invRight" && tInv === "invRight") {
                $.post("http://inventario/updateChestSlots", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            }

            updateHouseChest()
            requestHouseChest()
        }
    });

}

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* SISTEMA DE LOJA */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
const requestStore = () => {
    $.post("http://inventario/requestStore", JSON.stringify({}), (data) => {
        // let porcentage = data.peso * 100 / data.maxpeso;
        // weight_bar.set(porcentage)
        $('.weight_info').html(`
            ${(data.peso).toFixed(2)}/${(data.maxpeso).toFixed(2)}
        `)

        $("#invpeso").html('LOJA')

        $(".pesoBau").hide();

        $(".on").removeClass('on');
        if (data.amountMoc == 1) {
            $(".one").addClass('on');
        } else if (data.amountMoc == 2) {
            $(".one").addClass('on');
            $(".two").addClass('on');
        } else if (data.amountMoc >= 3) {
            $(".one").addClass('on');
            $(".two").addClass('on');
            $(".tree").addClass('on');
        }

        $(".invLeft").html("");
        $(".invRight").html("");
        for (let x = 1; x <= mySlots; x++) {
            const slot = x.toString();

            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? " #fc5858" : colorPicker(actualPercent)}" ></div >
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invLeft").append(item);
            }
        }


        for (let x = 1; x <= inSlots; x++) {
            const slot = x.toString();
            if (data.inventario2[slot] !== undefined) {
                const v = data.inventario2[slot];
                /* if (v.buyPrice == 0) { v.buyPrice = "Free" } else if (v.buyPrice == undefined) { v.buyPrice = "Sem Estoque" }
                if (v.sellPrice == 0) { v.sellPrice = "Free" } else if (v.sellPrice == undefined) { v.sellPrice = "Indisponivel" } */

                let format = 0
                if (v.buyPrice > 0) {
                    format = v.buyPrice
                } else if (v.sellPrice > 0) {
                    format = v.sellPrice
                }
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount"> <b style="font-size: 1.2vh">${v.amount}</b></div>
                        <div class="item_weight"> <b style="font-size: 1.2vh; text-align: right">R$ ${format}</b></div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? " #fc5858" : colorPicker(actualPercent)}" ></div >
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invRight").append(item);
            }
        }

        updateStore();
    });
}

const updateStore = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount | (itemData.key == "dinheiro" && origin === "invLeft" && tInv === "invLeft")) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            let buyAmount = 0;
            if ($(".amount").val() == "" | parseInt($(".amount").val()) == 0) {
                buyAmount = 1
            } else {
                buyAmount = $(".amount").val()
            }

            if (tInv === "invLeft") {
                if (origin === "invLeft") {
                    $.post("http://inventario/updateSlot", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invRight") {
                    $.post("http://inventario/buyStore", JSON.stringify({
                        item: itemData.key,
                        target: target,
                        amount: buyAmount
                    }));
                }

            } else if (tInv === "invRight") {
                if (origin === "invLeft") {
                    $.post("http://inventario/sellStore", JSON.stringify({
                        item: itemData.key,
                        amount: parseInt(amount)
                    }));
                }
            }

            updateStore()
            requestStore()
        }
    });


    $('.populated').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            if (ui.draggable.parent()[0] == undefined) return;

            const origin = ui.draggable.parent()[0].className;


            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');
            const targetname = $(this).data('item-key');
            const targetamount = $(this).data('amount');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if ($(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (amount > itemAmount) {
                amount = itemAmount;
            }

            let futureWeightLeft = weightLeft;

            if (ui.draggable.data('item-key') == $(this).data('item-key')) {
                let newSlotAmount = amount + parseInt($(this).data('amount'));
                let newSlotWeight = parseFloat(ui.draggable.children(".top").children(".itemWeight").html()) + parseFloat($(this).children(".top").children(".itemWeight").html());

                $(this).data('amount', newSlotAmount);
                $(this).children(".top").children(".itemAmount").html(newSlotAmount + "x");
                $(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

                if (amount == itemAmount) {
                    ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
                } else {
                    let newMovedAmount = itemAmount - amount;
                    let newMovedWeight = newMovedAmount * parseFloat(ui.draggable.data("peso"));

                    ui.draggable.data('amount', newMovedAmount);
                    ui.draggable.children(".top").children(".itemAmount").html(newMovedAmount + "x");
                    ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
                }

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('peso')) * amount);
                } else if (origin === "invRight" && tInv === "invLeft") {
                    futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('peso')) * amount);
                }
            } else {
                if (origin === "invRight" && tInv === "invLeft") return;

                let clone1 = ui.draggable.clone();
                let clone2 = $(this).clone();

                let slot1 = ui.draggable.data("slot");
                let slot2 = $(this).data("slot");

                if (origin === "invLeft" && tInv === "invRight") {
                    futureWeightLeft = futureWeightLeft - parseFloat(ui.draggable.data('amount')) + parseFloat($(this).data('amount'));
                }

                ui.draggable.replaceWith(clone2);
                $(this).replaceWith(clone1);

                $(clone1).data("slot", slot2);
                $(clone2).data("slot", slot1);
            }



            if (origin === "invLeft" && tInv === "invLeft") {
                $.post("http://inventario/updateSlot", JSON.stringify({
                    item: itemData.key,
                    slot: itemData.slot,
                    amount: parseInt(amount),
                    target: target,
                    targetname: targetname,
                    targetamount: parseInt(targetamount)
                }));
            }

            updateStore()
            requestStore()
        }
    });

}
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* SISTEMA DE REVISTAR */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
const requestRevistar = () => {
    $.post("http://inventario/requestRevistar", JSON.stringify({}), (data) => {

        // let porcentage = data.peso * 100 / data.maxpeso;
        // weight_bar.set(porcentage)
        $('.weight_info').html(`
            ${(data.peso).toFixed(2)}/${(data.maxpeso).toFixed(2)}
        `)

        $(".pesoBau").html(`
            ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}
		`);

        $("#invpeso").html(`REVISTAR ${(data.peso2).toFixed(2)} / ${(data.maxpeso2).toFixed(2)}`)

        $(".on").removeClass('on');
        if (data.amountMoc == 1) {
            $(".one").addClass('on');
        } else if (data.amountMoc == 2) {
            $(".one").addClass('on');
            $(".two").addClass('on');
        } else if (data.amountMoc >= 3) {
            $(".one").addClass('on');
            $(".two").addClass('on');
            $(".tree").addClass('on');
        }

        $(".invLeft").html("");
        $(".invRight").html("");
        for (let x = 1; x <= mySlots; x++) {
            const slot = x.toString();

            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? " #fc5858" : colorPicker(actualPercent)}" ></div >
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invLeft").append(item);
            }
        }


        for (let x = 1; x <= inSlots; x++) {
            const slot = x.toString();
            if (data.inventario2[slot] !== undefined) {
                const v = data.inventario2[slot];
                // durabilidade
                const maxDurability = 86400 * v.days;
                const newDurability = (maxDurability - (v.durability ?? 0)) / maxDurability;
                var actualPercent = parseInt(newDurability * 100);
                let barra = 2;

                // durabilidade

                const item = `
                <div class="item populated" style="background-image: url('${imageURL}${v.key}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
                    <div class="top_item">
                        <div class="item_amount">x${formatarNumero(v.amount)}</div>
                        <div class="item_weight">
                            <img src="images/weight.svg" alt="">
                            ${(v.peso * v.amount).toFixed(2)}
                        </div>
                    </div>
                    <div class="durability" style="right: ${barra}%; width: ${actualPercent}%; background: ${actualPercent == 100 ? " #fc5858" : colorPicker(actualPercent)}" ></div >
                    <div class="item_name">
                    ${v.name}
                    </div>
                </div>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;
                $(".invRight").append(item);
            }
        }

        updateRevistar();
    });
}

const updateRevistar = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            if (delay) return
            setTimeout(() => { delay = false; }, 1000);
            delay = true

            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined) return;
            const tInv = $(this).parent()[0].className;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = 0;
            let itemAmount = parseInt(ui.draggable.data('amount'));
            if (parseInt($(".amount").val()) < 0 | $(".amount").val() == "" | parseInt($(".amount").val()) == 0 | shiftPressed | parseInt($(".amount").val()) > itemAmount | (itemData.key == "dinheiro" && origin === "invLeft" && tInv === "invLeft")) {
                amount = itemAmount;
            } else {
                amount = parseInt($(".amount").val());
            }

            if (tInv === "invLeft") {
                if (origin === "invLeft") {
                    $.post("http://inventario/updateSlot", JSON.stringify({
                        item: itemData.key,
                        slot: itemData.slot,
                        target: target,
                        amount: amount
                    }))
                } else if (origin === "invRight") {
                    $.post("http://inventario/retirarItemRevistar", JSON.stringify({
                        item: itemData.key,
                        target: target,
                        slot: itemData.slot,
                        amount: amount
                    }));
                }
            } else if (tInv === "invRight") {
                if (origin === "invLeft") {
                    $.post("http://inventario/colocarItemRevistar", JSON.stringify({
                        item: itemData.key,
                        slot: target,
                        amount: amount
                    }));
                }
            }



            updateRevistar()
            requestRevistar()
        }
    });
}


/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* OUTROS */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
const formatarNumero = n => {
    var n = n.toString();
    var r = '';
    var x = 0;

    for (var i = n.length; i > 0; i--) {
        r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
        x = x == 2 ? 0 : x + 1;
    }

    return r.split('').reverse().join('');
}


window.addEventListener("offline", function () {
    $(".inventory").css("display", "none")
    $.post("http://inventario/invClose", JSON.stringify({}));
});

$(document).on("contextmenu", ".item", function(e) {
    e.preventDefault(); // Bloqueia o menu padrão do navegador

    // Pega os dados do item clicado
    const type = $(this).data("type"); // Você precisa ter data-type="weapon" no HTML do item
    const item = $(this).data("item");
    const slot = $(this).data("slot");
    const amount = $(this).data("amount");

    selectedItemData = { item, slot, amount, type };

    // Posiciona o menu onde o mouse está
    $("#context-menu").css({
        top: e.pageY + "px",
        left: e.pageX + "px",
        display: "block"
    });

    // Lógica para mostrar opções de arma
    // Se o nome do item começar com "WEAPON_" ou for do tipo arma
    if (item.toUpperCase().includes("WEAPON_")) {
        $(".weapon-only").show();
    } else {
        $(".weapon-only").hide();
    }
});

// Fecha o menu se clicar fora
$(document).on("click", function() {
    $("#context-menu").hide();
});

// Ação ao clicar nas opções do menu
$(".context-option").on("click", function() {
    const action = $(this).data("action");
    
    if (!selectedItemData) return;

    if (action === "use") {
        // Função original de usar
        $.post("http://inventario/useItem", JSON.stringify({
            item: selectedItemData.item,
            slot: selectedItemData.slot,
            amount: 1
        }));
    } else if (action === "drop") {
        // Abre modal de dropar ou dropa 1 direto (você escolhe)
        $.post("http://inventario/dropItem", JSON.stringify({
            item: selectedItemData.item,
            slot: selectedItemData.slot,
            amount: selectedItemData.amount 
        }));
    } else if (action === "send") {
        // Lógica de enviar (precisa implementar modal de ID depois)
    } else if (action === "removeAmmo") {
        // NOVA FUNÇÃO: Remover Munição
        $.post("http://inventario/removeAmmo", JSON.stringify({
            item: selectedItemData.item
        }));
    } else if (action === "checkSerial") {
        // NOVA FUNÇÃO: Ver Serial
        $.post("http://inventario/checkSerial", JSON.stringify({
            item: selectedItemData.item
        }));
    }

    $("#context-menu").hide();
});