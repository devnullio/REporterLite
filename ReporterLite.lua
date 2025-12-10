-- 1. IMMEDIATE DEBUG
-- If you do not see this message on login, the folder/file name is wrong.
print("|cff00ff00[ReporterLite]|r: Addon file loaded.")

-- 2. CREATE THE MAIN CONTAINER FRAME
-- We create this immediately so it exists no matter what.
local MainFrame = CreateFrame("Frame", "ReporterLiteFrame", UIParent)
MainFrame:SetSize(250, 250)
MainFrame:SetPoint("CENTER")
MainFrame:SetFrameStrata("HIGH") -- Force it on top of other windows
MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)

-- Add a Dark Background so you can definitely see it
MainFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})

-- Add a Header
local Header = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Header:SetPoint("TOP", MainFrame, "TOP", 0, -10)
Header:SetText("Reporter Lite")

-- Hide it by default
MainFrame:Hide()

-- 3. CREATE THE 5 BUTTONS
-- We attach these to the bottom of the MainFrame
local ButtonContainer = CreateFrame("Frame", nil, MainFrame)
ButtonContainer:SetSize(230, 40)
ButtonContainer:SetPoint("BOTTOM", MainFrame, "BOTTOM", 0, 10)

local function ClickButton(count)
-- Get Location
local loc = GetSubZoneText()
if not loc or loc == "" then loc = GetMinimapZoneText() end
    if not loc or loc == "" then loc = GetZoneText() end
        if not loc or loc == "" then loc = "Unknown Loc" end

            -- Construct Message
            local msg = "INC " .. count .. " @ " .. loc

            -- Determine Channel (Safe Fallback)
            local channel = "SAY"
            if UnitInBattleground("player") then
                channel = "BATTLEGROUND"
                end

                SendChatMessage(msg, channel)
                print("|cff00ff00[Sent]|r: " .. msg)
                end

                for i = 1, 5 do
                    local btn = CreateFrame("Button", nil, ButtonContainer, "UIPanelButtonTemplate")
                    btn:SetSize(40, 30) -- Nice and big
                    btn:SetPoint("LEFT", ButtonContainer, "LEFT", ((i-1)*45) + 5, 0)

                    local label = tostring(i)
                    if i == 5 then label = "5+" end

                        btn:SetText(label)
                        btn:SetScript("OnClick", function() ClickButton(label) end)
                        end

                        -- 4. MAP HANDLING
                        -- This function attempts to put the Blizzard map inside our box
                        local function AttachMap()
                        -- Load the Blizzard addon if needed
                        if not IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
                            local loaded = LoadAddOn("Blizzard_BattlefieldMinimap")
                            end

                            -- Check if it exists now
                            if BattlefieldMinimap then
                                BattlefieldMinimap:SetParent(MainFrame)
                                BattlefieldMinimap:ClearAllPoints()
                                BattlefieldMinimap:SetPoint("TOP", MainFrame, "TOP", 0, -30)
                                BattlefieldMinimap:SetSize(220, 150)
                                BattlefieldMinimap:Show()
                                BattlefieldMinimap:SetAlpha(1)

                                -- Force dots to show
                                if BattlefieldMinimapOptions then BattlefieldMinimapOptions.showPlayers = true end
                                    if BattlefieldMinimapTab then BattlefieldMinimapTab:Hide() end
                                        else
                                            print("ReporterLite: Could not find BattlefieldMinimap frame.")
                                            end
                                            end

                                            -- 5. SLASH COMMANDS
                                            SLASH_REPORTER1 = "/rep"
                                            SlashCmdList["REPORTER"] = function(msg)
                                            if MainFrame:IsVisible() then
                                                MainFrame:Hide()
                                                print("Reporter Hidden")
                                                else
                                                    AttachMap() -- Try to grab the map every time we open
                                                    MainFrame:Show()
                                                    print("Reporter Shown")
                                                    end
                                                    end

                                                    -- 6. EVENT LOGIC (The "Reporter Loaded" Requirement)
                                                    local EventFrame = CreateFrame("Frame")
                                                    EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
                                                    EventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

                                                    local lastWasPVP = false

                                                    EventFrame:SetScript("OnEvent", function()
                                                    local _, instanceType = IsInInstance()

                                                    if instanceType == "pvp" then
                                                        if not lastWasPVP then
                                                            -- We just entered a BG
                                                            print("Reporter Loaded") -- <--- EXACTLY AS REQUESTED
                                                            AttachMap()
                                                            MainFrame:Show()
                                                            lastWasPVP = true
                                                            end
                                                            else
                                                                -- We are not in a BG
                                                                if lastWasPVP then
                                                                    MainFrame:Hide()
                                                                    lastWasPVP = false
                                                                    end
                                                                    end
                                                                    end)
