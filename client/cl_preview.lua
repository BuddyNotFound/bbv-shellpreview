RegisterNetEvent('bbv-shellpreview:client',function(data)
    local shellspawn = Config.Shells.PreviewLocation
    local oldpos = GetEntityCoords(Main.me())
    previewmodel = Config.Shells[data].name
    local model = previewmodel
    Main:CreatePreview(shellspawn, exit, model, oldpos , data)
end)

function Main:CreatePreview(spawn, exitXYZH, model, oldpos, type)
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
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1000)
    end
    self.Shells[#self.Shells + 1] = CreateObject(model, spawn.x, spawn.y, spawn.z, false, false, false)
    SetFollowPedCamViewMode(4)
    FreezeEntityPosition(self.Shells[#self.Shells], true)
    self:TeleportToInterior(spawn.x, spawn.y, spawn.z, type)
    Main.preview = true
    TriggerEvent('bbv-shellpreview:exit',self.Shells[#self.Shells],oldpos)
end

RegisterNetEvent('bbv-shellpreview:exit',function(delshell,tppos)
    while Main.preview do 
        Wait(0)
        NetworkOverrideClockTime(23, 00, 0)
        Main:DisplayText("Press [F] to exit preview")
        if IsControlJustReleased(0,23) then
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
            DoScreenFadeIn(1000)
        end
    end
end)
