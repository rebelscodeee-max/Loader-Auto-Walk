local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local scaleFactor = isMobile and 1.2 or 1.0

local PANEL_W = 320 * scaleFactor
local PANEL_H = 420 * scaleFactor
local ENTRY_HEIGHT = 56 * scaleFactor
local RECENT_IGNORE_SECONDS = 2

local lastSeen = {}
local entriesCount = 0
local isMinimized = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoomboxTrackerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(0.7, 0, 0.15, 0)
panel.AnchorPoint = Vector2.new(0, 0)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BorderSizePixel = 0
panel.Parent = screenGui
panel.ClipsDescendants = true

local panelRound = Instance.new("UICorner", panel)
panelRound.CornerRadius = UDim.new(0, 14)

local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1, 0, 0, 50 * scaleFactor)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
header.BorderSizePixel = 0

local headerRound = Instance.new("UICorner", header)
headerRound.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -140 * scaleFactor, 1, 0)
title.Position = UDim2.new(0, 12 * scaleFactor, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Boombox Tracker"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextSize = 16 * scaleFactor
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = isMobile

local buttonContainer = Instance.new("Frame", header)
buttonContainer.Size = UDim2.new(0, 130 * scaleFactor, 1, 0)
buttonContainer.Position = UDim2.new(1, -135 * scaleFactor, 0, 0)
buttonContainer.BackgroundTransparency = 1

local function makeHeaderButton(name, text, order)
	local b = Instance.new("TextButton", buttonContainer)
	b.Name = name
	b.Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor)
	b.Position = UDim2.new(0, (order - 1) * 33 * scaleFactor, 0.5, -15 * scaleFactor)
	b.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	b.TextColor3 = Color3.fromRGB(240, 240, 240)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14 * scaleFactor
	b.Text = text
	b.AutoButtonColor = true
	local r = Instance.new("UICorner", b)
	r.CornerRadius = UDim.new(0, 6)
	
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(75, 75, 75)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
	end)
	
	return b
end

local btnMinimize = makeHeaderButton("MinimizeBtn", "─", 1)
local btnClose = makeHeaderButton("CloseBtn", "✕", 2)

local buttonRow = Instance.new("Frame", panel)
buttonRow.Name = "ButtonRow"
buttonRow.Size = UDim2.new(1, -16 * scaleFactor, 0, 36 * scaleFactor)
buttonRow.Position = UDim2.new(0, 8 * scaleFactor, 0, 58 * scaleFactor)
buttonRow.BackgroundTransparency = 1

local function makeActionButton(name, text, order)
	local b = Instance.new("TextButton", buttonRow)
	b.Name = name
	b.LayoutOrder = order
	b.Size = UDim2.new(0.32, -4 * scaleFactor, 1, 0)
	b.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13 * scaleFactor
	b.Text = text
	b.AutoButtonColor = true
	local r = Instance.new("UICorner", b)
	r.CornerRadius = UDim.new(0, 8)
	
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 150, 200)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 180)}):Play()
	end)
	
	return b
end

local btnLayout = Instance.new("UIListLayout", buttonRow)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
btnLayout.Padding = UDim.new(0, 6 * scaleFactor)

local btnClear = makeActionButton("ClearBtn", "Clear", 1)
local btnCopyAll = makeActionButton("CopyAllBtn", "Copy All", 2)
local btnToggle = makeActionButton("ToggleBtn", "Hide", 3)

local content = Instance.new("Frame", panel)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 102 * scaleFactor)
content.Size = UDim2.new(1, 0, 1, -102 * scaleFactor)
content.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", content)
scroll.Name = "List"
scroll.Size = UDim2.new(1, -12 * scaleFactor, 1, -12 * scaleFactor)
scroll.Position = UDim2.new(0, 6 * scaleFactor, 0, 6 * scaleFactor)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6 * scaleFactor
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8 * scaleFactor)

local padding = Instance.new("UIPadding", scroll)
padding.PaddingTop = UDim.new(0, 4 * scaleFactor)
padding.PaddingBottom = UDim.new(0, 8 * scaleFactor)

local toast = Instance.new("TextLabel", panel)
toast.Size = UDim2.new(1, -24 * scaleFactor, 0, 28 * scaleFactor)
toast.Position = UDim2.new(0, 12 * scaleFactor, 1, -36 * scaleFactor)
toast.BackgroundTransparency = 1
toast.Text = ""
toast.TextColor3 = Color3.fromRGB(255, 255, 255)
toast.Font = Enum.Font.Gotham
toast.TextSize = 13 * scaleFactor
local toastCorner = Instance.new("UICorner", toast)
toastCorner.CornerRadius = UDim.new(0, 8)

