local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface("inventario", src)
vSERVER = Tunnel.getInterface("inventario")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local droplist = {}
local segundos = 0
local myInventory = false
local myChestVehicle = nil
local myOrgChest = nil
local myChestHouse = nil
local myStore = nil
local myRevistar = nil

-- =========================================================
-- HELPERS (NORMALIZAR W_ -> WEAPON_)
-- =========================================================
local function normalizeWeaponName(name)
    if not name then return name end
    name = tostring(name)
    if name:sub(1,2) == "W_" then
        return "WEAPON_" .. name:sub(3)
    end
    return name
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MOC
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("moc","Abrir a mochila","keyboard","OEM_3")
RegisterCommand("moc",function(source,args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 105 and not myInventory and NetworkIsSessionActive() and vSERVER.checkConnected() and segundos <= 0 then
		if not IsScreenFadedOut() then
			segundos = 2
			myInventory = true
			SetNuiFocus(true,true)
			TransitionToBlurred(1000)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ action = "showMenu" })
		end
	end
end)

RegisterKeyMapping("pmalas","Abrir Porta Malas","keyboard","PAGEUP")
RegisterCommand("pmalas",function(source,args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) >= 101 and myChestVehicle == nil and NetworkIsSessionActive() and vSERVER.checkConnected() and segundos <= 0 then
		
		local Vehicle,Network,Plate,Model,Class,Lock = vRP.VehicleList(5)
		if Plate and not Lock and vSERVER.checkVehicleOpen(Plate) then
			segundos = 2
			vSERVER.setVehicleOpen(Plate, true, Network)
			myChestVehicle = { Plate,Model }
			SetNuiFocus(true, true)
			TransitionToBlurred(1000)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ action = "showVehicles", log = "chestVehicle" })
		end
	end
end)

RegisterKeyMapping("ochest","Abrir bau de org","keyboard","E")
RegisterCommand("ochest",function(source,args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 105 and myOrgChest == nil and NetworkIsSessionActive() and vSERVER.checkConnected() and segundos <= 0 then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(cfg.chestOrgs) do
			local distance = #(coords - v.coords)
			if distance <= 1.5 then
				segundos = 2

				if vSERVER.checkPermission(v.perm) then
					if k then
						if vSERVER.checkOrgOpen(v.org) then
							vSERVER.setOrgOpen(v.org, true)
							myOrgChest = { k,v.org,v.maxbau }
							SetNuiFocus(true, true)
							TransitionToBlurred(1000)
							SetCursorLocation(0.5,0.5)
							SendNUIMessage({ action = "showOrgChest", log = "chestOrg" })
						end
					end
				end
			end
		end

	end
end)

RegisterKeyMapping("ostore","Abrir loja de vendas","keyboard","E")
RegisterCommand("ostore",function(source,args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 105 and myStore == nil and NetworkIsSessionActive() and vSERVER.checkConnected() and segundos <= 0 then
		
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(cfg.storesLocs) do
			local distance = #(coords - v.coords)

			if distance <= 1.5 then
				segundos = 2

				if v.perm == nil or vSERVER.checkPermission(v.perm) then
					
					myStore = { v.type }
					SetNuiFocus(true, true)
					TransitionToBlurred(1000)
					SetCursorLocation(0.5,0.5)
					SendNUIMessage({ action = "showStore" })
				end
			end
		end
			
	end
end)
 
RegisterCommand("revistar",function(source,args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 105 and myRevistar == nil and NetworkIsSessionActive() and vSERVER.checkConnected() and segundos <= 0 and not IsPedInAnyVehicle(PlayerPedId()) then
		segundos = 2

		local revistar = vSERVER.checkOpenRevistar()
		if revistar then
			vSERVER.setRevistar(revistar, true)
			myRevistar = { revistar }
			SetNuiFocus(true, true)
			TransitionToBlurred(1000)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ action = "showRevistar" })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
---	 HOTBAR
---	---------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local idle = 5 -- MUDAR DE 1000 PARA 5 (IMPORTANTE!)
        local ped = PlayerPedId()
        
        -- Bloqueia a tecla TAB
        DisableControlAction(0, 37, true) 
        
        -- Bloqueia Roda do Mouse
        DisableControlAction(0, 12, true)
        DisableControlAction(0, 13, true)
        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)
        
        -- Se apertar TAB, mostra a barra
        if IsDisabledControlJustPressed(0, 37) then
            SendNUIMessage({ action = "showHotbar" })
        end
        
        Wait(idle)
    end
end)

