local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('reward', function(data)
    local Player = QBCore.Functions.GetPlayer(source)

    Player.Functions.AddMoney("cash", 5000, "Help")
    TriggerClientEvent('QBCore:Notify', source, "Här får du, Tack för hjälpen", "success", 5000)
    TriggerClientEvent('endMission')
end)