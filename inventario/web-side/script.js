
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

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* INIT */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
$(document).ready(function () {
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-id="${v.id}" data-grid="${v.grid}" data-amount="${v.amount}" data-peso="${v.peso}" data-slot="${slot}">
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

    $(".populated").on("auxclick", e => {
        e.preventDefault();
        if (e.which === 3) {
            const item = e.target;
            const origin = $(item).parent()[0].className;
            if (origin === undefined || origin === "invRight") return;

            itemData = { key: $(item).data('item-key'), slot: $(item).data('slot') };

            if (itemData.key === undefined) return;

            $.post("http://inventario/useItem", JSON.stringify({
                item: itemData.key,
                slot: itemData.slot,
                amount: parseInt(parseInt($(".amount").val()))
            }));
        }
    });
}

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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-size: 55% !important; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-size: 55% !important; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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
                <div class="item populated" style="background-image: url('http://104.234.65.183/inventario/${v.key}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
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