local toastTask
local function showToast(text, timeSec)
	timeSec = timeSec or 1.2
	toast.Text = text
	toast.BackgroundTransparency = 0.3
	toast.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	toast.TextColor3 = Color3.fromRGB(240, 240, 240)
	if toastTask then task.cancel(toastTask) end
	toastTask = task.spawn(function()
		wait(timeSec)
		toast.BackgroundTransparency = 1
		toast.Text = ""
	end)
end

local credit = Instance.new("TextLabel", screenGui)
credit.Size = UDim2.new(0, 220 * scaleFactor, 0, 24 * scaleFactor)
credit.AnchorPoint = Vector2.new(0.5, 1)
credit.Position = UDim2.new(0.5, 0, 1, -6)
credit.BackgroundTransparency = 1
credit.Text = "script created by ScriptBox"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.TextSize = 12 * scaleFactor
credit.Font = Enum.Font.Gotham

local function showManualCopyModal(textToShow)
	local existing = screenGui:FindFirstChild("ManualCopyModal")
	if existing then existing:Destroy() end
	
	local modal = Instance.new("Frame", screenGui)
	modal.Name = "ManualCopyModal"
	modal.AnchorPoint = Vector2.new(0.5, 0.5)
	modal.Position = UDim2.new(0.5, 0, 0.5, 0)
	modal.Size = UDim2.new(0, 300 * scaleFactor, 0, 160 * scaleFactor)
	modal.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	modal.BorderSizePixel = 0
	Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 12)
	
	local label = Instance.new("TextLabel", modal)
	label.Size = UDim2.new(1, -24 * scaleFactor, 0, 42 * scaleFactor)
	label.Position = UDim2.new(0, 12 * scaleFactor, 0, 12 * scaleFactor)
	label.BackgroundTransparency = 1
	label.Text = "Tap & hold the box to Copy"
	label.TextColor3 = Color3.fromRGB(240, 240, 240)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13 * scaleFactor
	
	local box = Instance.new("TextBox", modal)
	box.Size = UDim2.new(1, -24 * scaleFactor, 0, 56 * scaleFactor)
	box.Position = UDim2.new(0, 12 * scaleFactor, 0, 62 * scaleFactor)
	box.Text = textToShow
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.TextSize = 14 * scaleFactor
	box.TextColor3 = Color3.fromRGB(20, 20, 20)
	box.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	box.Selectable = true
	box.TextEditable = false
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	
	local closeBtn = Instance.new("TextButton", modal)
	closeBtn.Size = UDim2.new(0, 54 * scaleFactor, 0, 36 * scaleFactor)
	closeBtn.Position = UDim2.new(1, -66 * scaleFactor, 1, -46 * scaleFactor)
	closeBtn.Text = "Close"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 13 * scaleFactor
	closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
	
	closeBtn.MouseButton1Click:Connect(function()
		modal:Destroy()
	end)
end

local function createEntry(soundId, ownerName, soundName)
	entriesCount = entriesCount + 1
	
	local entryFrame = Instance.new("Frame")
	entryFrame.Size = UDim2.new(1, -8 * scaleFactor, 0, ENTRY_HEIGHT)
	entryFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	entryFrame.BorderSizePixel = 0
	entryFrame.Parent = scroll
	Instance.new("UICorner", entryFrame).CornerRadius = UDim.new(0, 10)
	
	local left = Instance.new("Frame", entryFrame)
	left.Size = UDim2.new(0.65, -8 * scaleFactor, 1, 0)
	left.Position = UDim2.new(0, 8 * scaleFactor, 0, 0)
	left.BackgroundTransparency = 1
	
	local titleLabel = Instance.new("TextLabel", left)
	titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
	titleLabel.Position = UDim2.new(0, 0, 0, 6 * scaleFactor)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = (ownerName or "Unknown") .. " — " .. (soundName or "")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextSize = 13 * scaleFactor
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	
	local idLabel = Instance.new("TextLabel", left)
	idLabel.Size = UDim2.new(1, 0, 0.5, 0)
	idLabel.Position = UDim2.new(0, 0, 0.5, -6 * scaleFactor)
	idLabel.BackgroundTransparency = 1
	idLabel.Text = tostring(soundId)
	idLabel.TextXAlignment = Enum.TextXAlignment.Left
	idLabel.TextSize = 12 * scaleFactor
	idLabel.Font = Enum.Font.Gotham
	idLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	idLabel.TextTruncate = Enum.TextTruncate.AtEnd
	
	local copyBtn = Instance.new("TextButton", entryFrame)
	copyBtn.Size = UDim2.new(0.3, -12 * scaleFactor, 0.7, 0)
	copyBtn.Position = UDim2.new(0.68, 6 * scaleFactor, 0.15, 0)
	copyBtn.Text = "Copy"
	copyBtn.Font = Enum.Font.GothamBold
	copyBtn.TextSize = 13 * scaleFactor
	copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	copyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	copyBtn.AutoButtonColor = true
	Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)
	
	copyBtn.MouseButton1Click:Connect(function()
		local numericId = tostring(soundId):match("%d+") or tostring(soundId)
		local ok = pcall(function()
			if setclipboard then
				setclipboard(numericId)
			else
				error("no_setclipboard")
			end
		end)
		if ok then
			showToast("Copied ID: " .. numericId)
		else
			showManualCopyModal(numericId)
		end
	end)