RegisterNetEvent("inventory:UpdateHotbar")
AddEventHandler("inventory:UpdateHotbar", function(items)
    SendNUIMessage({
        action = "updateHotbar",
        items = items
    })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("progress")
AddEventHandler("progress",function(time)
    -- Envia a mensagem para o HTML mostrar a barra pelo tempo (ms) recebido
    SendNUIMessage({ action = "showProgress", time = time })
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- HOTKEYS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local useDelay = false

RegisterKeyMapping("useslot 1", "Hotkey 1", "keyboard", "1")
RegisterKeyMapping("useslot 2", "Hotkey 2", "keyboard", "2")
RegisterKeyMapping("useslot 3", "Hotkey 3", "keyboard", "3")
RegisterKeyMapping("useslot 4", "Hotkey 4", "keyboard", "4")
RegisterKeyMapping("useslot 5", "Hotkey 5", "keyboard", "5")

RegisterCommand('useslot', function(source,args)
	local value = parseInt(args[1])
	if value > 0 and value <= 6 then
		if not useDelay then
			useDelay = true

			vSERVER._useItem(value, 1)
			
			SetTimeout(5 * 1000, function() useDelay = false end)
		end
	end
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS INVENTARIO PERSONAL
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMochila",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local dropItems = {}

		for k,v in pairs(droplist) do
			local bowz,cdz = GetGroundZFor_3dCoord(v["x"],v["y"],v["z"])
			local dist = #(coords - vector3(v["x"],v["y"],cdz))
			if dist <= 1.5 then
				table.insert(dropItems,{ name = v["name"], key = v.key, amount = v["count"], index = v["index"], peso = v["peso"], desc = v["desc"], png = v["png"], id = k })
			end
		end
		if myInventory then
		    TriggerEvent("Ativar:Hud", false)
        end
		local inventario,peso,maxpeso,infos,amountMoc,banco,carteira = vSERVER.Mochila()
		if inventario then
			cb({ inventario = inventario, drop = dropItems, peso = peso, maxpeso = maxpeso, infos = infos, amountMoc = amountMoc, banco = banco, carteira = carteira })
		end
	end
end)

RegisterNUICallback("updateSlot",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		TriggerEvent("sound:source","slot",0.1)
		vSERVER.updateSlot(data.item, data.slot, data.target, data.targetname, data.targetamount, parseInt(data.amount))
	end
end)

RegisterNUICallback("invClose",function(data,cb)
	TriggerEvent("Ativar:Hud", true)
	src.closeInventory()
end)

RegisterNUICallback("useItem",function(data)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		local amount = data.amount
		vSERVER.useItem(data.slot, amount)
		TriggerEvent("Ativar:Hud", true)
	end
end)

RegisterNUICallback("sendItem",function(data)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.sendItem(data.item,data.slot,data.amount)
	end
end)

RegisterNUICallback("dropItem",function(data)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if not IsScreenFadedOut() then
			local amount = data.amount
			
			if amount == nil or amount <= 1 then
				amount = 1
			end

			vSERVER.droparItem(data.slot, amount)
		end
	end
end)

RegisterNUICallback("pickupItem",function(data)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if not IsScreenFadedOut() then
			vSERVER.pegarItem(data.id, data.target, data.amount)
		end
	end
end)


src.SetAnim = function(amount)
	vRP.loadAnimSet("move_m@drunk@moderatedrunk")
		
	SetTimeout(60000*amount, function()
		if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
			vRP.loadAnimSet("move_m@confident")
		elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
			vRP.loadAnimSet("move_f@heels@c")
		end
	end)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS INVENTARIO VEICULO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestVehicle",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if myChestVehicle ~= nil then
			local inventario,inventario2,peso,maxpeso,peso2,maxpeso2,infos,infosVehicle,amountMoc = vSERVER.openVehicles(myChestVehicle[1],myChestVehicle[2])
			if inventario and inventario2 then
				cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos, infosVehicle = infosVehicle, amountMoc = amountMoc })
			end
		end
	end
end)

RegisterNUICallback("updateVehicleSlots",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		TriggerEvent("sound:source",'slot',0.1)
		vSERVER.updateVehicleSlots(data.item, data.slot, data.target, data.targetname, data.targetamount, parseInt(data.amount), myChestVehicle[1],myChestVehicle[2])
	end
end)

RegisterNUICallback("takeVehicle",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.retirarVehicle(data.item, data.amount, data.slot, data.target, myChestVehicle[1],myChestVehicle[2])
	end
end)

RegisterNUICallback("storeVehicle",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.colocarVehicle(data.item,data.amount,data.slot, myChestVehicle[1],myChestVehicle[2])
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS INVENTARIO FACTION
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestOrgChest",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if myOrgChest ~= nil then
			local inventario,inventario2,peso,maxpeso,peso2,maxpeso2,infos,infosOrg,amountMoc = vSERVER.openOrgChest(myOrgChest[1],myOrgChest[2],myOrgChest[3])
			if inventario and inventario2 then
				cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos, infosOrg = infosOrg, amountMoc = amountMoc })
			end
		end
	end
