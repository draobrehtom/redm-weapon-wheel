--[[
Aspect Ratios:

1920/1080 = 1.77 [!]
1760/990 = 1.77
1680/1050 = 1.6 [!]
1600/900 = 1.6
1280/1024 = 1.25 [!]
1366/768 = 1.77
1280/720 = 1.77
1024/768 = 1.33 [!]

]]

-- Debug values
-- local debug = true
local debugSpriteIndex = 'sidearms'

-- Setup wheel
local wheel = {

     -- upper 660x260
    ['sidearms'] = {
        texture = 'wheel_slot_mask_6_0_extended', x = 0.5, y = 0.31, size = 0.3425, width = 660, height = 260,
        aspectRatioX = {
            ['1.77'] = 0.5, ['1.60'] = 0.5, ['1.33'] = 0.5, ['1.25'] = 0.5,
        },
        -- weapon = {"inventory_items", "weapon_sniperrifle_carcano"},
        weaponIconRepositionOffsetY = -0.05,
        weaponIconSize = 0.075,
        weaponIconAngle = 0.0,
    },
    
    -- or
    -- {texture = 'wheel_slot_mask_upperleft', x = 0.505, y = 0.755, size = 0.2125}, -- 464x480
    -- {texture = 'wheel_slot_mask_uppermid', x = 0.505, y = 0.755, size = 0.2125}, -- 296x312
    -- {texture = 'wheel_slot_mask_upperright', x = 0.505, y = 0.755, size = 0.2125}, -- 456x464

     -- left 320x464
    ['longarm_shoulder'] = {
        texture = 'wheel_slot_mask_6_6', x = 0.3622, y = 0.5117, size = 0.0831, width = 320, height = 464, 
        aspectRatioX = {
            ['1.77'] = 0.3622, ['1.60'] = 0.3474, ['1.33'] = 0.315, ['1.25'] = 0.3050,
        },
        -- weapon = {"inventory_items", "weapon_pistol_volcanic"},
        weaponIconSize = 0.075,
        weaponIconAngle = 45.0,
    },

     -- bottom
    ['longarm_back'] = {
        texture = 'wheel_slot_mask_6_4', x = 0.506, y = 0.7509, size = 0.1238, width = 480, height = 312,
        aspectRatioX = {
            ['1.77'] = 0.506, ['1.60'] = 0.506, ['1.33'] = 0.506, ['1.25'] = 0.506,
        },
        -- weapon = {"inventory_items", "weapon_pistol_volcanic"},
        weaponIconSize = 0.075,
        weaponIconAngle = 0.0,
    },
}

-- Calculate apsect ratio
for k,v in pairs(wheel) do
    if v.width and v.height then
        v.aspect = v.width / v.height
    end
end

-- Unload when script is stopped
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        for k,v in pairs(wheel) do
            if v.weapon then
                SetStreamedTextureDictAsNoLongerNeeded(v.weapon[1])
            end
        end
    end
end)

-- Get screen resolution from HTML as it is not possible to do it via in-game natives
local screenWidth = nil
local screenHeight = nil
local screenAspectRatio = 1.0
RegisterNUICallback('screenResolution', function(params, cb)
    screenWidth = params.width
    screenHeight = params.height
    print('Screen resolution', screenWidth, screenHeight)
    screenAspectRatio = (screenWidth / screenHeight)
    screenAspectRatio = math.floor(screenAspectRatio * 100) / 100
    print(screenAspectRatio)
    cb(true)
end)

-- Function to draw the sprite
function DrawSpriteCustom(dict, name, x, y, width, height, heading, r, g, b, a)
    DrawSprite(dict, name, x, y, width, height, heading, r, g, b, a)
end

local function normalizeValue(size, baseResolution, currentResolution)
    local aspectRatioBase = baseResolution.x / baseResolution.y
    local aspectRatioCurrent = currentResolution.x / currentResolution.y
    
    local ratio = aspectRatioBase / aspectRatioCurrent
    return size * ratio
end

