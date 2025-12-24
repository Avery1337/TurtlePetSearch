-- ==========================================================
-- TITLES PROJECT: DATA & TABLES
-- ==========================================================
local FROG_LIST = { ["Azure Frog"]=1, ["Bullfrog"]=1, ["Dart Frog"]=1, ["Dream Frog"]=1, ["Golden Frog"]=1, ["Infinite Frog"]=1, ["Island Frog"]=1, ["Poison Frog"]=1, ["Pond Frog"]=1, ["Snow Frog"]=1, ["Tree Frog"]=1, ["Wood Frog"]=1, ["Jubling"]=1 }
local CAT_LIST = { ["Bombay"]=1, ["Black Tabby"]=1, ["Cornish Rex"]=1, ["Orange Tabby"]=1, ["Siamese"]=1, ["White Kitten"]=1, ["Mr. Bigglesworth"]=1, ["Midnight"]=1, ["Corrupted Kitten"]=1, ["White Tiger Cub"]=1, ["Silver Tabby"]=1 }
local SPIDER_LIST = { ["Araxxna's Hatchling"]=1, ["Cavernweb Hatchling"]=1, ["Maexxna's Hatchling"]=1, ["Razzashi Hatchling"]=1, ["Skitterweb Hatchling"]=1, ["Black Widow Hatchling"]=1, ["Darkmist Hatchling"]=1, ["Lava Hatchling"]=1, ["Mistbark Hatchling"]=1, ["Night Web Hatchling"]=1, ["Smolderweb Hatchling"]=1, ["Tarantula Hatchling"]=1, ["Timberweb Hatchling"]=1, ["Webwood Hatchling"]=1, ["Wildthorn Hatchling"]=1 }

-- ==========================================================
-- TITLES INTERFACE (MAIN WINDOW)
-- ==========================================================
local TitlesFrame = CreateFrame("Frame", "TurtleTitlesFrame", UIParent)
TitlesFrame:SetWidth(300) TitlesFrame:SetHeight(280)
TitlesFrame:SetPoint("CENTER", UIParent, "CENTER")
TitlesFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
TitlesFrame:SetMovable(true) TitlesFrame:EnableMouse(true)
TitlesFrame:SetScript("OnMouseDown", function() this:StartMoving() end)
TitlesFrame:SetScript("OnMouseUp", function() this:StopMovingOrSizing() end)
TitlesFrame:Hide()

-- Checklist Detail Window (Secondary)
local DetailFrame = CreateFrame("Frame", "TurtleTitlesDetail", TitlesFrame)
DetailFrame:SetWidth(250) DetailFrame:SetHeight(320)
DetailFrame:SetPoint("LEFT", TitlesFrame, "RIGHT", 5, 0)
DetailFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
DetailFrame:Hide()

local detailTitle = DetailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
detailTitle:SetPoint("TOP", DetailFrame, "TOP", 0, -10)

local detailContent = DetailFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
detailContent:SetPoint("TOPLEFT", DetailFrame, "TOPLEFT", 15, -30)
detailContent:SetJustifyH("LEFT")

-- Function to show missing/owned pets
local function ShowDetails(titleName, dataList)
    local numTabs = GetNumSpellTabs()
    local companionTabID = numTabs - 1
    local _, _, offset, numSpells = GetSpellTabInfo(companionTabID)
    
    local owned = {}
    for i = (offset + 1), (offset + numSpells) do
        local name = GetSpellName(i, BOOKTYPE_SPELL)
        if name then owned[name] = true end
    end

    local text = ""
    for petName, _ in pairs(dataList) do
        if owned[petName] then
            text = text .. "|cff00ff00[X] " .. petName .. "|r\n"
        else
            text = text .. "|cffff0000[ ] " .. petName .. "|r\n"
        end
    end
    
    detailTitle:SetText(titleName)
    detailContent:SetText(text)
    DetailFrame:Show()
end