end)

RegisterNUICallback("updateOrgSlots",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		TriggerEvent("sound:source",'slot',0.1)
		vSERVER.updateOrgSlots(data.item, data.slot, data.target, data.targetname, data.targetamount, parseInt(data.amount), myOrgChest[2])
	end
end)

RegisterNUICallback("takeOrgChest",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.retirarOrgChest(data.item, data.amount, data.slot, data.target, myOrgChest[2], myOrgChest[1])
	end
end)

RegisterNUICallback("storeOrgChest",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.colocarOrgChest(data.item,data.amount,data.slot, myOrgChest[2], myOrgChest[3], myOrgChest[1])
	end
end)

Citizen.CreateThread(function()
    while true do
        local time = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local nearby = false -- Controle para esconder o UI se não houver nada perto

        for k,v in pairs(cfg.chestOrgs) do
            local distance = #(coords - v.coords)
            
            if distance <= 2.5 then
                time = 200
                nearby = true
                
                exports['ghost_ui']:ShowPrompt({
                    id = 'org_chest',       -- ID único para interação de baús
                    coords = v.coords,      -- Coordenada do baú
                    text = 'Abrir',         -- Texto da ação
                    key = 'E',              -- Tecla
                    type = 'door',          -- Usei 'door' (verde) para combinar com o ~g~ original
                    maxDistance = 2.5,
                    offset = 0.5            -- Altura do texto acima da coordenada
                })
            end
        end

        if not nearby then
            exports['ghost_ui']:HidePrompt('org_chest')
        end

        Citizen.Wait(time)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS INVENTARIO HOUSE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("myHouseChest")
AddEventHandler("myHouseChest",function(id, houseID, maxBau)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 101 and NetworkIsSessionActive() and vSERVER.checkConnected() and segundos <= 0 and myChestHouse == nil then
		if vSERVER.checkHouseChest(id) then
			myChestHouse = { id,houseID,maxBau }
			vSERVER.setHouseChest(myChestHouse[1], true)
			SetNuiFocus(true, true)
			TransitionToBlurred(1000)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ action = "showChestHouse" })
		end
	end
end)

RegisterNUICallback("requestHouseChest",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if myChestHouse ~= nil then
			local inventario,inventario2,peso,maxpeso,peso2,maxpeso2,infos,infosOrg,amountMoc = vSERVER.openHouseChest(myChestHouse[1],myChestHouse[2],myChestHouse[3])
			if inventario and inventario2 then
				cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos, infosOrg = infosOrg, amountMoc = amountMoc })
			end
		end
	end
end)

RegisterNUICallback("updateChestSlots",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		TriggerEvent("sound:source",'slot',0.1)
		vSERVER.updateHouseSlots(data.item, data.slot, data.target, data.targetname, data.targetamount,  parseInt(data.amount), myChestHouse[1])
	end
end)

RegisterNUICallback("takeHouseChest",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.retirarHouseChest(data.item, data.amount, data.slot, data.target, myChestHouse[1])
	end
end)

RegisterNUICallback("storeHouseChest",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.colocarHousehest(data.item,data.amount,data.slot, myChestHouse[1])
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS INVENTARIO REVISTAR
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestRevistar",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if myRevistar ~= nil then
			local inventario,inventario2,peso,maxpeso,peso2,maxpeso2,infos,infoNPlayer,amountMoc = vSERVER.openRevistar(myRevistar[1])
			if inventario and inventario2 then
				cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos, infoNPlayer = infoNPlayer, amountMoc = amountMoc })
			end
		end
	end
end)

RegisterNUICallback("retirarItemRevistar",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.retirarItemRevistar(myRevistar[1], data.item, data.target, data.amount, data.slot)
	end
end)

function src.checkAnim()
    if IsEntityPlayingAnim(GetPlayerPed(-1),"random@arrests@busted","idle_a",3) then
        return true
    end
end

function src.checkPositions(player,nplayer)
	local distance = #(player - nplayer)
	if distance >= 3.5 then
		return true
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS STORE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestStore",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		if myStore ~= nil then
			local inventario,inventario2,peso,maxpeso,peso2,maxpeso2,infos,infosOrg,amountMoc = vSERVER.openStore(myStore[1])
			if inventario and inventario2 then
				cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos, infosOrg = infosOrg, amountMoc = amountMoc })
			end
		end
	end
end)

RegisterNUICallback("buyStore",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.buyStore(myStore[1], data.item, data.target, data.amount)
	end
end)

RegisterNUICallback("sellStore",function(data,cb)
	if NetworkIsSessionActive() and vSERVER.checkConnected() then
		vSERVER.sellStore(myStore[1], data.item, data.amount)
	end
end)

