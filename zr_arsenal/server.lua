----------------------------------------------------------------
---------------------EDIT BY: ZR SRORE
-- CORRIGIDO: Bug de serviço, duplicata de arma, drop e remoção
----------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local cfgGroups = module("vrp", "Config/Groups")
local groups = cfgGroups.groups

local ARSENAL_WEAPON_ITEMS = {
	WEAPON_CARBINERIFLE = true,
	WEAPON_SPECIALCARBINE = true,
	WEAPON_SMG = true,
	WEAPON_COMBATPDW = true,
	WEAPON_PUMPSHOTGUN_MK2 = true,
	WEAPON_PISTOL_MK2 = true,
	WEAPON_COMBATPISTOL = true,
	WEAPON_NIGHTSTICK = true,
	WEAPON_KNIFE = true,
	WEAPON_STUNGUN = true,
	WEAPON_FLASHLIGHT = true
}

local ARSENAL_AMMO_ITEMS = {
	AMMO_CARBINERIFLE = { max = 250 },
	AMMO_SPECIALCARBINE = { max = 250 },
	AMMO_SMG = { max = 250 },
	AMMO_COMBATPDW = { max = 250 },
	AMMO_PUMPSHOTGUN_MK2 = { max = 100 },
	AMMO_PISTOL_MK2 = { max = 200 },
	AMMO_COMBATPISTOL = { max = 200 }
}

local DUTY_ONLY_WEAPONS = {
    ["WEAPON_CARBINERIFLE"] = true,
    ["WEAPON_SPECIALCARBINE"] = true,
    ["WEAPON_SMG"] = true,
    ["WEAPON_COMBATPDW"] = true,
    ["WEAPON_PUMPSHOTGUN_MK2"] = true,
    ["WEAPON_PISTOL_MK2"] = true,
    ["WEAPON_COMBATPISTOL"] = true,
    ["WEAPON_NIGHTSTICK"] = true,
    ["WEAPON_KNIFE"] = true,
    ["WEAPON_STUNGUN"] = true,
    ["WEAPON_FLASHLIGHT"] = true
}

local function normalizeWeaponName(name)
    if not name then return name end
    name = tostring(name)
    if name:sub(1,2) == "W_" then
        return "WEAPON_" .. name:sub(3)
    end
    return name
end

local function isDutyOnlyWeapon(itemName)
    if not itemName then return false end
    local w = normalizeWeaponName(itemName)
    return DUTY_ONLY_WEAPONS[w] == true
end

-- ================================================================
-- FIX #1: isOnDuty com fallback correto para grupos
-- ================================================================
local function isOnDuty(user_id)
    local user_groups = vRP.getUserGroups(user_id)
    for groupName, _ in pairs(user_groups) do
        local groupData = groups[groupName]
        if groupData and groupData._config and groupData._config.gtype == "job" then
            -- Só bloqueia se o grupo começa com "Paisana" (folga)
            if string.sub(groupName, 1, 7) ~= "Paisana" then
                return true
            end
        end
    end
    return false
end

-- ================================================================
-- FIX #1: isPoliceOnDuty agora usa isOnDuty como fallback
-- Se checkPatrulhamento não existir, cai no isOnDuty
-- ================================================================
local function isPoliceOnDuty(user_id)
    if not vRP.hasPermission(user_id, "policia.permissao") then
        return false
    end
    -- Tenta checkPatrulhamento primeiro
    if vRP.checkPatrulhamento then
        local ok = vRP.checkPatrulhamento(user_id)
        if ok then return true end
        -- Se checkPatrulhamento retornou false, ainda verifica grupo de job
        -- (cobre casos onde checkPatrulhamento não reflete o grupo paisana)
    end
    -- Fallback: verifica grupo de job ativo
    return isOnDuty(user_id)
end

local function buildArsenalMeta(user_id, itemName)
    -- IMPORTANTE: salva user_id como number para comparação consistente
    return {
        arsenalDuty = true,
        nonTransferable = true,
        job = "police",
        issuedTo = tonumber(user_id),  -- FIX #3: sempre number
        issuedAt = os.time(),
        serial = ("ARS-%s-%s"):format(itemName, math.random(1000, 9999))
    }
end

local function LogDutyWeapon(action, src, ownerId, serial, extra)
    local actor = src and vRP.getUserId(src) or "N/A"
    local details = extra and tostring(extra) or "sem-detalhes"
    print(("[DUTY-WEAPON] action=%s actor=%s owner=%s serial=%s extra=%s"):format(action, actor, ownerId or "N/A", serial or "N/A", details))
end

local function getItemMetadata(slotData)
    if not slotData then return nil end
    return slotData.metadata or slotData.meta or slotData.info or slotData.data
end

-- ================================================================
-- FIX #2: Verificar se o player já tem a arma no inventário
-- ================================================================
local function playerHasArsenalWeapon(user_id, weaponName)
    local inv = vRP.getInventory(user_id)
    if not inv then return false end
    for _, data in pairs(inv) do
        if data.item == weaponName then
            local meta = getItemMetadata(data)
            -- Verifica se é uma arma do arsenal (com arsenalDuty)
            if meta and meta.arsenalDuty == true then
                return true
            end
            -- Também bloqueia se existir qualquer instância da arma
            -- (evita duplicatas mesmo sem metadata)
            return true
        end
    end
    return false
