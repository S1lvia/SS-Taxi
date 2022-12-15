-- If someone asks me what stuff in this script does i am going to lose it, ive spent so much time making it simple for the comments :P
-- If you have googled your problem and you are really stuck, feel free to dm me or ask for support in the discord <3

local pedCoords = GetEntityCoords(PlayerPedId()) -- Gets player Coords.
local markerCoords = vector3(895.0926, -179.0311, 74.7003) -- Variable where the marker spawns.
local taxiSpawned = false -- Variable to check if the taxi has spawned.
local taxisSpawned = 0 -- Variable to check how many taxis a user has spawned.
local startedJob = false -- Variable to check if the player has started the job.
local atPickUp = false -- Variable to check if the player is at the location to pick up the client.
local atDropOff = false -- Variable to check if the player is at the location to drop off the client.
local random = math.random -- Makes a variable for random 

AddTextEntry('Start_Job', 'Press ~INPUT_WEAPON_SPECIAL_TWO~ to start the job.') -- Adds the little prompt in the top left, to start the job.
AddTextEntry('Pick_Up', 'Press ~INPUT_WEAPON_SPECIAL_TWO~ to start the job.') -- Adds the little prompt in the top left, to pick up the client.
AddTextEntry('Drop_Off', 'Press ~INPUT_WEAPON_SPECIAL_TWO~ to start the job.') -- Adds the little prompt in the top left, to drop off thee client.

