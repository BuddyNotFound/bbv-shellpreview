CreateThread(function()
    Wait(100)
    LoadConfigShells()
end)

RegisterCommand('openui', function(src, args)
    ShellPreviewer(args[1])
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

RegisterNUICallback('PreviewInformation', function(data)
    print('Preview: '..data.shellid)
end)

RegisterNUICallback('InsideInformation', function(data)
    print('Inside:'..data.shellid)
end)