local function CreatePetBar(name, yOffset, maxVal, color, dataList)
    local row = CreateFrame("Button", nil, TitlesFrame)
    row:SetWidth(260) row:SetHeight(45)
    row:SetPoint("TOPLEFT", TitlesFrame, "TOPLEFT", 20, yOffset)
    
    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    label:SetText(name .. " |cff888888(Click for Details)|r")

    local bar = CreateFrame("StatusBar", nil, row)
    bar:SetWidth(250) bar:SetHeight(16)
    bar:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar:SetStatusBarColor(color.r, color.g, color.b)
    bar:SetMinMaxValues(0, maxVal)

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(bar) bg:SetTexture(0, 0, 0, 0.5)

    local txt = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    txt:SetPoint("CENTER", bar, "CENTER", 0, 0)
    
    row:SetScript("OnClick", function() ShowDetails(name, dataList) end)
    
    return bar, txt
end

local barFrog, txtFrog = CreatePetBar("Lord of the Frogs", -50, 13, {r=0.2, g=0.8, b=0.2}, FROG_LIST)
local barCat, txtCat = CreatePetBar("Crazy Cat Lady", -110, 11, {r=1, g=0.5, b=0}, CAT_LIST)
local barSpider, txtSpider = CreatePetBar("Itsy Bitsy Hero", -170, 15, {r=0.6, g=0.3, b=0.8}, SPIDER_LIST)

local function UpdatePetStats()
    local numTabs = GetNumSpellTabs()
    local companionTabID = numTabs - 1
    if companionTabID < 1 then return end
    local _, _, offset, numSpells = GetSpellTabInfo(companionTabID)
    local fCount, cCount, sCount = 0, 0, 0
    for i = (offset + 1), (offset + numSpells) do
        local name = GetSpellName(i, BOOKTYPE_SPELL)
        if name then
            if FROG_LIST[name] then fCount = fCount + 1 end
            if CAT_LIST[name] then cCount = cCount + 1 end
            if SPIDER_LIST[name] then sCount = sCount + 1 end
        end
    end
    barFrog:SetValue(fCount) txtFrog:SetText(fCount.." / 13")
    barCat:SetValue(cCount) txtCat:SetText(cCount.." / 11")
    barSpider:SetValue(sCount) txtSpider:SetText(sCount.." / 15")
end

