local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "SunnyHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- Crimson red
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -30, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0) -- Darker crimson
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Parent = MainFrame

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = MainFrame.Size
ToggleFrame.Position = MainFrame.Position
ToggleFrame.Visible = false
ToggleFrame.BackgroundColor3 = MainFrame.BackgroundColor3
ToggleFrame.Parent = ScreenGui

local ExpandButton = Instance.new("TextButton")
ExpandButton.Size = UDim2.new(0, 25, 0, 25)
ExpandButton.Position = UDim2.new(0, 0, 0, 0)
ExpandButton.Text = "+"
ExpandButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0) -- Darker crimson
ExpandButton.TextColor3 = Color3.new(1, 1, 1)
ExpandButton.Parent = ToggleFrame

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleFrame.Visible = true
end)

ExpandButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleFrame.Visible = false
end)

local function CreateButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- Crimson
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = MainFrame
    return btn
end

local killAuraEnabled = false
local killAuraConnection

local killAuraBtn = CreateButton("Kill Aura", 40)
killAuraBtn.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        killAuraBtn.Text = "Kill Aura [ON]"
        killAuraConnection = RunService.Heartbeat:Connect(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChild("Humanoid")
                    if root and hum and hum.Health > 0 and (myRoot.Position - root.Position).Magnitude <= 10 then
                        local tool = myChar:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                end
            end
        end)
    else
        killAuraBtn.Text = "Kill Aura"
        if killAuraConnection then
            killAuraConnection:Disconnect()
            killAuraConnection = nil
        end
    end
end)

local flingEnabled = false
local flingConnection

local flingBtn = CreateButton("Fling Touch", 80)
flingBtn.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    local tool = myChar and myChar:FindFirstChildOfClass("Tool")
    local handle = tool and tool:FindFirstChild("Handle")
    if not tool or not handle then
        flingBtn.Text = "Fling Touch (No Tool)"
        wait(2)
        flingBtn.Text = "Fling Touch"
        return
    end

    flingEnabled = not flingEnabled
    if flingEnabled then
        flingBtn.Text = "Fling Touch [ON]"
        flingConnection = handle.Touched:Connect(function(part)
            if not flingEnabled then return end
            local victimRoot = part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
            if victimRoot and part.Parent ~= myChar then
                victimRoot.Velocity = Vector3.new(0, 200, 0)
            end
        end)
    else
        flingBtn.Text = "Fling Touch"
        if flingConnection then
            flingConnection:Disconnect()
            flingConnection = nil
        end
    end
end)

local dmgBoostEnabled = false
local dmgBoostConnection

local dmgBoostBtn = CreateButton("Damage Boost", 120)
dmgBoostBtn.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    local tool = myChar and myChar:FindFirstChildOfClass("Tool")
    local handle = tool and tool:FindFirstChild("Handle")

    if not tool or not handle then
        dmgBoostBtn.Text = "Damage Boost (No Tool)"
        wait(2)
        dmgBoostBtn.Text = "Damage Boost"
        return
    end

    dmgBoostEnabled = not dmgBoostEnabled
    if dmgBoostEnabled then
        dmgBoostBtn.Text = "Damage Boost [ON]"
        dmgBoostConnection = handle.Touched:Connect(function(part)
            if not dmgBoostEnabled then return end
            local hum = part.Parent and part.Parent:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                hum:TakeDamage(20)
            end
        end)
    else
        dmgBoostBtn.Text = "Damage Boost"
        if dmgBoostConnection then
            dmgBoostConnection:Disconnect()
            dmgBoostConnection = nil
        end
    end
end)
