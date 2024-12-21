lockVehicle = function()
    vehicles = lib.getClosestVehicle(cache.coords, 10, true)
    if not vehicles then
        Config.notify(Locales[Config.Language].NoVehiclesNearby, Config.types.error)
        return
    end
    props = lib.getVehicleProperties(vehicles)
    lib.callback('server:GetOwnerShip', 1000, function(owner)
        if owner then
            local lockStatus = GetVehicleDoorLockStatus(vehicles)
            if lockStatus == 1 then -- unlocked
                lib.requestAnimDict("anim@mp_player_intmenu@key_fob@")
                lib.requestModel("p_car_keys_01")

                Fob = CreateObject("p_car_keys_01", GetEntityCoords(cache.ped), true, false, false)
                AttachEntityToEntity(Fob, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0, -0.045, 0.0, 10.0, 180.0,
                    90.0, true, true, false, true, 1, true)
                TaskPlayAnim(cache.ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false,
                    false, false)

                SetVehicleDoorsLocked(vehicles, 2)
                PlayVehicleDoorCloseSound(vehicles, 1)
                SetVehicleLights(vehicles, 2)
                Wait(250)
                SetVehicleLights(vehicles, 0)
                Wait(250)
                StartVehicleHorn(vehicles, 500, "NORMAL", -1)

                Config.notify(Locales[Config.Language].VehicleLocked, Config.types.info)
                Wait(500)
                DeleteObject(Fob)
            elseif lockStatus == 2 then
                lib.requestAnimDict("anim@mp_player_intmenu@key_fob@")
                lib.requestModel("p_car_keys_01")

                Fob = CreateObject("p_car_keys_01", GetEntityCoords(cache.ped), true, false, false)
                AttachEntityToEntity(Fob, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0, -0.045, 0.0, 10.0, 180.0,
                    90.0, true, true, false, true, 1, true)
                TaskPlayAnim(cache.ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false,
                    false, false)

                SetVehicleDoorsLocked(vehicles, 1)
                PlayVehicleDoorCloseSound(vehicles, 0)
                SetVehicleLights(vehicles, 2)
                Wait(250)
                SetVehicleLights(vehicles, 0)
                Wait(250)
                StartVehicleHorn(vehicles, 500, "NORMAL", -1)

                Config.notify(Locales[Config.Language].VehicleUnlocked, Config.types.info)
                Wait(500)
                DeleteObject(Fob)
            end
        else
            Config.notify(Locales[Config.Language].LockVehicleNotFounded, Config.types.error)
        end
    end, props.plate)
end
---comment
---@param veh integer
---@return integer
isVehLocked = function(veh)
    if not veh then
        lib.print.error("No veh value given")
        return
    end

    return GetVehicleDoorLockStatus(veh)
end



RegisterKeyMapping("Z_LockVeh", "Key to lock or unlock your car", "keyboard", "g")
exports("lockVehicle", lockVehicle)
exports("isVehLocked", isVehLocked)
