RegisterNUICallback('PreviewInformation', function(data)
    local shellspawn = Config.Settings.PreviewLocation
    local oldpos = GetEntityCoords(Main.me())
    previewmodel = data.shellid
    local model = previewmodel
    Main:CreatePreview(shellspawn, exit, model, oldpos, data)
end)

RegisterNUICallback('InsideInformation', function(data)
    local shellspawn = Config.Settings.PreviewLocation
    local oldpos = GetEntityCoords(Main.me())
    previewmodel = data.shellid
    local model = previewmodel
    local id = data.index
    Main:CreatePreview(shellspawn, exit, model, oldpos, data, true, id)
end)

RegisterNetEvent('bbv-shellpreview:client', function(data)
    local shellspawn = Config.Settings.PreviewLocation
    local oldpos = GetEntityCoords(Main.me())
    if type(data) == 'string' then 
        previewmodel = data
    else
        previewmodel = Config.Shells[data].name
    end
    local model = previewmodel
    Main:CreatePreview(shellspawn, exit, model, oldpos, data)
end)

function Main:CreatePreview(spawn, exitXYZH, model, oldpos, type, inside, id)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = exitXYZH
    POIOffsets.stash = stashcoords
    POIOffsets.outfits = outfitcoords
    Main.EnterPos = GetEntityCoords(Main.me())
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    print(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1000)
    end
    self.Shells[#self.Shells + 1] = CreateObject(model, spawn.x, spawn.y, spawn.z, false, false, false)
    if not inside then
        SetFollowPedCamViewMode(4)
        Main.preview = true
    end
    FreezeEntityPosition(self.Shells[#self.Shells], true)
    self:TeleportToInterior(spawn.x, spawn.y, spawn.z, type, self.Shells[#self.Shells],inside,id)
    TriggerEvent('bbv-shellpreview:exit',self.Shells[#self.Shells],oldpos)
end

RegisterNetEvent('bbv-shellpreview:exit',function(delshell,tppos)
    while Main.preview do 
        Wait(0)
        NetworkOverrideClockTime(23, 00, 0)
        Main:DisplayText("Press [F] to exit preview")
        if IsControlJustReleased(0,23) then
            Main:EndOrbitCam()
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(10)
            end
            Main.preview = false
            DeleteEntity(delshell)
            SetEntityCoords(Main.me(),tppos)
            FreezeEntityPosition(Main.me(),false)
            SetEntityVisible(Main.me(), true)
            SetFollowPedCamViewMode(0)
            Wait(1000)
            AnimateGameplayCamZoom(PlayerPedId(),100.0)
            DoScreenFadeIn(1000)
        end
    end
end)
