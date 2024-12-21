local peds = {}
local blips = {}
local EmptyVehicles = {}
AddTextEntry("BLIP_PROPCAT", "Garázs")

function GetVehicleLabel(model)
  local label = GetLabelText(GetDisplayNameFromVehicleModel(model))

  if label == 'NULL' then
    label = GetDisplayNameFromVehicleModel(model)
  end

  return label
end

---@param type boolean
function initGarage(type)
  if type then
    for k, v in pairs(Config.Garages) do
      lib.requestModel(v.spawnPedModell)
      local ped = CreatePed(1, v.spawnPedModell, v.pedPlace.x, v.pedPlace.y, v.pedPlace.z - 1.0, v.pedPlace.w, false,
        false)

      peds[#peds + 1] = ped
      FreezeEntityPosition(peds[k], true)
      SetBlockingOfNonTemporaryEvents(peds[k], true)
      SetEntityInvincible(peds[k], true)
      TaskStartScenarioInPlace(peds[k], "WORLD_HUMAN_CLIPBOARD", -1, false)

      local point = lib.points.new({
        coords = v.pedPlace,
        distance = Config.Target.distanceToAccess * 1.5,
      })

      function point:onEnter()
        -- textui
        if not Config.Target.enabled then
          lib.showTextUI(('[E] - %s'):format(Locales[Config.Language].garageLabelTarget))
        end
      end

      function point:onExit()
        if not Config.Target.enabled then
          lib.hideTextUI()
        end
      end

      if Config.Target.enabled then
        exports.ox_target:addLocalEntity(peds, {
          {
            label = Locales[Config.Language].garageLabelTarget,
            name = "openGarage",
            icon = Config.Target.garageIcon,
            distance = Config.Target.distanceToAccess,
            onSelect = function()
              OpenGarage(lib.points.getClosestPoint().id)
            end,
          },
        })
      else
        function point:nearby()
          DrawMarker(Config.Marker.type, GetEntityForwardVector(ped).xyz + v.pedPlace.xyz, Config.Marker.direction.x,
            Config.Marker.direction.y, Config.Marker.direction.z, Config.Marker.rotate.x, Config.Marker.rotate.y,
            Config.Marker.rotate.z, Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z,
            Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.alpha,
            Config.Marker.bopupdown, Config.Marker.facecamera, 2, Config.Marker.rotating, nil, nil, false)

          if self.currentDistance < Config.Target.distanceToAccess * 1.5 and IsControlJustReleased(0, 38) then
            OpenGarage(self.id)
          end
        end
      end

      local blip = AddBlipForCoord(v.pedPlace.xyz)
      blips[#blips + 1] = blip
      for blipIndex, blipValue in pairs(blips) do
        SetBlipSprite(blipValue, Config.Blip.sprite)
        SetBlipColour(blipValue, Config.Blip.color)
        SetBlipDisplay(blipValue, Config.Blip.display)
        SetBlipAsShortRange(blipValue, Config.Blip.shortRange)
        SetBlipScale(blipValue, Config.Blip.scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Garages[blipIndex].label)
        EndTextCommandSetBlipName(blipValue)
        if Config.debug then
          lib.print.info(blipIndex, "Blip created")
        end
      end


      local zone = lib.zones.sphere({
        coords = vec3(v.storeVehicle.xyz),
        radius = v.storeZoneSize,
        debug = v.debugZone,
        inside = function()
          if IsControlJustReleased(0, 38) then
            if not cache.vehicle then
              Config.notify(Locales[Config.Language].notInCar, Config.types.error)
            else
              StoreVehicle(cache.vehicle)
            end
          end
        end,
        onEnter = function()
          lib.showTextUI(Locales[Config.Language].storeMsg, {
            position = Config.TextUI.position,
            icon = Config.TextUI.icon,
            style = {
              borderRadius = Config.TextUI.borderRadius,
              backgroundColor = Config.TextUI.backgroundColor,
              color = Config.TextUI.color
            }
          })
        end,
        onExit = function()
          lib.hideTextUI()
        end
      })
    end

  else
    peds = {}
  end
end

---@param veh integer
StoreVehicle = function(veh)
  local props = lib.getVehicleProperties(veh)
  lib.callback('server:GetOwnerShip', 1000, function(owner)
    if owner then
      lib.callback('server:UpdateStored', false, function()
        DeleteEntity(veh)
        Config.notify(Locales[Config.Language].successStore, Config.types.success)
      end, 1, props.plate, props)
    else
      Config.notify(Locales[Config.Language].notOwned, Config.types.error)
    end
  end, props.plate)
end



function OpenGarage(id)
  local vehiclesList = {}
  lib.callback("server:getOwnedVehicles", false, function(vehicles)
    for i = 1, #vehicles, 1 do
      local label = GetLabelText(GetDisplayNameFromVehicleModel(vehicles[i].model))
      if vehicles[i].bodyHealth ~= nil and vehicles[i].fuelLevel ~= nil then
        vehiclesList[#vehiclesList + 1] = {
          model = vehicles[i].model,
          label = label,
          plate = vehicles[i].plate,
          body = tonumber(vehicles[i].bodyHealth) / 10,
          fuel = tonumber(vehicles[i].fuelLevel),
        }
      else
        vehiclesList[#vehiclesList + 1] = {
          model = vehicles[i].model,
          label = label,
          plate = vehicles[i].plate,
          body = 0,
          fuel = 0,
        }
      end
    end

    local imp_vehiclesList = {}
    lib.callback("server:getImpoundedVehicles", false, function(vehicles)
      for i = 1, #vehicles, 1 do
        local label = GetLabelText(GetDisplayNameFromVehicleModel(vehicles[i].model))

        if vehicles[i].bodyHealth ~= nil and vehicles[i].fuelLevel ~= nil then
          imp_vehiclesList[#imp_vehiclesList + 1] = {
            model = vehicles[i].model,
            label = label,
            plate = vehicles[i].plate,
            body = tonumber(vehicles[i].bodyHealth) / 10,
            fuel = tonumber(vehicles[i].fuelLevel),
          }
        else
          imp_vehiclesList[#imp_vehiclesList + 1] = {
            model = vehicles[i].model,
            label = label,
            plate = vehicles[i].plate,
            body = 0,
            fuel = 0,
          }
        end
      end

      if Config.debug then
        if #vehiclesList == 0 or #imp_vehiclesList == 0 then
          Config.notify(Locales[Config.Language].noVehicles, Config.types.error)
          lib.print.info("No vehicles owned.")
        end
      end

      SetNuiState(true, false)

      SendNUIMessage({
        type = "setvehicles",
        vehicles = vehiclesList,
        gName = Config.Garages[id].label
      })

      SendNUIMessage({
        type = "setImpoundedvehicles",
        Imp_Vehicles = imp_vehiclesList
      })
    end)
  end)
end

RegisterNUICallback("getImpound", function()
  local imp_vehiclesList = {}
  lib.callback("server:getImpoundedVehicles", false, function(vehicles)
    for i = 1, #vehicles, 1 do
      local label
      if Config.UseCarLabels then
        label = GetLabelText(GetDisplayNameFromVehicleModel(vehicles[i].model))
      else
        label = GetDisplayNameFromVehicleModel(vehicles[i].model)
      end
      imp_vehiclesList[#imp_vehiclesList + 1] = {
        model = vehicles[i].model,
        label = label,
        plate = vehicles[i].plate,
        body = tonumber(vehicles[i].bodyHealth) / 10,
        fuel = tonumber(vehicles[i].fuelLevel),
      }
    end
    SendNUIMessage({
      type = "setImpoundedvehicles",
      Imp_Vehicles = imp_vehiclesList
    })
  end)
end)



CreateThread(function()
  initGarage(true)
end)

--Todo megkell csinalni azt hogy ilyenkor a garazsba tegye az autokat, ne impoundba
AddEventHandler("onResourceStop", function(resname)
  if (resname ~= GetCurrentResourceName()) then return end
  for _, v in ipairs(GetGamePool('CVehicle')) do
    EmptyVehicles[#EmptyVehicles + 1] = v
  end

  if GetVehiclePedIsIn(cache.ped, false) ~= 0 then
    if lib.table.contains(EmptyVehicles, GetVehiclePedIsIn(cache.ped, false)) then
      for k, v in pairs(EmptyVehicles) do
        EmptyVehicles[k] = nil
      end
    end
  end

  for _, v in pairs(EmptyVehicles) do
    local props = lib.getVehicleProperties(v)
    DeleteEntity(v)

    lib.callback('server:setImpounded', false, function()
      EmptyVehicles = {}
    end, 2, props.plate, props, "auto")
  end
  initGarage(false)
  TriggerScreenblurFadeOut(0)
end)

---@param vehicle integer
function ImpoundVehicle(vehicle)
  local props = lib.getVehicleProperties(vehicle)
  local plate = props.plate


  if lib.progressBar({
        duration = 6000,
        label = Locales[Config.Language].impounding,
        useWhileDead = false,
        canCancel = true,
        disable = {
          car = true,
        },
        anim = {
          dict = 'amb@medic@standing@kneel@idle_a',
          clip = 'idle_a'
        }
      }) then
    lib.callback('server:setImpounded', false, function()
    end, 2, plate, props, "manual")
    DeleteEntity(vehicle)
    Config.notify(Locales[Config.Language].successImp)
  else
    Config.notify(Locales[Config.Language].cancelledImp)
    return
  end
end

RegisterNUICallback("exit", function(data, cb)
  SetNuiState(false, false)
  SetNuiState(false, true)
  cb("ok")
end)


RegisterNUICallback("takeOut", function(data, cb)
  if not data.vehicle then return end
  lib.requestModel(data.vehicle)
  lib.callback("server:getVehProperties", false, function(props)
    local veh = CreateVehicle(data.vehicle, Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.x,
      Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.y,
      Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.z,
      Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.w, true, false)


    SetPedIntoVehicle(cache.ped, veh, -1)
    SetNuiState(false, true)
    SetNuiState(false, false)


    lib.callback('server:UpdateStored', false, function()
    end, 0, data.plate, lib.getVehicleProperties(veh))

    for i = 1, #props do
      lib.setVehicleProperties(veh, props[i], false)
    end
  end, data.plate)
end)



RegisterNUICallback("takeOutImp", function(data, cb)
  if not data.vehicle then return end
  lib.requestModel(data.vehicle)
  lib.callback("server:getVehProperties", false, function(props)
    local veh = CreateVehicle(data.vehicle, Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.x,
      Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.y,
      Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.z,
      Config.Garages[lib.points.getClosestPoint().id].spawnVehicle.w, true, false)


    SetPedIntoVehicle(cache.ped, veh, -1)
    SetNuiState(false, true)
    SetNuiState(false, false)


    lib.callback('server:UpdateStored', false, function()
    end, 0, data.plate, lib.getVehicleProperties(veh))

    for i = 1, #props do
      lib.setVehicleProperties(veh, props[i], false)
    end
  end, data.plate)
end)

function SetNuiState(state, impound)
  SetNuiFocus(state, state)
  if state then
    TriggerScreenblurFadeIn(0)
  else
    TriggerScreenblurFadeOut(0)
  end
  if impound then
    SendNUIMessage({
      type = "show_Impound",
      enable = state
    })
  else
    SendNUIMessage({
      type = "show_Garage",
      enable = state
    })
  end
end

RegisterNetEvent("delAll")
AddEventHandler("delAll", function(plates)
  if GetInvokingResource() ~= nil then return end

  local vehiclePool = GetGamePool('CVehicle')
  for i = 1, #vehiclePool do
    if GetPedInVehicleSeat(vehiclePool[i], -1) == 0 then
      local props = lib.getVehicleProperties(vehiclePool[i])
      DeleteEntity(vehiclePool[i])

      lib.callback('server:setImpounded', false, function()

      end, 2, props.plate, props, "auto")
    end
  end
end)



RegisterNetEvent("notify")
AddEventHandler("notify", function(type, msg)
  if GetInvokingResource() ~= nil then return end
  Config.notify(msg, type)
end)

exports("ImpoundVehicle", ImpoundVehicle)

CreateThread(function()
  if Config.LockSystem then
    RegisterCommand("Z_LockVeh", function(source, rawCommand, args)
      lockVehicle()
    end, false)
  end
end)
