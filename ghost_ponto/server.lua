local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local cfgGroups = module("vrp", "Config/Groups")
local groups = cfgGroups.groups

-- Tabela para verificar quem está online trabalhando (para o loop de salvamento)
local activeWorkers = {} 

-- LISTA NEGRA DE ARMAS
local armasServico = {
    "WEAPON_CARBINERIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_SMG", "WEAPON_COMBATPDW",
    "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL",
    "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_KNIFE", "WEAPON_FLASHLIGHT"
}

-- Função Limpar Armas
local function limparArmasServico(source)
    vRPclient.getWeapons(source, function(weapons)
        if weapons then
            local houveAlteracao = false
            for k, v in pairs(weapons) do
                local armaPlayerUpper = string.upper(k)
                for _, armaProibida in pairs(armasServico) do
                    if armaPlayerUpper == string.upper(armaProibida) then
                        weapons[k] = nil
                        houveAlteracao = true
                        break
                    end
                end
            end
            if houveAlteracao then vRPclient.replaceWeapons(source, weapons) end
        end
    end)
    TriggerClientEvent("vrp_ponto:limparArmasVisual", source, armasServico)
end

-- Funções de Tempo (UData)
local function getWorkingHours(user_id)
    local data = vRP.getUData(user_id, "vRP:PontoHoras")
    return json.decode(data) or 0
end

local function addWorkingTime(user_id, minutes)
    local current = getWorkingHours(user_id)
    vRP.setUData(user_id, "vRP:PontoHoras", json.encode(current + minutes))
end

local function formatTime(minutes)
    local h = math.floor(minutes / 60)
    local m = minutes % 60
    return string.format("%02dh %02dm", h, m)
end

local function getJobCategory(user_id)
    local uGroups = vRP.getUserGroups(user_id)
    for gName, _ in pairs(uGroups) do
        if Config.Blips[gName] then
            return Config.Blips[gName].group
        end
    end
    return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_ponto:abrirTablet")