Citizen.CreateThread(function()
    while true do
        local time = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local nearby = false -- Variável para verificar se achou alguma loja

        for k,v in pairs(cfg.storesLocs) do
            local distance = #(coords - v.coords)

            -- Verifica se está perto (ajustei levemente para garantir que o UI pegue)
            if distance <= 2.0 then
                time = 200 -- Pode ser maior que 5, pois o UI gerencia a animação
                nearby = true
                
                exports['ghost_ui']:ShowPrompt({
                    id = 'store_interaction', -- ID único para não bugar
                    coords = v.coords,        -- Coordenada da loja
                    text = 'Acessar',         -- Texto da ação
                    key = 'E',                -- Tecla
                    type = 'shop',            -- Estilo (tem 'shop', 'job', 'door', 'default' no CSS)
                    maxDistance = 2.0,        -- Distância máxima pro UI sumir sozinho
                    offset = 0.5              -- Altura acima da coordenada (ajuste se necessário)
                })
            end
        end

        -- Se não estiver perto de nenhuma loja, forçamos esconder para limpar o prompt antigo
        if not nearby then
            exports['ghost_ui']:HidePrompt('store_interaction')
        end

        Citizen.Wait(time)
    end
end)


local blip = {}
function criarSellBlips()
    for k,v in pairs(cfg.storesLocs) do
		if v.blip and v.blipName ~= nil then
		 	blip[k] = AddBlipForCoord(v.coords[1],v.coords[2],v.coords[3])
			SetBlipSprite(blip[k], v.blipID)
			SetBlipColour(blip[k], v.blipColor)
			SetBlipScale(blip[k], 0.5)
			SetBlipAsShortRange(blip[k], true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.blipName)
			EndTextCommandSetBlipName(blip[k])
		end
    end
end

