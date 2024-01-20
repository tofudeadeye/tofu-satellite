local QBCore = exports['qb-core']:GetCoreObject()

-- Updates the satellite overlay with a flashing message
Citizen.CreateThread(function()
    while true do
        if Satellite.IsOpen and #Satellite.TrackingPeds > 0 then
            Satellite.HudText = "TRACKING TARGET"
            Citizen.Wait(1000)
            Satellite.HudText = ""
            Citizen.Wait(650)
        end
        Citizen.Wait(1000)
    end
end)

-- Updates the camera rotation
CameraRotX = 0.000
Citizen.CreateThread(function()
    while true do
        if Satellite.IsOpen then
            CameraRotX = CameraRotX + Satellite.CameraRotDegrees
            if CameraRotX >= 360.0 then
                CameraRotX = 0
            end

            Citizen.Wait(60)
        else
            Citizen.Wait(5000)
        end
    end
end)

-- Checks if satellite timer has expired
Citizen.CreateThread(function()
    while true do
        if Satellite.IsOpen and Satellite.DefaultTimer > 0 then
            Citizen.Wait(Satellite.DefaultTimer * 1000)
            ToggleSatellite(false)
        else
            Citizen.Wait(5000)
        end
    end
end)

-- Draw tracked peds
Citizen.CreateThread(function()
    local pos, playerIdx, ped, offScreen, x, y = nil, nil, nil, nil
    while true do
        if Satellite.IsOpen then
            if #Satellite.TrackingPeds > 0 then
                for _, p in pairs(Satellite.TrackingPeds) do
                    playerIdx = GetPlayerFromServerId(p)
                    ped = GetPlayerPed(playerIdx)
                    if ped ~= 0 then
                        pos = GetEntityCoords(ped)
                        offScreen, x, y = GetHudScreenPositionFromWorldPosition(pos.x, pos.y, pos.z)
                        if offScreen then
                            DrawSprite("helicopterhud", "hudarrow", QBCore.Shared.Round(x, 5), QBCore.Shared.Round(y, 5),
                                0.01500, 0.02500, 0.00000, 50, 155, 255, 255)
                        else
                            DrawSprite("helicopterhud", "hud_lock", QBCore.Shared.Round(x, 5), QBCore.Shared.Round(y, 5),
                                0.025, 0.02500, 0.00000, 255, 100, 100, 255)
                        end
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)
