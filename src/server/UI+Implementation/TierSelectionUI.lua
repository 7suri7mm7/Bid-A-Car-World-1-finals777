--[[
    TierSelectionUI.lua
    Purpose: Display tier selection pop-up with scrollable horizontal tiers
    Parent: StarterPlayer > StarterCharacterScripts
]]

local TierSelectionUI = {}

-- Configuration
local TIER_DATA = {
    {
        name = "BEGINNER",
        cost = 200,
        minDeco = 4,
        maxDeco = 7,
        color = Color3.fromRGB(0, 212, 255) -- Cyan
    },
    {
        name = "ADVANCED",
        cost = 500,
        minDeco = 7,
        maxDeco = 13,
        color = Color3.fromRGB(0, 212, 255)
    },
    {
        name = "EXPERT",
        cost = 1200,
        minDeco = 13,
        maxDeco = 21,
        color = Color3.fromRGB(0, 212, 255)
    },
    {
        name = "CHOSEN",
        cost = 2500,
        minDeco = 21,
        maxDeco = 50,
        color = Color3.fromRGB(0, 212, 255)
    },
    {
        name = "TIER 5",
        cost = 5000,
        minDeco = 50,
        maxDeco = 80,
        color = Color3.fromRGB(0, 212, 255)
    }
}

local COLORS = {
    PRIMARY_CYAN = Color3.fromRGB(0, 212, 255),
    PRIMARY_PURPLE = Color3.fromRGB(123, 44, 191),
    DARK_BLUE = Color3.fromRGB(26, 31, 113),
    WHITE = Color3.fromRGB(255, 255, 255),
    SEMI_TRANSPARENT = Color3.fromRGB(0, 0, 0)
}

local screenSize = nil
local screenGui = nil
local scrollFrame = nil

--[[
    Create the main Tier Selection UI
]]
function TierSelectionUI:Create()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenSize = playerGui.Parent.AbsoluteSize
    
    -- Main ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TierSelectionUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Semi-transparent background
    local background = Instance.new("TextLabel")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = COLORS.SEMI_TRANSPARENT
    background.BackgroundTransparency = 0.5
    background.TextTransparency = 1
    background.ZIndex = 1
    background.Parent = screenGui
    
    -- Pop-up frame (container)
    local popupFrame = Instance.new("Frame")
    popupFrame.Name = "PopupFrame"
    popupFrame.Size = UDim2.new(0, 900, 0, 300)
    popupFrame.Position = UDim2.new(0.5, -450, 0.5, -150) -- Center on screen
    popupFrame.BackgroundColor3 = COLORS.DARK_BLUE
    popupFrame.BorderSizePixel = 2
    popupFrame.BorderColor3 = COLORS.PRIMARY_CYAN
    popupFrame.ZIndex = 2
    popupFrame.Parent = screenGui
    
    -- Gradient background (using UIGradient)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.PRIMARY_CYAN),
        ColorSequenceKeypoint.new(1, COLORS.PRIMARY_PURPLE)
    })
    gradient.Rotation = 90
    gradient.Parent = popupFrame
    
    -- Close button (X)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0, 10)
    closeButton.BackgroundColor3 = COLORS.PRIMARY_PURPLE
    closeButton.TextColor3 = COLORS.WHITE
    closeButton.TextSize = 24
    closeButton.Text = "✕"
    closeButton.ZIndex = 3
    closeButton.Parent = popupFrame
    
    closeButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = COLORS.WHITE
    title.TextSize = 28
    title.TextScaled = true
    title.Text = "SELECT YOUR BID TIER"
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 3
    title.Parent = popupFrame
    
    -- ScrollFrame for tiers
    scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -40, 0, 180)
    scrollFrame.Position = UDim2.new(0, 20, 0, 70)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 450 * #TIER_DATA, 0, 180)
    scrollFrame.ScrollDirection = Enum.ScrollDirection.X
    scrollFrame.ZIndex = 3
    scrollFrame.Parent = popupFrame
    
    -- Create tier buttons
    for i, tierInfo in ipairs(TIER_DATA) do
        self:CreateTierButton(scrollFrame, tierInfo, i)
    end
    
    print("[TierSelectionUI] Created successfully")
    return screenGui
end