end


btnClose.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)


btnMinimize.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetSize = isMinimized and UDim2.new(0, PANEL_W, 0, 50 * scaleFactor) or UDim2.new(0, PANEL_W, 0, PANEL_H)
	
	TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
	
	buttonRow.Visible = not isMinimized
	content.Visible = not isMinimized
	btnMinimize.Text = isMinimized and "□" or "─"
end)


btnClear.MouseButton1Click:Connect(function()
	for _, v in pairs(scroll:GetChildren()) do
		if v:IsA("Frame") then v:Destroy() end
	end
	lastSeen = {}
	entriesCount = 0
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	showToast("Cleared all entries")
end)


btnCopyAll.MouseButton1Click:Connect(function()
	local ids = {}
	for _, v in pairs(scroll:GetChildren()) do
		if v:IsA("Frame") then
			for _, ch in pairs(v:GetDescendants()) do
				if ch:IsA("TextLabel") and ch.Text:match("%d+") and not ch.Name:match("Title") then
					local num = ch.Text:match("%d+")
					if num then table.insert(ids, num) end
					break
				end
			end
		end
	end
	
	if #ids == 0 then
		showToast("No IDs to copy")
		return
	end
	
	local all = table.concat(ids, "\n")
	local ok = pcall(function()
		if setclipboard then 
			setclipboard(all) 
		else 
			error("no_setclipboard") 
		end
	end)
	
	if ok then
		showToast("Copied " .. #ids .. " IDs")
	else
		showManualCopyModal(all)
	end
end)


local contentVisible = true
btnToggle.MouseButton1Click:Connect(function()
	contentVisible = not contentVisible
	scroll.Visible = contentVisible
	btnToggle.Text = contentVisible and "Hide" or "Show"
	showToast(contentVisible and "List shown" or "List hidden")
end)


local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	panel.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or 
	   input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)


local function findBoomboxOwner(sound)
	local cur = sound
	for i = 1, 6 do
		if not cur then break end
		if cur:IsA("Tool") then
			if cur.Name:lower():find("boom") then
				local char = cur.Parent
				if char and char:IsA("Model") then
					local p = Players:GetPlayerFromCharacter(char)
					if p then return p, cur end
				end
				return nil, cur
			end
		end
		cur = cur.Parent
	end
	return nil, nil
end

local function handlePotentialSound(sound)
	if not sound or not sound:IsA("Sound") then return end
	if not sound.SoundId or sound.SoundId == "" then return end
	
	local function tryAdd()
		local owner, source = findBoomboxOwner(sound)
		if not (owner or (source and tostring(source):lower():find("boom"))) then return end
		
		local ownerName = owner and owner.Name or (source and source.Name) or "Unknown"
		local key = tostring(sound.SoundId) .. "|" .. tostring(ownerName)
		local now = os.time()
		
		if lastSeen[key] and (now - lastSeen[key] < RECENT_IGNORE_SECONDS) then return end
		
		lastSeen[key] = now
		createEntry(sound.SoundId, ownerName, sound.Name)
	end
	
	if sound.IsPlaying then
		tryAdd()
	else
		local conn
		conn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
			if sound.IsPlaying then
				tryAdd()
				conn:Disconnect()
			end
		end)
	end
end


for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("Sound") and v.SoundId ~= "" then
		task.delay(0.05, function() 
			pcall(function() handlePotentialSound(v) end)
		end)
	end
end


workspace.DescendantAdded:Connect(function(desc)
	if desc:IsA("Sound") then
		task.delay(0.05, function()
			pcall(function() handlePotentialSound(desc) end)
		end)
	end
end)

showToast("Boombox Tracker Active (" .. (isMobile and "Mobile" or "PC") .. " Mode)", 2)
