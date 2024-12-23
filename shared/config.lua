Config = {}
Config.Language = "EN" --"EN", "HU"
Config.AutomaticDeleteOverTime = true
Config.DeleteDates = {
    { ["h"] = 00, ["m"] = 00 },
    { ["h"] = 01, ["m"] = 00 },
    { ["h"] = 02, ["m"] = 00 },
    { ["h"] = 03, ["m"] = 00 },
    { ["h"] = 04, ["m"] = 00 },
    { ["h"] = 05, ["m"] = 00 },
    { ["h"] = 06, ["m"] = 00 },
    { ["h"] = 07, ["m"] = 00 },
    { ["h"] = 08, ["m"] = 00 },
    { ["h"] = 09, ["m"] = 00 },
    { ["h"] = 10, ["m"] = 00 },
    { ["h"] = 11, ["m"] = 00 },
    { ["h"] = 12, ["m"] = 00 },
    { ["h"] = 13, ["m"] = 00 },
    { ["h"] = 14, ["m"] = 00 },
    { ["h"] = 15, ["m"] = 00 },
    { ["h"] = 16, ["m"] = 00 },
    { ["h"] = 17, ["m"] = 00 },
    { ["h"] = 18, ["m"] = 00 },
    { ["h"] = 19, ["m"] = 00 },
    { ["h"] = 20, ["m"] = 00 },
    { ["h"] = 21, ["m"] = 00 },
    { ["h"] = 22, ["m"] = 00 },
    { ["h"] = 23, ["m"] = 00 },
}
Config.debug = false     --for printing informations
Config.LockSystem = true --Simple vehicle lock system. similar to esx_vehiclelocks
Config.Target = {
    enabled = false,
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
    scale = 0.8, -- Float!
    shortRange = true,
    display = 4, -- don't recommended to touch until you know what you are doing.
    label = "Public Garage"
}

Config.Garages = {
    [1] = {                                                         -- Fő publik
        pedPlace = vector4(215.0626, -809.8212, 30.7503, 249.7947), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(231.6359, -794.8170, 30.5807, 158.6609),
        storeVehicle = vector3(222.6965, -763.7098, 30.8188),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                       --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [2] = {                                                         -- Fő publik
        pedPlace = vector4(276.5470, -345.0832, 45.1734, 250.0008), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(291.2586, -334.6864, 44.9199, 161.8472),
        storeVehicle = vector3(274.4957, -329.0567, 44.9206),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                        --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [3] = {                                                          -- Fő publik
        pedPlace = vector4(-1184.7164, -1508.6017, 4.6312, 50.6762), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(-1179.7656, -1478.6583, 4.3797, 19.9567),
        storeVehicle = vector3(-1195.2688, -1488.1886, 4.3797),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                     --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [4] = {                                                       -- Fő publik
        pedPlace = vector4(82.1640, 6391.7007, 31.3759, 54.0686), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(73.4935, 6372.8682, 31.2369, 288.6134),
        storeVehicle = vector3(63.9287, 6389.7090, 31.2386),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                        --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [5] = {                                                          -- Fő publik
        pedPlace = vector4(1851.0856, 2586.1074, 45.6720, 287.7161), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(1863.9523, 2588.6082, 45.6720, 356.0142),
        storeVehicle = vector3(1882.4248, 2591.9697, 45.6721),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                     --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [6] = {                                                       -- Fő publik
        pedPlace = vector4(637.3426, 206.7257, 97.6042, 77.5008), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(645.3956, 169.9251, 95.5215, 344.1644),
        storeVehicle = vector3(645.3154, 192.3324, 95.9420),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                        --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [7] = {                                                          -- Fő publik
        pedPlace = vector4(1693.6743, 3768.0691, 34.6367, 295.9062), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(1710.5997, 3763.0095, 34.2451, 218.9834),
        storeVehicle = vector3(1707.6246, 3769.1030, 34.3955),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                         --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [8] = {                                                           -- Fő publik
        pedPlace = vector4(-832.6857, -2350.9431, 14.5706, 289.5262), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(-803.6439, -2355.5447, 14.5706, 152.9763),
        storeVehicle = vector3(-812.4112, -2357.2336, 14.5707),
        storeZoneSize = 3.5, --FLOAT!!
        drawOutline = false,       --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                     --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [9] = {                                                       -- Fő publik
        pedPlace = vector4(988.0369, -1398.9926, 31.5268, 147.0913), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(994.9067, -1403.9685, 31.3063, 124.7526),
        storeVehicle = vector3(999.7350, -1403.1161, 31.3408),
        storeZoneSize = 3.5,                                        --FLOAT!!
        drawOutline = false,                                              --To draw zone outline
        spawnPedModell =
        "mp_m_securoguard_01"                                       --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [10] = {                                                        -- Fő publik
        pedPlace = vector4(863.0966, -2334.6921, 30.3453, 77.6547), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(853.4869, -2346.5085, 30.3315, 265.2116),
        storeVehicle = vector3(839.0308, -2350.6550, 30.3346),
        storeZoneSize = 3.5,                                      --FLOAT!!
        drawOutline = false,                                            --To draw zone outline
        spawnPedModell = "mp_m_securoguard_01"                    --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [11] = {                                                      -- Fő publik
        pedPlace = vector4(-1555.5750, -422.5113, 41.9915, 335.8000), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(-1542.6929, -407.7450, 41.9893, 309.4163),
        storeVehicle = vector3(-1550.0448, -407.8743, 41.9876),
        storeZoneSize = 3.5,                                  --FLOAT!!
        drawOutline = false,                                        --To draw zone outline
        spawnPedModell = "mp_m_securoguard_01"                --https://docs.fivem.net/docs/game-references/ped-models/
    },
    [12] = {                                                  -- Fő publik
        pedPlace = vector4(-3147.8911, 1113.6665, 20.8490, 179.2463), --Fourth value is must! Its the ped heading
        spawnVehicle = vector4(-3146.0273, 1083.3801, 20.6880, 158.8911),
        storeVehicle = vector3(-3136.8662, 1091.2449, 20.6301),
        storeZoneSize = 3.5,           --FLOAT!!
        drawOutline = false,                 --To draw zone outline
        spawnPedModell = "mp_m_securoguard_01" --https://docs.fivem.net/docs/game-references/ped-models/
    },

}

Config.types = {
    info = "info",
    error = "error",
    success = "success"
}
Config.notify = function(msg, type)
    ESX.ShowNotification(msg, 5000, type)
end
