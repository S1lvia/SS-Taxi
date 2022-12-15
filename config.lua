Config = {}

Config.Marker = true -- Blip on map.
Config.Ring = true -- Purple ring at Door/PickUps/DropOffs, currently doesnt work.

Config.TaxiModel = 'taxi' -- Change to what ever Taxi Model you would like, base gta model is 'taxi'.

-- Locations
Config.MarkerCoords = { -- Where the marker and ring spawns.
    {x = 895.0926, y = -179.0311, z = 74.7003}
}

Config.TaxiSpawn = { -- Places where the taxis will spawn, they currently dont spawn well inside the lanes but oh well.
    {x = 896.6687, y = -183.1723, z = 73.7451},
    {x = 899.8098, y = -180.7018, z = 73.8568},
    {x = 903.3667, y = -191.9923, z = 73.7906},
    {x = 905.0192, y = -188.8279, z = 73.7951},
    {x =  906.6825, y = -186.1229, z = 74.0070},
    {x = 908.6951, y =  -183.2227, z = 74.2097}
}

Config.PickUps = { -- Places where you pick up the client.
    {x = 291.8669, y = -227.6334, z = 171.8748}, -- 1
}

Config.DropOffs = { -- Places where you drop off the client.
    {x = -577.5571, y = -1008.4626, z = 22.1731}
}