-- ND-Core exports ( can change to your said core/framework)

RegisterServerEvent('SS-Taxi:success') -- Registers the event to server.
AddEventHandler('SS-Taxi:success', function(pay) -- Creats the event.
    local player = source -- Gets the player.
    NDCore.Functions.AddMoney(pay, player, "cash") -- Adds the money using ND-Core.
end)

RegisterServerEvent("SS-Taxi:penalty") -- Registers the event to server.
AddEventHandler("SS-Taxi:penalty", function(money) -- Creats the event.
    local player = source -- Gets the player.
    NDCore.Functions.DeductMoney(money, player, "cash") -- Removes the money using ND-Core.
end)