-- Displays notifications ontop of the mini map
---@param text string
local function notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Randomly picks an item form a table
---@param table table
---@return index
local function randomItem(table)
    local keys = {}
    for key, value in pairs(table) do
        keys[#keys + 1] = key
    end
    index = keys[random(1, #keys)]
    return table[index]
end

-- funtion to end the job session.
local function endJob()
    SetWaypointOff() -- Turns off any current waypoints.
    startedJob = false -- Sets that as false.
    taxiSpawned = false -- Sets that as false.
    atPickUp = false -- Sets that as false.
    atDropOff = false -- Sets that as false.
end

-- function to spawn the vehicle at the locations.
function SpawnVehicle(model, location)
    RequestModel(model) -- Loads the model into memory.
    while not HasModelLoaded(model) do -- Checks if the model has loaded and if not it waits 500ms.
        Citizen.Wait(500) -- Waits 500ms
    end
    vehicle = CreateVehicle(model, location.x, location.y, location.z, location.h, true, false) -- Creats the model, docs for more info https://docs.fivem.net/natives/?_0xAF35D0D2583051B0.
    SetVehicleOnGroundProperly(vehicle) -- Sets the vehicle on the ground.
    SetEntityAsMissionEntity(vehicle, true, true) -- Sets the entity as a vehicle, docs for more info https://docs.fivem.net/natives/?_0xAD738C3085FE7E11.
    SetModelAsNoLongerNeeded(model) -- Unloads the model from memory.
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0) -- Waits for 0 ms lol, just needed.

        if not startedJob and #(pedCoords - markerCoords) <= 15.0 then -- Checks if jobs started and if your in 15 coords close.
            DrawMarker(1, markerCoords.x, markerCoords.y, markerCoords.z - 1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 153, 51, 255, 50, false, true, 2.0, nil, nil, false) -- The purple ring.

            if #(pedCoords - markerCoords) <= 2.0 then -- Checks if you are 2 coords close.
                DisplayHelpTextThisFrame('Start_Job') -- Displays the prompt in the top left, line 8.
                if IsControlJustPressed(0, 51) and not IsPedInAnyVehicle(PlayerPedId(), true) then -- Checks if you preesed said key and if your not in  a vehicle.
                    if taxiSpawned then -- Checks if the variable taxiSpawned is set as true.
                        notify('You\'ve ~r~already~s~ spawned a Taxi!') -- Sends a notification.
                    else
                        TaxiSpawn = randomItem(Config.TaxiSpawn) -- Picks a random taxispawn from the config and sets it as a variable.
                        SpawnVehicle(Config.TaxiModel, TaxiSpawn) -- Spawns the vehicle and and gets the spawn code form the config.
                        taxiSpawned = true -- Sets the variable taxiSpawned a true.
                        taxisSpawned = taxisSpawned + 1 -- Adds 1 to the taxisSpawned.
                        pickUpLocation = randomItem(Config.PickUps) -- Picks a random pick up zone from the config and sets it as a variable.
                        pickUpCords = vector3(pickUpLocation.x, pickUpLocation.y, pickUpLocation.z) -- Sets the pick up cords as a vector3 and a new variable.
                        startedJob = true -- Sets the variable startedJob a true.
                        taxiSpawned = true -- Sets the variable taxiSpawned a true.
                        SetNewWaypoint(pickUpLocation.x, pickUpLocation.y) -- Sets a waypoint at the pick up location.
                    end
                elseif IsControlJustPressed(0, 51) and IsPedInAnyVehicle(PlayerPedId(), true) then -- If you pressed said key and in a vehicle.
                    notify('You ~y~can\'t~s~ start running in a vehicle.') -- Sends a notification.
                elseif taxisSpawned == 5 then -- Checks if you have already spawned 5 taxis.
                    notify('You have spawned 5 taxis total, please wait 5 minutes.') -- Sends a notification.
                    Citizen.Wait(300000) -- Waits 300000ms (5 minutes).
                    taxisSpawned = 0 -- Sets taxisSpawned to 0 so you can spawn 5 more taxis.
                end
            end
        else
            Citizen.Wait(2000) -- Waits 2000ms.
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Waits for 0 ms lol, just needed.

        if startedJob and #(pedCoords - pickUpCords) <= 15.0 then -- doesnt work at all ngl
            DrawMarker(1, pickUpCords.x, pickUpCords.y, pickUpCords.z - 1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 153, 51, 255, 50, false, true, 2.0, nil, nil, false) -- The purple ring.
        else
            Citizen.Wait(2000)
        end
    end
end)

-- just waits, literally.
Citizen.CreateThread(function()
    while true do
        pedCoords = GetEntityCoords(PlayerPedId()) -- i dont really know why this is needed, but it is for the rings to update, i am not really sure how to fix this or what todo, so :P yk 
        Citizen.Wait(500) -- Waits 500ms.
    end
end)

-- Creats the blips on the mini map.
Citizen.CreateThread(function()   
    if Config.Marker == true then -- Checks if the config is set as true 
        local blip = AddBlipForCoord(markerCoords.x, markerCoords.y, markerCoords.z) -- Sets the blip and makes a variable for it.
        SetBlipSprite(blip, 198) -- Sets the image for the blip, docs for more info https://docs.fivem.net/docs/game-references/blips/.
        SetBlipDisplay(blip, 4) -- Sets the visibility level, docs for more info https://docs.fivem.net/natives/?_0x9029B2F3DA924928.
        SetBlipColour(blip, 21) -- Sets the color, docs for more info https://docs.fivem.net/docs/game-references/blips/#BlipColors.
        SetBlipAsShortRange(blip, true) -- Sets the blip as short range, docs for more info https://docs.fivem.net/natives/?_0xBE8BE4FE60E27B72.
        BeginTextCommandSetBlipName("STRING") -- Sets the blips name, docs for more info https://docs.fivem.net/natives/?_0xF9113A30DE5C6670.
        AddTextComponentString("Taxi Job") -- Sets name of the blip to show, docs for more info https://docs.fivem.net/natives/?_0x6C188BE134E074AA.
        EndTextCommandSetBlipName(blip) -- Sets to the blips name [so many lines of code for it :P], docs for more info https://docs.fivem.net/natives/?_0xBC38B49BCB83BC9B.
    end
end)

-- Makes a command to end the job incase you get busy doing something else.
RegisterCommand('endTaxi', function()
    if startedJob and taxiSpawned then -- checks if the taxi is spawend.
        notify('You have ended your shift.') -- Sends a notifications.
        endJob() -- ends the job and resets all values.
    else -- checks if you have started the job.
        notify('You\'re ~r~NOT~s~ currently not Working.') -- Sends a notifications.
    end
end)