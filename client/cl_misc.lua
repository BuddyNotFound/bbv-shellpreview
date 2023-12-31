Main = {
    Shells = {},
    me = PlayerPedId
}

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    DoScreenFadeIn(1)
    FreezeEntityPosition(Main.me(),false)
    SetEntityVisible(Main.me(), true)
    DespawnShells()
end)

function DespawnShells()
    for _, v in pairs(Main.Shells) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end

function Main:TeleportToInterior(x, y, z,type)
    CreateThread(function()
        SetEntityCoords(Main.me(), x , y - 5, z + Config.Shells[type].hight, 0, 0, 0, false)
        FreezeEntityPosition(Main.me(),true)
        SetEntityVisible(Main.me(), false)
        Wait(100)

        DoScreenFadeIn(1000)
    end)
end

function Main:DisplayText(Text)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(Text)
    DrawText(0.45, 0.95)
end