function DrawText(text, x, y, fontscale, fontsize, r, g, b, alpha, textcentred, shadow)
    -- local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextScale(fontscale, fontsize)
    SetTextColor(r, g, b, alpha)
    SetTextCentre(textcentred)
    if shadow then 
        SetTextDropshadow(1, 0, 0, 255)
    end
    SetTextFontForCurrentCommand(6)
    DisplayText(text, x, y)
end

function tick()
    while screenAspectRatio == nil do
        Wait(0)
        print('Waiting for aspect ratio')
    end

    -- Draw the sprite at the current position
    SetScriptGfxDrawOrder(3) -- 11 is maximum value which works to draw on top of weapon wheel
    
    for k,v in pairs(wheel) do

        if v.weapon then
            -- background: get width and height
            local size = normalizeValue(v.size, {x = 1920, y = 1080}, {x = screenWidth, y = screenHeight}) -- normalize size
            local width = size -- set width as size
            local height = (size / v.aspect) * screenAspectRatio -- set height as (size/imageAspect)*screenAspectRatio
            -- background: get x and y position based on screen aspect ratio
            local x, y = v.x, v.y
            local _r = string.format("%.2f", screenAspectRatio)
            if v.aspectRatioX and v.aspectRatioX[_r] then
                x = v.aspectRatioX[_r]
            end
            -- background: draw
            DrawSpriteCustom("hud_quick_select", v.texture, x, y, width, height, 0.0, 0, 0, 0, 255)


            -- weapon: get width and height
            local size = v.weaponIconSize
            local size = normalizeValue(size, {x = 1920, y = 1080}, {x = screenWidth, y = screenHeight}) -- normalize size
            local width = size -- set width as size
            local height = (size / (1.0)) * screenAspectRatio -- set height as (size/imageAspect)*screenAspectRatio
            -- weapon: get x and y
            local repositionOffsetY = v.weaponIconRepositionOffsetY and v.weaponIconRepositionOffsetY or 0.0
            local x, y = x, v.y + repositionOffsetY
            local weaponIconAngle = v.weaponIconAngle or 0.0
            -- weapon: draw
            DrawSpriteCustom(v.weapon[1], v.weapon[2], x, y, width, height, weaponIconAngle, 255, 255, 255, 255)
        end
    end


    if debug then
        local _offsetSize = 0.0001
        local spriteX = wheel[debugSpriteIndex].x
        local spriteY = wheel[debugSpriteIndex].y
        local spriteSize = wheel[debugSpriteIndex].size

        -- Handle key presses
        local offsetSize = _offsetSize
        if IsControlPressed(0, `INPUT_SPRINT`) then -- Arrow Up
            offsetSize = offsetSize * 5
        end

        if IsControlPressed(0, `INPUT_FRONTEND_UP`) then -- Arrow Up
            spriteY = spriteY - offsetSize
        end
        if IsControlPressed(0, `INPUT_FRONTEND_DOWN`) then -- Arrow Down
            spriteY = spriteY + offsetSize
        end
        if IsControlPressed(0, `INPUT_FRONTEND_LEFT`) then -- Arrow Left
            spriteX = spriteX - offsetSize
        end
        if IsControlPressed(0, `INPUT_FRONTEND_RIGHT`) then -- Arrow Right
            spriteX = spriteX + offsetSize
        end
        if IsControlPressed(0, `INPUT_FRONTEND_RS`) then -- X
            spriteSize = spriteSize - offsetSize
        end
        if IsControlPressed(0, `INPUT_FRONTEND_LS`) then -- Z
            spriteSize = spriteSize + offsetSize
        end

        -- Ensure the sprite stays within screen bounds
        if spriteX < 0 then spriteX = 0 end
        if spriteX > 1 then spriteX = 1 end
        if spriteY < 0 then spriteY = 0 end
        if spriteY > 1 then spriteY = 1 end

        if spriteSize < 0 then spriteSize = 0 end
        if spriteSize > 1 then spriteSize = 1 end

        -- Show values
        local text = ('X: %s Y: %s S: %s AspectRatio %s/%s=%s'):format(spriteX, spriteY, spriteSize, screenWidth, screenHeight, screenAspectRatio)
        DrawText(
            text, 
            0.0009, 0.9798, 1.0, 0.3, 255, 255, 255, 255, false, true
        )

        -- Update values
        wheel[debugSpriteIndex].x = spriteX
        wheel[debugSpriteIndex].y = spriteY
        wheel[debugSpriteIndex].size = spriteSize
    end