Citizen.CreateThread(function()
    criarSellBlips()
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE DROPAR ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.updateDrops(id,marker)
	droplist[id] = marker
end

function src.removeDrop(id)
	if droplist[id] ~= nil then
		droplist[id] = nil
	end
end

Citizen.CreateThread(function()
    while true do
        local time = 1000
        local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(droplist) do
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = #(coords - vector3(v.x,v.y,cdz))
			if distance <= 15 then
				time = 5
				DrawMarker(28,v.x,v.y,cdz+0.1,0,0,0,180.0,0,0,0.05,0.05,0.05,0,129,254,100,0,0,0,0)
			end
		end

        Citizen.Wait(time)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIONALIDADE DE ITENS DO INVENTARIO
-----------------------------------------------------------------------------------------------------------------------------------------
local oxygen = 0
local in_scuba = false
local attachedProp = 0
local scubaMask = 0
local scubaTank = 0

function src.setScuba(status)
    if status then
        attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
        attachProp("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
        in_scuba = true
        oxygen = 100
    else
        in_scuba = false
        DeleteEntity(scubaMask)
        DeleteEntity(scubaTank)
    end
end

function src.checkScuba()
    return in_scuba
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	local attachModel = GetHashKey(attachModelSent)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumberSent)

	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
    end

    if tonumber(attachModel) == 1569945555 then
        attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
        scubaTank = attachedProp
    elseif tonumber(attachModel) == 138065747 then
        attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
        scubaMask = attachedProp
    end

    SetEntityCollision(attachedProp, false, 0)
    AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

Citizen.CreateThread(function()
	while true do
		local time = 1000
        if IsPedSwimmingUnderWater(GetPlayerPed(-1)) and in_scuba then
            time = 5
            if oxygen > 50 then
                drawTxt("VOCÊ POSSUI ~g~"..oxygen.."% ~w~ DE OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            elseif oxygen > 30 then
                drawTxt("VOCÊ POSSUI ~b~"..oxygen.."% ~w~ DE OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            elseif oxygen > 0 then
                drawTxt("VOCÊ POSSUI ~r~"..oxygen.."% ~w~ DE OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            elseif oxygen <= 0 then
                drawTxt("~r~VOCÊ NÃO POSSUI MAIS OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), true)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 0.0)
                oxygen = 0
            end
        elseif IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not in_scuba then
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            SetPedDiesInWater(GetPlayerPed(-1), true)
        end
        Citizen.Wait(time)
    end
end)

Citizen.CreateThread(function()
	while true do
		local time = 5000
        if IsPedSwimmingUnderWater(GetPlayerPed(-1)) and in_scuba then
            oxygen = oxygen - 1
        end
        Citizen.Wait(time)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE ENERGETICO
-----------------------------------------------------------------------------------------------------------------------------------------
local energetico = false

function src.setEnergetico(status)
	if status then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.15)
		energetico = true
	else
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		RestorePlayerStamina(PlayerId(),1.0)
		energetico = false
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE USAR BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local bandagem = false
local tempoBandagem = 0
local oldHealth = 0

function src.useBandagem()
	bandagem = true
	tempoBandagem = 60
	oldHealth = GetEntityHealth(PlayerPedId())
end

Citizen.CreateThread(function()
	while true do
		local time = 1000
		if bandagem then
			if GetEntityHealth(PlayerPedId()) > 250 then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify","negado","<b>[BANDAGEM]</b> Vida cheia.")
			end

			tempoBandagem = tempoBandagem - 1
			
			if tempoBandagem <= 0 then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify","negado","<b>[BANDAGEM]</b> acabou a bandagem..")
			end

			if oldHealth > GetEntityHealth(PlayerPedId()) and bandagem then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify","negado","<b>[BANDAGEM]</b> Você sofreu algum dano.")
			end

			if GetEntityHealth(PlayerPedId()) <= 105 and bandagem then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify","negado","<b>[BANDAGEM]</b> Você morreu.")
			end

			if GetEntityHealth(PlayerPedId()) > 105 and bandagem and GetEntityHealth(PlayerPedId()) < 250 then
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)
			end
			
			if GetEntityHealth(PlayerPedId()) >= 250 and bandagem then
				tempoBandagem = 0
				bandagem = false
				SetEntityHealth(PlayerPedId(), 250)
				TriggerEvent("Notify","negado","<b>[BANDAGEM]</b> Vida cheia.")
			end
		end
		Citizen.Wait(time)
	end
end)

Citizen.CreateThread(function()
	while true do
		local time = 5000
		if bandagem then
			oldHealth = GetEntityHealth(PlayerPedId())
		end

		Citizen.Wait(time)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE ENCHER A GARRAFA
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkFountain()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler"),true) or DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler_dark"),true) then
		return true,"fountain"
	end

	if IsEntityInWater(ped) then
		return true,"floor"
	end

	return false
end

function src.startAnimHotwired()
	while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
		RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
		Citizen.Wait(10)
	end
	TaskPlayAnim(PlayerPedId(),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",3.0,3.0,-1,49,5.0,0,0,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- Atualizar Armas
-----------------------------------------------------------------------------------------------------------------------------------------
function src.updateWeapons()
    vRPserver.updateWeapons(vRP.getWeapons())
    vRPserver.updateArmor(vRP.getArmour())
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reparar')
AddEventHandler('reparar',function(vehicle)
	TriggerServerEvent("tryreparar",VehToNet(vehicle))
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				SetEntityAsMissionEntity(v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR MOTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararmotor')
AddEventHandler('repararmotor',function(vehicle)
	TriggerServerEvent("trymotor",VehToNet(vehicle))
end)

RegisterNetEvent('syncmotor')
AddEventHandler('syncmotor',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleEngineHealth(v,1000.0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR PNEUS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararpneus')
AddEventHandler('repararpneus',function(vehicle)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryrepararpneus",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncrepararpneus')
AddEventHandler('syncrepararpneus',function(index)
	if NetworkDoesNetworkIdExist(index) then
        local v = NetToEnt(index)
        if DoesEntityExist(v) then
            for i = 0,8 do
                SetVehicleTyreFixed(v,i)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLONAGEM DE PLACA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('clonar')
AddEventHandler('clonar',function(vehicle)
	if IsEntityAVehicle(vehicle) then
		SetVehicleNumberPlateText(vehicle,"Clonada")
		SetVehicleDoorsLocked(vehicle,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOGUETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Firecracker")
AddEventHandler("inventory:Firecracker",function()
	if LoadPtfxAsset("scr_indep_fireworks") then
		Wait(1700)
		local Explosive = 25
		local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,0.5,-1.0)
		local Network = CreateObject("ind_prop_firework_03",Coords["x"],Coords["y"],Coords["z"])
		
		FreezeEntityPosition(Network,true)

		Wait(4000)
		repeat
			Wait(2000)
			Explosive = Explosive - 1
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst",Coords,0.0,0.0,0.0,0.4,false,false,false,false)
		until Explosive <= 0

		DeleteEntity(Network)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.updateInventory(action)
	SendNUIMessage({ action = action })
end

function src.closeInventory()
	TriggerEvent("Ativar:Hud", true)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = "hideMenu" })

	if myInventory then
		myInventory = false
	end

	if myChestVehicle ~= nil then
		vSERVER.setVehicleOpen(myChestVehicle[1], false, myChestVehicle[3])
		myChestVehicle = nil
	end

	if myOrgChest ~= nil then
		vSERVER.setOrgOpen(myOrgChest[2], false)
		myOrgChest = nil
	end

	if myChestHouse ~= nil then
		vSERVER.setHouseChest(myChestHouse[1], false)
		myChestHouse = nil
	end

	if myRevistar ~= nil then
		vSERVER.setRevistar(myRevistar[1], false)
		myRevistar = nil
	end

	if myStore ~= nil then
		myStore = nil
	end
end

function src.trunkchestAnim(vehID, status)
	if NetworkDoesNetworkIdExist(vehID) then
		local v = NetToVeh(vehID)
		
		local isopen = GetVehicleDoorAngleRatio(v,5)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTROS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function()
	if GetCurrentResourceName() then
        src.closeInventory()
	end
end)

Citizen.CreateThread(function()
    while true do
        if segundos > 0 then
            segundos = segundos - 1
        end

        if segundos <= 0 then
            segundos = 0
        end
		
		Citizen.Wait(1000)
    end
end)

function src.updateWeapons()
    vRPserver._updateWeapons(vRP.getWeapons())
end

function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
 
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- ATMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local ATMList = {
	["1"] = { -32.08,-1104.32,27.26 },
	["2"] = { 228.18,338.4,105.56 },
	["3"] = { 158.63,234.22,106.63 },
	["4"] = { -57.67,-92.62,57.78 },
	["5"] = { 356.97,173.54,103.07 },
	["6"] = { -1415.94,-212.03,46.51 },
	["7"] = { -1430.2,-211.08,46.51 },
	["8"] = { -1282.54,-210.9,42.44 },
	["9"] = { -1286.25,-213.44,42.44 },
	["10"] = { -1289.32,-226.82,42.44 },
	["11"] = { -1285.58,-224.28,42.44 },
	["12"] = { -1109.8,-1690.82,4.36 },
	["13"] = { 1686.85,4815.82,42.01 },
	["14"] = { 1701.21,6426.57,32.76 },
	["15"] = { 1171.56,2702.58,38.16 },
	["16"] = { 1172.5,2702.59,38.16 },
	["17"] = { -1091.49,2708.66,18.96 },
	["18"] = { -3144.38,1127.6,20.86 },
	["19"] = { 527.36,-160.69,57.09 },
	["20"] = { 285.45,143.39,104.17 },
	["21"] = { -846.27,-341.28,38.67 },
	["22"] = { -846.85,-340.2,38.67 },
	["23"] = { -721.06,-415.56,34.98 },
	["24"] = { -1410.34,-98.75,52.42 },
	["25"] = { -1409.78,-100.49,52.39 },
	["26"] = { -712.9,-818.92,23.72 },
	["27"] = { -710.05,-818.9,23.72 },
	["28"] = { -660.71,-854.07,24.48 },
	["29"] = { -594.58,-1161.29,22.33 },
	["30"] = { -596.09,-1161.28,22.33 },
	["31"] = { -821.64,-1081.91,11.12 },
	["32"] = { 155.93,6642.86,31.59 },
	["33"] = { 174.14,6637.94,31.58 },
	["34"] = { -283.01,6226.11,31.49 },
	["35"] = { -95.55,6457.19,31.46 },
	["36"] = { -97.3,6455.48,31.46 },
	["37"] = { -132.93,6366.52,31.48 },
	["38"] = { -386.74,6046.08,31.49 },
	["39"] = { 24.47,-945.96,29.35 },
	["40"] = { 5.24,-919.83,29.55 },
	["41"] = { 295.77,-896.1,29.22 },
	["42"] = { 296.47,-894.21,29.23 },
	["43"] = { 1138.22,-468.93,66.73 },
	["44"] = { 1166.97,-456.06,66.79 },
	["45"] = { 1077.75,-776.54,58.23 },
	["46"] = { 289.1,-1256.8,29.44 },
	["47"] = { 288.81,-1282.37,29.64 },
	["48"] = { -1571.05,-547.38,34.95 },
	["49"] = { -1570.12,-546.72,34.95 },
	["50"] = { -1305.4,-706.41,25.33 },
	["51"] = { -2072.36,-317.28,13.31 },
	["52"] = { -2295.48,358.13,174.6 },
	["53"] = { -2294.7,356.46,174.6 },
	["54"] = { -2293.92,354.8,174.6 },
	["55"] = { 2558.75,351.01,108.61 },
	["56"] = { 89.69,2.47,68.29 },
	["57"] = { -866.69,-187.75,37.84 },
	["58"] = { -867.62,-186.09,37.84 },
	["59"] = { -618.22,-708.89,30.04 },
	["60"] = { -618.23,-706.89,30.04 },
	["61"] = { -614.58,-704.83,31.24 },
	["62"] = { -611.93,-704.83,31.24 },
	["63"] = { -537.82,-854.49,29.28 },
	["64"] = { -165.15,232.7,94.91 },
	["65"] = { -165.17,234.78,94.91 },
	["66"] = { -303.25,-829.74,32.42 },
	["67"] = { -301.7,-830.01,32.42 },
	["68"] = { -203.81,-861.37,30.26 },
	["69"] = { 119.06,-883.72,31.12 },
	["70"] = { 112.58,-819.4,31.34 },
	["71"] = { 111.26,-775.25,31.44 },
	["72"] = { 114.43,-776.38,31.41 },
	["73"] = { -256.23,-715.99,33.53 },
	["74"] = { -258.87,-723.38,33.48 },
	["75"] = { -254.42,-692.49,33.6 },
	["76"] = { -28.0,-724.52,44.23 },
	["78"] = { -30.23,-723.69,44.23 },
	["79"] = { -1315.75,-834.69,16.95 },
	["80"] = { -1314.81,-835.96,16.95 },
	["81"] = { -2956.86,487.64,15.47 },
	["82"] = { -2958.98,487.73,15.47 },
	["83"] = { -3040.85, 593.16, 7.9 },
	["84"] = { -3241.17,997.6,12.55 },
	["85"] = { -1205.78,-324.79,37.86 },
	["86"] = { -1205.02,-326.3,37.84 },
	["87"] = { 147.58,-1035.77,29.34 },
	["88"] = { 146.0,-1035.17,29.34 },
	["89"] = { 33.24, -1348.16, 29.49 },
	["90"] = { 2558.42, 389.46, 108.61 },
	["91"] = { 1153.65,-326.78,69.2 },
	["92"] = { -717.71,-915.66,19.21 },
	["93"] = { -56.9, -1752.14, 29.42 },
	["94"] = { 380.83, 323.46, 103.56 },
	["95"] = { -3240.68, 1008.56, 12.82 },
	["96"] = { 1735.28, 6410.55, 35.03 },
	["97"] = { 540.31, 2671.05, 42.16 },
	["98"] = { 1968.1, 3743.62, 32.33 },
	["99"] = { 2683.11, 3286.59, 55.23 },
	["100"] = { 1703.0, 4933.59, 42.06 },
	["101"] = { -1827.3,784.88,138.3 },
	["102"] = { -3043.91,592.48,7.9 },
	["103"] = { 127.81,-1296.03,29.27 },
	["104"] = { 2564.5,2584.79,38.08 },
	["105"] = { -1200.76,-885.44,13.26 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKATM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkAtm(Coords)
	local BombZone = false
	local AtmSelected = false

	for Number,v in pairs(ATMList) do
		local Distance = #(vec3(Coords["x"],Coords["y"],Coords["z"]) - vec3(v[1],v[2],v[3]))
		if Distance <= 1.0 then
			BombZone = vec3(v[1],v[2],v[3] - 1)
			AtmSelected = Number
			break
		end
	end

	return BombZone,AtmSelected
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY ITEM (GLOBAL)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:NotifyItem")
AddEventHandler("inventory:NotifyItem",function(item,name,amount,mode)
    SendNUIMessage({
        action = "itemNotify",
        item = item,
        name = name,
        amount = amount,
        mode = mode
    })
end)

-- EVENTO PARA FORÇAR A ARMA NA MÃO
RegisterNetEvent("inventory:EquipWeapon")
AddEventHandler("inventory:EquipWeapon", function(weaponName)
    local ped = PlayerPedId()
    local hash = GetHashKey(weaponName)
    
    -- Força a arma para a mão
    SetCurrentPedWeapon(ped, hash, true)
end)

-- =========================================================
-- CHECK: ARMA NA MÃO
-- =========================================================
function src.checkWeaponInHand(weaponItem)
    local ped = PlayerPedId()
    local weaponName = normalizeWeaponName(weaponItem)
    local inHand = GetSelectedPedWeapon(ped)
    return inHand == GetHashKey(weaponName)
end

function src.isWeaponInHand()
    local ped = PlayerPedId()
    local inHand = GetSelectedPedWeapon(ped)
    return inHand ~= GetHashKey("WEAPON_UNARMED")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE RECARREGAR (LIMITE 250 BALAS)
-----------------------------------------------------------------------------------------------------------------------------------------
local reloadCooldown = 0

CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        
        -- Verifica se está armado
        if IsPedArmed(ped, 4) then
            idle = 5
            
            -- [FIX] Impede o boneco de guardar a arma sozinho
            SetPedConfigFlag(ped, 48, true) 
            
            if reloadCooldown > 0 then
                reloadCooldown = reloadCooldown - 1
            end

            local weaponHash = GetSelectedPedWeapon(ped)
            local totalAmmo = GetAmmoInPedWeapon(ped, weaponHash) -- Pega a munição TOTAL (Pente + Reserva)
            local maxLimit = 250 -- SEU LIMITE MÁXIMO DEFINIDO

            -- CONDIÇÃO: Apertou R OU (Acabou a bala e tentou atirar)
            if (IsControlJustPressed(0, 45) or (totalAmmo <= 0 and IsControlPressed(0, 24))) and reloadCooldown <= 0 then
                
                if not IsPedReloading(ped) then
                    
                    -- Verifica se já chegou no limite
                    if totalAmmo < maxLimit then
                        local amountNeeded = maxLimit - totalAmmo -- Calcula quanto falta pra 250
                        
                        reloadCooldown = 100 -- Delay de segurança
                        TriggerServerEvent("inventory:ReloadWeapon", weaponHash, amountNeeded)
                    else
                        -- Opcional: Avisar que tá cheio se apertar R
                        if IsControlJustPressed(0, 45) then
                            TriggerEvent("Notify","aviso","Munição <b>cheia</b> (Máx: "..maxLimit..").")
                        end
                    end
                end
            end
        else
            if idle == 5 then idle = 1000 end
        end
        
        Wait(idle)
    end
end)

-- =========================================================
-- UNEQUIP: LIMPAR ARMA DA MÃO
-- =========================================================
RegisterNetEvent("inventory:UnequipWeapon")
AddEventHandler("inventory:UnequipWeapon", function()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
end)

-- =========================================================
-- SHOW SERIAL BOX NA NUI
-- =========================================================
RegisterNetEvent("inventory:showSerial")
AddEventHandler("inventory:showSerial", function(serial, owner)
    SendNUIMessage({
        action = "showSerialBox",
        serial = serial,
        owner = owner
    })
end)

-- EVENTO PARA FORÇAR A ARMA NA MÃO
RegisterNetEvent("inventory:EquipWeapon")
AddEventHandler("inventory:EquipWeapon", function(weaponName)
    local ped = PlayerPedId()
    local hash = GetHashKey(weaponName)
    SetCurrentPedWeapon(ped, hash, true)
end)

-- ADICIONAR MUNIÇÃO NA ARMA (GARANTIDO)
RegisterNetEvent("inventory:ClientAddAmmo")
AddEventHandler("inventory:ClientAddAmmo", function(weaponName, amount)
    local ped = PlayerPedId()
    local hash = GetHashKey(weaponName)
    
    -- Adiciona a munição
    AddAmmoToPed(ped, hash, amount)
    
    -- Se a arma estava zerada, forçamos um reload visual para ficar bonito
    if GetAmmoInClip(ped, hash) == 0 then
        SetPedAmmoToDrop(ped, 0)
        MakePedReload(ped)
    end
end)

-- Recebe o clique de remover munição da NUI
RegisterNUICallback("removeAmmo", function(data, cb)
    TriggerServerEvent("inventory:removeAmmo", data.item, data.slot)
    if cb then cb("ok") end
end)

-- Recebe o clique de ver serial da NUI
RegisterNUICallback("checkSerial", function(data, cb)
    TriggerServerEvent("inventory:checkSerial", data.item, data.slot)
    if cb then cb("ok") end
end)
-- =========================================================

RegisterNetEvent("inventory:checkWeaponTarget")
AddEventHandler("inventory:checkWeaponTarget", function(policeSource)
    local ped = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(ped)
    
    if weaponHash ~= GetHashKey("WEAPON_UNARMED") then
        local ammo = GetAmmoInPedWeapon(ped, weaponHash)
        
        -- Tenta descobrir o nome da arma pelo Hash (simples)
        -- Idealmente você teria uma tabela reversa Hash -> Nome
        TriggerServerEvent("inventory:receiveWeaponCheck", policeSource, "Arma Identificada ("..weaponHash..")", ammo)
    else
        TriggerServerEvent("inventory:receiveWeaponCheck", policeSource, "Desarmado", 0)
    end
end)

-- =========================================================
-- GET AMMO: MUNIÇÃO DA ARMA
-- =========================================================
function src.getAmmoInWeapon(weaponItem)
    local ped = PlayerPedId()
    local weaponName = normalizeWeaponName(weaponItem)
    local hash = GetHashKey(weaponName)
    return GetAmmoInPedWeapon(ped, hash)
end

-- =========================================================
-- SET AMMO: ZERAR/SETAR MUNIÇÃO DA ARMA (para removeAmmo funcionar)
-- =========================================================
function src.setWeaponAmmo(weaponItem, ammo)
    local ped = PlayerPedId()
    local weaponName = normalizeWeaponName(weaponItem)
    local hash = GetHashKey(weaponName)

    ammo = tonumber(ammo) or 0

    -- Zera a munição do ped pra essa arma
    SetPedAmmo(ped, hash, ammo)
end

