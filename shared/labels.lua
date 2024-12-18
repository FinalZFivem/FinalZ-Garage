Config.SetLabels = {
    ["gti8"] = "WolksVagen gri"
}


CreateThread(function()
    if Config.UseCarlabels then
        for k,v in pairs(Config.SetLabels) do 
            AddTextEntry(k, v)
        end
    end
end)