end

exports('setWeaponWheelIcon', function(slot, icon)
    if not wheel[slot] then
        return error('unexisting slot ' .. slot)
    end
    
    if DoesStreamedTextureDictExist(icon[1]) and IsTextureInDict(GetHashKey(icon[2]), GetHashKey(icon[1])) then
        RequestStreamedTextureDict(icon[1], true)
        while not HasStreamedTextureDictLoaded(icon[1]) do
            Citizen.Wait(0)
        end
        print('^2Weapon texture loaded^0')
    else
        error('Timeout on loading weapon textures. Texture dict or name is invalid ' .. json.encode(icon))
    end

    wheel[slot].weapon = icon
end)

-- Script Exports

exports('resetWeaponWheelIcon', function(slot)
    if not wheel[slot] then
        return error('unexisting slot')
    end
    
    SetStreamedTextureDictAsNoLongerNeeded(wheel[slot].weapon)

    wheel[slot].weapon = nil
end)

exports('resetWeaponWheelIcons', function()
    for k,v in pairs(wheel) do
        if v.weapon ~= nil then
            SetStreamedTextureDictAsNoLongerNeeded(v.weapon)
        end
        v.weapon = nil
    end
end)

-- Test commands

-- RegisterCommand('givecustomweapon', function()
--     local attachPoint = 0
--     RemoveWeaponFromPed(PlayerPedId(), `weapon_shotgun_pump`, true, 0)
--     GiveWeaponToPed_2(PlayerPedId(), `weapon_shotgun_pump`, 12, true, true, attachPoint, false, 0.5, 1.0, 752097756, false, 0, false)

--     exports[GetCurrentResourceName()]:setWeaponWheelIcon('longarm_shoulder', {
--         'inventory_items', 'weapon_shotgun_pump',
--     })
-- end)

-- RegisterCommand('removecustomweapon', function()
--     local attachPoint = 0
--     RemoveWeaponFromPed(PlayerPedId(), `weapon_shotgun_pump`, true, 0)
--     exports[GetCurrentResourceName()]:resetWeaponWheelIcon('longarm_shoulder')
-- end)

-- Handle weapon wheel detection
-- Ref: https://github.com/aaron1a12/wild/blob/9235aaa39696691ff26977ff1d2c18fe67971ef5/wild-core/client/cl_weaponWheel.lua#L6

local bQuickSelectOpen = false
local currentWheel = -1
local lastWeaponWheel = -1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        -- Fix for abilities menu glitch while in weapon wheel
        if IsUiappActiveByHash(`abilities`) then
            CloseUiappByHash(`abilities`)
        end

        if IsUiappRunning("hud_quick_select") then
            
            -- Hook into the message queue for the weapon wheel
            while EventsUiIsPending(`HUD_QUICK_SELECT`) do
                local msg = DataView.ArrayBuffer(8 * 4)
                msg:SetInt32(0, 0)
                msg:SetInt32(8, 0)
                msg:SetInt32(16, 0)
                msg:SetInt32(24, 0)
    
                if (Citizen.InvokeNative(0xE24E957294241444, `hud_quick_select`, msg:Buffer()) ~= 0) then -- EVENTS_UI_GET_MESSAGE                    
                    -- if msg:GetInt32(0) == `ITEM_FOCUSED` then
                        if msg:GetInt32(8) == 1 and msg:GetInt32(16) == 813560150 then
                            currentWheel = 0 -- Weapon wheel
                        elseif msg:GetInt32(8) == 2 and msg:GetInt32(16) == -414255251 then
                            currentWheel = 1 -- Item wheel
                        elseif msg:GetInt32(8) == 3 and msg:GetInt32(16) == -1472057397 then
                            currentWheel = 2 -- Horse wheel
                        end
                    -- end
                else
                    Citizen.Wait(0)
                end 



            end

            if currentWheel == 0 then
                tick()
            end
        end
    end
end)