end

-- ================================================================
-- FIX #2: Verificar se o player já tem ammo do tipo no inventário
-- (apenas verifica se já atingiu o máximo permitido)
-- ================================================================
local function getPlayerAmmoAmount(user_id, ammoName)
    return vRP.getInventoryItemAmount(user_id, ammoName) or 0
end

RegisterServerEvent('ndk:permissao')
AddEventHandler('ndk:permissao', function()
    local src = source
    local user_id = vRP.getUserId(src)
    if vRP.hasPermission(user_id, "policia.permissao") then
        TriggerClientEvent('ndk:permissao', src)
    end
end)

RegisterServerEvent('zr_arsenal:colete')
AddEventHandler('zr_arsenal:colete', function()
    local src = source
    local user_id = vRP.getUserId(src)
    if vRP.hasPermission(user_id, "policia.permissao") then
        local colete = 100
        vRPclient.setArmour(src, 100)
        vRP.setUData(user_id, "vRP:colete", json.encode(colete))
    end
end)

-- ================================================================
-- FIX #1 + #2: requestWeaponItem com verificação de serviço
-- correta E verificação de duplicata
-- ================================================================
RegisterServerEvent("zr_arsenal:requestWeaponItem")
AddEventHandler("zr_arsenal:requestWeaponItem", function(weaponName)
    local src = source
    local user_id = vRP.getUserId(src)
    if not user_id then return end

    -- Verifica permissão de policia
    if not vRP.hasPermission(user_id, "policia.permissao") then
        TriggerClientEvent("Notify", src, "negado", "Sem permissão de polícia.")
        return
    end

    -- FIX #1: usa isPoliceOnDuty com fallback correto
    if not isPoliceOnDuty(user_id) then
        TriggerClientEvent("Notify", src, "negado", "Você não está em serviço.")
        return
    end

    if type(weaponName) ~= "string" or not ARSENAL_WEAPON_ITEMS[weaponName] then
        LogDutyWeapon("arsenal_denied", src, user_id, "N/A", "weapon-invalida")
        return
    end

    -- FIX #2: bloqueia se já tem essa arma do arsenal
    if playerHasArsenalWeapon(user_id, weaponName) then
        TriggerClientEvent("Notify", src, "negado", "Você já possui este item no inventário.")
        return
    end

    vRP.giveInventoryItem(user_id, weaponName, 1, true, nil, buildArsenalMeta(user_id, weaponName))
    TriggerClientEvent("Notify", src, "sucesso", "Item retirado do arsenal.")
    LogDutyWeapon("arsenal_give_item", src, user_id, "N/A", "weapon=" .. weaponName)
end)

-- ================================================================
-- FIX #1 + #2: requestAmmoItem com verificação de serviço
-- correta E limite de quantidade
-- ================================================================
RegisterServerEvent("zr_arsenal:requestAmmoItem")
AddEventHandler("zr_arsenal:requestAmmoItem", function(ammoName, amount)
    local src = source
    local user_id = vRP.getUserId(src)
    if not user_id then return end

    if not vRP.hasPermission(user_id, "policia.permissao") then
        TriggerClientEvent("Notify", src, "negado", "Sem permissão de polícia.")
        return
    end

    -- FIX #1: usa isPoliceOnDuty com fallback correto
    if not isPoliceOnDuty(user_id) then
        TriggerClientEvent("Notify", src, "negado", "Você não está em serviço.")
        return
    end

    if type(ammoName) ~= "string" or not ARSENAL_AMMO_ITEMS[ammoName] then
        LogDutyWeapon("arsenal_ammo_denied", src, user_id, "N/A", "ammo-invalida")
        return
    end

    local ammoConfig = ARSENAL_AMMO_ITEMS[ammoName]
    local giveAmount = tonumber(amount) or ammoConfig.max
    if giveAmount <= 0 then giveAmount = ammoConfig.max end
    if giveAmount > ammoConfig.max then giveAmount = ammoConfig.max end

    -- FIX #2: verifica quanto já tem e limita para não ultrapassar o max
    local currentAmount = getPlayerAmmoAmount(user_id, ammoName)
    if currentAmount >= ammoConfig.max then
        TriggerClientEvent("Notify", src, "negado", "Você já possui a quantidade máxima de munição.")
        return
    end

    -- Ajusta para não ultrapassar o limite
    local available = ammoConfig.max - currentAmount
    if giveAmount > available then giveAmount = available end

    vRP.giveInventoryItem(user_id, ammoName, giveAmount, true, nil, buildArsenalMeta(user_id, ammoName))
    TriggerClientEvent("Notify", src, "sucesso", "Munição retirada do arsenal: " .. giveAmount .. "x")
    LogDutyWeapon("arsenal_give_ammo", src, user_id, "N/A", ("ammo=%s amount=%s"):format(ammoName, giveAmount))
end)