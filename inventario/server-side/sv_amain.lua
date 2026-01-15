local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------

vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("inventario",src)
Proxy.addInterface("inventario",src)

vTASKBAR = Tunnel.getInterface('taskbar')
vCLIENT = Tunnel.getInterface("inventario")

local func = exports["vrp"]
-------------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local idgens = Tools.newIDGenerator()
local allItems = {}

--CLASSES DAS ARMAS--
local classWeapons = {
    ["WEAPON_SNSPISTOL_MK2"] = "PISTOLAS",
    ["WEAPON_PISTOL_MK2"] = "PISTOLAS",
    ["WEAPON_COMBATPISTOL"] = "PISTOLAS",
    ["WEAPON_HEAVYPISTOL"] = "PISTOLAS",
    ["WEAPON_PISTOL50"] = "PISTOLAS",
    ["WEAPON_GUSENBERG"] = "SEMI-RIFLE",
    ["WEAPON_MACHINEPISTOL"] = "SEMI-RIFLE",
    ["WEAPON_SMG_MK2"] = "SEMI-RIFLE",
    ["WEAPON_SMG"] = "SEMI-RIFLE",
    ["WEAPON_ASSAULTSMG"] = "SEMI-RIFLE",
	["WEAPON_COMBATPDW"] = "SEMI-RIFLE",
    ["WEAPON_SAWNOFFSHOTGUN"] = "SHOTGUN",
    ["WEAPON_PUMPSHOTGUN_MK2"] = "SHOTGUN",
    ["WEAPON_ASSAULTRIFLE"] = "RIFLE",
    ["WEAPON_ASSAULTRIFLE_MK2"] = "RIFLE",
    ["WEAPON_SPECIALCARBINE_MK2"] = "RIFLE",
    ["WEAPON_CARBINERIFLE"] = "RIFLE",
    ["WEAPON_SPECIALCARBINE"] = "RIFLE",
	["WEAPON_AR15"] = "RIFLE",
	["WEAPON_M4"] = "RIFLE",
	["WEAPON_MK14"] = "SNIPER",
	["WEAPON_AK47"] = "RIFLE",
	["WEAPON_SCARH"] = "RIFLE",
	["WEAPON_M110"] = "SNIPER",
	["WEAPON_M70AB2"] = "RIFLE",
    ["WEAPON_STUNGUN"] = "STUNGUN",
	["WEAPON_GLOCK18C"] = "PISTOLAS",
	["WEAPON_DE"] = "PISTOLAS",
	["WEAPON_FNX45"] = "PISTOLAS",
	["WEAPON_UZI"] = "SEMI-RIFLE",
	["WEAPON_KARAMBITKNIFE"] = "FACAS",
    
}
-- TABELA DE RELAÇÃO ARMA -> ITEM DE MUNIÇÃO
-- TABELA DE RELAÇÃO ARMA -> ITEM DE MUNIÇÃO
local ammoTable = {
    -- PISTOLAS
    ["WEAPON_SNSPISTOL_MK2"]    = "AMMO_SNSPISTOL_MK2",
    ["WEAPON_PISTOL_MK2"]       = "AMMO_PISTOL_MK2",
    ["WEAPON_GUSENBERG"]        = "AMMO_GUSENBERG",
    ["WEAPON_PISTOL50"]         = "AMMO_PISTOL50",
    ["WEAPON_COMBATPISTOL"]     = "AMMO_COMBATPISTOL",
    ["WEAPON_COMBATPDW"]        = "AMMO_COMBATPDW",
    ["WEAPON_GLOCK18C"]         = "AMMO_GLOCK18C",
    ["WEAPON_DE"]               = "AMMO_DE",
    ["WEAPON_PISTOL"]           = "AMMO_PISTOL",
    ["WEAPON_FNX45"]            = "AMMO_FNX45",

    -- SUBMETRALHADORA
    ["WEAPON_MACHINEPISTOL"]    = "AMMO_MACHINEPISTOL",
    ["WEAPON_SMG_MK2"]          = "AMMO_SMG_MK2",
    ["WEAPON_SMG"]              = "AMMO_SMG",
    ["WEAPON_ASSAULTSMG"]       = "AMMO_ASSAULTSMG",
    ["WEAPON_UZI"]              = "AMMO_UZI",

    -- SHOTGUN
    ["WEAPON_SAWNOFFSHOTGUN"]   = "AMMO_SAWNOFFSHOTGUN",
    ["WEAPON_PUMPSHOTGUN_MK2"]  = "AMMO_PUMPSHOTGUN_MK2",

    -- FUZIL / RIFLE
    ["WEAPON_ASSAULTRIFLE"]     = "AMMO_ASSAULTRIFLE",
    ["WEAPON_ASSAULTRIFLE_MK2"] = "AMMO_ASSAULTRIFLE_MK2",
    ["WEAPON_SPECIALCARBINE"]   = "AMMO_SPECIALCARBINE",
    ["WEAPON_SPECIALCARBINE_MK2"] = "AMMO_SPECIALCARBINE_MK2",
    ["WEAPON_DOUBLEACTION"]     = "AMMO_DOUBLEACTION",
    ["WEAPON_CARBINERIFLE"]     = "AMMO_CARBINERIFLE",
    ["WEAPON_CARBINERIFLE_MK2"] = "AMMO_CARBINERIFLE_MK2",
    ["WEAPON_MUSKET"]           = "AMMO_MUSKET",
    ["WEAPON_AK47"]             = "AMMO_AK47",
    ["WEAPON_AR15"]             = "AMMO_AR15",
    ["WEAPON_M4"]               = "AMMO_M4",
    ["WEAPON_M70AB2"]           = "AMMO_M70AB2",
    ["WEAPON_M110"]             = "AMMO_M110",
    ["WEAPON_MK14"]             = "AMMO_MK14",
    ["WEAPON_SCARH"]            = "AMMO_SCARH",

    -- OUTROS
    ["WEAPON_PETROLCAN"]        = "AMMO_PETROLCAN"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
Objects = {
	["1"] = { x = 594.59, y = 146.52, z = 97.30, h = 70.04, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["2"] = { x = 660.44, y = 268.29, z = 102.04, h = 152.09, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["3"] = { x = 552.54, y = -198.45, z = 53.75, h = 89.32, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["4"] = { x = 339.75, y = -580.95, z = 73.42, h = 67.19, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["5"] = { x = 696.12, y = -965.69, z = 23.26, h = 271.33, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["6"] = { x = 1152.45, y = -1531.51, z = 34.65, h = 144.89, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["7"] = { x = 1382.1, y = -2081.97, z = 51.25, h = 220.16, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["8"] = { x = 589.32, y = -2802.73, z = 5.32, h = 328.01, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["9"] = { x = -453.19, y = -2810.47, z = 6.56, h = 225.82, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["10"] = { x = -1007.18, y = -2836.12, z = 13.20, h = 149.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["11"] = { x = -2018.21, y = -361.03, z = 47.36, h = 324.55, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["12"] = { x = -1727.77, y = 250.26, z = 61.65, h = 24.7, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["13"] = { x = -1089.6, y = 2717.05, z = 18.33, h = 40.52, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["14"] = { x = 321.27, y = 2874.98, z = 42.71, h = 27.62, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["15"] = { x = 1163.47, y = 2722.09, z = 37.26, h = 179.11, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["16"] = { x = 1745.86, y = 3326.69, z = 40.30, h = 115.55, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["17"] = { x = 2013.4, y = 3934.36, z = 31.65, h = 236.38, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["18"] = { x = 2526.3, y = 4191.6, z = 44.53, h = 236.44, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["19"] = { x = 2874.05, y = 4861.57, z = 61.35, h = 87.57, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["20"] = { x = 1985.16, y = 6200.39, z = 41.33, h = 330.21, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["21"] = { x = 1552.97, y = 6610.24, z = 2.12, h = 145.64, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["22"] = { x = -298.32, y = 6392.66, z = 29.87, h = 302.99, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["23"] = { x = -813.88, y = 5384.45, z = 33.77, h = 356.87, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["24"] = { x = -1606.5, y = 5259.26, z = 1.35, h = 114.45, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["25"] = { x = -199.22, y = 3638.8, z = 63.70, h = 39.84, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["26"] = { x = -1487.45, y = 2688.99, z = 2.94, h = 317.89, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["27"] = { x = -3266.12, y = 1139.82, z = 1.91, h = 249.17, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },

	["28"] = { x = 574.01, y = 132.56, z = 98.48, h = 70.99, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["29"] = { x = 344.79, y = 929.2, z = 202.44, h = 268.09, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["30"] = { x = -123.8, y = 1896.67, z = 196.34, h = 358.95, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["31"] = { x = -1099.85, y = 2703.51, z = 21.99, h = 221.35, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["32"] = { x = -2198.91, y = 4243.21, z = 46.92, h = 128.84, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["33"] = { x = -1487.02, y = 4983.14, z = 62.67, h = 174.11, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["34"] = { x = 1346.49, y = 6396.73, z = 32.42, h = 90.94, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["35"] = { x = 2535.72, y = 4661.39, z = 33.08, h = 316.4, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["36"] = { x = 1155.62, y = -1334.48, z = 33.72, h = 174.97, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["37"] = { x = 1116.06, y = -2498.07, z = 32.37, h = 193.39, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["38"] = { x = 261.06, y = -3135.82, z = 4.8, h = 88.83, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["39"] = { x = -1619.81, y = -1035.0, z = 12.16, h = 50.84, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["40"] = { x = -3420.87, y = 977.0, z = 10.91, h = 226.29, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["41"] = { x = -1909.53, y = 4624.93, z = 56.07, h = 135.57, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["42"] = { x = 894.51, y = 3211.45, z = 38.09, h = 273.04, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["43"] = { x = 1791.71, y = 4602.84, z = 36.69, h = 185.86, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["44"] = { x = 464.8, y = 6462.03, z = 28.76, h = 334.71, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["45"] = { x = 63.22, y = 6323.67, z = 37.87, h = 301.22, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["46"] = { x = -736.64, y = 5594.98, z = 40.66, h = 268.78, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },

	["47"] = { x = -2682.86, y = 2304.87, z = 20.85, h = 164.19, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["48"] = { x = -1282.33, y = 2559.98, z = 17.4, h = 148.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["49"] = { x = 159.65, y = 3118.8, z = 42.44, h = 16.37, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["50"] = { x = 1061.43, y = 3527.62, z = 33.15, h = 255.93, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["51"] = { x = 2370.22, y = 3156.55, z = 47.21, h = 221.77, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["52"] = { x = 2520.51, y = 2637.83, z = 36.95, h = 314.33, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["53"] = { x = 2572.37, y = 477.44, z = 107.68, h = 269.49, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["54"] = { x = 1223.15, y = -1079.56, z = 37.53, h = 123.38, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["55"] = { x = 1048.49, y = -247.53, z = 68.66, h = 149.33, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["56"] = { x = 499.41, y = -529.38, z = 23.76, h = 262.13, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["57"] = { x = 592.53, y = -2115.87, z = 4.76, h = 100.96, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["58"] = { x = 523.43, y = -2578.67, z = 13.82, h = 318.38, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["59"] = { x = -2.98, y = -1299.67, z = 28.28, h = 359.37, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["60"] = { x = 183.11, y = -1086.93, z = 28.28, h = 348.57, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["61"] = { x = 713.88, y = -850.95, z = 23.3, h = 271.63, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" }
}

Citizen.CreateThread(function()
	if config.sendItemsToServer then
		allItems = config.items
		for k,v in pairs(config.items) do
			vRP.defInventoryItem(k,v[1],v[2],v[3],v[4],v[5])
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GARMAS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Arena = false

RegisterNetEvent("mirtin_survival:updateArena")
AddEventHandler("mirtin_survival:updateArena", function(boolean)
    Arena = boolean
end)

RegisterCommand('garmas', function(source,args)
    local user_id = vRP.getUserId(source)
	if not Arena then
		if user_id then
			local ok = vRP.request(source, "Você deseja guardar suas armas?", 30)
			if ok and vRPclient.getHealth(source) >= 101 then

				if not vRP.checkPatrulhamento(user_id) then
					local weapons = vRPclient.replaceWeapons(source,{})
					local mensagem = ""

					for k,v in pairs(weapons) do
						if k == "WEAPON_STUNGUN" or k == "WEAPON_PETROLCAN" then 
							TriggerClientEvent("Notify",source,"negado","Não é possivel guardar <b>"..vRP.getItemName(k).."</b> na mochila..")
						else
							vRP.giveInventoryItem(user_id, k, 1, true)

							if v.ammo > 0 then
								local ammo = string.gsub(k, "WEAPON_","AMMO_")
								vRP.giveInventoryItem(user_id, ammo, v.ammo, true)
							end
							
							vCLIENT.updateWeapons(source)
							if v.ammo > 0 then
								mensagem = mensagem.. "(Arma: "..k.." Municao: "..v.ammo.."x) - "
							else
								mensagem = mensagem.. "(Arma: "..k.." Municao: 0x) - "
							end

						end
					end
					
					TriggerClientEvent("Notify",source,"sucesso","Você guardou seu armamento na mochila.")
					vRP.sendLog("GARMAS", "O ID "..user_id.." guardou  [ "..mensagem.." ] ")
				else
					TriggerClientEvent("Notify",source,"negado","Você não pode guardar armas em patrulhamento.")
				end
			end
		end
	end	
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE INVENTARIO PERSONAL
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local droplist = {}

function src.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if user_id then
		
		local inv = vRP.getInventory(user_id)
		local amountMoc = vRP.getMochilaAmount(user_id)
		if inv then 
			local inventory = {}
 
			for k,v in pairs(inv) do

				if allItems[v.item] then
					if (parseInt(v["amount"]) <= 0 or allItems[v.item] == nil) then
						vRP.removeInventoryItem(user_id,v.item,parseInt(v["amount"]))
					else
						v["amount"] = parseInt(v["amount"])
						v["name"] = allItems[v["item"]][1]
						v["peso"] = allItems[v["item"]][3]
						v["index"] = allItems[v["item"]][2]
						v["key"] = v["item"]
						v["slot"] = k
						inventory[k] = v
					end
				end
			end
			
			local org = vRP.getUserGroupByType(user_id,"org")
			if org == nil or org == "" then org = "Nenhum(a)" end
			
			return inventory,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id), { identity["name"].." "..identity["firstname"],user_id,identity["phone"],identity["registration"], org }, amountMoc, vRP.getBankMoney(user_id), vRP.getMoney(user_id)
		end
	end
end

function src.useItem(slot, amount)
    local source = source
    local user_id = vRP.getUserId(source)
	local Vehicle,Network,Plate,Model,Class,Lock = vRPclient.VehicleList(source, 7)
	
    if user_id then
        local inv = vRP.getInventory(user_id)
		 
        if inv then
            if not inv[tostring(slot)] or inv[tostring(slot)].item == nil then
                return
            end

            local item = inv[tostring(slot)].item
            local itemType = vRP.getItemType(item)
            if itemType then
				local status,time = func:getCooldown(user_id, "inventario")
                if status then
					if amount == nil or amount <= 0 then
						amount = vRP.getInventoryItemAmount(user_id, item)
					end

                        if itemType == "usar" then 
							func:setCooldown(user_id, "inventario", 2)

                            if item == "mochila" then
                                local maxMochila = {}
								maxMochila[user_id] = 3

                                if tonumber(maxMochila[user_id]) > tonumber(vRP.getMochilaAmount(user_id)) then
                                    if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
                                        vRP.addMochila(user_id)
                                        TriggerClientEvent( "Notify", source, "importante", "Você equipou a mochila, limite maximo de <b>(" .. vRP.getMochilaAmount(user_id) .. "/" .. maxMochila[user_id] .. ")</b> mochilas." )
                                    end
                                else
                                    TriggerClientEvent( "Notify", source, "negado", "Você ja antigiu o limite maximo de <b>(" .. maxMochila[user_id] .. ")</b> mochilas." )
                                end

							elseif item == "colete" then

								if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
							
									vRPclient._playAnim(source,true,{"oddjobs@basejump@ig_15","puton_parachute"},false)
									vRPclient._setArmour(source,100)
									TriggerClientEvent("progress",source,3000)
									TriggerClientEvent("Notify",source,"sucesso","<b>Colete</b> colocado com sucesso.",8000)
								end

							elseif item == "c4" then
								atmTimers = {}
								local Hash = "ch_prop_ch_ld_bomb_01a"
								local Application, Coords, Heading = vRPclient.objectCoords(source, Hash)
								if Application then
									local CoordsAtm, NumberAtm = vCLIENT.checkAtm(source, Coords)

									if CoordsAtm then
										if not atmTimers[NumberAtm] then
											atmTimers[NumberAtm] = os.time()
										end

										if os.time() < atmTimers[NumberAtm] then
											local Cooldown = parseInt(atmTimers[NumberAtm] - os.time())
											TriggerClientEvent("Notify", source, "azul", "Caixa vazio, aguarde <b>" ..Cooldown.. "</b> segundos até que um transportador venha até o local efetuar reabastecimento do mesmo.", 5000)
											return
										end

										-- local Total = vRP.getUsersByPermission("Policia.permissao")
										-- if #Total <= 5 then
										-- 	TriggerClientEvent("Notify", source, "azul", "Policias insuficiente.", 5000)
										-- 	return
										-- end

										if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
											local Number = 0

											repeat
												Number = Number + 1
											until not Objects[tostring(Number)]

											Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]),
												z = mathLength(Coords["z"]), h = mathLength(Heading), object = Hash, item = item, Distance = 100 }
											TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
											TriggerClientEvent("progress", source, "Plantando", 25000)
											atmTimers[NumberAtm] = os.time() + 10800
											local explosionProgress = 25


											repeat
												Wait(1000)
												explosionProgress = explosionProgress - 1
											until explosionProgress <= 0

											src.DropServer("dinheirosujo", (math.random(2500, 5000)), source, CoordsAtm)
											TriggerClientEvent("player:Residuals", source, "Resíduo de Explosivo.")
											TriggerClientEvent("objects:Remover", -1, tostring(Number))
											TriggerClientEvent("vRP:Explosion", source, Coords)
											TriggerEvent("Wanted", source, user_id, 30)
										end
									end
								end

							elseif item == "capuz" then
								if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
									local nplayer = vRPclient.getNearestPlayer(source, 5)
									if nplayer then
										local nuser_id = vRP.getUserId(nplayer)

										if vRPclient.isCapuz(nplayer) then
											vRPclient._setCapuz(nplayer, false)
											TriggerClientEvent( "Notify", source, "sucesso", "Você retirou o capuz desse jogador." )
										else
											vRPclient._setCapuz(nplayer, true)
											TriggerClientEvent( "Notify", source, "sucesso", "Você colocou o capuz nesse jogador, para retirar use o item novamente." )
										end

										vRP.sendLog("", "O USER_ID: "..user_id.. " Usou o Capuz no USER_ID: "..nuser_id)
									else
										TriggerClientEvent( "Notify", source, "negado", "Nenhum jogador proximo." )
									end
								end

								
							elseif item == "megaphone" then
								TriggerClientEvent("player:Megaphone",source)
								TriggerClientEvent("pma-voice:Megaphone",source,true)
								TriggerEvent("pma-voice:Megaserver",source,true)
								TriggerClientEvent("emotes",source,"megaphone")

							elseif item == "foguete" then
                                if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
                                    vRPclient._playAnim( source, false, { {"anim@mp_fireworks", "place_firework_3_box"} }, false)
									TriggerClientEvent("inventory:Firecracker", source)
									TriggerClientEvent("progress", source, 2000)
                                end

							elseif item == "suspensaoar" then
								TriggerClientEvent("zo_install_suspe_ar", source)
                                
							elseif item == "moduloneon" then
                                TriggerClientEvent("zo_install_mod_neon", source)

							elseif item == "moduloxenon" then
                                TriggerClientEvent("zo_install_mod_xenon", source)

							elseif item == "nitro" then
											if not Plate then
												TriggerClientEvent("Notify",source,"negado","Veículo não detectado.")
											else
												if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
													local Nitro = GlobalState["Nitro"]
													Nitro[Plate] = 2000
													GlobalState:set("Nitro", Nitro, true)
									
													TriggerClientEvent("progress", source, 2000)
												end
											end
                            elseif item == "maconha" or item == "cocaina" or item == "lsd" or item == "heroina" or item == "metanfetamina" or item == "lancaperfume" or item == "balinha" then
                                if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
                                    vRPclient._playAnim( source, true, {{"mp_player_int_uppersmoke", "mp_player_int_smoke"}}, true )
                                    SetTimeout( 10000, function() vRPclient._stopAnim(source, false) vRPclient._playScreenEffect(source, "RaceTurbo", 180) vRPclient._playScreenEffect(source, "DrugsTrevorClownsFight", 180) end )
                                end
							
                            elseif item == "lockpick" then
								local Consult = vRP.query("vehicles/selectVehicle",{ plate = Plate, vehicle = Model })
								local mPlacaUser = vRP.getUserIdentity(Consult[1].user_id)
                                local x, y, z = vRPclient.getPosition(source)
                                if mPlacaUser then
									
									vCLIENT.closeInventory(source)

									Wait(1000)
									vCLIENT.startAnimHotwired(source)
									if vRP.tryGetInventoryItem(user_id, "lockpick", 1, true, slot) then
										
										local finished = vTASKBAR.taskLockpick(source)
										if finished then
											local Network = NetworkGetEntityFromNetworkId(Network)
											if GetVehicleDoorLockStatus(Network) == 2 then
												SetVehicleDoorsLocked(Network,1)
											end
											TriggerClientEvent("sound:source", source, "lock", 0.1)
											TriggerClientEvent( "Notify", source, "negado", "Você destrancou o veiculo, cuidado a policia foi acionada." )
										end

										vRPclient._stopAnim(source, false)
									end
                                else
                                    TriggerClientEvent( "Notify", source, "negado", "Este veiculo não pode ser roubado." )
                                end

							elseif item == "placa" then
								if not vRP.isInVehicle(source) then
									vRP.tryGetInventoryItem(user_id, "placa", 1, true, slot)
									TriggerClientEvent("progress", source, 30000)
									SetTimeout(30000,function()
										TriggerClientEvent("clonar", source, Vehicle)
										vRPclient._stopAnim(source, false)
										TriggerClientEvent( "Notify", source, "sucesso", "Veiculo clonado." )
									end)
								else
									TriggerClientEvent("Notify", source, "negado", "Precisa estar dentro do veículo para efetuar a clonagem." )
								end
								
							elseif item == "repairkit" then
								if not vRPclient.isInVehicle(source) then  -- Verifica se o jogador está fora do veículo
									if vRP.tryGetInventoryItem(user_id, "repairkit", 1, true, slot) or vRP.hasPermission(user_id, "mecanico.permissao") then
										vRPclient._playAnim(source, false, {{"mini@repair", "fixing_a_player"}}, true)
										TriggerClientEvent("progress", source, 30000)
										vRP.blockCommands(user_id, 35)
										SetTimeout(30000, function()
											TriggerClientEvent("reparar", source, Vehicle)
											vRPclient._stopAnim(source, false)
											TriggerClientEvent("Notify", source, "sucesso", "Você reparou o veículo.")
										end)
									end
								else
									-- Envia mensagem de erro para o jogador
									TriggerClientEvent("Notify", source, "negado", "Você não pode usar o kit de reparo dentro do veículo!")
								end

							elseif item == "pneus" then
                                if not vRP.isInVehicle(source) then
									if vRP.tryGetInventoryItem(user_id, "pneus", 1, true, slot) then
										vRPclient._playAnim(source,false,{{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"}},true)
										TriggerClientEvent("progress", source, 10000)
										vRP.blockCommands(user_id, 15)
										SetTimeout(10000,function()
												TriggerClientEvent('repararpneus',source,Vehicle)
												vRPclient._stopAnim(source, false)
												TriggerClientEvent( "Notify", source, "sucesso", "Você reparou o pneu do veiculo." )
											end)
									end
                                else
                                    TriggerClientEvent( "Notify", source, "negado", "Precisa estar próximo ou fora do veículo para efetuar os reparos." )
                                end

							elseif item == "militec" then
                                if not vRP.isInVehicle(source) then
									if vRP.tryGetInventoryItem(user_id, "militec", 1, true, slot) or vRP.hasPermission(user_id, "mecanico.permissao") then
										vRPclient._playAnim( source, false, {{"mini@repair", "fixing_a_player"}}, true )
										TriggerClientEvent("progress", source, 30000)
										vRP.blockCommands(user_id, 35)
										SetTimeout(30000,function()
											TriggerClientEvent("repararmotor", source, Vehicle)
											vRPclient._stopAnim(source, false)
											TriggerClientEvent( "Notify", source, "sucesso", "Você reparou o veiculo." )
										end)
									end
                                else
                                    TriggerClientEvent( "Notify", source, "negado", "Precisa estar próximo ou fora do veículo para efetuar os reparos." )
                                end
								
                            elseif item == "algemas" then
                                local nplayer = vRPclient.getNearestPlayer(source, 3)
                                if nplayer then
									if vRPclient.checkPrisioneiro(source) or vRPclient.checkPrisioneiro(nplayer) then
										return
									end

									if not vCLIENT.checkAnim(nplayer) then
										TriggerClientEvent("Notify",source,"importante","O jogador não está rendido.")
										return
									end

                                    if not vRPclient.isHandcuffed(nplayer) then
                                        if vRP.tryGetInventoryItem(user_id, "algemas", 1, true, slot) then
                                            vRP.giveInventoryItem(user_id, "chave_algemas", 1, true)
                                            vCLIENT.arrastar(nplayer, source)
                                            vRPclient._playAnim( source, false, {{"mp_arrest_paired", "cop_p2_back_left"}}, false )
                                            vRPclient._playAnim( nplayer, false, {{"mp_arrest_paired", "crook_p2_back_left"}}, false )
                                            SetTimeout(3500,function()
                                                    vRPclient._stopAnim(source, false)
                                                    vRPclient._toggleHandcuff(nplayer)
                                                    vCLIENT.arrastar(nplayer, source)
                                                    TriggerClientEvent("sound:source", source, "cuff", 0.1)
                                                    TriggerClientEvent("sound:source", nplayer, "cuff", 0.1)
                                                    vRPclient._setHandcuffed(nplayer, true)
                                                end)
                                        else
                                            TriggerClientEvent( "Notify", source, "negado", "Você não possui algemas." )
                                        end
                                    end
                                else
                                    TriggerClientEvent("Notify", source, "negado", "Nenhum jogador proximo.")
                                end

elseif item == "chave_algemas" then
                                local nplayer = vRPclient.getNearestPlayer(source, 3)
                                if nplayer then
                                    if vRPclient.isHandcuffed(source) then
                                        if vRP.tryGetInventoryItem(user_id, "chave_algemas", 1, true, slot) then
                                            vRP.giveInventoryItem(user_id, "algemas", 1, true)
                                            TriggerClientEvent("sound:source", source, "uncuff", 0.4)
                                            TriggerClientEvent("sound:source", nplayer, "uncuff", 0.4)
                                            vRPclient._setHandcuffed(nplayer, false)
                                        else
                                            TriggerClientEvent( "Notify", source, "negado", "Você não possui chave de algemas." )
                                        end
                                    end
                                else
                                    TriggerClientEvent("Notify", source, "negado", "Nenhum jogador proximo." )
                                end

                            else
                                vRP.useInventoryItem(user_id, item, amount)
                            end
							end								

if itemType == "equipar" then
                            -- COOLDOWN REDUZIDO: De 5 para 1 segundo (Muito mais rápido)
                            func:setCooldown(user_id, "inventario", 1)

                            -- Verifica no cliente se a arma JÁ está na mão (Toggle)
                            local isEquipped = vCLIENT.checkWeaponInHand(source, item)

                            if isEquipped then
                                -- --- DESEQUIPAR (GUARDAR) ---
                                vRPclient._replaceWeapons(source, {}) -- Limpa a mão
                                TriggerClientEvent("inventory:UnequipWeapon", source) -- Garante animação
                                TriggerClientEvent("Notify",source,"azul","Arma <b>guardada</b>.")
                            else
                                -- --- EQUIPAR (PUXAR) ---
                                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                                    local weapons = {}
                                    weapons[item] = { ammo = 0 } -- Vem sem munição (recarrega com R)
                                    
                                    vRPclient._giveWeapons(source, weapons)
                                    TriggerClientEvent("inventory:EquipWeapon", source, item) -- Força pra mão
                                    TriggerClientEvent("Notify",source,"sucesso","Arma <b>equipada</b>.")
                                else
                                    TriggerClientEvent("Notify",source,"negado","Você não possui este item.")
                                end
                            end
                            
                            updateHotbar(source)
                        end


						if itemType == "beber" then
							func:setCooldown(user_id, "inventario", 5)

							local fome,sede = vRP.itemFood(item)

							if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
								TriggerClientEvent("progress",source, 10000)
								play_drink(source, item, 10000)
								SetTimeout(10000, function() 
                                    vRP.upgradeThirst(user_id, tonumber(sede))
                                    
                                    -- ADICIONE ESSE BLOCO AQUI
                                    if item == "agua" then
                                        vRP.giveInventoryItem(user_id, "garrafa_vazia", 1)
                                        TriggerClientEvent("Notify",source,"sucesso","Você guardou a garrafa vazia.")
									-- Notify Visual da Garrafa Vazia ganhada:
										TriggerClientEvent("inventory:NotifyItem",source, "garrafa_vazia", "Garrafa Vazia", 1, "adicionado")
										-- Notify Visual da Agua perdida:
										TriggerClientEvent("inventory:NotifyItem",source, "agua", "Água", 1, "removido")

                                    end
                                    ----------------------------

									if item == "energetico" then
										TriggerClientEvent("Notify",source,"sucesso","Energetico utilizado com sucesso.")
										vCLIENT.setEnergetico(source, true)
				
										SetTimeout(30*1000, function() 
											TriggerClientEvent("Notify",source,"negado","O Efeito do energetico acabou.")
											vCLIENT.setEnergetico(source, false)
										end)
									end
								end)
							end
						end

						if itemType == "comer" then
							func:setCooldown(user_id, "inventario", 5)

							local fome,sede = vRP.itemFood(item)
				
							if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then

								TriggerClientEvent("progress",source, 10500)
								play_eat(source, item, 10500)

								SetTimeout(10500, function() vRP.upgradeHunger(user_id, tonumber(fome)) end)
							end
						end

						if itemType == "bebera" then
							local fome,sede = vRP.itemFood(item)
							func:setCooldown(user_id, "inventario", 5)

							TriggerClientEvent("progress",source, 10000)
							play_drink(source, item, 10000)
				
							if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
								SetTimeout(15*1000, function()
									vRPclient._playScreenEffect(source, "RaceTurbo", 60*amount)
									vRPclient._playScreenEffect(source, "DrugsTrevorClownsFight", 60*amount)
									vCLIENT._SetAnim(source, amount)
								end)
							end
						end

						if itemType == "remedio" then
							func:setCooldown(user_id, "inventario", 5)
							if item == "bandagem" then

								if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
									vRPclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)

									TriggerClientEvent("progress",source, 15000)
									SetTimeout(15*1000, function()
										vRPclient._DeletarObjeto(source)
										vCLIENT._useBandagem(source)
										TriggerClientEvent( "Notify", source, "importante", "Você utilizou a bandagem, não tome nenhum tipo de dano para não ser cancelada.." )
									end)
									
								end
							end


							if item == "adrenalina" then
								if vRP.tryGetInventoryItem(user_id, item, 1, true, slot) then
									local nplayer = vRPclient.getNearestPlayer(source,2)
									if nplayer then
										vRPclient._playAnim(source,false,{{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
										TriggerClientEvent("progress",source, 15)
										SetTimeout(15*1000, function()
											vRPclient.stopAnim(source)
											vRPclient.setHealth(nplayer, 200)
											TriggerClientEvent( "Notify", source, "importante", "Você utilizou a adrenalina no seu amigo.." )
										end)
									end
									
								end
							end
						end

                        vCLIENT.updateInventory(source, "updateMochila")
						vCLIENT.closeInventory(source)
                else
                    TriggerClientEvent( "Notify", source, "negado", "Aguarde <b>" .. time .. " segundo(s)</b> para utilizar isso novamente." )
                end
            end
        end
    end
	updateHotbar(source)
end

function src.droparItem(slot,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local status,time = func:getCooldown(user_id, "drop")

		if GetPlayerRoutingBucket(source) ~= 0 then
			TriggerClientEvent( "Notify", source, "negado", "Você não pode item agora." )
			return
		end

		if status then
			func:setCooldown(user_id, "drop", 2)

			local inv = vRP.getInventory(user_id)
			if inv then
				if not inv[tostring(slot)] or inv[tostring(slot)].item == nil then
					return
				end

				local itemName = inv[tostring(slot)].item

				if vRP.tryGetInventoryItem(user_id,itemName, parseInt(amount), true, slot) then
					TriggerClientEvent("inventory:NotifyItem",source, itemName, vRP.getItemName(itemName), amount, "removido")
					vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
					src.createDropItem(itemName,parseInt(amount),source)
					vCLIENT.updateInventory(source, "updateMochila")

					local nplayer = vRP.getNearestPlayer(source, 15)
					if nplayer then
						vCLIENT.updateInventory(nplayer, "updateMochila")
					end

					vRP.sendLog("DROPAR", "O ID "..user_id.." dropou o item "..vRP.getItemName(itemName).." na quantidade de "..amount.."x.")
				end
			end
		else
			TriggerClientEvent( "Notify", source, "negado", "Aguarde <b>" .. time .. " segundo(s)</b> para utilizar isso novamente." )
		end
	end
	updateHotbar(source)
end

function src.pegarItem(id,slot,amount)
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		local status,time = func:getCooldown(user_id, "pegar")
		if GetPlayerRoutingBucket(source) ~= 0 then
			TriggerClientEvent( "Notify", source, "negado", "Você não pode pegar item agora." )
			return
		end

		if status then
			func:setCooldown(user_id, "pegar", 2)

			if droplist[id] == nil then
				return
			else

				if vRP.computeInvWeight(user_id)+vRP.getItemWeight(tostring(droplist[id].item))*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
					if tostring(droplist[id].item) == "dinheiro" then
						vRP.giveInventoryItem(user_id,tostring(droplist[id].item),parseInt(amount), true, vRP.getItemInSlot(user_id, "dinheiro", slot))
					else
						vRP.giveInventoryItem(user_id,tostring(droplist[id].item),parseInt(amount), true, slot)
					end

					TriggerClientEvent("inventory:NotifyItem",source, droplist[id].item, vRP.getItemName(droplist[id].item), amount, "adicionado")
					
					vRP.sendLog("", "O ID "..user_id.." pegou o item do chão "..droplist[id].item.." na quantidade de "..amount.."x.")
						
					if droplist[id].count - amount >= 1 then 
						vCLIENT.removeDrop(-1, id)
						
						local newamount = droplist[id].count - amount
						src.createDropItem(droplist[id].item, newamount, source)

						droplist[id] = nil
						idgens:free(id)
					else
						vCLIENT.removeDrop(-1, id)
						droplist[id] = nil
						idgens:free(id)
					end
			
					vCLIENT.updateInventory(source, "updateMochila")
				else
					TriggerClientEvent( "Notify", source, "negado", "Mochila cheia." )
				end
			end
		else
			TriggerClientEvent( "Notify", source, "negado", "Aguarde <b>" .. time .. " segundo(s)</b> para utilizar isso novamente." )
		end
	end
	updateHotbar(source)
end

function src.sendItem(item,slot,amount)
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		local status,time = func:getCooldown(user_id, "enviar")
		if GetPlayerRoutingBucket(source) ~= 0 then
			TriggerClientEvent( "Notify", source, "negado", "Você não enviar item agora." )
			return
		end

		if status then
			func:setCooldown(user_id, "enviar", 2)

			if amount == nil or amount <= 0 then
				amount = vRP.getInventoryItemAmount(user_id, item)
			end

			local nplayer = vRPclient.getNearestPlayer(source, 3)
			if nplayer then
				local nuser_id = vRP.getUserId(nplayer)
				if vRP.computeInvWeight(nuser_id)+vRP.getItemWeight(tostring(item))*parseInt(amount) <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id, item, parseInt(amount), true, slot) then
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						vRP.giveInventoryItem(nuser_id, item, parseInt(amount), true)
						vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)

						vRP.sendLog("ENVIAR", "O ID "..user_id.." enviou o item "..vRP.getItemName(item).." na quantidade de "..amount.."x para o id "..nuser_id..".")
					end
				else
					TriggerClientEvent( "Notify", source, "negado", "Mochila do jogador cheia." )
				end

				vCLIENT.updateInventory(nplayer, "updateMochila")
				vCLIENT.updateInventory(source, "updateMochila")
			else
				TriggerClientEvent( "Notify", source, "negado", "Nenhum jogador proximo.")
			end
		end
	end
end

function src.updateSlot(itemName, slot, target, targetName, targetamount, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local firstItemAmount = vRP.getInventoryItemAmount(user_id, itemName)

		if amount == nil or amount <= 0 then 
			amount = 1 
		end

		if targetamount == nil or targetamount <= 0 then 
			targetamount = 1
		end

		local inv = vRP.getInventory(user_id)
		if inv then
			if targetName ~= nil then
				if itemName ~= targetName then
					if vRP.tryGetInventoryItem(user_id, itemName, firstItemAmount, false, slot) then
						if vRP.tryGetInventoryItem(user_id, targetName, targetamount, false, target) then 
							vRP.giveInventoryItem(user_id, itemName, firstItemAmount, false, target)
							vRP.giveInventoryItem(user_id, targetName, targetamount, false, slot)
						end
					end
				else
					if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
						vRP.giveInventoryItem(user_id, itemName, amount, false, target)
					end
				end
			else
				if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
					vRP.giveInventoryItem(user_id, itemName, amount, false, target)
				end
			end
		end
	end
	updateHotbar(source)
end

function src.checkPermission(permission)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, permission) then
			return true
		end
	end
end

function src.checkConnected()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if GetPlayerPing(source) > 0 then
			return true
		else
			print("Troxa tentando dupar: "..user_id)
		end
	end
end

function checkPlate(plate)
	local rows = vRP.query("vRP/getPlate", {placa = plate} ) or nil
	if not rows[1] then
		return true
	end
end

function checkNumber(numero)
	local rows = vRP.query("vRP/getNumber", {phone = numero} ) or nil
	if not rows[1] then
		return true
	end
end

function checkRG(numero)
	local rows = vRP.query("vRP/getregistration", {registration = numero} ) or nil
	if not rows[1] then
		return true
	end
end

function formatNumber(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1-'):reverse())..right
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE INVENTARIO DE VEICULOS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local openedVehicle = {}
local dataVehicle = {}

function src.openVehicles(plate,mName)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local mPlaca = string.gsub(plate, " ","")
	local amountMoc = vRP.getMochilaAmount(user_id)

	if user_id then
		if mPlaca and mName then
			local Vehicle,Network,Plate,Model = vRPclient.VehicleList(source, 7)
			if openedVehicle[mPlaca] == user_id then

				local inv = vRP.getInventory(user_id)
				local myInventory = {}
				if inv then
					for k,v in pairs(inv) do
						if allItems[v["item"]] then

							v["amount"] = parseInt(v["amount"])
							v["name"] = allItems[v["item"]][1]
							v["peso"] = allItems[v["item"]][3]
							v["index"] = allItems[v["item"]][2]
							v["key"] = v["item"]
							v["slot"] = k
							myInventory[k] = v
						end
					end
				end

				if dataVehicle[mPlaca] == nil then
					local rows = vRP.getSData("Chest:"..mName..":"..mPlaca)
					dataVehicle[mPlaca] = { json.decode(rows) or {},mName }
				end

				local myVehicle = {}
				if dataVehicle[mPlaca] then
					for k,v in pairs(dataVehicle[mPlaca][1]) do
						if allItems[v["item"]] then
							v["amount"] = parseInt(v["amount"])
							v["name"] = allItems[v["item"]][1]
							v["peso"] = allItems[v["item"]][3]
							v["index"] = allItems[v["item"]][2]
							v["key"] = v["item"]
							v["slot"] = k

							myVehicle[k] = v
							SetTimeout(200, function() v["name"] = nil v["peso"] = nil v["index"] = nil v["key"] = nil v["slot"] = nil end)
						end
					end 
				end

				return myInventory,myVehicle,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(myVehicle),VehicleChest(Model),{identity["name"].." "..identity["firstname"],user_id}, { mPlaca,Model },amountMoc
			else
				vCLIENT.closeInventory(source)
			end
			
		end
	end
end

function src.colocarVehicle(item,amount,slot,mPlate,mName)
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca = string.gsub(mPlate, " ","")

	if user_id and mPlaca then
		if GetPlayerPing(source) > 0 then

			if openedVehicle[mPlaca] == user_id and dataVehicle[mPlaca][1] ~= nil then
				if vRP.computeItemsWeight(dataVehicle[mPlaca][1])+vRP.getItemWeight(item)*parseInt(amount) <= VehicleChest(mName) then
					
					if vRP.tryGetInventoryItem(user_id, item, amount, true) then
						dataVehicle[mPlaca][1][tostring(slot)] =  { amount = amount, item = item }
					end

				else
					TriggerClientEvent( "Notify", source, "negado", "Porta malas cheio." )
				end
			else
				vCLIENT.closeInventory(source)
			end
		end
	end

end

function src.retirarVehicle(item,amount,slot,target,mPlate,mName)
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca = string.gsub(mPlate, " ","")

	if user_id then
		if GetPlayerPing(source) > 0 then

			if openedVehicle[mPlaca] == user_id and dataVehicle[mPlaca][1][tostring(slot)].item ~= nil then
				if vRP.computeInvWeight(user_id)+vRP.getItemWeight(tostring(dataVehicle[mPlaca][1][tostring(slot)].item))*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
					
					vRP.giveInventoryItem(user_id, dataVehicle[mPlaca][1][tostring(slot)].item, amount, true, target)

					dataVehicle[mPlaca][1][tostring(slot)].amount = dataVehicle[mPlaca][1][tostring(slot)].amount - amount
					if dataVehicle[mPlaca][1][tostring(slot)].amount <= 0 then
						dataVehicle[mPlaca][1][tostring(slot)] = nil
					end

				else
					TriggerClientEvent( "Notify", source, "negado", "Mochila cheia." )
				end
			else
				vCLIENT.closeInventory(source)
			end
		end
	end
	
end

function src.updateVehicleSlots(itemName, slot, target, targetName, targetamount, amount, mPlate, mName)
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca = string.gsub(mPlate, " ","")

	if user_id and mPlaca then
		if openedVehicle[mPlaca] == user_id then
			if amount == nil or amount <= 0 then 
				amount = 1 
			end

			if targetamount == nil or targetamount <= 0 then 
				targetamount = 1
			end

			if itemName ~= targetName then
				dataVehicle[mPlaca][1][tostring(slot)].amount = dataVehicle[mPlaca][1][tostring(slot)].amount - amount
				dataVehicle[mPlaca][1][tostring(target)] = { amount = amount, item = itemName }

				if itemName and targetName then
					dataVehicle[mPlaca][1][tostring(slot)] = { amount = targetamount, item = targetName }
				end

				if dataVehicle[mPlaca][1][tostring(slot)].amount <= 0 then
					dataVehicle[mPlaca][1][tostring(slot)] = nil
				end

				if dataVehicle[mPlaca][1][tostring(target)].amount <= 0 then
					dataVehicle[mPlaca][1][tostring(target)] = nil
				end
				
			else
				dataVehicle[mPlaca][1][tostring(slot)].amount = dataVehicle[mPlaca][1][tostring(slot)].amount - amount
				dataVehicle[mPlaca][1][tostring(target)].amount = dataVehicle[mPlaca][1][tostring(target)].amount + amount

				if dataVehicle[mPlaca][1][tostring(slot)].amount <= 0 then
					dataVehicle[mPlaca][1][tostring(slot)] = nil
				end

				if dataVehicle[mPlaca][1][tostring(target)].amount <= 0 then
					dataVehicle[mPlaca][1][tostring(target)] = nil
				end
			end
		else
			vCLIENT.closeInventory(source)
		end

	end
end

function src.checkVehicleOpen(plate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local mPlaca = string.gsub(plate, " ","")
		if openedVehicle[mPlaca] == nil then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Este porta malas ja esta sendo utilizado por outra pessoa.")
		end
	end
end

function src.setVehicleOpen(plate, status, vehID)
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca = string.gsub(plate, " ","")
	if user_id then
		if status then
			openedVehicle[mPlaca] = user_id
		--	vCLIENT.trunkchestAnim(-1, vehID, true)
		else
			openedVehicle[mPlaca] = nil
		--	vCLIENT.trunkchestAnim(-1, vehID, false)
		end
	end
end


function save_vehicles_chest()
	local count = 0
	for k,v in pairs(dataVehicle) do
		if openedVehicle[k] == nil then
			vRP.setSData("Chest:"..v[2]..":"..k, json.encode(dataVehicle[k][1]))
			dataVehicle[k] = nil
			count = count + 1
		end
	end
	SetTimeout(200,save_vehicles_chest)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE INVENTARIO DE FACTOPMS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local openedOrg = {}
local dataOrgChest = {}

function src.openOrgChest(id,org,maxbau)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local amountMoc = vRP.getMochilaAmount(user_id)

		if openedOrg[org] == user_id then

			local inv = vRP.getInventory(user_id)
			local myInventory = {}
			if inv then
				for k,v in pairs(inv) do
					if allItems[v["item"]] then

						if v.amount > 0 then
							v["amount"] = parseInt(v["amount"])
							v["name"] = allItems[v["item"]][1]
							v["peso"] = allItems[v["item"]][3]
							v["index"] = allItems[v["item"]][2]
							v["key"] = v["item"]
							v["slot"] = k

							myInventory[k] = v
						end
					end
				end
			end

			if dataOrgChest[org] == nil then
				local rows = vRP.getSData("orgChest:"..org)
				dataOrgChest[org] = { json.decode(rows) or {} }
			end

			local myOrgChest = {}
			for k,v in pairs(dataOrgChest[org][1]) do
				if v.amount > 0 then
					if allItems[v["item"]] then
						v["amount"] = parseInt(v["amount"])
						v["name"] = allItems[v["item"]][1]
						v["peso"] = allItems[v["item"]][3]
						v["index"] = allItems[v["item"]][2]
						v["key"] = v["item"]
						v["slot"] = k
						
						myOrgChest[k] = v
						SetTimeout(200, function() v["name"] = nil v["peso"] = nil v["index"] = nil v["key"] = nil v["slot"] = nil end)
					end
				end
			end 

			return myInventory,myOrgChest,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(myOrgChest),maxbau,{identity["name"].." "..identity["firstname"],user_id}, { id,org },amountMoc
		else
			vCLIENT.closeInventory(source)
		end
	end
end

function src.colocarOrgChest(item,amount,slot, org, maxBau, id)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id and org then
		if openedOrg[org] == user_id then

			if vRP.computeItemsWeight(dataOrgChest[org][1])+vRP.getItemWeight(item)*parseInt(amount) <= maxBau then
				if vRP.tryGetInventoryItem(user_id, item, amount, true) then
					dataOrgChest[org][1][tostring(slot)] =  { amount = amount, item = item }

					if cfg.chestOrgs[id] then
						if cfg.chestOrgs[id].weebhook ~= nil then
							vRP.sendLog(cfg.chestOrgs[id].weebhook, "```css\n["..org.."]\n"..os.date("[%d/%m/%Y] [%X]").." O (ID: "..user_id..") colocou o item ("..vRP.getItemName(item).. " " ..amount.."x)```")
						end
					end
				end
			else
				TriggerClientEvent( "Notify", source, "negado", "Bau cheio." )
			end
		else
			vCLIENT.closeInventory(source)
		end
	end
end

function src.retirarOrgChest(item,amount,slot,target, org, id)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if openedOrg[org] == user_id then

			if vRP.computeInvWeight(user_id)+vRP.getItemWeight(tostring(dataOrgChest[org][1][tostring(slot)].item))*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
				if item == "dinheiro" then
					vRP.giveInventoryItem(user_id, dataOrgChest[org][1][tostring(slot)].item, amount, true, vRP.getItemInSlot(user_id, "dinheiro", target))
				else
					vRP.giveInventoryItem(user_id, dataOrgChest[org][1][tostring(slot)].item, amount, true, target)
				end

				dataOrgChest[org][1][tostring(slot)].amount = dataOrgChest[org][1][tostring(slot)].amount - amount
				if dataOrgChest[org][1][tostring(slot)].amount <= 0 then
					dataOrgChest[org][1][tostring(slot)] = nil
				end

				if cfg.chestOrgs[id] then
					if cfg.chestOrgs[id].weebhook ~= nil then
						vRP.sendLog(cfg.chestOrgs[id].weebhook, "```css\n["..org.."]\n"..os.date("[%d/%m/%Y] [%X]").." O (ID: "..user_id..") retirou o item ("..vRP.getItemName(item).. " " ..amount.."x)```")
					end
				end
			else
				TriggerClientEvent( "Notify", source, "negado", "Mochila cheia." )
			end
		else
			vCLIENT.closeInventory(source)
		end
	end
	
end

function src.updateOrgSlots(itemName, slot, target, targetName, targetamount, amount, org)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id and org then
		if openedOrg[org] == user_id then
			if amount == nil or amount <= 0 then 
				amount = 1 
			end

			if targetamount == nil or targetamount <= 0 then 
				targetamount = 1
			end

			if itemName ~= targetName then
				if dataOrgChest[org] ~= nil then
					dataOrgChest[org][1][tostring(slot)].amount = dataOrgChest[org][1][tostring(slot)].amount - amount
					dataOrgChest[org][1][tostring(target)] = { amount = amount, item = itemName }

					if itemName and targetName then
						dataOrgChest[org][1][tostring(slot)] = { amount = targetamount, item = targetName }
					end

					if dataOrgChest[org][1][tostring(slot)].amount <= 0 then
						dataOrgChest[org][1][tostring(slot)] = nil
					end

					if dataOrgChest[org][1][tostring(target)].amount <= 0 then
						dataOrgChest[org][1][tostring(target)] = nil
					end
				end
			else
				dataOrgChest[org][1][tostring(slot)].amount = dataOrgChest[org][1][tostring(slot)].amount - amount
				dataOrgChest[org][1][tostring(target)].amount = dataOrgChest[org][1][tostring(target)].amount + amount

				if dataOrgChest[org][1][tostring(slot)].amount <= 0 then
					dataOrgChest[org][1][tostring(slot)] = nil
				end

				if dataOrgChest[org][1][tostring(target)].amount <= 0 then
					dataOrgChest[org][1][tostring(target)] = nil
				end
			end

		else
			vCLIENT.closeInventory(source)
		end
	end
end

function src.checkOrgOpen(org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if openedOrg[org] == nil then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Este bau ja esta sendo utilizado por outra pessoa.")
		end
	end
end

function src.setOrgOpen(org, status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if status then
			openedOrg[org] = user_id
		else
			openedOrg[org] = nil
		end
	end
end

function save_org_chest()
	local count = 0
	for k,v in pairs(dataOrgChest) do
		if openedOrg[k] == nil then
			vRP.setSData("orgChest:"..k, json.encode(dataOrgChest[k][1]))
			dataOrgChest[k] = nil
			count = count + 1
		end
	end

	SetTimeout(200,save_org_chest)
end

-- NUIS CALLBACKS INVENTARIO HOUSE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local openedHouseChest = {}
local dataHouseChest = {}

function src.openHouseChest(id, NomeCasa, maxBau)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local amountMoc = vRP.getMochilaAmount(user_id)

		if openedHouseChest[id] == user_id then
			local inv = vRP.getInventory(user_id)
			local myInventory = {}
			if inv then
				for k,v in pairs(inv) do
					if allItems[v["item"]] then

						v["amount"] = parseInt(v["amount"])
						v["name"] = allItems[v["item"]][1]
						v["peso"] = allItems[v["item"]][3]
						v["index"] = allItems[v["item"]][2]
						v["key"] = v["item"]
						v["slot"] = k

						myInventory[k] = v
					end
				end
			end

			if dataHouseChest[id] == nil then
				if maxBau <= 60 then
					local rows = vRP.getSData("Fridge:"..NomeCasa)
					dataHouseChest[id] = { json.decode(rows) or {}, NomeCasa, maxBau }
				elseif maxBau >= 100 then
					local rows = vRP.getSData("Vault:"..NomeCasa)
					dataHouseChest[id] = { json.decode(rows) or {}, NomeCasa, maxBau }
				end
			end

			local myHouseChest = {}
			for k,v in pairs(dataHouseChest[id][1]) do
				if allItems[v["item"]] then
					v["amount"] = parseInt(v["amount"])
					v["name"] = allItems[v["item"]][1]
					v["peso"] = allItems[v["item"]][3]
					v["index"] = allItems[v["item"]][2]
					v["key"] = v["item"]
					v["slot"] = k
					
					myHouseChest[k] = v
					SetTimeout(200, function() v["name"] = nil v["peso"] = nil v["index"] = nil v["key"] = nil v["slot"] = nil end)
				end
			end 

			return myInventory,myHouseChest,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(myHouseChest),dataHouseChest[id][3] + 0.0,{identity["name"].." "..identity["firstname"],user_id}, { NomeCasa },amountMoc
		else
			TriggerClientEvent("Notify",source,"negado","Este bau ja esta sendo utilizado por outra pessoa.")
			vCLIENT.closeInventory(source)
		end
	end
end

function src.colocarHousehest(item,amount,slot, id)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id and id then
		if openedHouseChest[id] == user_id or vRP.hasPermission(user_id, "developer.permissao") then

			if vRP.computeItemsWeight(dataHouseChest[id][1])+vRP.getItemWeight(item)*parseInt(amount) <= dataHouseChest[id][3] + 0.0 then
				if vRP.tryGetInventoryItem(user_id, item, amount, true) then
					dataHouseChest[id][1][tostring(slot)] =  { amount = amount, item = item }
				end

				vRP.sendLog("BAUCASAS", "** COLOCOU ** O ID "..user_id.." colocou o item "..vRP.getItemName(item).." na quantidade de "..amount.."x da propriedade "..dataHouseChest[id][2].." ")
			else
				TriggerClientEvent( "Notify", source, "negado", "Bau cheio." )
			end
		else
			vCLIENT.closeInventory(source)
		end
	end

end

function src.retirarHouseChest(item,amount,slot,target, id)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if openedHouseChest[id] == user_id or vRP.hasPermission(user_id, "admin.permissao") then
			
			if vRP.computeInvWeight(user_id)+vRP.getItemWeight(tostring(dataHouseChest[id][1][tostring(slot)].item))*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
				if item == "dinheiro" then
					vRP.giveInventoryItem(user_id, dataHouseChest[id][1][tostring(slot)].item, amount, true, vRP.getItemInSlot(user_id, "dinheiro", target))
				else
					vRP.giveInventoryItem(user_id, dataHouseChest[id][1][tostring(slot)].item, amount, true, target)
				end

				dataHouseChest[id][1][tostring(slot)].amount = dataHouseChest[id][1][tostring(slot)].amount - amount
				if dataHouseChest[id][1][tostring(slot)].amount <= 0 then
					dataHouseChest[id][1][tostring(slot)] = nil
				end

				vRP.sendLog("BAUCASAS", "** RETIRAR ** O ID "..user_id.." retirou o item "..vRP.getItemName(item).." na quantidade de "..amount.."x da propriedade "..dataHouseChest[id][2].." ")
			else
				TriggerClientEvent( "Notify", source, "negado", "Mochila cheia." )
			end
		else
			vCLIENT.closeInventory(source)
		end
	end
	
end

-- DESBUGAR BAÚ--
RegisterCommand('maravilha',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao")  then
		openedOrg = {}
	end
end)

function src.updateHouseSlots(itemName, slot, target, targetName, targetamount, amount, id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and id then
		if openedHouseChest[id] == user_id or vRP.hasPermission(user_id, "developer.permissao") then
			if amount == nil or amount <= 0 then 
				amount = 1 
			end

			if targetamount == nil or targetamount <= 0 then 
				targetamount = 1
			end

			if itemName ~= targetName then
				dataHouseChest[id][1][tostring(slot)].amount = dataHouseChest[id][1][tostring(slot)].amount - amount
				dataHouseChest[id][1][tostring(target)] = { amount = amount, item = itemName }

				if itemName and targetName then
					dataHouseChest[id][1][tostring(slot)] = { amount = targetamount, item = targetName }
				end

				if dataHouseChest[id][1][tostring(slot)].amount <= 0 then
					dataHouseChest[id][1][tostring(slot)] = nil
				end

				if dataHouseChest[id][1][tostring(target)].amount <= 0 then
					dataHouseChest[id][1][tostring(target)] = nil
				end
				
			else
				dataHouseChest[id][1][tostring(slot)].amount = dataHouseChest[id][1][tostring(slot)].amount - amount
				dataHouseChest[id][1][tostring(target)].amount = dataHouseChest[id][1][tostring(target)].amount + amount

				if dataHouseChest[id][1][tostring(slot)].amount <= 0 then
					dataHouseChest[id][1][tostring(slot)] = nil
				end

				if dataHouseChest[id][1][tostring(target)].amount <= 0 then
					dataHouseChest[id][1][tostring(target)] = nil
				end
			end
		else
			vCLIENT.closeInventory(source)
		end
	end
end

function src.checkHouseChest(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if openedHouseChest[id] == nil then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Este bau ja esta sendo utilizado por outra pessoa.")
		end
	end
end

function src.setHouseChest(id, status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if status then
			openedHouseChest[id] = user_id
		else
			openedHouseChest[id] = nil
		end
	end
end

function save_house_chest()
	local count = 0
	for k,v in pairs(dataHouseChest) do
		if openedHouseChest[k] == nil then
			if v[3] >= 100 then
				vRP.setSData("Vault:"..v[2], json.encode(dataHouseChest[k][1]))
				dataHouseChest[k] = nil
				count = count + 1
			elseif v[3] <= 60 then
				vRP.setSData("Fridge:"..v[2], json.encode(dataHouseChest[k][1]))
				dataHouseChest[k] = nil
				count = count + 1
			end
		end
	end

	SetTimeout(200,save_house_chest)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE INVENTARIO REVISTAR
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local openedRevistar = {}

function src.openRevistar(nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = vRP.getUserSource(parseInt(nuser_id))
	if user_id then
		local amountMoc = vRP.getMochilaAmount(user_id)

		if nplayer then
			if openedRevistar[nuser_id] == user_id then
				local identity2 = vRP.getUserIdentity(nuser_id)

				local inv = vRP.getInventory(user_id)
				local myInventory = {}
				if inv then
					for k,v in pairs(inv) do
						if allItems[v["item"]] then
							v["amount"] = parseInt(v["amount"])
							v["name"] = allItems[v["item"]][1]
							v["peso"] = allItems[v["item"]][3]
							v["index"] = allItems[v["item"]][2]
							v["key"] = v["item"]
							v["slot"] = k

							myInventory[k] = v
						end
					end
				end

				local inv2 = vRP.getInventory(nuser_id)
				local myHouseChest = {}
				for k,v in pairs(inv2) do
					if allItems[v["item"]] then
						v["amount"] = parseInt(v["amount"])
						v["name"] = allItems[v["item"]][1]
						v["peso"] = allItems[v["item"]][3]
						v["index"] = allItems[v["item"]][2]
						v["key"] = v["item"]
						v["slot"] = k
						
						myHouseChest[k] = v
						SetTimeout(200, function() v["name"] = nil v["peso"] = nil v["index"] = nil v["key"] = nil v["slot"] = nil end)
					end
				end 
				return myInventory,myHouseChest,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(myHouseChest),vRP.getInventoryMaxWeight(nuser_id),{identity["name"].." "..identity["firstname"],user_id}, { identity2.name, identity2.firstname, nuser_id },amountMoc
			else
				vCLIENT.closeInventory(source)
			end

		end
	end
end

function src.checkOpenRevistar()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local nplayer = vRPclient.getNearestPlayer(source, 5)
		local nuser_id = vRP.getUserId(nplayer)

		if vRPclient.getHealth(nplayer) <= 101 or vRP.request(nplayer,"Aceita ser Revistado ?", 30) then
			if nplayer then
				
				-- if vRP.hasPermission(user_id,"perm.policia") then
				-- 	return
				-- end

				if vRP.hasPermission(nuser_id, "perm.disparo") and vRP.checkPatrulhamento(nuser_id) then
					TriggerClientEvent("Notify",source,"negado","Você não pode saquear um policia em patrulhamento.")
					return
				end

				if openedRevistar[nuser_id] == nil then
					if vCLIENT.checkAnim(nplayer) or vRPclient.getHealth(nplayer) >= 101 or vRPclient.isHandcuffed(nplayer) then
						TriggerClientEvent("Notify",source,"sucesso","Iniciando revista...")
						TriggerClientEvent("Notify",nplayer,"negado","Você está sendo revistado...")
		
						local weapons = vRPclient.replaceWeapons(nplayer,{})
						for k,v in pairs(weapons) do
								vRP.giveInventoryItem(nuser_id, k, 1, true)
							if v.ammo > 0 then
								local weapon = string.gsub(k, "WEAPON_","AMMO_")
								vRP.giveInventoryItem(nuser_id, weapon, v.ammo, true)
							end
						end
						
						vCLIENT.updateWeapons(nplayer)
						vCLIENT.closeInventory(nplayer)
						revistando(source,user_id, nplayer, nuser_id)

						return nuser_id
					else
						TriggerClientEvent("Notify",source,"negado","O jogador precisa estar em coma ou rendido.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Este jogador ja esta sendo revistado por outra pessoa.")
				end
			end
		end

		return false
	end
end

function src.setRevistar(id, status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if status then
			openedRevistar[id] = user_id
		else
			openedRevistar[id] = nil
		end
	end
end

local itensblock = {
	["algemas"] = true,
	["chave_algemas"] = true,
	["c4"] = true,
	["bolsadinheiro"] = true,
	["masterpick"] = true,
	["pendrive"] = true,
	["furadeira"] = true,
	["lockpick"] = true,
	["m-aco"] = true,
	["m-capa_colete"] = true,
	["m-corpo_ak47_mk2"] = true,
	["m-corpo_g3"] = true,
	["m-corpo_machinepistol"] = true,
	["m-corpo_pistol_mk2"] = true,
	["m-corpo_shotgun"] = true,
	["m-corpo_smg_mk2"] = true,
	["m-corpo_snspistol_mk2"] = true,
	["m-gatilho"] = true,
	["capsulas"] = true,
	["polvora"] = true,
	["pecadearma"] = true,
	["placademetal"] = true,
	["molas"] = true,
	["gatilho"] = true,
	["m-malha"] = true,
	["m-placametal"] = true,
	["m-tecido"] = true,
	["c-cobre"] = true,
	["c-ferro"] = true,
	["c-fio"] = true,
	["c-polvora"] = true,
	["l-alvejante"] = true,
	["folhamaconha"] = true,
	["maconha"] = true,
	["pastabase"] = true,
	["cocaina"] = true,
	["acidolsd"] = true,
	["colete"] = true,
	["capuz"] = true,
	["dirty_money"] = true,
	["scubagear"] = true,
	["relogioroubado"] = true,
	["colarroubado"] = true,
	["anelroubado"] = true,
	["brincoroubado"] = true,
	["pulseiraroubada"] = true,
	["carnedepuma"] = true,
	["carnedelobo"] = true,
	["carnedejavali"] = true,
	["lsd"] = true,
	["morfina"] = true,
	["heroina"] = true,
	["anfetamina"] = true,
	["metanfetamina"] = true,
	["tartaruga"] = true,
	["WEAPON_SNSPISTOL_MK2"] = true,
	["AMMO_SNSPISTOL_MK2"] = true,
	["WEAPON_PISTOL_MK2"] = true,
	["WEAPON_GUSENBERG"] = true,
	["WEAPON_PISTOL50"] = true,
	["WEAPON_HEAVYPISTOL"] = true,
	["WEAPON_HATCHET"] = true,
	["AMMO_PISTOL_MK2"] = true,
	["WEAPON_COMBATPISTOL"] = true,
	["WEAPON_COMBATPDW"] = true,
	["AMMO_COMBATPISTOL"] = true,
	["WEAPON_MACHINEPISTOL"] = true,
	["AMMO_MACHINEPISTOL"] = true,
	["WEAPON_SMG_MK2"] = true,
	["AMMO_SMG_MK2"] = true,
	["WEAPON_SMG"] = true,
	["AMMO_SMG"] = true,
	["WEAPON_ASSAULTSMG"] = true,
	["AMMO_ASSAULTSMG"] = true,
	["WEAPON_SAWNOFFSHOTGUN"] = true,
	["AMMO_SAWNOFFSHOTGUN"] = true,
	["WEAPON_PUMPSHOTGUN_MK2"] = true,
	["AMMO_PUMPSHOTGUN_MK2"] = true,
	["WEAPON_ASSAULTRIFLE_MK2"] = true,
	["AMMO_ASSAULTRIFLE_MK2"] = true,
	["WEAPON_SPECIALCARBINE_MK2"] = true,
	["AMMO_SPECIALCARBINE_MK2"] = true,
	["WEAPON_CARBINERIFLE"] = true,
	["AMMO_CARBINERIFLE"] = true,
	["WEAPON_SPECIALCARBINE"] = true,
	["AMMO_SPECIALCARBINE"] = true,
	["WEAPON_STUNGUN"] = true,
	["WEAPON_PETROLCAN"] = true,
	["AMMO_PETROLCAN"] = true,
}

function src.retirarItemRevistar(id, item, target, amount, slot)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRP.getUserSource(id)
	if user_id then
		if nplayer then
			if openedRevistar[id] == user_id then

				if vRP.hasPermission(user_id,"ol.permissao") then
					if itensblock[item] ~= nil then
						TriggerClientEvent("Notify",source,"negado","Você não pode pegar esse item de bandidos.")
						return
					end
				end

				if vRP.computeInvWeight(user_id)+vRP.getItemWeight(tostring(item))*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
					if vRP.tryGetInventoryItem(id, item, amount, true, slot) then
						if item == "dinheiro" then
							vRP.giveInventoryItem(user_id, item, amount, true, vRP.getItemInSlot(user_id, "dinheiro", target))
						else
							vRP.giveInventoryItem(user_id, item, amount, true, target)
						end

						vRP.sendLog("SAQUEAR", "O ID "..user_id.." saqueou o item "..vRP.getItemName(item).." na quantidade "..amount.."x do ID "..id..".")
					end
				else
					TriggerClientEvent( "Notify", source, "negado", "Mochila cheia." )
				end
				
			else
				vCLIENT.closeInventory(source)
			end
		end
	end
end

function revistando(source,user_id, nplayer,nuser_id)
	async(function()
		while true do
			if openedRevistar[nuser_id] == user_id then
				local x,y,z = vRPclient.getPosition(source)
				local nx,ny,nz = vRPclient.getPosition(nplayer)
				if vCLIENT.checkPositions(source, vec3(x,y,z), vec3(nx,ny,nz)) then
					openedRevistar[nuser_id] = nil
					vCLIENT.closeInventory(source)
					vCLIENT.closeInventory(nplayer)
					TriggerClientEvent("Notify",source,"negado","Você se afastou muito do jogador e a revista foi cancelada..")
				end
			end

			Citizen.Wait(1000)
		end
	end)
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NUIS CALLBACKS STORES
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function src.openStore(id)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local amountMoc = vRP.getMochilaAmount(user_id)
		local inv = vRP.getInventory(user_id)
		local myInventory = {}
		if inv then
			for k,v in pairs(inv) do
				if (parseInt(v["amount"]) <= 0 or allItems[v.item] == nil) then
					vRP.removeInventoryItem(user_id,v.item,parseInt(v["amount"]))
				else
					v["amount"] = parseInt(v["amount"])
					v["name"] = allItems[v["item"]][1]
					v["peso"] = allItems[v["item"]][3]
					v["index"] = allItems[v["item"]][2]
					v["key"] = v["item"]
					v["slot"] = k

					myInventory[k] = v
				end
			end
		end

		if cfg.stores[id] then
			local items = cfg.stores[id].items
			local myStore = {}
			for k,v in pairs(items) do
				v["name"] = allItems[v.item][1]
				v["buyPrice"] = v.priceBuy
				v["sellPrice"] = v.priceSell
				v["key"] = v.item

				myStore[v.slot] = v
			end

			return myInventory,myStore,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id),0,9999,{identity["name"].." "..identity["firstname"],user_id}, { id },amountMoc
		end

	end
end

function src.buyStore(id, item, target, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if cfg.stores[id] then
            local items = cfg.stores[id].items
            if items[item].priceBuy ~= nil then

                if vRP.computeInvWeight(user_id)+vRP.getItemWeight(tostring(item))*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
                    
                    local price = parseInt(items[item].priceBuy)
                    local totalPrice = price * parseInt(amount)

                    if price == 0 or vRP.tryFullPayment(user_id, totalPrice) then

                        vRP.giveInventoryItem(user_id, item, amount, true, target)

                        if string.upper(item):find("WEAPON_") then
                            local serial = "W"..math.random(1000,9999).."-"..user_id
                            TriggerClientEvent("Notify",source,"sucesso","Arma registrada com Serial: <b>"..serial.."</b>")
                        end

                        if totalPrice > 0 then
                            TriggerClientEvent("Notify", source, "sucesso", "Você pagou <b>$ "..vRP.format(totalPrice).."</b>.")
                        end

                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui dinheiro.")
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Mochila cheia.")
                end
            end
        end
    end
end

function src.sellStore(id, item, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if cfg.stores[id] then
			local items = cfg.stores[id].items
			local bonus = cfg.stores[id].bonus
			local dinheiro = cfg.stores[id].dinheiro

			for k,v in pairs(items) do
				Pagar = v.priceSell
			end

			if vRP.tryGetInventoryItem(user_id, item, amount) then
				if dinheiro == "limpo" then 
					vRP.GiveCarteira(user_id, parseInt(Pagar)*amount)
				elseif dinheiro == "sujo" then 
					dinheiro = "dinheirosujo" 
					vRP.giveInventoryItem(user_id, dinheiro, parseInt(items[item].sellPrice)*amount, true)
				end

				vCLIENT.updateInventory(source, "updateStore")
			else
				TriggerClientEvent( "Notify", source, "negado", "Você não possui dinheiro." )
			end
				
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE DROPAR DROPAR ITEM
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function src.createDropItem(item,count,source)
    local id = idgens:gen()
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.getItemName(item), key = item, index = vRP.getItemType(item), peso = vRP.getItemWeight(item) }
	vCLIENT.updateDrops(-1,id,droplist[id]) 

	local nplayer = vRP.getNearestPlayer(source, 15)
	if nplayer then
		vCLIENT.updateInventory(nplayer, "updateMochila")
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE DROPAR DROPAR ITEM
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function src.DropServer(item,count,source,coords)
    local id = idgens:gen()
    local x,y,z = table.unpack(coords)
    droplist[id] = { item = item, count = count, x = x, y = y, z = z + 0.1, name = vRP.getItemName(item), key = item, index = vRP.getItemType(item), peso = vRP.getItemWeight(item) }
	vCLIENT.updateDrops(-1,id,droplist[id]) 
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES DE UTILIZAÇÃO DE ITENS INVENTARIO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function play_eat(source, tipo, segundos)
	local prop = ""
	-- COMIDAS
	if tipo == "sanduiche" then
		prop = "prop_cs_burger_01"
	elseif tipo == "pizza" then
		prop = "prop_taco_01"
	elseif tipo == "chocolate" then
		prop = "prop_choc_meto"
	elseif tipo == "hotdog" then
		prop = "prop_cs_hotdog_01"
	elseif tipo == "pipoca" then
		prop = "ng_proc_food_chips01b"
	elseif tipo == "donut" then
		prop = "prop_amb_donut"
	else
		prop = "prop_cs_burger_01"
	end

	vRPclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c",prop,49,28422)
	SetTimeout(10500, function() vRPclient._DeletarObjeto(source) end)
end

function play_drink(source, tipo, segundos)
	local prop = ""
	-- BEBIDAS
	if tipo == "energetico" then
		prop = "prop_energy_drink"
	elseif tipo == "agua" then
		prop = "prop_ld_flow_bottle"
	elseif tipo == "cafe" then
		prop = "prop_fib_coffee"
	elseif tipo == "cocacola" then
		prop = "ng_proc_sodacan_01a"

	-- BEBIDAS ALCOLICAS
	elseif tipo == "cerveja" then
		prop = "prop_amb_beer_bottle"
	elseif tipo == "whisky" then
		prop = "prop_drink_whisky"
	elseif tipo == "vodka" then
		prop = "p_whiskey_notop" 
	elseif tipo == "pinga" then
		prop = "p_whiskey_notop" 
	elseif tipo == "corote" then
		prop = "ng_proc_sodacan_01b"
	elseif tipo == "absinto" then
		prop = "prop_drink_whisky"
	elseif tipo == "skolb" then
		prop = "ng_proc_sodacan_01b"
	else
		prop = "prop_ld_flow_bottle"
	end
	
	vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a",prop,49,28422)
    SetTimeout(segundos, function() vRPclient._DeletarObjeto(source) end)
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("bauadm",function(source,args)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, "admin.permissao") then
			if tonumber(args[1]) and tonumber(args[1]) > 0 then
				vCLIENT.openSelectedChest(source, "houseChest", tonumber(args[1]))
				vRP.sendLog("HOUSEADMCHEST", "```css\n O Admin "..user_id.." acessou o bau da propriedade ID: "..tonumber(args[1]).. "```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
	TriggerClientEvent("syncreparar",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR MOTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trymotor")
AddEventHandler("trymotor",function(nveh)
	TriggerClientEvent("syncmotor",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR PNEUS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryrepararpneus")
AddEventHandler("tryrepararpneus",function(nveh)
	TriggerClientEvent("syncrepararpneus",-1,nveh)
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if user_id then 
		for k,v in pairs(openedOrg) do
			if openedOrg[k] == user_id then
				openedOrg[k] = nil
				print("(ID: "..user_id.. ") Crashou com Bau da Organização aberto.")
			end
		end

		for k,v in pairs(openedVehicle) do
			if openedVehicle[k] == user_id then
				openedVehicle[k] = nil
				print("(ID: "..user_id.. ") Crashou com Bau do Carro aberto.")
			end
		end

		for k,v in pairs(openedHouseChest) do
			if openedHouseChest[k] == user_id then
				openedHouseChest[k] = nil
				print("(ID: "..user_id.. ") Crashou com Bau da casa aberta.")
			end
		end
	end
end)

async(function()
	save_org_chest()
	save_vehicles_chest()
	save_house_chest()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE HOTBAR (Adicione isso no final do arquivo)
-----------------------------------------------------------------------------------------------------------------------------------------
function updateHotbar(source)
    local user_id = vRP.getUserId(source)
    if user_id then
        local inv = vRP.getInventory(user_id)
        if inv then
            local items = {}
            for k,v in pairs(inv) do
                -- Verifica se o item está nos slots 1 a 5
                if parseInt(k) >= 1 and parseInt(k) <= 5 then
                    if allItems[v.item] then
                        items[k] = {
                            item = v.item,
                            amount = parseInt(v.amount)
                        }
                    end
                end
            end
            -- Envia para o HTML
            TriggerClientEvent("inventory:UpdateHotbar", source, items)
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- RECARREGAR ARMA (RESPEITANDO O LIMITE DE 250)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:ReloadWeapon")
AddEventHandler("inventory:ReloadWeapon", function(weaponHash, amountNeeded)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local weaponName = nil
        -- Busca o nome da arma pelo Hash
        for name, _ in pairs(ammoTable) do
            if GetHashKey(name) == weaponHash then
                weaponName = name
                break
            end
        end

        if weaponName then
            local ammoItem = ammoTable[weaponName]
            if ammoItem then
                local ammoAmount = vRP.getInventoryItemAmount(user_id, ammoItem)
                
                if ammoAmount > 0 then
                    -- Define quanto vai carregar:
                    -- O cliente pediu X para completar 250. Se não pediu nada, tenta 250.
                    local amountToTake = amountNeeded or 250 
                    
                    -- Se tiver MENOS no inventário do que precisa, usa tudo que tem
                    if ammoAmount < amountToTake then
                        amountToTake = ammoAmount
                    end

                    -- Consome do inventário
                    if vRP.tryGetInventoryItem(user_id, ammoItem, amountToTake, true) then
                        
                        -- Adiciona na arma
                        TriggerClientEvent("inventory:ClientAddAmmo", source, weaponName, amountToTake)
                        
                        TriggerClientEvent("Notify",source,"sucesso","Recarregou <b>"..amountToTake.."x</b> munições.")
                        updateHotbar(source)
                    else
                         TriggerClientEvent("Notify",source,"negado","Erro ao processar munição.")
                    end
                else
                    TriggerClientEvent("Notify",source,"negado","Sem <b>munição</b> no inventário.")
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER MUNIÇÃO (AGORA COMO SERVER EVENT)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:removeAmmo")
AddEventHandler("inventory:removeAmmo", function(weaponItem)
    local source = source
    local user_id = vRP.getUserId(source)
    
    -- Verifica se a arma está na mão
    local isEquipped = vCLIENT.checkWeaponInHand(source, weaponItem)

    if isEquipped then
        local currentAmmo = vRPclient.getAmmoInWeapon(source, weaponItem)
        
        if currentAmmo > 0 then
            vRPclient.setWeaponAmmo(source, weaponItem, 0)
            local ammoItem = ammoTable[weaponItem]
            if ammoItem then
                vRP.giveInventoryItem(user_id, ammoItem, currentAmmo)
                TriggerClientEvent("Notify",source,"sucesso","Você removeu <b>"..currentAmmo.."x</b> balas.")
                updateHotbar(source)
            end
        else
            TriggerClientEvent("Notify",source,"negado","Arma está vazia.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Equipe a arma primeiro.")
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE CAIXAS DE ARMAS (UNBOXING + REGISTRO DE SERIAL)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Espera o vRP carregar

    -- Percorre todas as armas que têm munição definida para criar suas caixas
    -- Certifique-se que a tabela 'ammoTable' está definida no início do arquivo
    for weapon, ammo in pairs(ammoTable) do
        local boxItem = "box_"..weapon
        
        -- Define o que acontece ao usar a caixa
        vRP.defInventoryItem(boxItem, function(source, user_id, itemName, itemAmount)
            
            -- Tenta pegar 1 caixa
            if vRP.tryGetInventoryItem(user_id, boxItem, 1, true) then
                
                -- Gera o Serial: W + ID QUEM ABRIU + Aleatório
                local serial = "W"..user_id.."-"..math.random(1000, 9999)
                
                -- Dá a arma
                vRP.giveInventoryItem(user_id, weapon, 1, true)
                
                -- Efeito Visual (Opcional)
                TriggerClientEvent("Notify", source, "sucesso", "Você abriu a caixa!<br>Serial: <b>"..serial.."</b>")
                
                -- Se quiser salvar no banco de dados futuramente, seria aqui.
            end
        end)
    end

    -- Caixa do Tazer (Manual pq geralmente não tem munição)
    local tazerBox = "box_WEAPON_STUNGUN"
    vRP.defInventoryItem(tazerBox, function(source, user_id, itemName, itemAmount)
        if vRP.tryGetInventoryItem(user_id, tazerBox, 1, true) then
            local serial = "T"..user_id.."-"..math.random(1000, 9999)
            vRP.giveInventoryItem(user_id, "WEAPON_STUNGUN", 1, true)
            TriggerClientEvent("Notify", source, "sucesso", "Tazer registrado!<br>Serial: <b>"..serial.."</b>")
        end
    end)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICAR SERIAL (UPDATED)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:checkSerial")
AddEventHandler("inventory:checkSerial", function(weaponItem)
    local source = source
    local user_id = vRP.getUserId(source)

    if not weaponItem then return end

    local weaponName = vRP.getItemName(weaponItem)
    if not weaponName then 
        TriggerClientEvent("Notify",source,"negado","Isso não é uma arma.")
        return 
    end

    -- Gera um serial visual baseado no portador atual para simular
    -- (Já que vRP antigo não salva serial no item, o serial "muda" se trocar de dono, simulando raspagem/novo registro)
    local serial = "REG-"..user_id.."-"..math.random(1000, 9999)
    local durabilidade = math.random(90, 100) 

    local mensagem = "<b>Arma:</b> "..weaponName.."<br>"..
                     "<b>Serial Atual:</b> <span style='color:#00ff88'>"..serial.."</span><br>"..
                     "<b>Estado:</b> "..durabilidade.."%"
    
    TriggerClientEvent("Notify",source,"azul", mensagem, 8000)
end)


-- Atualiza a hotbar assim que o jogador entra na cidade
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        Wait(2000)
        updateHotbar(source)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO /VERARMA (PARA POLÍCIA/ADMIN)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("verarma", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    -- Adicione verificação de permissão de polícia aqui se quiser:
    -- if vRP.hasPermission(user_id, "policia.permissao") then
    
    local nplayer = vRPclient.getNearestPlayer(source, 2)
    if nplayer then
        local nuser_id = vRP.getUserId(nplayer)
        
        -- Pergunta ao cliente do jogador próximo qual arma ele tá segurando
        local weaponHash = vRPclient.getWeapons(nplayer) -- Precisa verificar se sua base tem essa função
        -- OU usando uma estratégia mais garantida:
        
        local weapons = vRPclient.replaceWeapons(nplayer, {}) -- Pega as armas (cuidado, isso tira as armas na vRP antiga!)
        -- SE SUA BASE FOR AS MAIS NOVAS QUE NÃO TIRAM ARMA AO CHECAR, USE OUTRA LÓGICA.
        
        -- MODO SEGURO (Sem tirar arma):
        -- Você precisaria de um evento client-side no alvo para retornar a arma atual.
        TriggerClientEvent("inventory:checkWeaponTarget", nplayer, source)
    else
        TriggerClientEvent("Notify",source,"negado","Nenhum jogador próximo.")
    end
end)

-- Evento de retorno (Server -> Client Alvo -> Server Policial)
RegisterServerEvent("inventory:receiveWeaponCheck")
AddEventHandler("inventory:receiveWeaponCheck", function(policeSource, weaponName, ammo)
    local source = source -- O bandido
    local user_id = vRP.getUserId(source)
    
    local serial = "BUSCA-"..user_id.."-"..math.random(100,999)
    
    local mensagem = "<b>Alvo:</b> "..user_id.."<br>"..
                     "<b>Arma:</b> "..weaponName.."<br>"..
                     "<b>Serial:</b> "..serial.."<br>"..
                     "<b>Munição:</b> "..ammo
                     
    TriggerClientEvent("Notify", policeSource, "importante", mensagem, 10000)
end)