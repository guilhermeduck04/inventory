local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local menuOpen = false
local activeBlips = {} 

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE BLIPS (GPS)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_ponto:atualizarBlips")
AddEventHandler("vrp_ponto:atualizarBlips", function(blipData)
    -- Remove blips antigos
    for _, blip in pairs(activeBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    activeBlips = {}

    -- Cria novos blips
    for _, info in pairs(blipData) do
        local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
        SetBlipSprite(blip, info.id)
        SetBlipColour(blip, info.color)
        SetBlipScale(blip, 0.9) -- Aumentei levemente o tamanho
        
        -- IMPORTANTE: False = Mostra no mapa todo (GPS Global). True = Só mostra perto.
        SetBlipAsShortRange(blip, false) 
        
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.name)
        EndTextCommandSetBlipName(blip)
        
        table.insert(activeBlips, blip)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTO 3D & TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
end

RegisterNetEvent("vrp_ponto:limparArmasVisual")
AddEventHandler("vrp_ponto:limparArmasVisual", function(listaArmas)
    local ped = PlayerPedId()
    for _, armaName in pairs(listaArmas) do
        local hash = GetHashKey(armaName)
        if HasPedGotWeapon(ped, hash, false) then
            RemoveWeaponFromPed(ped, hash)
        end
    end
end)

RegisterNUICallback("fechar", function(data, cb)
    SetNuiFocus(false, false)
    menuOpen = false
    cb("ok")
end)

RegisterNUICallback("baterPonto", function(data, cb)
    TriggerServerEvent("vrp_ponto:trocar")
    SetNuiFocus(false, false)
    menuOpen = false
    cb("ok")
end)

Citizen.CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        local nearby = false -- Controle para esconder o UI

        if not menuOpen then
            for _, v in pairs(Config.Locais) do
                local x, y, z = v[1], v[2], v[3]
                local distance = #(pCoords - vector3(x, y, z))

                if distance <= 5.0 then
                    idle = 5
                    nearby = true

                    -- Exibe o Prompt
                    exports['ghost_ui']:ShowPrompt({
                        id = 'ponto_tablet',    -- ID único
                        coords = vector3(x, y, z),
                        text = 'Acessar ' .. v[4], -- Concatena com o nome do local
                        key = 'E',
                        type = 'door',          -- 'door' é verde no CSS, igual ao ~g~
                        maxDistance = 5.0,
                        offset = 0.5            -- Altura do texto
                    })

                    -- Lógica de pressionar a tecla (mantida do seu script original)
                    if distance <= 1.5 then
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent("vrp_ponto:abrirTablet", v[4])
                        end
                    end
                end
            end
        end

        -- Se não estiver perto de nada OU o menu estiver aberto, esconde o prompt
        if not nearby then
            exports['ghost_ui']:HidePrompt('ponto_tablet')
        end

        Citizen.Wait(idle)
    end
end)

RegisterNetEvent("vrp_ponto:atualizarTablet")
AddEventHandler("vrp_ponto:atualizarTablet", function(dados)
    menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open", data = dados })
end)

RegisterCommand("destravarponto", function()
    SetNuiFocus(false, false)
    menuOpen = false
end)