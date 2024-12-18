-- ---@param CurrentOwner string | integer
-- ---@param NewOwner string | integer
-- ---@param VehToTransfer table
-- function TransferVeh(CurrentOwner, NewOwner, VehToTransfer)

--   lib.callback("server:TransferVeh",)

-- end

function OpenTransferMenu()
    local vehiclesList = {}

    lib.callback("server:getOwnedVehicles", false, function(vehicles)
        for i = 1, #vehicles, 1 do
          vehiclesList[#vehiclesList+1] = {
              model = vehicles[i].model,
              label = GetDisplayNameFromVehicleModel(vehicles[i].model),
              plate = vehicles[i].plate,
          }
        end
    end)

    local input = lib.inputDialog('Jármű átadás', {
        {type = 'input', label = 'Text input', description = 'Átírás rendszám alapján', icon = 'car'},
        {type = 'multi-select', label = 'Number input', description = 'Átírás birtokolt járművek listájából', icon = 'cars'},
      })

      if not input then return end

      if input[1] then
        print("Rendszam based")
      else
        print("List based")
      end
end