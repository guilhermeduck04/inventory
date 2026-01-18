----------------------------------------------------------------
---------------------EDIT BY: ZR SRORE
----------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local cfgGroups = module("vrp", "Config/Groups")
local groups = cfgGroups.groups

local DUTY_WEAPONS = {
	{ token = "police_weapon_token", weapon = "WEAPON_STUNGUN" }
}

local armas = {
}

local function LogDutyWeapon(action, src, ownerId, serial, extra)
	local actor = src and vRP.getUserId(src) or "N/A"
	local details = extra and tostring(extra) or "sem-detalhes"
	print(("[DUTY-WEAPON] action=%s actor=%s owner=%s serial=%s extra=%s"):format(action, actor, ownerId or "N/A", serial or "N/A", details))
end

local function getItemMetadata(slotData)
	if not slotData then return nil end
	return slotData.metadata or slotData.meta or slotData.info or slotData.data
end

local function generateSerial(user_id, source)
	return ("DT-%s-%s-%s"):format(os.time(), source, math.random(1000, 9999))
end

local function isOnDuty(user_id)
	local user_groups = vRP.getUserGroups(user_id)
	for groupName, _ in pairs(user_groups) do
		local groupData = groups[groupName]
		if groupData and groupData._config and groupData._config.gtype == "job" then
			if string.sub(groupName, 1, 7) ~= "Paisana" then
				return true
			end
		end
	end
	return false
end

local function isPoliceOnDuty(user_id)
	if not vRP.hasPermission(user_id, "policia.permissao") then
		return false
	end
	if vRP.checkPatrulhamento and vRP.checkPatrulhamento(user_id) then
		return true
	end
	return isOnDuty(user_id)
end

local function isDutyTokenMeta(meta, user_id)
	return meta
		and meta.duty == true
		and meta.nonTransferable == true
		and meta.job == "police"
		and meta.issuedTo == user_id
		and meta.serial ~= nil
		and meta.weapon ~= nil
end

local function isWeaponAllowed(tokenMeta)
	for _, entry in pairs(DUTY_WEAPONS) do
		if entry.token == "police_weapon_token" and entry.weapon == tokenMeta.weapon then
			return true
		end
	end
	return false
end

local function hasDutyToken(user_id, tokenName, weaponName)
	local inv = vRP.getInventory(user_id)
	if not inv then return false end
	for _, data in pairs(inv) do
		if data.item == tokenName then
			local meta = getItemMetadata(data)
			if isDutyTokenMeta(meta, user_id) and meta.weapon == weaponName then
				return true
			end
		end
	end
	return false
end

local function issueDutyTokens(source, user_id)
	if not isPoliceOnDuty(user_id) then
		LogDutyWeapon("issue_denied", source, user_id, "N/A", "sem-permissao-ou-folga")
		return
	end

	for _, entry in pairs(DUTY_WEAPONS) do
		if not hasDutyToken(user_id, entry.token, entry.weapon) then
			local meta = {
				duty = true,
				job = "police",
				nonTransferable = true,
				issuedTo = user_id,
				issuedAt = os.time(),
				serial = generateSerial(user_id, source),
				weapon = entry.weapon
			}
			vRP.giveInventoryItem(user_id, entry.token, 1, true, nil, meta)
			LogDutyWeapon("issue", source, user_id, meta.serial, "weapon=" .. entry.weapon)
		end
	end
end

local function clearDutyTokens(source, user_id, reason)
	local inv = vRP.getInventory(user_id)
	if not inv then return end
	for slot, data in pairs(inv) do
		if data.item == "police_weapon_token" then
			local meta = getItemMetadata(data)
			if isDutyTokenMeta(meta, user_id) then
				vRP.tryGetInventoryItem(user_id, data.item, parseInt(data.amount or 1), true, tostring(slot))
				local target = source or vRP.getUserSource(user_id)
				if target then
					TriggerClientEvent("zr_arsenal:removeWeapon", target, meta.weapon)
				end
				LogDutyWeapon("clear", source, user_id, meta.serial, reason or "duty-off")
			end
		end
	end
end

RegisterNetEvent("zr_arsenal:issueDutyTokens")
AddEventHandler("zr_arsenal:issueDutyTokens", function(src)
	local source = src or source
	local user_id = vRP.getUserId(source)
	if not user_id then return end
	issueDutyTokens(source, user_id)
end)

RegisterNetEvent("zr_arsenal:clearDutyTokens")
AddEventHandler("zr_arsenal:clearDutyTokens", function(src, reason)
	local source = src or source
	local user_id = vRP.getUserId(source)
	if not user_id then return end
	clearDutyTokens(source, user_id, reason)
end)

AddEventHandler("zr_arsenal:tokenTransferAttempt", function(ownerSource, actorSource, tokenMeta, action, destination)
	local ownerId = tokenMeta and tokenMeta.issuedTo or (ownerSource and vRP.getUserId(ownerSource))
	local serial = tokenMeta and tokenMeta.serial or "N/A"
	LogDutyWeapon("transfer_" .. tostring(action), actorSource or ownerSource, ownerId, serial, destination)

	local target = ownerSource or (ownerId and vRP.getUserSource(ownerId))
	if target and tokenMeta and tokenMeta.weapon then
		TriggerClientEvent("zr_arsenal:removeWeapon", target, tokenMeta.weapon)
	end
end)

RegisterNetEvent("zr_arsenal:equipToken")
AddEventHandler("zr_arsenal:equipToken", function(src, tokenMeta)
	local source = src or source
	local user_id = vRP.getUserId(source)
	if not user_id then return end

	if type(tokenMeta) ~= "table" then
		LogDutyWeapon("equip_invalid_meta", source, user_id, "N/A", "metadata-ausente")
		TriggerClientEvent("Notify", source, "negado", "Token inválido.")
		return
	end

	if not isPoliceOnDuty(user_id) then
		LogDutyWeapon("equip_denied", source, user_id, tokenMeta.serial, "folga-ou-sem-permissao")
		TriggerClientEvent("Notify", source, "negado", "Você não está em serviço.")
		return
	end

	if not isDutyTokenMeta(tokenMeta, user_id) or not isWeaponAllowed(tokenMeta) then
		LogDutyWeapon("equip_invalid_meta", source, user_id, tokenMeta.serial, "metadata-inconsistente")
		TriggerClientEvent("Notify", source, "negado", "Token inválido.")
		return
	end

	TriggerClientEvent("zr_arsenal:giveWeapon", source, tokenMeta.weapon)
	LogDutyWeapon("equip", source, user_id, tokenMeta.serial, "weapon=" .. tokenMeta.weapon)
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	if first_spawn then
		SetTimeout(5000, function()
			if not isPoliceOnDuty(user_id) then
				clearDutyTokens(source, user_id, "spawn_cleanup")
			end
		end)
	end
end)

RegisterServerEvent('ndk:permissao')
AddEventHandler('ndk:permissao', function()
	local src = source
	local user_id = vRP.getUserId(src)
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent('ndk:permissao', src)
	end
end)

RegisterServerEvent('zr_arsenal:colete')
AddEventHandler('zr_arsenal:colete', function()
	local src = source
	local user_id = vRP.getUserId(src)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local colete = 100
		vRPclient.setArmour(src,100)
		vRP.setUData(user_id,"vRP:colete", json.encode(colete))
	end
end)
