-- Internal reference values, do not modify.
Satellite.HudText = ""
Satellite.IsOpen = false
Satellite.Camera = nil
Satellite.TrackingPeds = {}
Satellite.PlayerPedID = PlayerPedId()

RegisterNetEvent('tofu-satellite:open', function(peds, duration)
    Satellite.TrackingPeds = peds
    Satellite.DefaultTimer = duration
    ToggleSatellite(true)
end)

Citizen.CreateThread(function()
    local pos = nil
    while true do
        if Satellite.IsOpen then
            if not HasStreamedTextureDictLoaded("helicopterhud") then
                RequestStreamedTextureDict("helicopterhud")
                while not HasStreamedTextureDictLoaded("helicopterhud") do
                    Citizen.Wait(0)
                end
            end

            if not HasStreamedTextureDictLoaded("crosstheline") then
                RequestStreamedTextureDict("crosstheline")
                while not HasStreamedTextureDictLoaded("crosstheline") do
                    Citizen.Wait(0)
                end
            end

            if Satellite.Camera == nil then
                -- default camera position is that of the player
                pos = GetEntityCoords(Satellite.PlayerPedID)
                if #Satellite.TrackingPeds > 0 then
                    -- if tracking targets, set camera position to that of the first target
                    pos = GetEntityCoords(GetPlayerPed(Satellite.TrackingPeds[1].PlayerData.source))
                end

                Satellite.Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
                SetCamCoord(Satellite.Camera, vector3(pos.x, pos.y, Satellite.MaxHeight))
                SetCamRot(Satellite.Camera, -80.00000, CameraRotX, 0.00000, 2)
                SetCamActive(Satellite.Camera, true)
                StopCamPointing(Satellite.Camera)
                RenderScriptCams(true, true, 0, 0, 0)
            end

            SetCamRot(Satellite.Camera, -80.00000, CameraRotX, 0.00000, 2)
            AnimpostfxPlay("MP_OrbitalCannon", 0, true)
            RenderSatelliteOverlay()
            HudControls()

            Citizen.Wait(0)
        else
            AnimpostfxStop("MP_OrbitalCannon")
            SetCamActive(Satellite.Camera, false)
            StopCamPointing(Satellite.Camera)
            RenderScriptCams(0, 0, 0, 0, 0)
            FreezeEntityPosition(Satellite.PlayerPedID, false)
            SetFocusEntity(Satellite.PlayerPedID)
            Satellite.Camera = nil

            DisableControlAction(2, 16, false)
            DisableControlAction(2, 17, false)

            Citizen.Wait(500)
        end
    end
end)
