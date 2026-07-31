local ADDON_NAME = ...

local DEFAULTS = {
    style = "icon",
    color = { r = 1, g = 1, b = 1 },
    size = 32,
    offsetX = 0,
    offsetY = 0,
    worldOnly = true,
    combatOnly = false,
}

-- Blizzard's FrameXML calls SetCursor("REPAIR_CURSOR"/"BUY_CURSOR"/
-- "MAIL_CURSOR"/"TRANSMOGRIFY_CURSOR"/etc.) whenever a special cursor shape
-- (anvil, bag, envelope, transmog icon...) should replace the default
-- gauntlet, and ResetCursor() when it should revert. Hooking these tells us
-- precisely when a non-gauntlet shape is active, instead of guessing from
-- what frame the mouse is over.
local activeCursorOverride = nil
local debugEnabled = false

hooksecurefunc("SetCursor", function(cursorToken)
    activeCursorOverride = cursorToken
    if debugEnabled then
        print("|cff33ff99CursorWow|r SetCursor(" .. tostring(cursorToken) .. ")")
    end
end)
hooksecurefunc("ResetCursor", function()
    activeCursorOverride = nil
    if debugEnabled then
        print("|cff33ff99CursorWow|r ResetCursor()")
    end
end)

SLASH_CURSORWOW1 = "/cursorwow"
SlashCmdList.CURSORWOW = function(msg)
    if msg == "debug" then
        debugEnabled = not debugEnabled
        print("|cff33ff99CursorWow|r debug " .. (debugEnabled and "ON" or "OFF"))
    end
end

-- Confirmed via in-game debug logging: Blizzard only ever calls SetCursor
-- with a non-nil override for special interaction cursors (buy, repair,
-- mail, transmog...). Everywhere else -- world, action bars, Healbot,
-- bag windows -- no override is set, so presence/absence of an override is
-- the reliable signal, not which frame the mouse happens to be over.
local lastDebugFocusName = nil
local function GetTopFocus()
    if GetMouseFoci then
        local foci = GetMouseFoci()
        return foci[1]
    end
    if GetMouseFocus then
        return GetMouseFocus()
    end
    return nil
end

local function IsGauntletCursor()
    if debugEnabled then
        local top = GetTopFocus()
        local name = top and (top.GetName and top:GetName()) or tostring(top)
        if name ~= lastDebugFocusName then
            lastDebugFocusName = name
            print(("|cff33ff99CursorWow|r focus=%s override=%s"):format(tostring(name), tostring(activeCursorOverride)))
        end
    end

    return activeCursorOverride == nil
end

-- Merchant/mail/transmog windows don't call SetCursor for their whole area,
-- only for specific slots -- but the whole window is an interaction context,
-- not the 3D world, so hide the marker whenever one of these is open.
local SPECIAL_WINDOW_NAMES = { "MerchantFrame", "MailFrame", "TransmogFrame", "WardrobeTransmogFrame", "TransmogrifyFrame" }
local function IsSpecialWindowOpen()
    for _, name in ipairs(SPECIAL_WINDOW_NAMES) do
        local f = _G[name]
        if f and f.IsShown and f:IsShown() then
            return true
        end
    end
    return false
end

CursorWow_ICON_TEXTURE = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"

local frame = CreateFrame("Frame", "CursorWowFrame", UIParent)
frame:SetFrameStrata("TOOLTIP")
frame:SetSize(DEFAULTS.size, DEFAULTS.size)

local texture = frame:CreateTexture(nil, "OVERLAY")
texture:SetAllPoints()

-- "plain" style: a flat white texture masked into a circle. SetVertexColor
-- on a white base gives a pure, unmixed color, unlike the "icon" style below
-- which tints on top of the icon's own baked-in color.
local mask = frame:CreateMaskTexture()
mask:SetAllPoints(texture)
mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

local function ApplySettings()
    local db = CursorWowDB
    if db.style == "plain" then
        texture:SetColorTexture(1, 1, 1)
        texture:AddMaskTexture(mask)
    else
        texture:RemoveMaskTexture(mask)
        texture:SetTexture(CursorWow_ICON_TEXTURE)
    end
    texture:SetVertexColor(db.color.r, db.color.g, db.color.b)
    frame:SetSize(db.size, db.size)
end
CursorWow_ApplySettings = ApplySettings

frame:SetScript("OnUpdate", function(self)
    -- Hidden frames stop receiving OnUpdate in WoW, which would freeze this
    -- polling logic forever the first time it hides itself. Use alpha
    -- instead so the frame stays "shown" and keeps ticking every frame.
    local db = CursorWowDB
    local cursorVisible = not IsMouselooking()
    local combatOk = not db.combatOnly or InCombatLockdown()
    local shouldShow = cursorVisible and combatOk
        and (not db.worldOnly or (IsGauntletCursor() and not IsSpecialWindowOpen()))
    self:SetAlpha(shouldShow and 1 or 0)
    if not shouldShow then return end

    local scale = UIParent:GetEffectiveScale()
    local x, y = GetCursorPosition()
    self:ClearAllPoints()
    -- Anchored by top-left rather than center: the hardware cursor's hotspot
    -- (what GetCursorPosition reports) sits at its tip, not its visual center.
    -- offsetX/offsetY let the player move the marker away from that hotspot.
    self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale + db.offsetX, y / scale + db.offsetY)
end)

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(_, _, addonName)
    if addonName ~= ADDON_NAME then return end

    CursorWowDB = CursorWowDB or {}
    CursorWowDB.style = CursorWowDB.style or DEFAULTS.style
    CursorWowDB.size = CursorWowDB.size or DEFAULTS.size
    CursorWowDB.offsetX = CursorWowDB.offsetX or DEFAULTS.offsetX
    CursorWowDB.offsetY = CursorWowDB.offsetY or DEFAULTS.offsetY
    CursorWowDB.color = CursorWowDB.color or {}
    CursorWowDB.color.r = CursorWowDB.color.r or DEFAULTS.color.r
    CursorWowDB.color.g = CursorWowDB.color.g or DEFAULTS.color.g
    CursorWowDB.color.b = CursorWowDB.color.b or DEFAULTS.color.b
    if CursorWowDB.worldOnly == nil then
        CursorWowDB.worldOnly = DEFAULTS.worldOnly
    end
    if CursorWowDB.combatOnly == nil then
        CursorWowDB.combatOnly = DEFAULTS.combatOnly
    end

    ApplySettings()
end)
