cfg = {}




cfg.chestOrgs = { 

    [1] = { coords = vec3(-2397.81, 1810.48, 207.99), maxbau = 5000, org = "Franca", perm = "franca.permissao", weebhook = "" }, -- ARMA FAVELA DA FRANÇA
    [2] = { coords = vec3(2110.55, 3831.34, 37.95), maxbau = 3000, org = "Turquia", perm = "turquia.permissao", weebhook = "" }, -- ARMA FAVELA DO NORTE

    [3] = { coords = vec3(-1037.32, -1487.88, 1.63), maxbau = 3000, org = "Yakuza", perm = "yakuza.permissao", weebhook = "" }, -- MUNIÇÃO MANSÃO NO GOLF
    [4] = { coords = vec3(-1886.47, 2062.33, 140.98), maxbau = 3000, org = "Cartel", perm = "cartel.permissao", weebhook = "" }, -- MUNIÇÃO MANSÃO VINHEDO

    [5] = { coords = vec3(-3087.91,1472.99,25.25), maxbau = 3000, org = "Vagos", perm = "vagos.permissao", weebhook = "" }, -- DESMANCHE FAVELA DO ZANCUDO
    [6] = { coords = vec3(1364.69,-2440.01,62.19), maxbau = 3000, org = "Aztecas", perm = "aztecas.permissao", weebhook = "" }, -- DESMANCHE FAVELA DO PETRÓLEO

    [7] = { coords = vec3(122.75, -1297.84, 29.32), maxbau = 3000, org = "Vanilla", perm = "vanilla.permissao", weebhook = "" }, -- LAVAGEM VANILLA
    [8] = { coords = vec3(741.56,-811.16,24.28), maxbau = 3000, org = "MotoClub", perm = "motoclub.permissao", weebhook = "" }, -- LAVAGEM ARCADEBAR
    
    [9] = { coords = vec3(1345.82, -680.79, 88.55), maxbau = 3000, org = "Ballas", perm = "ballas.permissao", weebhook = "" }, -- DROGAS FAVELA DO HELIPA
    [10] = { coords = vec3(1250.35,-1084.44,54.16), maxbau = 3000, org = "Grove", perm = "grove.permissao", weebhook = "" }, -- DROGAS FAVELA DO ESGOTO
    
    [11] = { coords = vec3(-675.37,316.18,92.75), maxbau = 10000, org = "Hospital", perm = "ems.permissao", weebhook = "" }, -- HOSPITAL NORTE
    [13] = { coords = vec3(883.17,-2100.51,30.46), maxbau = 20000, org = "Mecanica", perm = "mecanico.permissao", weebhook = "" }, -- MEC NA CIDADE
    
    [14] = { coords = vec3(467.58, -989.57, 35.06), maxbau = 30000, org = "Policia", perm = "policia.permissao", weebhook = "" }, -- DP PMESP
    [15] = { coords = vec3(-1188.07, -1726.99, 4.58), maxbau = 10000, org = "Baep", perm = "baep.permissao", weebhook = "" }, -- DP BAEP
    [16] = { coords = vec3(-1221.33, -2286.32, 14.57), maxbau = 10000, org = "Rota", perm = "rota.permissao", weebhook = "" }, -- DP ROTA
    [17] = { coords = vec3(287.58, -325.3, 45.28), maxbau = 10000, org = "Gcm", perm = "gcm.permissao", weebhook = "" }, -- DP GCM
    [18] = { coords = vec3(1451.19, 3550.9, 40.47), maxbau = 10000, org = "Tor", perm = "tor.permissao", weebhook = "" }, -- DP TOR
    [19] = { coords = vec3(2604.76, 5344.91, 47.6), maxbau = 10000, org = "Prf", perm = "prf.permissao", weebhook = "" }, -- DP PRF
    [20] = { coords = vec3(1078.62, -195.99, 71.71), maxbau = 10000, org = "Civil", perm = "civil.permissao", weebhook = "" }, -- DP CIVIL


    [21] = { coords = vec3(-1179.89,-898.96,13.99), maxbau = 10000, org = "BurgerShot", perm = "burgershot.permissao", weebhook = "" }, -- RESTAURANTE BURGUER SHOT
}