TitlesFrame:SetScript("OnShow", function() UpdatePetStats() end)
TitlesFrame:SetScript("OnHide", function() DetailFrame:Hide() end)
local closeBtn = CreateFrame("Button", nil, TitlesFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", TitlesFrame, "TOPRIGHT", -5, -5)

-- ==========================================================
-- SEARCH BAR & INTERFACE INTEGRATION
-- ==========================================================
local PARENT_FRAME = SpellBookFrame 
local BOX_WIDTH, BOX_HEIGHT = 130, 24
local POS_X, POS_Y = -55, -45
local lastSearchText, currentMatchIndex = "", 0

local searchBox = CreateFrame("EditBox", "TurtlePetSearchBox", PARENT_FRAME, "InputBoxTemplate")
searchBox:SetWidth(BOX_WIDTH) searchBox:SetHeight(BOX_HEIGHT)
searchBox:SetPoint("TOPRIGHT", PARENT_FRAME, "TOPRIGHT", POS_X, POS_Y)
searchBox:SetAutoFocus(false)
searchBox:SetText("Search Pet...")
searchBox:SetMaxLetters(50)

local projectBtn = CreateFrame("Button", "TurtleProjectButton", PARENT_FRAME, "UIPanelButtonTemplate")
projectBtn:SetWidth(50) projectBtn:SetHeight(24)
projectBtn:SetPoint("RIGHT", searchBox, "LEFT", -55, 0)
projectBtn:SetText("Titles") 
projectBtn:SetScript("OnClick", function() if TitlesFrame:IsVisible() then TitlesFrame:Hide() else TitlesFrame:Show() end end)

local counterText = searchBox:CreateFontString("TurtlePetCounter", "OVERLAY", "GameFontNormalSmall")
counterText:SetPoint("LEFT", projectBtn, "RIGHT", 2, 0)
counterText:SetPoint("RIGHT", searchBox, "LEFT", -2, 0)
counterText:SetJustifyH("CENTER")
counterText:SetText("")
counterText:SetTextColor(1, 1, 1)

local highlighter = CreateFrame("Frame", "TurtlePetHighlight", SpellBookFrame)
highlighter:SetWidth(46) highlighter:SetHeight(46)
highlighter:SetFrameStrata("TOOLTIP") highlighter:Hide()
local highlightTex = highlighter:CreateTexture(nil, "OVERLAY")
highlightTex:SetAllPoints(highlighter)
highlightTex:SetTexture("Interface\\Buttons\\CheckButtonHilight")
highlightTex:SetBlendMode("ADD")

searchBox:SetScript("OnEditFocusGained", function() if this:GetText() == "Search Pet..." then this:SetText("") end end)
searchBox:SetScript("OnEditFocusLost", function() if this:GetText() == "" then this:SetText("Search Pet...") end end)

searchBox:SetScript("OnEnterPressed", function()
    local text = string.lower(this:GetText())
    highlighter:Hide()
    if text == "" or text == "search pet..." then counterText:SetText("") return end
    if text ~= lastSearchText then lastSearchText = text currentMatchIndex = 0 end
    local numTabs = GetNumSpellTabs()
    local companionTabID = numTabs - 1
    if companionTabID < 1 then companionTabID = 1 end
    local _, _, offset, numSpells = GetSpellTabInfo(companionTabID)
    local matches, count = {}, 0
    for i = (offset + 1), (offset + numSpells) do
        local name = GetSpellName(i, BOOKTYPE_SPELL)
        if name and string.find(string.lower(name), text, 1, true) then
            count = count + 1 matches[count] = i
        end
    end
    if count == 0 then counterText:SetText("0") counterText:SetTextColor(1, 0, 0) currentMatchIndex = 0 return end
    currentMatchIndex = currentMatchIndex + 1
    local needsReset = false
    if currentMatchIndex > count then currentMatchIndex = 1 needsReset = true end
    counterText:SetText(currentMatchIndex.."/"..count) counterText:SetTextColor(1, 0.8, 0)
    local targetID = matches[currentMatchIndex]
    if targetID then
        local tabBtn = getglobal("SpellBookSkillLineTab"..companionTabID)
        if tabBtn then tabBtn:Click() end
        local navigator = CreateFrame("Frame")
        navigator.timer, navigator.targetID = 0, targetID
        if needsReset then navigator.state = "RESET" else navigator.state = "SCAN" end
        navigator:SetScript("OnUpdate", function()
            this.timer = this.timer + arg1
            if this.timer > 0.1 then
                this.timer = 0
                if this.state == "RESET" then
                    local prevBtn = getglobal("SpellBookPrevPageButton")
                    if prevBtn and prevBtn:IsEnabled() == 1 then prevBtn:Click() else this.state = "SCAN" end
                elseif this.state == "SCAN" then
                    local found = false
                    for b = 1, 12 do
                        local btn = getglobal("SpellButton"..b)
                        if btn and btn:IsVisible() then
                            local bID = SpellBook_GetSpellID(btn:GetID())
                            if bID == this.targetID then
                                highlighter:SetPoint("CENTER", btn, "CENTER", 0, 0)
                                highlighter:Show() found = true break
                            end
                        end
                    end
                    if found then this:SetScript("OnUpdate", nil) else
                        local nextBtn = getglobal("SpellBookNextPageButton")
                        if nextBtn and nextBtn:IsEnabled() == 1 then nextBtn:Click() else this.state = "RESET" end
                    end
                end
            end
        end)
    end
end)

searchBox:SetScript("OnEscapePressed", function() this:ClearFocus() end)

-- FIX FOR 1.12: Hooking core functions to clear highlight
local originalUpdate = SpellBookFrame_Update
SpellBookFrame_Update = function()
    highlighter:Hide()
    originalUpdate()
end

-- Hook page buttons specifically for 1.12 click handling
local originalNext = SpellBookNextPageButton_OnClick
SpellBookNextPageButton_OnClick = function()
    highlighter:Hide()
    originalNext()
end

local originalPrev = SpellBookPrevPageButton_OnClick
SpellBookPrevPageButton_OnClick = function()
    highlighter:Hide()
    originalPrev()
end