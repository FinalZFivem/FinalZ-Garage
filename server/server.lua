lib.callback.register('server:GetOwnerShip', function(source, plate)
    local identifier = GetPlayerIdentifierByType(source, "license")
    local response = MySQL.query.await('SELECT `owner` FROM `owned_vehicles` WHERE `plate` = @plate', {
        ['@plate'] = plate
    })

    if response then
        for i = 1, #response do
            local row = response[i]

            if (identifier):gsub("license:", "") ~= row.owner then
                return false
            else
                return true
            end
        end
    end
end)


lib.callback.register('server:UpdateStored', function(source, stored, plate, props)
    local identifier = GetPlayerIdentifierByType(source, "license")
    identifier = (identifier):gsub("license:", "")
    if stored then
        MySQL.update(
            'UPDATE owned_vehicles SET `stored` = @stored, `vehicle` = @vehicle WHERE `plate` = @plate AND `owner` = @identifier',
            {
                ['@identifier'] = identifier,
                ['@vehicle']    = json.encode(props),
                ['@plate']      = plate,
                ['@stored']     = stored,
            }, function(affectedRows)
                if not SConfig.Webhook.store.enabled then return end

                if stored == 0 then
                    sendToDiscord("store",
                        "**Vehicle Took out by: **" ..
                        GetPlayerName(source) ..
                        "\n **identifier:** " .. identifier ..
                        " \n **Plate:** " .. plate .. "\n **model hash:** " .. props.model .. "", "Vehicle took out",
                        "**Taking out**")
                else
                    sendToDiscord("store",
                        "**Vehicle Stored by: **" ..
                        GetPlayerName(source) ..
                        "\n **identifier:** " .. identifier ..
                        " \n **Plate:** " .. plate .. "\n **model hash:** " .. props.model .. "", "Vehicle Stored",
                        "**Storing**")
                end
            end)
    else
        
        print("Error while storing")
        return
    end
end)

lib.callback.register('server:setImpounded', function(source, stored, plate, props, type)
    local identifier = GetPlayerIdentifierByType(source, "license"):gsub("license:", "")


    MySQL.update(
        'UPDATE owned_vehicles SET `stored` = @stored, `vehicle` = @vehicle WHERE `plate` = @plate AND `owner` = @identifier',
        {
            ['@identifier'] = identifier,
            ['@vehicle']    = json.encode(props),
            ['@plate']      = plate,
            ['@stored']     = stored,
        }, function(affectedRows)
            if SConfig.Webhook.automaticImpound.enabled and type == "auto" and stored ~= 0 then
                sendToDiscord("automaticImpound", "**Server deleted all empty vehicles!", "impound", "**auto impound)")
            elseif SConfig.Webhook.impound.enabled and type == "manual" and stored ~= 0 then
                sendToDiscord("manualImpound",
                    "**Vehicle impounded  by: **" ..
                    GetPlayerName(source) ..
                    "\n **identifier:** " .. identifier .. " \n **Plate:** " .. plate ..
                    "\n **model hash:** " .. props.model .. "", "Impound", "**Manual impound**")
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
    local identifier = GetPlayerIdentifierByType(source, "license"):gsub("license:", "")

    -- 'SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `parking` = @parking AND `stored` = 1',
    local response = MySQL.query.await('SELECT `vehicle` FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        identifier, plate
    })

    if response then
        for i = 1, #response do
            props[#props + 1] = json.decode(response[i].vehicle)
        end

        return props
    else
    end
end)

lib.callback.register('server:getOwnedVehicles', function(source)
    local ownedVehs = {}
    local identifier = GetPlayerIdentifierByType(source, "license")
    identifier = (identifier):gsub("license:", "")

    local response = MySQL.query.await(
        'SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `stored` = 1 AND `type` = ? ', {
            identifier, "car"
        })

    if response then
        for i = 1, #response do
            ownedVehs[#ownedVehs + 1] = json.decode(response[i].vehicle)
        end

        return ownedVehs
    end
end)

lib.callback.register('server:getImpoundedVehicles', function(source)
    local imps = {}
    local identifier = GetPlayerIdentifierByType(source, "license")
    identifier = (identifier):gsub("license:", "")

    Wait(50)

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `stored` = 2', {
        identifier
    })

    if response then
        for i = 1, #response do
            imps[#imps + 1] = json.decode(response[i].vehicle)
        end

        return imps
    end
end)

function sendToDiscord(type, description, action, title)
    timestamp = os.date("%Y, %B, %A, %d, %X")
    local sendD = {
        {
            ["color"] = 15548997,
            ["title"] = title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = "**FinalZ Garage System  at " .. timestamp .. "**"
            },
        }
    }

    if type == "store" then
        PerformHttpRequest(SConfig.Webhook.store.link, function(err, text, headers)
            end, 'POST', json.encode({ username = "FinalZ Garage | " .. action .. " ", embeds = sendD }),
            { ['Content-Type'] = 'application/json' })
    elseif type == "takeOutGarage" then
        PerformHttpRequest(SConfig.Webhook.takeOut.link, function(err, text, headers)
            end, 'POST', json.encode({ username = "FinalZ Garage | " .. action .. " ", embeds = sendD }),
            { ['Content-Type'] = 'application/json' })
    elseif type == "impoundTakeOut" then
        PerformHttpRequest(SConfig.Webhook.impoundTakeOut.link, function(err, text, headers)
            end, 'POST', json.encode({ username = "FinalZ Garage | " .. action .. " ", embeds = sendD }),
            { ['Content-Type'] = 'application/json' })
    elseif type == "manualImpound" then
        PerformHttpRequest(SConfig.Webhook.manualImpound.link, function(err, text, headers)
            end, 'POST', json.encode({ username = "FinalZ Garage | " .. action .. " ", embeds = sendD }),
            { ['Content-Type'] = 'application/json' })
    elseif type == "automaticImpound" then
        PerformHttpRequest(SConfig.Webhook.automaticImpound.link, function(err, text, headers)
            end, 'POST', json.encode({ username = "FinalZ Garage | " .. action .. " ", embeds = sendD }),
            { ['Content-Type'] = 'application/json' })
    end
end


if Config.AutomaticDeleteOverTime then
    CreateThread(function()
        while true do
            local time = os.date("*t")
            local h, m = time.hour, time.min

            for k, v in ipairs(Config.DeleteDates) do
                if v["h"] == h and v["m"] - m == 10 then
                    TriggerClientEvent("notify", -1, "info", string.format(Locales[Config.Language].autoDel, 10))
                end
                if v["h"] == h and v["m"] - m == 5 then
                    TriggerClientEvent("notify", -1, "info", string.format(Locales[Config.Language].autoDel, 5))
                end
                if v["h"] == h and v["m"] - m == 3 then
                    TriggerClientEvent("notify", -1, "info", string.format(Locales[Config.Language].autoDel, 3))
                end
                if v["h"] == h and v["m"] == m then
                    TriggerClientEvent("notify", -1, "info", Locales[Config.Language].deletedCars)

                    TriggerClientEvent("delAll", -1)
                end
            end
            Wait(60000)
        end
    end)
end

CreateThread(function()
    if Config.AutomaticDeleteOverTime then
        if Config.debug then
            lib.print.info("The automatic car deleter system is turned on")
        end
    else
        if Config.debug then
            lib.print.info("The automatic car deleter system is turned off")
        end
    end



    if Config.LockSystem then
        if Config.debug then
            lib.print.info("The built in lock system is turned on")
        end
    else
        if Config.debug then
            lib.print.info("The built in lock system is turned off")
        end
    end
end)