cfg.stores = {

    ["Bebidas"] = {
        bonus = false,
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            vodka = { item = "vodka", priceBuy = 200, priceSell = nil, amount = 1, slot = 2 },
            cerveja = { item = "cerveja", priceBuy = 200, priceSell = nil, amount = 1, slot = 3},
            whisky = { item = "whisky", priceBuy = 200, priceSell = nil, amount = 1, slot = 4 },
            absinto = { item = "absinto", priceBuy = 200, priceSell = nil, amount = 1, slot = 5 },
        }
    },

    ["Joalheria"] = {
        bonus = false, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            relogio = { item = "relogioroubado", priceBuy = nil, priceSell = 50, amount = 1, slot = 2 },
            colar = { item = "colarroubado", priceBuy = nil, priceSell = 100, amount = 1, slot = 3 },
            anel = { item = "anelroubado", priceBuy = nil, priceSell = 200, amount = 1, slot = 4 },
            pulseira = { item = "pulseiraroubada", priceBuy = nil, priceSell = 200, amount = 1, slot = 4 },
            brinco = { item = "brincoroubado", priceBuy = nil, priceSell = 300, amount = 1, slot = 5 }
        },
    },

    ["Ammunation"] = {
        bonus = false,
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            WEAPON_KNIFE = { item = "WEAPON_KNIFE", priceBuy = 100000, priceSell = 0, amount = 1, slot = 2 },
            WEAPON_DAGGER = { item = "WEAPON_DAGGER", priceBuy = 100000, priceSell = 0, amount = 1, slot = 3 },
            WEAPON_MACHETE = { item = "WEAPON_MACHETE", priceBuy = 100000, priceSell = 0, amount = 1, slot = 4 },
            WEAPON_SWITCHBLADE = { item = "WEAPON_SWITCHBLADE", priceBuy = 100000, priceSell = 0, amount = 1, slot = 5 },
            WEAPON_WRENCH = { item = "WEAPON_WRENCH", priceBuy = 100000, priceSell = 0, amount = 1, slot = 6 },
            WEAPON_HAMMER = { item = "WEAPON_HAMMER", priceBuy = 100000, priceSell = 0, amount = 1, slot = 7 },
            WEAPON_GOLFCLUB = { item = "WEAPON_GOLFCLUB", priceBuy = 100000, priceSell = 0, amount = 1, slot = 8 },
            WEAPON_CROWBAR = { item = "WEAPON_CROWBAR", priceBuy = 100000, priceSell = 0, amount = 1, slot = 9 },
            WEAPON_FLASHLIGHT = { item = "WEAPON_FLASHLIGHT", priceBuy = 100000, priceSell = 0, amount = 1, slot = 10 },
            WEAPON_BAT = { item = "WEAPON_BAT", priceBuy = 100000, priceSell = 0, amount = 1, slot = 11 },
            WEAPON_BOTTLE = { item = "WEAPON_BOTTLE", priceBuy = 100000, priceSell = 0, amount = 1, slot = 12 },
            WEAPON_BATTLEAXE = { item = "WEAPON_BATTLEAXE", priceBuy = 100000, priceSell = 0, amount = 1, slot = 13 },
            WEAPON_POOLCUE = { item = "WEAPON_POOLCUE", priceBuy = 100000, priceSell = 0, amount = 1, slot = 14 },
            GADGET_PARACHUTE = { item = "GADGET_PARACHUTE", priceBuy = 10000, priceSell = 0, amount = 1, slot = 15 },
        }
    },

    ["Mercado"] = {
        bonus = false,
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            repairkit = { item = "repairkit", priceBuy = 5000, priceSell = nil, amount = 1, slot = 2 },
            militec = { item = "militec", priceBuy = 3000, priceSell = nil, amount = 1, slot = 3 },
            pneus = { item = "pneus", priceBuy = 1000, priceSell = nil, amount = 1, slot = 4 },
            mochila = { item = "mochila", priceBuy = 3000, priceSell = nil, amount = 1, slot = 5 },
            radio = { item = "radio", priceBuy = 1000, priceSell = nil, amount = 1, slot = 6 },
            celular = { item = "celular", priceBuy = 2000, priceSell = nil, amount = 1, slot = 7 },
            roupas = { item = "roupas", priceBuy = 5000, priceSell = nil, amount = 1, slot = 8 },
            alianca = { item = "alianca", priceBuy = 5000, priceSell = nil, amount = 1, slot = 9 },

            donut = { item = "donut", priceBuy = 350, priceSell = nil, amount = 1, slot = 10 },
            chocolate = { item = "chocolate", priceBuy = 350, priceSell = nil, amount = 1, slot = 11 },

            cafe = { item = "cafe", priceBuy = 200, priceSell = nil, amount = 1, slot = 12 },
            cocacola = { item = "cocacola", priceBuy = 200, priceSell = nil, amount = 1, slot = 13 },
            agua = { item = "agua", priceBuy = 200, priceSell = nil, amount = 1, slot = 14 },
            energetico = { item = "energetico", priceBuy = 200, priceSell = nil, amount = 1, slot = 15 },
        }
    },

    ["Bandagem"] = {
        bonus = false,
        dinheiro = "limpo", -- MONEY PARA RECEBER 

        items = {
            none = { item = "none", priceBuy = nil, priceSell = nil, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            bandagem = { item = "bandagem", priceBuy = 10000, priceSell = nil, amount = 1, slot = 2 },
        }
    },

    ["Graos"] = {
        bonus = true, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            graos= { item = "graos", priceBuy = nil, priceSell = 200, amount = 1, slot = 2 },
        },
    },

    ["Feira"] = {
        bonus = false, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            massa = { item = "massa", priceBuy = 200, priceSell = nil, amount = 1, slot = 2 },
            tomate = { item = "tomate", priceBuy = 200, priceSell = nil, amount = 1, slot = 3 },
            alface = { item = "alface", priceBuy = 200, priceSell = nil, amount = 1, slot = 4 },
            queijo = { item = "queijo", priceBuy = 200, priceSell = nil, amount = 1, slot = 5 },
            salsicha = { item = "salsicha", priceBuy = 200, priceSell = nil, amount = 1, slot = 6 },
            carne = { item = "carne", priceBuy = 200, priceSell = nil, amount = 1, slot = 7 },
            pao = { item = "pao", priceBuy = 200, priceSell = nil, amount = 1, slot = 8 },
        },
    },

    ["Cafe"] = {
        bonus = false, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            cafe = { item = "cafe", priceBuy = 250, priceSell = nil, amount = 1, slot = 2 },
            agua = { item = "agua", priceBuy = 100, priceSell = nil, amount = 1, slot = 3 },
            donut = { item = "donut", priceBuy = 100, priceSell = nil, amount = 1, slot = 4 },
            chocolate = { item = "chocolate", priceBuy = 300, priceSell = nil, amount = 1, slot = 5 },
            item = { item = "cocacola", priceBuy = 350, priceSell = nil, amount = 1, slot = 6 },
        },
    },

    ["Contrabando"] = {
        bonus = false, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            gatilho = { item = "gatilho", priceBuy = 5000, priceSell = nil, amount = 1, slot = 2 },
            placademetal = { item = "placademetal", priceBuy = 5000, priceSell = nil, amount = 1, slot = 3 },
            molas = { item = "molas", priceBuy = 5000, priceSell = nil, amount = 1, slot = 4 },
            corpo_ak47_mk2 = { item = "corpo_ak47_mk2", priceBuy = 10000, priceSell = nil, amount = 1, slot = 5 },
            corpo_g3 = { item = "corpo_g3", priceBuy = 10000, priceSell = nil, amount = 1, slot = 6 },
            corpo_machinepistol = { item = "corpo_machinepistol", priceBuy = 10000, priceSell = nil, amount = 1, slot = 7 },
            corpo_pistol_mk2 = { item = "corpo_pistol_mk2", priceBuy = 10000, priceSell = nil, amount = 1, slot = 8 },
            corpo_shotgun = { item = "corpo_shotgun", priceBuy = 10000, priceSell = nil, amount = 1, slot = 9 },
            corpo_smg_mk2 = { item = "corpo_smg_mk2", priceBuy = 10000, priceSell = nil, amount = 1, slot = 10 },
            corpo_snspistol_mk2 = { item = "corpo_snspistol_mk2", priceBuy = 10000, priceSell = nil, amount = 1, slot = 11 },
        },
    },
    
    ["Laranjas"] = {
        bonus = false, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            laranja = { item = "laranja", priceBuy = nil, priceSell = 100, amount = 1, slot = 2 },
        },
    },

    ["Lenhador"] = {
        bonus = false, 
        dinheiro = "limpo", -- MONEY PARA RECEBER

        items = {
            none = { item = "none", priceBuy = 1, priceSell = 1, amount = 1, slot = 1 }, -- NAO MEXER SLOT PADRAO
            lenha = { item = "lenha", priceBuy = nil, priceSell = 100, amount = 1, slot = 2 },
        },
    },
}

