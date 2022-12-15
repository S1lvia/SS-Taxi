-- ND-Core exports ( can change to your said core/framework)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if GetCurrentResourceName() ~= 'SS-Taxi' and Config.Support == true then
        print('^6[Warning]^0 For better support, it is recommended that "'..GetCurrentResourceName().. '" be renamed to "SS-Taxi"')
    end
    if Config.AutoUpdates == true then
        PerformHttpRequest('https://api.github.com/repos/S1lvia/SS-Taxi/releases/latest', function (err, data, headers)
            local data = json.decode(data)
            if data.tag_name ~= 'v'..GetResourceMetadata(GetCurrentResourceName(), 'version', 0) then
                print('\n^1================^0')
                print('^1SS Taxi ('..GetCurrentResourceName()..') is outdated!^0')
                print('Current version: (^1v'..GetResourceMetadata(GetCurrentResourceName(), 'version', 0)..'^0)')
                print('Latest version: (^2'..data.tag_name..'^0) '..data.html_url)
                print('Release notes: '..data.body)
                print('^1================^0')
            end
        end, 'GET', '')
    end
end)

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