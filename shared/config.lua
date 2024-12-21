Config = {}
Config.Language = "EN" --"EN", "HU"
Config.AutomaticDeleteOverTime = true
Config.DeleteDates = {
    {["h"] = 11, ["m"] = 59},
    {["h"] = 12, ["m"] = 10},
    {["h"] = 13, ["m"] = 36},
}
Config.debug = true --for printing informations
Config.LockSystem = true --Simple vehicle lock system. similar to esx_vehiclelocks 
Config.Target = {
    enabled = true,
    garageIcon = "fa-solid fa-car",
    distanceToAccess = 1.5
}

-- Config.Transfer  = {
--     Fee = 50,
--     BlacklistedVehs = {
--         ["adder"] = true
--     }
-- }

Config.ImpoundTakeoutPrice = 1500

Config.Marker = { -- Do not mind if Config.Target.enabled is true
    type = 2,
    direction = {
        x = 0.0,
        y = 0.0,
        z = 0.0
    },
    rotate = {
        x = 0.0,
        y = 180.0,
        z = 0.0
    },
    scale = {
        x = 0.5,
        y = 0.5,
        z = 0.5
    },
    color = {
        r = 200,
        g = 20,
        b = 20
    },
    alpha = 50,
    bopupdown = false,
    facecamera = true,
    rotating = false
}
Config.TextUI = {
    position = 'right-center',
    icon = 'car',
    borderRadius = 5,
    backgroundColor = '#b31800',
    color = 'white'
}

Config.Blip = {
    sprite = 50,
    color = 29,
    scale = 0.8,     -- Float!
    shortRange = true,
    display = 4,     -- don't recommended to touch until you know what you are doing.
}

Config.Garages = {
    [1] = { -- Fő publik
        pedPlace = vector4(215.0626, -809.8212, 30.7503, 249.7947), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(231.6359, -794.8170, 30.5807, 158.6609),
        storeVehicle = vector3(222.6965, -763.7098, 30.8188),
        storeZoneSize = 3.5, --FLOAT!! 
        debug = true, --To draw zone outline
        label = "Publikus garázs 1",
        spawnPedModell = "mp_m_securoguard_01" --https://docs.fivem.net/docs/game-references/ped-models/
    },
}

Config.types = {
    info = "info",
    error = "error",
    success = "success"
}
Config.notify = function(msg,type)
    ESX.ShowNotification(msg, 5000, type)
end