--[[
    Create individual tier button
]]
function TierSelectionUI:CreateTierButton(parent, tierInfo, index)
    -- Tier button container
    local tierButton = Instance.new("TextButton")
    tierButton.Name = "Tier_" .. tierInfo.name
    tierButton.Size = UDim2.new(0, 420, 0, 180)
    tierButton.Position = UDim2.new(0, (index - 1) * 430, 0, 0)
    tierButton.BackgroundColor3 = COLORS.DARK_BLUE
    tierButton.BorderColor3 = tierInfo.color
    tierButton.BorderSizePixel = 3
    tierButton.Text = ""
    tierButton.ZIndex = 3
    tierButton.Parent = parent
    
    -- Hover effect
    local originalColor = tierButton.BackgroundColor3
    tierButton.MouseEnter:Connect(function()
        tierButton.BackgroundColor3 = Color3.fromRGB(40, 50, 120)
    end)
    
    tierButton.MouseLeave:Connect(function()
        tierButton.BackgroundColor3 = originalColor
    end)
    
    -- Tier name
    local tierName = Instance.new("TextLabel")
    tierName.Name = "Name"
    tierName.Size = UDim2.new(1, -20, 0, 50)
    tierName.Position = UDim2.new(0, 10, 0, 10)
    tierName.BackgroundTransparency = 1
    tierName.TextColor3 = tierInfo.color
    tierName.TextSize = 24
    tierName.TextScaled = true
    tierName.Text = tierInfo.name
    tierName.Font = Enum.Font.GothamBold
    tierName.ZIndex = 4
    tierName.Parent = tierButton
    
    -- Tier cost
    local tierCost = Instance.new("TextLabel")
    tierCost.Name = "Cost"
    tierCost.Size = UDim2.new(1, -20, 0, 40)
    tierCost.Position = UDim2.new(0, 10, 0, 50)
    tierCost.BackgroundTransparency = 1
    tierCost.TextColor3 = COLORS.WHITE
    tierCost.TextSize = 18
    tierCost.Text = "$" .. tostring(tierInfo.cost)
    tierCost.Font = Enum.Font.Gotham
    tierCost.ZIndex = 4
    tierCost.Parent = tierButton
    
    -- Decorations range
    local decoRange = Instance.new("TextLabel")
    decoRange.Name = "DecoRange"
    decoRange.Size = UDim2.new(1, -20, 0, 40)
    decoRange.Position = UDim2.new(0, 10, 0, 90)
    decoRange.BackgroundTransparency = 1
    decoRange.TextColor3 = Color3.fromRGB(150, 150, 150)
    decoRange.TextSize = 14
    decoRange.Text = "Decorations: " .. tostring(tierInfo.minDeco) .. "-" .. tostring(tierInfo.maxDeco)
    decoRange.Font = Enum.Font.Gotham
    decoRange.ZIndex = 4
    decoRange.Parent = tierButton
    
    -- Select button
    local selectButton = Instance.new("TextButton")
    selectButton.Name = "SelectButton"
    selectButton.Size = UDim2.new(0.8, 0, 0, 30)
    selectButton.Position = UDim2.new(0.1, 0, 0.8, 10)
    selectButton.BackgroundColor3 = tierInfo.color
    selectButton.TextColor3 = COLORS.DARK_BLUE
    selectButton.TextSize = 16
    selectButton.Text = "SELECT"
    selectButton.Font = Enum.Font.GothamBold
    selectButton.ZIndex = 5
    selectButton.Parent = tierButton
    
    selectButton.MouseButton1Click:Connect(function()
        self:SelectTier(tierInfo)
    end)
end

--[[
    Handle tier selection
]]
function TierSelectionUI:SelectTier(tierInfo)
    print("[TierSelectionUI] Selected tier: " .. tierInfo.name .. " (Cost: $" .. tierInfo.cost .. ")")
    
    -- Fire event to server
    local RemoteEvent = game.ReplicatedStorage:FindFirstChild("SelectTier")
    if RemoteEvent then
        RemoteEvent:FireServer(tierInfo.name, tierInfo.cost)
    else
        warn("SelectTier RemoteEvent not found")
    end
    
    -- Hide UI after selection
    self:Hide()
end

--[[
    Show the UI
]]
function TierSelectionUI:Show()
    if screenGui then
        screenGui.Enabled = true
    else
        self:Create()
    end
    print("[TierSelectionUI] Shown")
end

--[[
    Hide the UI
]]
function TierSelectionUI:Hide()
    if screenGui then
        screenGui.Enabled = false
    end
    print("[TierSelectionUI] Hidden")
end

--[[
    Destroy the UI
]]
function TierSelectionUI:Destroy()
    if screenGui then
        screenGui:Destroy()
        screenGui = nil
    end
    print("[TierSelectionUI] Destroyed")
end

return TierSelectionUI
