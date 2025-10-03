local blocked = false
local lastFrozenVehicle = 0

local function isBlocked()
    local ratio = GetAspectRatio(false)
    if ratio <= 0.0 then
        return false
    end
    return math.abs(ratio - (4.0/3.0)) < 0.02
end

local function drawTextCentered(x, y, scale, text)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

CreateThread(function()
    while true do
        Wait(1000)
        blocked = isBlocked()
    end
end)

CreateThread(function()
    while true do
        if blocked then
            local ped = PlayerPedId()
            FreezeEntityPosition(ped, true)
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if veh ~= 0 then
                    FreezeEntityPosition(veh, true)
                    lastFrozenVehicle = veh
                end
            end
            HideHudAndRadarThisFrame()
            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 200)
            drawTextCentered(0.5, 0.45, 1.0, '~r~Résolution 4:3 interdite en RP')
            drawTextCentered(0.5, 0.52, 0.6, '~r~Changez votre résolution (16:9 conseillé)')
            print("^1Changez votre résolution")            
            Wait(0)
        else
            local ped = PlayerPedId()
            FreezeEntityPosition(ped, false)
            if lastFrozenVehicle ~= 0 and DoesEntityExist(lastFrozenVehicle) then
                FreezeEntityPosition(lastFrozenVehicle, false)
            end
            lastFrozenVehicle = 0
            Wait(500)
        end
    end
end)

