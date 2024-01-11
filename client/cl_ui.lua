-- UI BUILD BY NEENGAME
CreateThread(function()
    Wait(1000)
    LoadConfigShells()
end)

RegisterNetEvent('bbv-shellpreview',function()
    ShellPreviewer()
end)

--// Functions \\--

function ShellPreviewer(bool)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenShellui',
    })
end

function CloseUi()
    SendNUIMessage({
        action = 'CloseShellUI',
    })
    SetNuiFocus(false, false)
end

function LoadConfigShells()
    SendNUIMessage({
        action = 'LoadShells',
        shells = Config.Shells
    })
end

--// NuiCallbacks \\--

RegisterNUICallback('CloseShellUi', function()
    CloseUi()
end)
