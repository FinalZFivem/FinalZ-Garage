lib.callback.register('server:GetOwnerShip', function(source, plate)
    local identifier = GetPlayerIdentifierByType(source, "license")
    local response = MySQL.query.await('SELECT `owner` FROM `owned_vehicles` WHERE `plate` = @plate', {
        ['@plate']          = plate
    })
    
    if response then
        for i = 1, #response do
            local row = response[i]

            if (identifier):gsub("license:","") ~= row.owner then
                return false
            else
                return true
            end
        end
    end
end)


lib.callback.register('server:UpdateStored', function(source, stored,plate,props)
    local identifier = GetPlayerIdentifierByType(source, "license")
    identifier = (identifier):gsub("license:","")
    if stored then
        MySQL.update('UPDATE owned_vehicles SET `stored` = @stored, `vehicle` = @vehicle WHERE `plate` = @plate AND `owner` = @identifier', {
            ['@identifier'] = identifier,
			['@vehicle'] 	= json.encode(props),
			['@plate'] 		= plate,
			['@stored']     = stored,
        }, function(affectedRows)
            print(affectedRows)
            if  not Config.Webhook.store.enabled then return end

            if stored == 0 then
                sendToDiscord("store", "**Vehicle Took out by: **"..GetPlayerName(source).."\n **identifier:** "..identifier.." \n **Plate:** "..plate.."\n **model hash:** "..props.model.."", "Vehicle took out", "**Taking out**")
            else
                sendToDiscord("store", "**Vehicle Stored by: **"..GetPlayerName(source).."\n **identifier:** "..identifier.." \n **Plate:** "..plate.."\n **model hash:** "..props.model.."", "Vehicle Stored", "**Storing**")
            end
            
        end)
    else
        print("Error while storing")
        return
    end
end)

lib.callback.register('server:setImpounded', function(source, stored,plate,props, type)
    print("BUZI")
    local identifier = GetPlayerIdentifierByType(source, "license"):gsub("license:","")

    print(source, stored, plate,  props, type)

    MySQL.update('UPDATE owned_vehicles SET `stored` = @stored, `vehicle` = @vehicle WHERE `plate` = @plate AND `owner` = @identifier', {
        ['@identifier'] = identifier,
        ['@vehicle'] 	= json.encode(props),
        ['@plate'] 		= plate,
        ['@stored']     = stored,
    }, function(affectedRows)
        print(affectedRows)
    
        if Config.Webhook.automaticImpound.enabled and  type == "auto" and stored ~= 0 then
            sendToDiscord("automaticImpound", "**Vehicle Impounded by the server, \n **identifier:** "..identifier.." \n **Plate:** "..plate.."\n **model hash:** "..props.model.."**", "SYSTEM", "**AUTOMATIC IMPOUND**")
        elseif Config.Webhook.impound.enabled and  type == "manual" and stored ~= 0 then
            sendToDiscord("manualImpound", "**Vehicle impounded  by: **"..GetPlayerName(source).."\n **identifier:** "..identifier.." \n **Plate:** "..plate.."\n **model hash:** "..props.model.."", "Impound", "**Manual impound**")
        end
    end)
end)

-- lib.callback.register('server:TransferVehicle', function(source, oldOwner, newOwner, vehicle)
--     local affectedRows = MySQL.update.await('UPDATE users SET firstname = ? WHERE identifier = ?', {
--         newName, identifier
--     })
     
--     print(affectedRows)
-- end)

lib.callback.register('server:getVehProperties', function(source, plate)
    local props = {}
    local identifier = GetPlayerIdentifierByType(source, "license"):gsub("license:","")

    -- 'SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `parking` = @parking AND `stored` = 1',
    local response = MySQL.query.await('SELECT `vehicle` FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        identifier, plate
    })

    if response then
        for i=1, #response do
            props[#props+1] = json.decode(response[i].vehicle)
        end

        print(props, "a", plate)
        return props
    else
        print("J")
    end
end)

lib.callback.register('server:getOwnedVehicles', function(source)
    local ownedVehs = {}
    local identifier = GetPlayerIdentifierByType(source, "license")
    identifier = (identifier):gsub("license:","")

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `stored` = 1 AND `type` = ? ', {
        identifier, "car"
    })

    if response then
        for i=1, #response do
            ownedVehs[#ownedVehs+1] = json.decode(response[i].vehicle)
        end

        print("Owned Vehicles:", json.encode(ownedVehs)) 
        return ownedVehs
    end
end)

lib.callback.register('server:getImpoundedVehicles', function(source)
    local imps = {}
    local identifier = GetPlayerIdentifierByType(source, "license")
    identifier = (identifier):gsub("license:","")

    Wait(50)

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `stored` = 2', {
        identifier
    })

    if response then
        for i=1, #response do
            imps[#imps+1] = json.decode(response[i].vehicle)
        end

        print("Impounded Vehicles:", json.encode(imps)) -- Debug print
        return imps
    end
end)

function sendToDiscord(type,description, action, title)
    timestamp = os.date("%Y, %B, %A, %d, %X")
    local sendD = {
        {
            ["color"] = 15548997,
            ["title"] = title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = "**FinalZ Garage System  at "..timestamp.."**"
            },
        }
    }

    if type == "store" then
        PerformHttpRequest(Config.Webhook.store.link, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ Garage | "..action.." ", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    elseif type == "takeOutGarage" then 
        PerformHttpRequest(Config.Webhook.takeOut.link, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ Garage | "..action.." ", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    elseif type == "impoundTakeOut" then
        PerformHttpRequest(Config.Webhook.impoundTakeOut.link, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ Garage | "..action.." ", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    elseif type == "manualImpound" then 
        PerformHttpRequest(Config.Webhook.manualImpound.link, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ Garage | "..action.." ", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    elseif type == "automaticImpound" then 
        PerformHttpRequest(Config.Webhook.automaticImpound.link, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ Garage | "..action.." ", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    end
end

RegisterNetEvent("as")
AddEventHandler("as", function()
    Config.removemoney()
end)