config = {}

config.sendItemsToServer = true

config.items = {
	["none"] = { "none", "none", 0.0, nil, nil},

	-- Utilitarios
	["mochila"] = { "Mochila", "usar", 2.0, nil, nil},
	["roupas"] = { "Roupas", "none", 0.0, nil, nil},
	["algema"] = { "Algema", "usar", 2.0, nil, nil},
	["alianca"] = { "Alianca", "usar", 1.0, nil, nil},
	["nitro"] = { "Nitrox", "usar", 1.0, nil, nil},
	["foguete"] = { "Foguete", "usar", 1.0, nil, nil},
	["megaphone"] = { "Megaphone", "usar", 1.0, nil, nil},
	["cartaodeacesso"] = { "Cartão de Acesso", "none", 1.0, nil, nil},

	["suspensaoar"] = { "Kit Suspensão", "usar", 4.0, nil, nil},
	["moduloneon"] = { "Módulo Neon", "usar", 4.0, nil, nil},
	["moduloxenon"] = { "Módulo Xenon", "usar", 4.0, nil, nil},

	["vibrador"] = { "Vibrador", "none", 1.0, nil, nil},
	["cintaralho"] = { "Cintaralho", "none", 1.0, nil, nil},

	-- Mecanica
	["pneus"] = { "Pneus","usar", 10.0, nil, nil},
	["repairkit"] = { "Kit de Reparos", "usar", 1.0, nil, nil},
	["militec"] = { "Militec", "usar", 1.0, nil, nil},
	["ferramenta"] = { "Ferramenta", "none", 0.5, nil, nil},
	["nitrogenio"] = { "Nitrogênio", "none", 1.0, nil, nil},
	["cilindro"] = { "Cilindro", "none", 1.0, nil, nil},

	-- Eletronicos
	["radio"] = { "Radio", "none", 1.0, nil, nil},
    ["celular"] = { "Celular", "none", 1.0, nil, nil},
	["encomenda"] = { "Encomenda", "none", 3.0, nil, nil},
	-- Itens para Roubar
	["keycard"] = { "Keycard", "none", 1.0, nil, nil},
	["c4"] = { "C4", "usar", 5.0, nil, nil},
	["masterpick"] = { "MasterPick", "none", 1.0, nil, nil},
	["pendrive"] = { "Pendrive", "none", 1.0, nil, nil},
	["furadeira"] = { "Furadeira", "none", 3.0, nil, nil},
	["serra"] = { "Serra", "none", 3.0, nil, nil},
	["lockpick"] = { "Lock Pick", "usar", 1.0, nil, nil},

	-- Itens Armas
	["gatilho"] = { "Gatilho", "none", 0.40, nil, nil},
	["placademetal"] = { "Placa de Metal", "none", 0.3, nil, nil},
	["pecadearma"] = { "Peça de arma", "none", 0.3, nil, nil},
	["molas"] = { "Molas", "none", 0.3, nil, nil},
    ["corpo_ak47_mk2"] = { "Corpo de AK47", "none", 5.0, nil, nil},
    ["corpo_g3"] = { "Corpo de G3", "none", 5.0, nil, nil},
    ["corpo_machinepistol"] = { "Corpo de TEC-9", "none", 2.0, nil, nil},
    ["corpo_pistol_mk2"] = { "Corpo de Pistol", "none", 1.5, nil, nil},
    ["corpo_shotgun"] = { "Corpo de Shotgun", "none", 5.0, nil, nil},
    ["corpo_smg_mk2"] = { "Corpo de SMG", "none", 2.0, nil, nil},
    ["corpo_snspistol_mk2"] = { "Corpo de Fajuta", "none", 1.0, nil, nil},

	-- Itens Munição
	["polvora"] = { "Polvora", "none", 0.1, nil, nil},
	["capsulas"] = { "Cápsulas", "none", 0.1, nil, nil},
	["kevlar"] = { "Kevlar", "none", 0.1, nil, nil},
	["pano"] = { "Pano", "none", 0.1, nil, nil},
	["tecido"] = { "Tecido", "none", 0.40, nil, nil},

	-- Itens Lavagem
	["alvejante"] = { "Alvejante", "none", 1.0, nil, nil},
	["chip"] = { "Chip", "none", 0.6, nil, nil},

	-- Itens Drogas
	["cannabis"] = { "Cannabis", "none", 0.3, nil, nil},
    ["maconha"] = { "Maconha", "usar", 1.0, nil, nil},

    ["folhadecoca"] = { "Folha de Coca", "none", 0.3, nil, nil},
    ["cocaina"] = { "Cocaína", "usar", 1.0, nil, nil},
	
	-- Itens Desmanche
	["aco"] = { "Aço", "none", 0.3, nil, nil},
	["fita"] = { "Fita", "none", 0.3, nil, nil},
	["placa"] = { "Placa", "usar", 2.5, nil, nil},

    -- Ilegal
	["colete"] = { "Colete", "usar", 10.0, nil, nil},
    ["capuz"] = { "Capuz", "usar", 0.1, nil, nil},
    ["dinheirosujo"] = { "Dinheiro Sujo", "none", 0.0, nil, nil},

	-- Itens Joalheria
	["relogioroubado"] = { "Relogio Roubado", "none", 0.5, nil, nil},
	["colarroubado"] = { "Colar Roubado", "none", 0.1, nil, nil},
	["anelroubado"] = { "Anel Roubado", "none", 0.1, nil, nil},
	["brincoroubado"] = { "Brinco Roubado", "none", 0.1, nil, nil},
	["pulseiraroubada"] = { "Pulseira Roubada", "none", 0.1, nil, nil},

    -- Drogas
	["anfetamina"] = { "Anfetamina", "none", 0.9, nil, nil},
	["metanfetamina"] = { "Metanfetamina ", "usar", 1.0, nil, nil},
	["balinha"] = { "Balinha", "usar", 1.0, nil, nil},
	["podemd"] = { "Pó de MD", "none", 0.9, nil, nil},

	-- Graos
	["graos"] = { "Graos", "none", 1.0, nil, nil},
    ["graosimpuros"] = { "Graos Impuros", "none", 1.0, nil, nil},

	-- Mineracao
	["bronze"] = { "Bronze", "none", 1.0, nil, nil},
	["ferro"] = { "Ferro", "none", 0.4, nil, nil},
	["ouro"] = { "Ouro", "none", 1.0, nil, nil},
	["diamante"] = { "Diamante", "none", 1.0, nil, nil},
	["rubi"] = { "Rubi", "none", 1.0, nil, nil},
	["safira"] = { "Safira", "none", 1.0, nil, nil},

	-- EMPREGOS
	["caixa"] = { "Caixa De Brinquedos", "none", 1.0, nil, nil},	
	["lenha"] = { "Lenha", "none", 1.0, nil, nil},
	["laranja"] = { "Laranja", "none", 1.0, nil, nil},

	-- COMIDAS
	["donut"] = { "Donut", "comer", 0.5, 50, nil},
	["sanduiche"] = { "Sanduiche", "comer", 0.5, 50, nil},
	["chocolate"] = { "Chocolate", "comer", 0.5, 50, nil},
	["pizza"] = { "Pizza", "comer", 1.5, 50, nil},
	["hotdog"] = { "Cachorro Quente", "comer", 0.5, 50, nil},
	["hamburguer"] = { "Hamburguer", "comer", 0.3, 50, nil},

	-- IGREDIENTES
	["pao"] = { "Pão", "comer", 1.0, nil, nil},
	["massa"] = { "Massa", "comer", 1.0, nil, nil},
	["tomate"] = { "Tomate", "comer", 1.0, nil, nil},
	["alface"] = { "Alface", "comer", 1.0, nil, nil},
	["queijo"] = { "Queijo", "comer", 1.0, nil, nil},
	["salsicha"] = { "Salsicha", "comer", 1.0, nil, nil},
	["carne"] = { "Carne", "comer", 1.0, nil, nil},

	-- BEBIDAS
	["cafe"] = { "Café", "beber", 0.5, nil, 50},
	["cocacola"] = { "Coca Cola", "beber", 0.5, nil, 50},
	["agua"] = { "Água", "beber", 0.5, nil, 50},
	["garrafa_vazia"] = { "Garrafa Vazia", "none", 0.5, nil, nil},
	["energetico"] = { "Energetico", "beber", 0.25, nil, 50},

	-- ALCOLICAS FOME/SEDE
	["vodka"] = { "Vodka", "bebera", 1.0, 10, 7},
	["cerveja"] = { "Cerveja", "bebera", 0.5, 3, 10},
	["whisky"] = { "Whisky", "bebera", 1.0, 10, 8}, 
	["absinto"] = { "Absinto", "bebera", 0.5, 10, 10},

	-- REMEDIOS
	["amoxilina"] = { "Amoxilina", "remedio", 0.05, 5, nil},
	["dipirona"] = { "Dipirona", "remedio", 0.05, 5, nil},
	["paracetamol"] = { "Paracetamol", "remedio", 0.05, 5, nil},
	["coumadin"] = { "Coumadin", "remedio", 0.05, 5, nil},
	["dorflex"] = { "Dorflex", "remedio", 0.05, 5, nil},
	["anticoncepcional"] = { "Anticoncepcional", "remedio", 0.05, 5, nil},
	["bandagem"] = { "Bandagem", "remedio", 0.5, 5, nil},

	["adrenalina"] = { "Adrenalina", "remedio", 0.5, 5, nil},

	-- MACHADOS
	["WEAPON_HATCHET"] = { "Machados", "equipar", 3.0, nil, nil},
	["WEAPON_KNIFE"] = { "Faca", "equipar", 3.0, nil, nil},
	["WEAPON_DAGGER"] = { "Dagger", "equipar", 3.0, nil, nil},  -- Punhal
	["WEAPON_KNUCKLE"] = { "Knuckle", "equipar", 3.0, nil, nil},
	["WEAPON_MACHETE"] = { "Machete", "equipar", 3.0, nil, nil}, -- facão
	["WEAPON_SWITCHBLADE"] = { "SwitchBlade", "equipar", 3.0, nil, nil}, -- Canivete
	["WEAPON_WRENCH"] = { "Wrench", "equipar", 3.0, nil, nil}, -- chave inglesa
	["WEAPON_HAMMER"] = { "Hammer", "equipar", 3.0, nil, nil}, -- Martelo
	["WEAPON_GOLFCLUB"] = { "GolfClub", "equipar", 3.0, nil, nil}, -- Clube de Golf
	["WEAPON_CROWBAR"] = { "CrowBar", "equipar", 3.0, nil, nil},  -- Pé de cabra
	["WEAPON_FLASHLIGHT"] = { "Lanterna", "equipar", 3.0, nil, nil},
	["WEAPON_BAT"] = { "Bastão de Beisebol", "equipar", 3.0, nil, nil},
	["WEAPON_BOTTLE"] = { "Bottle", "equipar", 3.0, nil, nil},  -- Garrafa
	["WEAPON_BATTLEAXE"] = { "Battleaxe", "equipar", 3.0, nil, nil}, -- Machado de batalha
	["WEAPON_POOLCUE"] = { "Poolcue", "equipar", 3.0, nil, nil}, -- Taco de sinuca
	["GADGET_PARACHUTE"] = { "Paraquedas", "equipar", 3.0, nil, nil},
	["WEAPON_FLARE"] = { "Sinalizador", "equipar", 3.0, nil, nil},
	["WEAPON_KARAMBITKNIFE"] = { "Karambit", "equipar", 3.0, nil, nil},

	-- PISTOLAS
	["WEAPON_SNSPISTOL_MK2"] = { "Fajuta", "equipar", 3.0, nil, nil},
	["AMMO_SNSPISTOL_MK2"] = { "M-Fajuta", "recarregar", 0.05, nil, nil},

	["WEAPON_PISTOL_MK2"] = { "Five-Seven", "equipar", 3.0, nil, nil},
	["AMMO_PISTOL_MK2"] = { "M-Five-Seven", "recarregar", 0.05, nil, nil},

	["WEAPON_GUSENBERG"] = { "Submetralhadora Thompson", "equipar", 3.0, nil, nil},
	["AMMO_GUSENBERG"] = { "M-Thompson", "recarregar", 0.05, nil, nil},

	["WEAPON_PISTOL50"] = { "Desert Eagle", "equipar", 3.0, nil, nil},
	["AMMO_PISTOL50"] = { "M-Desert", "recarregar", 0.05, nil, nil},

	["WEAPON_COMBATPISTOL"] = { "Glock", "equipar", 3.0, nil, nil},
	["AMMO_COMBATPISTOL"] = { "M-Glock", "recarregar", 0.05, nil, nil},

	["WEAPON_COMBATPDW"] = { "Combat Pdw", "equipar", 3.0, nil, nil},
	["AMMO_COMBATPDW"] = { "M-Pdw", "recarregar", 0.05, nil, nil},

	["WEAPON_GLOCK18C"] = { "Glock 18C", "equipar", 3.0, nil, nil},
	["AMMO_GLOCK18C"] = { "M-Glock 18C", "recarregar", 0.05, nil, nil},

	["WEAPON_DE"] = { "Desert Eagle", "equipar", 3.0, nil, nil},
	["AMMO_DE"] = { "M-Desert Eagle", "recarregar", 0.05, nil, nil},

	["WEAPON_PISTOL"] = { "Pistol", "equipar", 3.0, nil, nil},
	["AMMO_PISTOL"] = { "M-Pistol", "recarregar", 0.05, nil, nil},

	["WEAPON_FNX45"] = { "FNX45", "equipar", 3.0, nil, nil},
	["AMMO_FNX45"] = { "M-FNX45", "recarregar", 0.05, nil, nil},
	
	-- SUBMETRALHADORA
	["WEAPON_MACHINEPISTOL"] = { "Tec-9", "equipar", 6.0, nil, nil},
	["AMMO_MACHINEPISTOL"] = { "M-Tec-9", "recarregar", 0.05, nil, nil},

	["WEAPON_SMG_MK2"] = { "Smg MK2", "equipar", 6.0, nil, nil},
	["AMMO_SMG_MK2"] = { "M-Smg MK2", "recarregar", 0.05, nil, nil},

	["WEAPON_SMG"] = { "SMG", "equipar", 6.0, nil, nil},
	["AMMO_SMG"] = { "M-SMG", "recarregar", 0.05, nil, nil},

	["WEAPON_ASSAULTSMG"] = { "MTAR", "equipar", 6.0, nil, nil},
	["AMMO_ASSAULTSMG"] = { "M-MTAR", "recarregar", 0.05, nil, nil},

	["WEAPON_UZI"] = { "Uzi", "equipar", 6.0, nil, nil},
	["AMMO_UZI"] = { "M-Uzi", "recarregar", 0.05, nil, nil},


	-- SHOTGUN
	["WEAPON_SAWNOFFSHOTGUN"] = { "Shotgun", "equipar", 8.0, nil, nil},
	["AMMO_SAWNOFFSHOTGUN"] = { "M-Shotgun", "recarregar", 0.05, nil, nil},

	["WEAPON_PUMPSHOTGUN_MK2"] = { "Pump Shotgun", "equipar", 8.0, nil, nil},
	["AMMO_PUMPSHOTGUN_MK2"] = { "M-Pump Shotgun", "recarregar", 0.05, nil, nil},

	-- FUZIL
	["WEAPON_ASSAULTRIFLE"] = { "AK 47", "equipar", 8.0, nil, nil},
	["AMMO_ASSAULTRIFLE"] = { "M-AK-47", "recarregar", 0.05, nil, nil},

	["WEAPON_ASSAULTRIFLE_MK2"] = { "AK MK2", "equipar", 8.0, nil, nil},
	["AMMO_ASSAULTRIFLE_MK2"] = { "M-AK MK2", "recarregar", 0.05, nil, nil},

	["WEAPON_SPECIALCARBINE"] = { "Parafal", "equipar", 8.0, nil, nil},
	["AMMO_SPECIALCARBINE"] = { "M-Parafal", "recarregar", 0.05, nil, nil},

	["WEAPON_SPECIALCARBINE_MK2"] = { "G3", "equipar", 8.0, nil, nil},
	["AMMO_SPECIALCARBINE_MK2"] = { "M-G3", "recarregar", 0.05, nil, nil},

	["WEAPON_DOUBLEACTION"] = { "DOUBLEACTION", "equipar", 8.0, nil, nil},
	["AMMO_DOUBLEACTION"] = { "M-DOUBLEACTION", "recarregar", 0.05, nil, nil},

	["WEAPON_CARBINERIFLE"] = { "M4", "equipar", 8.0, nil, nil},
	["AMMO_CARBINERIFLE"] = { "M-M4", "recarregar", 0.05, nil, nil},
	
	["WEAPON_CARBINERIFLE_MK2"] = { "M4 MK2", "equipar", 8.0, nil, nil},
	["AMMO_CARBINERIFLE_MK2"] = { "M-M4 MK2", "recarregar", 0.05, nil, nil},
	
	["WEAPON_MUSKET"] = { "Musket", "equipar", 8.0, nil, nil},
	["AMMO_MUSKET"] = { "M-Musket", "recarregar", 0.05, nil, nil},

	["WEAPON_AK47"] = { "AK47", "equipar", 8.0, nil, nil},
	["AMMO_AK47"] = { "M-AK47", "recarregar", 0.05, nil, nil},

	["WEAPON_AR15"] = { "AR15", "equipar", 8.0, nil, nil},
	["AMMO_AR15"] = { "M-AR15", "recarregar", 0.05, nil, nil},

	["WEAPON_M4"] = { "M4", "equipar", 8.0, nil, nil},
	["AMMO_M4"] = { "M-M4", "recarregar", 0.05, nil, nil},

	["WEAPON_M70AB2"] = { "M70AB2", "equipar", 8.0, nil, nil},
	["AMMO_M70AB2"] = { "M-M70AB2", "recarregar", 0.05, nil, nil},

	["WEAPON_M110"] = { "M110", "equipar", 8.0, nil, nil},
	["AMMO_M110"] = { "M-M110", "recarregar", 0.05, nil, nil},

	["WEAPON_MK14"] = { "MK14", "equipar", 8.0, nil, nil},
	["AMMO_MK14"] = { "M-MK14", "recarregar", 0.05, nil, nil},

	["WEAPON_SCARH"] = { "SCAR-H", "equipar", 8.0, nil, nil},
	["AMMO_SCARH"] = { "M-SCAR-H", "recarregar", 0.05, nil, nil},


	-- TAZER
	["WEAPON_STUNGUN"] = { "Tazer", "equipar", 1.0, nil, nil},

	-- GALAO DE GASOLINA
	["WEAPON_PETROLCAN"] = { "Galão de gasolina", "equipar", 1.0, nil, nil},
	["AMMO_PETROLCAN"] = { "Gasolina", "recarregar", 0.05, nil, nil},

	-- ATTACHMENTS
	["WEAPON_AT_AR_FLSH"] = { "Lanterna AR", "equipar", 0.5, nil, nil},
	["WEAPON_AT_AR_SUPP"] = { "Silenciador AR", "equipar", 0.5, nil, nil},
	["WEAPON_AT_AR_AFGRIP"] = { "Grip AR", "equipar", 0.5, nil, nil},
	["WEAPON_AT_PI_FLSH"] = { "Lanterna Pistol", "equipar", 0.5, nil, nil},
	["WEAPON_AT_PI_SUPP"] = { "Silenciador Pistol", "equipar", 0.5, nil, nil},
	["WEAPON_AT_SR_SUPP"] = { "Silenciador Sniper", "equipar", 0.5, nil, nil},

	-- CAIXAS DE ARMAS (SISTEMA DE UNBOXING)
    
    -- PISTOLAS
    ["box_WEAPON_SNSPISTOL_MK2"] = { "Caixa de Fajuta", "usar", 1.0, nil, nil},
    ["box_WEAPON_PISTOL_MK2"] = { "Caixa de Five-Seven", "usar", 1.0, nil, nil},
    ["box_WEAPON_GUSENBERG"] = { "Caixa de Thompson", "usar", 1.0, nil, nil},
    ["box_WEAPON_PISTOL50"] = { "Caixa de Desert Eagle", "usar", 1.0, nil, nil},
    ["box_WEAPON_COMBATPISTOL"] = { "Caixa de Glock", "usar", 1.0, nil, nil},
    ["box_WEAPON_COMBATPDW"] = { "Caixa de Combat Pdw", "usar", 1.0, nil, nil},
    ["box_WEAPON_GLOCK18C"] = { "Caixa de Glock 18C", "usar", 1.0, nil, nil},
    ["box_WEAPON_DE"] = { "Caixa de Desert Eagle", "usar", 1.0, nil, nil},
    ["box_WEAPON_PISTOL"] = { "Caixa de Pistol", "usar", 1.0, nil, nil},
    ["box_WEAPON_FNX45"] = { "Caixa de FNX45", "usar", 1.0, nil, nil},

    -- SUBMETRALHADORA
    ["box_WEAPON_MACHINEPISTOL"] = { "Caixa de Tec-9", "usar", 1.5, nil, nil},
    ["box_WEAPON_SMG_MK2"] = { "Caixa de Smg MK2", "usar", 1.5, nil, nil},
    ["box_WEAPON_SMG"] = { "Caixa de SMG", "usar", 1.5, nil, nil},
    ["box_WEAPON_ASSAULTSMG"] = { "Caixa de MTAR", "usar", 1.5, nil, nil},
    ["box_WEAPON_UZI"] = { "Caixa de Uzi", "usar", 1.5, nil, nil},

    -- SHOTGUN
    ["box_WEAPON_SAWNOFFSHOTGUN"] = { "Caixa de Shotgun", "usar", 2.0, nil, nil},
    ["box_WEAPON_PUMPSHOTGUN_MK2"] = { "Caixa de Pump Shotgun", "usar", 2.0, nil, nil},

    -- FUZIL
    ["box_WEAPON_ASSAULTRIFLE"] = { "Caixa de AK 47", "usar", 2.5, nil, nil},
    ["box_WEAPON_ASSAULTRIFLE_MK2"] = { "Caixa de AK MK2", "usar", 2.5, nil, nil},
    ["box_WEAPON_SPECIALCARBINE"] = { "Caixa de Parafal", "usar", 2.5, nil, nil},
    ["box_WEAPON_SPECIALCARBINE_MK2"] = { "Caixa de G3", "usar", 2.5, nil, nil},
    ["box_WEAPON_DOUBLEACTION"] = { "Caixa de DOUBLEACTION", "usar", 2.5, nil, nil},
    ["box_WEAPON_CARBINERIFLE"] = { "Caixa de M4", "usar", 2.5, nil, nil},
    ["box_WEAPON_CARBINERIFLE_MK2"] = { "Caixa de M4 MK2", "usar", 2.5, nil, nil},
    ["box_WEAPON_MUSKET"] = { "Caixa de Musket", "usar", 2.5, nil, nil},
    ["box_WEAPON_AK47"] = { "Caixa de AK47", "usar", 2.5, nil, nil},
    ["box_WEAPON_AR15"] = { "Caixa de AR15", "usar", 2.5, nil, nil},
    ["box_WEAPON_M4"] = { "Caixa de M4", "usar", 2.5, nil, nil},
    ["box_WEAPON_M70AB2"] = { "Caixa de M70AB2", "usar", 2.5, nil, nil},
    ["box_WEAPON_M110"] = { "Caixa de M110", "usar", 2.5, nil, nil},
    ["box_WEAPON_MK14"] = { "Caixa de MK14", "usar", 2.5, nil, nil},
    ["box_WEAPON_SCARH"] = { "Caixa de SCAR-H", "usar", 2.5, nil, nil},

    -- TAZER
    ["box_WEAPON_STUNGUN"] = { "Caixa de Tazer", "usar", 1.0, nil, nil},
}
