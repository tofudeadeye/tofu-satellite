function ToggleSatellite(isOpen)
    Satellite.IsOpen = isOpen
    if not Satellite.IsOpen then
        Satellite.TrackingPeds = {}
    end
    FreezeEntityPosition(Satellite.PlayerPedID, Satellite.IsOpen)
    DisplayRadar(Satellite.IsOpen)
end

function DrawTextXY(text, settings)
    if settings == nil then
        settings = {}
    end
    if settings.rgba == nil then
        settings.rgba = { 255, 255, 255, 255 }
    end
    SetTextFont(settings.font or 4)
    SetTextProportional(0)
    SetTextScale(settings.scale or 0.4, settings.scale or 0.4)
    if settings.right then
        SetTextRightJustify(1)
        SetTextWrap(0.0, settings.x or 0.5)
    end
    SetTextColour(settings.rgba[1] or 255, settings.rgba[2] or 255, settings.rgba[3] or 255, settings.rgba[4] or 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(settings.centre or 0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(settings.x or 0.5, settings.y or 0.5)
end

function RenderSatelliteOverlay()
    DrawSprite("helicopterhud", "hud_corner", 0.10000, 0.10000,
        0.01500, 0.02000, 0.00000, 255, 255, 255, 255)   -- top left
    DrawSprite("helicopterhud", "hud_corner", 0.90000, 0.10000,
        0.01500, 0.02000, 90.00000, 255, 255, 255, 255)  -- top right
    DrawSprite("helicopterhud", "hud_corner", 0.10000, 0.90000,
        0.01500, 0.02000, 270.00000, 255, 255, 255, 255) -- bottom left
    DrawSprite("helicopterhud", "hud_corner", 0.90000, 0.90000,
        0.01500, 0.02000, 180.00000, 255, 255, 255, 255) -- bottom right
end

function HudControls()
    if IsPauseMenuActive() == false then
        local rotation = GetCamRot(Satellite.Camera, 2)
        local satPos = GetCamCoord(Satellite.Camera)
        local heading = rotation.z
        local _, ground = GetGroundZFor_3dCoord(satPos.x, satPos.y, satPos.z, 0)
        SetFocusPosAndVel(satPos.x, satPos.y, ground, 0, 0, 0)

        -- scroll whell down
        DisableControlAction(2, 16, true)
        -- scroll wheel up
        DisableControlAction(2, 17, true)

        -- spacebar pressed, exit from satellite view
        if IsControlJustPressed(2, 22) then
            ToggleSatellite(false)
        end

        if IsDisabledControlPressed(2, 17) or IsControlPressed(2, 17) then
            if Satellite.MaxHeight > (Satellite.MinHeight + ground) then
                Satellite.MaxHeight = Satellite.MaxHeight - (Satellite.ZoomSpeed * 2)
                satPos = vector3(satPos.x, satPos.y, Satellite.MaxHeight)
                SetCamCoord(Satellite.Camera, satPos)
                RenderScriptCams(1, 1, 0, 0, 0)
            end
        end

        if IsDisabledControlPressed(2, 16) or IsControlPressed(2, 16) then
            if Satellite.MaxHeight < 800 then
                Satellite.MaxHeight = Satellite.MaxHeight + (Satellite.ZoomSpeed * 2)
                satPos = vector3(satPos.x, satPos.y, Satellite.MaxHeight)
                SetCamCoord(Satellite.Camera, satPos)
                RenderScriptCams(1, 1, 0, 0, 0)
            end
        end

        if #Satellite.TrackingPeds == 0 then
            DrawTextXY("MANUAL TRACKING",
                { centre = 0, x = 0.10300, y = 0.10000, scale = 0.85, rgba = { 100, 255, 100, 180 } })
            -- KeyPress: W
            if IsDisabledControlPressed(2, 33) then
                satPos = GetObjectOffsetFromCoords(satPos.x, satPos.y, satPos.z, heading, 0, -Satellite.MoveSpeed, 0)
                SetCamCoord(Satellite.Camera, satPos)
            end
            -- KeyPress: S
            if IsDisabledControlPressed(2, 32) then
                satPos = GetObjectOffsetFromCoords(satPos.x, satPos.y, satPos.z, heading, 0, Satellite.MoveSpeed, 0)
                SetCamCoord(Satellite.Camera, satPos)
            end
            -- KeyPress: A
            if IsDisabledControlPressed(2, 34) then
                satPos = GetObjectOffsetFromCoords(satPos.x, satPos.y, satPos.z, heading, -Satellite.MoveSpeed, 0, 0)
                SetCamCoord(Satellite.Camera, satPos)
            end
            -- KeyPress: D
            if IsDisabledControlPressed(2, 35) then
                satPos = GetObjectOffsetFromCoords(satPos.x, satPos.y, satPos.z, heading, Satellite.MoveSpeed, 0, 0)
                SetCamCoord(Satellite.Camera, satPos)
            end
        else
            DrawTextXY(Satellite.HudText,
                { centre = 0, x = 0.10300, y = 0.10000, scale = 0.85, rgba = { 255, 100, 100, 180 } })
        end
    end
end