AddEventHandler("vrp_ponto:abrirTablet", function(localName)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return end

    local identity = vRP.getUserIdentity(user_id)
    local user_groups = vRP.getUserGroups(user_id)
    local wallet = vRP.getMoney(user_id)
    local bank = vRP.getBankMoney(user_id)
    
    local isWorking = false
    local currentJob = "Desempregado/Paisana"
    
    -- Verifica emprego atual
    for k,v in pairs(user_groups) do
        local groupData = groups[k]
        if groupData and groupData._config and groupData._config.gtype == "job" then
            if string.sub(k, 1, 7) ~= "Paisana" then
                isWorking = true
                currentJob = vRP.getGroupTitle(k)
                -- Garante que está na lista de workers ativos
                activeWorkers[user_id] = true 
            else
                currentJob = "Folga ("..string.sub(k, 8)..")"
                activeWorkers[user_id] = nil
            end
            break 
        end
    end

    -- Pega o tempo direto do banco (agora atualizado minuto a minuto)
    local myTotalMinutes = getWorkingHours(user_id)

    -- Lógica de Colegas/Líder
    local onlineWorkers = 0
    local workersList = {}
    local isLeader = false
    
    local myCategory = getJobCategory(user_id)
    local groupToWatch = myCategory 

    -- Verifica liderança
    for liderGroup, baseGroup in pairs(Config.Lideres) do
        if vRP.hasGroup(user_id, liderGroup) then
            isLeader = true
            groupToWatch = baseGroup 
            break
        end
    end

    if groupToWatch then
        local users = vRP.getUsers()
        for _, pid in pairs(users) do
            local pid_id = vRP.getUserId(pid)
            local pCategory = getJobCategory(pid_id)

            if pCategory == groupToWatch then
                onlineWorkers = onlineWorkers + 1
                
                if isLeader then
                    local pIdentity = vRP.getUserIdentity(pid_id)
                    local pHours = getWorkingHours(pid_id)
                    table.insert(workersList, {
                        name = pIdentity.name.." "..pIdentity.firstname,
                        hours = formatTime(pHours)
                    })
                end
            end
        end
    end

    local dados = {
        playerName = identity.name.." "..identity.firstname,
        playerId = user_id,
        jobName = currentJob,
        isWorking = isWorking,
        onlineCount = onlineWorkers,
        myHours = formatTime(myTotalMinutes),
        totalMinutesInt = myTotalMinutes, 
        isLeader = isLeader,
        workersList = workersList,
        wallet = wallet,
        bank = bank
    }

    TriggerClientEvent("vrp_ponto:atualizarTablet", source, dados)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP DE SALVAMENTO AUTOMÁTICO DE HORAS (Resolve Tempo Travado)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- A cada 60 segundos
        for user_id, active in pairs(activeWorkers) do
            if active then
                -- Verifica se o player ainda está online e no grupo
                local source = vRP.getUserSource(user_id)
                if source then
                    addWorkingTime(user_id, 1) -- Adiciona 1 minuto no banco de dados
                else
                    activeWorkers[user_id] = nil -- Player saiu, remove da lista
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE BLIPS (GPS)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local blipsTable = {}
        local users = vRP.getUsers()
        
        -- 1. Coletar dados
        for _, src in pairs(users) do
            local user_id = vRP.getUserId(src)
            if user_id then
                local ped = GetPlayerPed(src)
                -- Só coleta se o ped existir (evita erro de coordenada 0,0,0)
                if DoesEntityExist(ped) then
                    local user_groups = vRP.getUserGroups(user_id)
                    for k, v in pairs(user_groups) do
                        if Config.Blips[k] then
                            local coords = GetEntityCoords(ped)
                            table.insert(blipsTable, {
                                coords = coords,
                                color = Config.Blips[k].blipColor,
                                id = Config.Blips[k].blipId,
                                name = Config.Blips[k].name,
                                category = Config.Blips[k].group,
                                src = src 
                            })
                            break 
                        end
                    end
                end
            end
        end

        -- 2. Enviar blips filtrados
        for _, src in pairs(users) do
            local user_id = vRP.getUserId(src)
            local myCategory = getJobCategory(user_id)

            if myCategory then
                local myView = {}
                for _, blip in pairs(blipsTable) do
                    -- Filtro: Mesma Categoria
                    if blip.category == myCategory then
                        table.insert(myView, blip)
                    end
                end
                TriggerClientEvent("vrp_ponto:atualizarBlips", src, myView)
            else
                TriggerClientEvent("vrp_ponto:atualizarBlips", src, {}) 
            end
        end

        Citizen.Wait(3000) 
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR DE GRUPO (BATER PONTO)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_ponto:trocar")
AddEventHandler("vrp_ponto:trocar", function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return end

    local user_groups = vRP.getUserGroups(user_id)
    local trocou = false

    for k,v in pairs(user_groups) do
        local groupData = groups[k]
        if groupData and groupData._config and groupData._config.gtype == "job" then
            if string.sub(k, 1, 7) == "Paisana" then
                local jobOriginal = string.sub(k, 8)
                if Config.Excecoes[k] then jobOriginal = Config.Excecoes[k] end 

                if groups[jobOriginal] then
                    vRP.removeUserGroup(user_id, k)
                    vRP.addUserGroup(user_id, jobOriginal)
                    TriggerClientEvent("Notify", source, "sucesso", "Ponto batido! Bom trabalho.")
                    TriggerEvent("zr_arsenal:issueDutyTokens", source)
                    
                    activeWorkers[user_id] = true -- Adiciona na lista de salvamento
                    trocou = true
                    break
                end
            else
                local jobPaisana = "Paisana"..k
                if Config.Excecoes[k] then jobPaisana = Config.Excecoes[k] end

                if groups[jobPaisana] then
                    vRP.removeUserGroup(user_id, k)
                    vRP.addUserGroup(user_id, jobPaisana)
                    limparArmasServico(source)
                    TriggerClientEvent("Notify", source, "aviso", "Você entrou em folga.")
                    TriggerEvent("zr_arsenal:clearDutyTokens", source, "duty_off")
                    
                    activeWorkers[user_id] = nil -- Remove da lista de salvamento
                    trocou = true
                    break
                end
            end
        end
    end

    if not trocou then TriggerClientEvent("Notify", source, "negado", "Você não possui permissão.") end
end)

AddEventHandler("vRP:playerLeave", function(user_id, source)
    activeWorkers[user_id] = nil
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        local user_groups = vRP.getUserGroups(user_id)
        for k,v in pairs(user_groups) do
            local groupData = groups[k]
            if groupData and groupData._config and groupData._config.gtype == "job" and string.sub(k, 1, 7) ~= "Paisana" then
                local jobPaisana = "Paisana"..k
                if Config.Excecoes[k] then jobPaisana = Config.Excecoes[k] end
                if groups[jobPaisana] then
                    vRP.removeUserGroup(user_id, k)
                    vRP.addUserGroup(user_id, jobPaisana)
                    SetTimeout(5000, function()
                        local player = vRP.getUserSource(user_id)
                        if player then
                            limparArmasServico(player)
                            TriggerClientEvent("Notify", player, "aviso", "Você entrou na cidade e foi colocado em folga.")
                            TriggerEvent("zr_arsenal:clearDutyTokens", player, "spawn_cleanup")
                        end
                    end)
                    activeWorkers[user_id] = nil
                end
            end
        end
    end
end)
