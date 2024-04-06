local QBCore = exports['qb-core']:GetCoreObject()
local activeMission = false

CreateThread(function(model)
    exports['qb-target']:SpawnPed({
        model = 'cs_devin',
        coords = vector4(332.75, -201.63, 54.23, 159.81),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        animDict = 'abigail_mcs_1_concat-0',
        anim = 'csb_abigail_dual-0',
        flag = 1,
        scenario = 'WORLD_HUMAN_AA_COFFEE',
        target = {
            options = {
                {
                    type = 'client',
                    event = 'ge:client:startMission',
                    icon = 'fas fa-sign-in-alt',
                    label = 'Prata med Stefan',
                }
            },
            distance = 2.5,
        },
        spawnNow = true,
        currentpednumber = 0,
    })
end)


RegisterNetEvent('spawn2ndped', function(data)


    cs_devin = exports['qb-target']:SpawnPed({
        model = 'cs_devin',
        coords =     vector4(39.15, -908.36, 30.84, 342.01),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        animDict = 'abigail_mcs_1_concat-0',
        anim = 'csb_abigail_dual-0',
        flag = 1,
        scenario = 'WORLD_HUMAN_AA_COFFEE',
        target = {
            options = {
                {
                    type = 'server',
                    event = 'reward',
                    icon = 'fas fa-sign-in-alt',
                    label = 'Få dina rewards',
                }
            },
            distance = 2.5,
        },
        currentpednumber = 1,
        spawnNow = true,
    })

    QBCore.Functions.DeleteVehicle('stockade')

end)

RegisterNetEvent('ge:client:startMission', function(cam)
    local Player = GetPlayerPed()
    FreezeEntityPosition(Player, true)
    print('1')
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 335.0, -204.0, 55.0, 0.0, 0.0, 69.0, 37.0, true, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, false, false)

    exports['qb-core']:DrawText("Hej du skall få ett updrag av mig!", 'right')
    Wait(5000)
    exports['qb-core']:DrawText("Åk till torget banken och sno pengar trucken", 'right')
    Wait(5000)
    exports['qb-core']:DrawText("Accepterar du?", 'right')
    exports['qb-core']:HideText()

    TriggerEvent('showAcceptDeclineMenu')

end)

RegisterNetEvent('showAcceptDeclineMenu')
AddEventHandler('showAcceptDeclineMenu', function(cam)
    exports['qb-menu']:openMenu({
        {
            id = 1,
            header = "Vågar du?",
            txt = ""
        },
        {
            id = 2,
            header = "Accept",
            txt = "Acceptera uppdraget",
            params = {
                event = "accepted"
            }
        },
        {
            id = 3,
            header = "Neka",
            txt = "Neka uppdraget",
            params = {
                event = "declined"
            }
        },
    })
end)

RegisterNetEvent('accepted')
AddEventHandler('accepted', function(cam)
    print("Accepted")
    SetCamActive(cam, false)
    RenderScriptCams(false, false, 1000, false, false)
    activeMission = true

    SetNewWaypoint(134.61, -1058.85)
    TriggerEvent('QBCore:Notify', "Här ta en bil sålänge oxå, Jag vill ha tbx den", "success", 4000)
    local veh = NetToVeh(netId)
    QBCore.Functions.SpawnVehicle('sultan', function(veh)
        SetVehicleNumberPlateText(veh, " ")
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
    end, vector4(314.8, -206.1, 54.09, 248.83), true)

    Wait(15000)
    spawnArmoredTruck()

end)

RegisterNetEvent('declined')
AddEventHandler('declined', function(cam)
    print("Declined")
    SetCamActive(cam, false)
    RenderScriptCams(false, false, 1000, false, false)

end)


function spawnArmoredTruck()
    local allSecurityDead = false

    QBCore.Functions.SpawnVehicle('stockade', function(vehicle)
        exports['LegacyFuel']:SetFuel(vehicle, 100.0) 
    end, vector4(128.97, -1069.01, 29.19, 180.72), true)

    Wait(1000) 

    local pedModels = {"s_m_m_security_01", "s_m_m_security_01", "s_m_m_security_01"} 
    local pedCoords = {
        vector4(132.23, -1070.94, 29.19, 180.72), 
        vector4(132.23, -1070.94, 29.19, 180.72), 
        vector4(132.23, -1070.94, 29.19, 180.72)  
    }

    for i = 1, #pedModels do
        RequestModel(GetHashKey(pedModels[i]))
        while not HasModelLoaded(GetHashKey(pedModels[i])) do
            Wait(100)
        end

        local ped = CreatePed(4, GetHashKey(pedModels[i]), pedCoords[i].x, pedCoords[i].y, pedCoords[i].z, pedCoords[i].w, true, false)
        GiveWeaponToPed(ped, GetHashKey("WEAPON_NIGHTSTICK"), 1, false, true) 
        TaskCombatPed(ped, PlayerPedId(), 0, 16)
        SetPedKeepTask(ped, true)


        Wait(50000)
        getArmoredTruckRoute()
        
        
    end
        

    isEnemySpawned = true
end

function getArmoredTruckRoute()
    SetNewWaypoint(39.52, -907.36)
    TriggerEvent('spawn2ndped')
    TriggerEvent('QBCore:Notify', "Följ GPS för att få din belöning", "sucess", 5000)
end


-- CreateThread(function()

--     while activeMission == true do

--         if DoesEntityExist(cs_devin) then

--             exports['qb-target']:RemoveSpawnedPed({[5] = cs_devin})

--         end

--         Wait(100)


--     end
-- end)


RegisterNetEvent('endMission', function(data)
    activeMission = false
end)