local ADDON_NAME = ...

local panel = CreateFrame("Frame")
panel.name = "CursorWow"

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("CursorWow")

-- Style: two radio buttons choosing between the raid-icon circle and the
-- plain masked circle (which takes color more purely, see Core.lua).
local STYLE_LABELS = {
    { key = "icon",  label = "Rond (icone)" },
    { key = "plain", label = "Rond (couleur pure)" },
}

local styleLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
styleLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -24)
styleLabel:SetText("Style")

local styleButtons = {}
local function RefreshStyleButtons()
    for _, btn in ipairs(styleButtons) do
        btn:SetChecked(btn.styleKey == CursorWowDB.style)
    end
end

local prevStyleButton
for _, entry in ipairs(STYLE_LABELS) do
    local btn = CreateFrame("CheckButton", "CursorWowStyleButton" .. entry.key, panel, "UIRadioButtonTemplate")
    btn.styleKey = entry.key
    btn.Text = _G[btn:GetName() .. "Text"]
    if btn.Text then
        btn.Text:SetText(entry.label)
    end
    if prevStyleButton then
        btn:SetPoint("TOPLEFT", prevStyleButton, "BOTTOMLEFT", 0, -8)
    else
        btn:SetPoint("TOPLEFT", styleLabel, "BOTTOMLEFT", 0, -8)
    end
    btn:SetScript("OnClick", function(self)
        CursorWowDB.style = self.styleKey
        RefreshStyleButtons()
        CursorWow_ApplySettings()
    end)
    styleButtons[#styleButtons + 1] = btn
    prevStyleButton = btn
end

-- Size slider.
local sizeSlider = CreateFrame("Slider", "CursorWowSizeSlider", panel, "OptionsSliderTemplate")
sizeSlider:SetPoint("TOPLEFT", prevStyleButton, "BOTTOMLEFT", 4, -32)
sizeSlider:SetMinMaxValues(8, 96)
sizeSlider:SetValueStep(1)
sizeSlider:SetObeyStepOnDrag(true)
sizeSlider:SetWidth(200)
_G[sizeSlider:GetName() .. "Low"]:SetText("8")
_G[sizeSlider:GetName() .. "High"]:SetText("96")
_G[sizeSlider:GetName() .. "Text"]:SetText("Taille")
sizeSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    CursorWowDB.size = value
    CursorWow_ApplySettings()
end)

-- Horizontal offset slider: moves the marker left/right of the real cursor.
local offsetXSlider = CreateFrame("Slider", "CursorWowOffsetXSlider", panel, "OptionsSliderTemplate")
offsetXSlider:SetPoint("TOPLEFT", sizeSlider, "BOTTOMLEFT", 0, -48)
offsetXSlider:SetMinMaxValues(-100, 100)
offsetXSlider:SetValueStep(1)
offsetXSlider:SetObeyStepOnDrag(true)
offsetXSlider:SetWidth(200)
_G[offsetXSlider:GetName() .. "Low"]:SetText("-100")
_G[offsetXSlider:GetName() .. "High"]:SetText("100")
_G[offsetXSlider:GetName() .. "Text"]:SetText("Decalage horizontal")
offsetXSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    CursorWowDB.offsetX = value
    CursorWow_ApplySettings()
end)

-- Vertical offset slider: moves the marker above/below the real cursor.
local offsetYSlider = CreateFrame("Slider", "CursorWowOffsetYSlider", panel, "OptionsSliderTemplate")
offsetYSlider:SetPoint("TOPLEFT", offsetXSlider, "BOTTOMLEFT", 0, -48)
offsetYSlider:SetMinMaxValues(-100, 100)
offsetYSlider:SetValueStep(1)
offsetYSlider:SetObeyStepOnDrag(true)
offsetYSlider:SetWidth(200)
_G[offsetYSlider:GetName() .. "Low"]:SetText("-100")
_G[offsetYSlider:GetName() .. "High"]:SetText("100")
_G[offsetYSlider:GetName() .. "Text"]:SetText("Decalage vertical")
offsetYSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    CursorWowDB.offsetY = value
    CursorWow_ApplySettings()
end)

-- World-only checkbox: hide the marker when the mouse is over UI (arrow
-- cursor) and only show it while hovering the 3D world (gauntlet cursor).
local worldOnlyCheckbox = CreateFrame("CheckButton", "CursorWowWorldOnlyCheckbox", panel, "UICheckButtonTemplate")
worldOnlyCheckbox:SetPoint("TOPLEFT", offsetYSlider, "BOTTOMLEFT", 0, -32)
_G[worldOnlyCheckbox:GetName() .. "Text"]:SetText("Afficher uniquement en mode gantelet (survol du monde)")
worldOnlyCheckbox:SetScript("OnClick", function(self)
    CursorWowDB.worldOnly = self:GetChecked()
    CursorWow_ApplySettings()
end)

-- Combat-only checkbox: hide the marker outside of combat.
local combatOnlyCheckbox = CreateFrame("CheckButton", "CursorWowCombatOnlyCheckbox", panel, "UICheckButtonTemplate")
combatOnlyCheckbox:SetPoint("TOPLEFT", worldOnlyCheckbox, "BOTTOMLEFT", 0, -8)
_G[combatOnlyCheckbox:GetName() .. "Text"]:SetText("Afficher uniquement en combat")
combatOnlyCheckbox:SetScript("OnClick", function(self)
    CursorWowDB.combatOnly = self:GetChecked()
    CursorWow_ApplySettings()
end)

-- Color picker button.
local colorButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
colorButton:SetPoint("TOPLEFT", combatOnlyCheckbox, "BOTTOMLEFT", 0, -8)
colorButton:SetSize(140, 24)
colorButton:SetText("Choisir la couleur")
colorButton:SetScript("OnClick", function()
    local db = CursorWowDB
    local function OnColorChanged()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        db.color.r, db.color.g, db.color.b = r, g, b
        CursorWow_ApplySettings()
    end
    local function OnCancel(previousValues)
        db.color.r, db.color.g, db.color.b = previousValues.r, previousValues.g, previousValues.b
        CursorWow_ApplySettings()
    end
    ColorPickerFrame:SetupColorPickerAndShow({
        r = db.color.r, g = db.color.g, b = db.color.b,
        hasOpacity = false,
        swatchFunc = OnColorChanged,
        cancelFunc = OnCancel,
    })
end)

panel:SetScript("OnShow", function()
    RefreshStyleButtons()
    sizeSlider:SetValue(CursorWowDB.size)
    offsetXSlider:SetValue(CursorWowDB.offsetX)
    offsetYSlider:SetValue(CursorWowDB.offsetY)
    worldOnlyCheckbox:SetChecked(CursorWowDB.worldOnly)
    combatOnlyCheckbox:SetChecked(CursorWowDB.combatOnly)
end)

local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
Settings.RegisterAddOnCategory(category)
