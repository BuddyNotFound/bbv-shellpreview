RegisterCommand('shellpreview', function(source,args)
    for k,v in pairs(Config.Settings.Allowed) do
        local src = source
        local myid = Identifiers(src)
        if v == myid.discord or Config.Settings.Permissions == false then 
            TriggerClientEvent('bbv-shellpreview:client',-1, tonumber(args[1]))
            return
        end
    end
end)

function Identifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end