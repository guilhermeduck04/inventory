----------------------------------------------------------------
--------------------- REDESIGN TABLET ARSENAL ------------------
----------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("_arsenal",client)

local inMenu = false

local arsenal = {   ---- CDS DOS ARSENAL 
	{ 457.01, -996.63, 35.06 },
    -- Adicione outras coordenadas aqui
}

Citizen.CreateThread(function()
    SetNuiFocus(false,false)
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        local nearby = false -- Variável para verificar se tem algum arsenal perto
        
        for _,lugares in pairs(arsenal) do
            local x,y,z = table.unpack(lugares)
            local distance = GetDistanceBetweenCoords(pCoords,x,y,z,true)

            if distance <= 3.0 then
                sleep = 200 -- Tempo de atualização otimizado para o UI
                nearby = true

                -- Integração com o Ghost UI
                exports['ghost_ui']:ShowPrompt({
                    id = 'arsenal_interaction', -- ID único
                    coords = vector3(x, y, z),
                    text = 'Abrir Arsenal',     -- Texto sugestivo
                    key = 'E',
                    type = 'job',               -- 'job' é azul (combina com o marker original)
                    maxDistance = 3.0,
                    offset = 0.5
                })

                if distance <= 1.2 then
                    if IsControlJustPressed(0,38) then -- Tecla E
                        TriggerServerEvent('ndk:permissao')             
                    end
                end
            end
        end

        -- Se não estiver perto de nenhum ponto do arsenal, esconde o UI
        if not nearby then
            exports['ghost_ui']:HidePrompt('arsenal_interaction')
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('ndk:permissao')
AddEventHandler('ndk:permissao',function()
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({showMenu = true})
    PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
end)

RegisterNUICallback('NUIFocusOff', function(data, cb)
    inMenu = false
    SetNuiFocus(false,false)
    PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Default", 1)
    if cb then cb('ok') end
end)

---------------------- CALLBACKS DE ARMAS ----------------------

local function SolicitarArmaInventario(weaponName)
    TriggerServerEvent("zr_arsenal:requestWeaponItem", weaponName)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end

RegisterNUICallback('m4a1', function(data, cb)
    SolicitarArmaInventario("WEAPON_CARBINERIFLE")
    if cb then cb('ok') end
end)

RegisterNUICallback('m4a4', function(data, cb)
    SolicitarArmaInventario("WEAPON_SPECIALCARBINE")
    if cb then cb('ok') end
end)

RegisterNUICallback('mp5', function(data, cb)
    SolicitarArmaInventario("WEAPON_SMG")
    if cb then cb('ok') end
end)

RegisterNUICallback('mpx', function(data, cb)
    SolicitarArmaInventario("WEAPON_COMBATPDW")
    if cb then cb('ok') end
end)

RegisterNUICallback('shot45', function(data, cb)
    SolicitarArmaInventario("WEAPON_PUMPSHOTGUN_MK2")
    if cb then cb('ok') end
end)

RegisterNUICallback('fiveseven', function(data, cb)
    SolicitarArmaInventario("WEAPON_PISTOL_MK2")
    if cb then cb('ok') end
end)

RegisterNUICallback('glock18', function(data, cb)
    SolicitarArmaInventario("WEAPON_COMBATPISTOL")
    if cb then cb('ok') end
end)

RegisterNUICallback('KITBASICO', function(data, cb)
    SolicitarArmaInventario("WEAPON_NIGHTSTICK")
    SolicitarArmaInventario("WEAPON_KNIFE")
    SolicitarArmaInventario("WEAPON_STUNGUN")
    SolicitarArmaInventario("WEAPON_FLASHLIGHT")
    TriggerServerEvent('zr_arsenal:colete') -- Este mantém pois dá o colete
    
    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    if cb then cb('ok') end
end)

RegisterNUICallback('Taser', function(data, cb)
    SolicitarArmaInventario("WEAPON_STUNGUN")
    if cb then cb('ok') end
end)

RegisterNUICallback('Lanterna', function(data, cb)
    SolicitarArmaInventario("WEAPON_FLASHLIGHT")
    if cb then cb('ok') end
end)

RegisterNUICallback('KCT', function(data, cb)
    SolicitarArmaInventario("WEAPON_NIGHTSTICK")
    if cb then cb('ok') end
end)

RegisterNUICallback('Faca', function(data, cb)
    SolicitarArmaInventario("WEAPON_KNIFE")
    if cb then cb('ok') end
end)

RegisterNUICallback('colete', function(data, cb)
    TriggerServerEvent('zr_arsenal:colete')
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    if cb then cb('ok') end
end)

RegisterNUICallback('Limpar', function(data, cb)
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 1)
    if cb then cb('ok') end
end)

RegisterNetEvent("zr_arsenal:giveWeapon")
AddEventHandler("zr_arsenal:giveWeapon", function(weaponName)
    if not weaponName then return end
    local ped = PlayerPedId()
    local hash = GetHashKey(weaponName)
    GiveWeaponToPed(ped, hash, 0, false, true)
    SetPedAmmo(ped, hash, 0)
end)

RegisterNetEvent("zr_arsenal:removeWeapon")
AddEventHandler("zr_arsenal:removeWeapon", function(weaponName)
    if not weaponName then return end
    local ped = PlayerPedId()
    RemoveWeaponFromPed(ped, GetHashKey(weaponName))
end)