cfg.storesLocs = {
    { type = "Joalheria",  blip = false, blipName = "Joalheria", blipID = 617, blipColor = 0, perm = nil, coords = vector3(-621.0, -228.58, 38.05) },
    { type = "Graos", blip = false, blipName = "Venda Graos", blipID = 478, blipColor = 0, perm = nil, coords = vector3(2885.46, 4387.4, 50.73) },
    { type = "Cafe", blip = false, blipName = "Cafeteria", blipID = 478, blipColor = 0, perm = nil, coords = vector3(-1024.9, -2762.13, 21.37) },
    { type = "Cafe", blip = false, blipName = "Cafeteria", blipID = 478, blipColor = 0, perm = nil, coords = vector3(-691.51, 322.29, 83.09) },

    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(1693.16,3760.08,34.71) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(252.62,-50.16,69.95) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(842.5,-1034.03,28.2) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(-330.66,6084.14,31.46) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(-662.27,-934.82,21.83) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(-1305.35,-394.27,36.7) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(-1118.12,2698.83,18.56) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(2568.04,293.88,108.74) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(-3172.41,1087.83,20.84) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(22.16,-1106.69,29.8) },
    { type = "Ammunation", blip = false, blipName = "Ammunation", blipID = 76, blipColor = 0, perm = nil, coords = vector3(810.23,-2157.77,29.62) },

    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-47.7,-1757.16,29.43) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(25.66,-1347.26,29.5) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1163.53,-322.9,69.21) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(373.77,326.11,103.57) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(2557.27,382.02,108.63) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(2678.63,3280.45,55.25) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1961.13,3740.59,32.35) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(547.8,2671.21,42.16) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1698.78,4923.95,42.07) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1728.92,6414.72,35.04) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-3242.12,1001.18,12.84) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-3039.37,585.66,7.91) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-1820.99,793.4,138.12) },
    { type = "Mercado", blip = false, blipName = "Mercado", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-707.33,-913.68,19.22) },


    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1135.66,-982.96,46.42) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1165.33,2709.43,38.16) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-1487.64,-378.56,40.17) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-1222.21,-906.77,12.33) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(1391.94,3604.85,34.99) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-2967.73,391.61,15.05) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(95.78, -1274.83, 21.11) },
    { type = "Bebidas", blip = false, blipName = "Loja de Bebidas", blipID = 52, blipColor = 0, perm = nil, coords = vector3(-1029.56, -1474.15, 5.31) },

    { type = "Feira", blip = true, blipName = "Feira", blipID = 628, blipColor = 0, perm = nil, coords = vector3(1476.66,2724.17,37.56) },
    { type = "Feira", blip = true, blipName = "Feira", blipID = 628, blipColor = 0, perm = nil, coords = vector3(148.6,1668.79,228.74) },

    { type = "Contrabando", blip = false, blipName = "Contrabando", blipID = 587, blipColor = 0, perm = nil, coords = vector3(1701.34,3291.29,48.93) },
    { type = "Laranjas", blip = false, blipName = "Laranjas", blipID = 587, blipColor = 0, perm = nil, coords = vector3(2311.43, 4765.1, 37.29) },
    { type = "Lenhador", blip = false, blipName = "Lenhador", blipID = 587, blipColor = 0, perm = nil, coords = vector3(-1490.53, 4981.56, 63.34) },

}