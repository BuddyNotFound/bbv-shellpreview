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

function Main:TeleportToInterior(x, y, z,data,object)
    if type(data) == 'string' then 
        offset = 0.5
    else
        offset = Config.Shells[data].hight
    end
    CreateThread(function()
        Main:StartOrbitCam(vector3(0.0, 0.0, -3),object,5, 15)
        SetEntityCoords(Main.me(), x , y - 5, z + offset, 0, 0, 0, false)
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

function Main:Notify(txt)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(txt)
    DrawNotification(0,1) 
end

usePreciseMethod = false
minRadius = 1.0
maxRadius = 15.0
radiusStepLength = 0.5
transitionSpeed = 1000
mouseSpeed = 8.0
controllerSpeed = 1.5

local cam = nil
local trackedEntity = nil
local camFocusPoint = vector3(0, 0, 0)
local entityOffset = nil

local minRadius, maxRadius = minRadius, maxRadius
local currentRadius = (minRadius + maxRadius) * 0.5

local angleY, angleZ = 0.0, 0.0

local disabledControls = { 14, 15, 16, 17, 81, 82, 99 }

function Main:StartOrbitCam(position, entity, _minRadius, _maxRadius)
    ClearFocus()
    if (entity) then
        trackedEntity = entity
        entityOffset = position
        camFocusPoint = GetEntityCoords(trackedEntity) + entityOffset
    else
        camFocusPoint = position
    end

    minRadius = _minRadius or minRadius
    maxRadius = _maxRadius or maxRadius

    local rot = GetGameplayCamRot(2)
    angleY = -rot.x
    angleZ = rot.z - 90

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camFocusPoint, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, transitionSpeed, true, false)

    Citizen.CreateThread(function()
        while (cam ~= nil) do
            Main:ProcessCamControls()
            Citizen.Wait(0)
        end
    end)
end

function Main:EndOrbitCam()
    ClearFocus()
    RenderScriptCams(false, true, transitionSpeed, true, false)
    DestroyCam(cam, false)
    cam = nil
    trackedEntity = nil
end

function Main:UpdateCamPosition(position, entity, _minRadius, _maxRadius)
    if (entity) then
        trackedEntity = entity
        entityOffset = position
        camFocusPoint = GetEntityCoords(trackedEntity) + entityOffset
    else
        camFocusPoint = position
    end

    minRadius = _minRadius or minRadius
    maxRadius = _maxRadius or maxRadius
end

function Main:ProcessCamControls()
    DisableFirstPersonCamThisFrame()
    for i, control in ipairs(disabledControls) do
        DisableControlAction(0, control, true)
    end

    local newPos = Main:ProcessNewPosition()

    SetCamCoord(cam, newPos)
    PointCamAtCoord(cam, camFocusPoint)
    SetFocusPosAndVel(camFocusPoint, 0.0, 0.0, 0.0)
end

function Main:ProcessNewPosition()
    local speedMult = IsInputDisabled(0) and mouseSpeed or controllerSpeed
    angleZ = angleZ - GetDisabledControlUnboundNormal(1, 1) * speedMult
    angleY = angleY + GetDisabledControlUnboundNormal(1, 2) * speedMult
    angleY = math.max(math.min(angleY, 89.0), -89.0)

    currentRadius = currentRadius + (GetDisabledControlNormal(0, 16) - GetDisabledControlNormal(0, 17)) * radiusStepLength
    currentRadius = math.max(math.min(currentRadius, maxRadius), minRadius)

    if (trackedEntity and DoesEntityExist(trackedEntity)) then
        camFocusPoint = GetEntityCoords(trackedEntity) + entityOffset
    end

    local cosY = Cos(angleY)
    local offset = vector3(Cos(angleZ) * cosY, Sin(angleZ) * cosY, Sin(angleY)) * currentRadius

    local newPos = camFocusPoint + offset

    local ignoreEnt = trackedEntity or PlayerPedId()
    local rayCastResults = {}
    if (usePreciseMethod) then
        local right, forward, up, currentCamPos = GetCamMatrix(cam)
        local vertOffset, horiOffset = right * 0.125, up * 0.07
        table.insert(rayCastResults, { Main:RayCast(camFocusPoint, newPos + vertOffset + horiOffset, ignoreEnt) })
        table.insert(rayCastResults, { Main:RayCast(camFocusPoint, newPos + vertOffset - horiOffset, ignoreEnt) })
        table.insert(rayCastResults, { Main:RayCast(camFocusPoint, newPos - vertOffset - horiOffset, ignoreEnt) })
        table.insert(rayCastResults, { Main:RayCast(camFocusPoint, newPos - vertOffset + horiOffset, ignoreEnt) })
    else
        table.insert(rayCastResults, { Main:RayCast(camFocusPoint, newPos, ignoreEnt) })
    end

    local radius = currentRadius
    for i, rayCastResult in ipairs(rayCastResults) do
        if (rayCastResult[1]) then
            local dist = #(camFocusPoint - rayCastResult[2])
            if (dist < radius) then
                radius = dist
            end
        end
    end

    offset = offset * (radius / currentRadius)

    return camFocusPoint + offset
end

function Main:RayCast(from, to, ignoreEntity)
    local _, hit, hitPosition = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(from, to, -1, ignoreEntity, 0))
    return hit, hitPosition
end

exports("StartOrbitCam", StartOrbitCam)
exports("UpdateCamPosition", UpdateCamPosition)
exports("EndOrbitCam", EndOrbitCam)