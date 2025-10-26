local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-- GUI MAIN FRAME
local gui = Instance.new("ScreenGui")
gui.Name = "MusicPlayer"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 460, 0, 400)
frame.Position = UDim2.new(0.5, -230, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Apple Music Player"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235,235,235)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local currentSongLabel = Instance.new("TextLabel")
currentSongLabel.Size = UDim2.new(1, -20, 0, 25)
currentSongLabel.Position = UDim2.new(0, 10, 0, 40)
currentSongLabel.BackgroundTransparency = 1
currentSongLabel.Font = Enum.Font.GothamBold
currentSongLabel.TextSize = 14
currentSongLabel.TextColor3 = Color3.fromRGB(160,160,160)
currentSongLabel.TextXAlignment = Enum.TextXAlignment.Left
currentSongLabel.Text = "Playing: "
currentSongLabel.Parent = frame

-- CLOSE & MINIMIZE
local AppleRed = Color3.fromRGB(255,59,48)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-40,0,10)
closeBtn.BackgroundColor3 = AppleRed
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,5)

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0,50,0,50)
miniBtn.Position = UDim2.new(0.9,-25,0.9,-25)
miniBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
miniBtn.Text = "🎵"
miniBtn.TextColor3 = AppleRed
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextScaled = true
miniBtn.Visible = false
miniBtn.Parent = gui
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,25)

local isMinimized = false

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy() -- ADDED (destroy instead minimize)
end)

miniBtn.MouseButton1Click:Connect(function()
	if isMinimized then
		isMinimized = false
		frame.Visible = true
		TweenService:Create(frame,TweenInfo.new(0.4,Enum.EasingStyle.Quad),{Position=UDim2.new(0.5,-230,0.5,-200)}):Play()
		task.wait(0.4)
		miniBtn.Visible = false
	end
end)

-- INPUT UI
local volumeLabel = Instance.new("TextLabel")
volumeLabel.Size = UDim2.new(0, 60, 0, 20)
volumeLabel.Position = UDim2.new(0, 20, 0, 70)
volumeLabel.BackgroundTransparency = 1
volumeLabel.Text = "Volume"
volumeLabel.Font = Enum.Font.GothamBold
volumeLabel.TextSize = 14
volumeLabel.TextColor3 = Color3.fromRGB(235,235,235)
volumeLabel.Parent = frame

local volumeBox = Instance.new("TextBox")
volumeBox.Size = UDim2.new(0, 80, 0, 20)
volumeBox.Position = UDim2.new(0, 90, 0, 70)
volumeBox.Text = "0.5"
volumeBox.Font = Enum.Font.GothamBold
volumeBox.TextColor3 = Color3.fromRGB(0,0,0)
volumeBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
volumeBox.TextScaled = true
volumeBox.Parent = frame
Instance.new("UICorner", volumeBox).CornerRadius = UDim.new(0, 8)

local songLabel = Instance.new("TextLabel")
songLabel.Size = UDim2.new(0, 60, 0, 20)
songLabel.Position = UDim2.new(0, 200, 0, 70)
songLabel.BackgroundTransparency = 1
songLabel.Text = "Song ID"
songLabel.Font = Enum.Font.GothamBold
songLabel.TextSize = 14
songLabel.TextColor3 = Color3.fromRGB(235,235,235)
songLabel.Parent = frame

local songBox = Instance.new("TextBox")
songBox.Size = UDim2.new(0, 120, 0, 20)
songBox.Position = UDim2.new(0, 270, 0, 70)
songBox.Font = Enum.Font.GothamBold
songBox.TextScaled = true
songBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
songBox.TextColor3 = Color3.fromRGB(0,0,0)
songBox.Parent = frame
Instance.new("UICorner", songBox).CornerRadius = UDim.new(0, 8)

-- Songs Table
local songs = {
	{ Name="Tabola bale", Id="104207837699519" },
	{ Name="Doo Wop", Id="111539034076305" },
	{ Name="I Want To Know What Love IS", Id="129192080836175" },
	{ Name="Let You Go", Id="107390983423942" },
	{ Name="When Days Are Dark", Id="124073860453774" },
	{ Name="Jamilah Itu Bukan Anunya Aisyah", Id="116255319981650" },
	{ Name="Pong Pong Enak", Id="90471492509215" },
	{ Name="Funkot Stesu Stesu Stelan Suka", Id="105935548669522" },
	{ Name="Cikini", Id="122665842844850" },
	{ Name="ABG TUA", Id="139825186779265" },
	{ Name="MAIMUNA JAMILA LAMBADA", Id="101351410845508" },
	{ Name="Hari itu gajian - Lembur", Id="132479837761371" },
	{ Name="Sudah", Id="85010781923163" },
	{ Name="Paradise Fall", Id="1837879082" },
	{ Name="DJ Sayang Culik aku dong", Id="119254319180287" }
}

local sound = Instance.new("Sound")
sound.Parent = workspace
sound.Volume = tonumber(volumeBox.Text) or 0.5

local function GetSongName(id)
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(id)
	end)
	return ok and info.Name or ("Song "..id)
end

local current = 1
local loopEnabled = true -- ADDED

-- PLAYLIST UI
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1,-20,0,180)
listFrame.Position = UDim2.new(0,10,0,180)
listFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
listFrame.Parent = frame
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,12)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.Parent = listFrame

local function PlaySong(i)
	current = i
	sound.SoundId = "rbxassetid://"..songs[i].Id
	sound:Play()
	currentSongLabel.Text = "Playing: "..songs[i].Name
end

local function RefreshList()
	scroll:ClearAllChildren()
	scroll.CanvasSize = UDim2.new(0,0,#songs*40)

	for i,song in ipairs(songs) do
		local item = Instance.new("TextButton")
		item.Size = UDim2.new(1,-10,0,35)
		item.Position = UDim2.new(0,5,0,(i-1)*40)
		item.Text = ""
		item.BackgroundColor3 = Color3.fromRGB(40,40,40)
		item.Parent = scroll
		Instance.new("UICorner", item).CornerRadius = UDim.new(0,6)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,-20,1,0)
		label.Position = UDim2.new(0,10,0,0)
		label.BackgroundTransparency = 1
		label.Text = song.Name
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextColor3 = Color3.fromRGB(235,235,235)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = item

		item.MouseEnter:Connect(function()
			TweenService:Create(item,TweenInfo.new(0.2,Enum.EasingStyle.Sine),{BackgroundColor3=Color3.fromRGB(60,60,60)}):Play()
		end)
		item.MouseLeave:Connect(function()
			TweenService:Create(item,TweenInfo.new(0.2,Enum.EasingStyle.Sine),{BackgroundColor3=Color3.fromRGB(40,40,40)}):Play()
		end)

		item.MouseButton1Click:Connect(function()
			PlaySong(i)
		end)
	end
end

RefreshList()
PlaySong(1)

-- CONTROLS
local function createButton(text, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 60, 0, 40)
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = AppleRed
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	b.Parent = frame

	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2,Enum.EasingStyle.Sine),{BackgroundColor3=Color3.fromRGB(55,55,55)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2,Enum.EasingStyle.Sine),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play()
	end)

	return b
end

local playBtn = createButton("▶", UDim2.new(0, 20, 0, 100))
local pauseBtn = createButton("⏸", UDim2.new(0, 90, 0, 100))
local stopBtn = createButton("■", UDim2.new(0, 160, 0, 100))
local nextBtn = createButton("⏭", UDim2.new(0, 230, 0, 100))
local prevBtn = createButton("⏮", UDim2.new(0, 300, 0, 100))

-- LOOP BUTTON (ADDED)
local loopBtn = createButton("🔁", UDim2.new(0, 370, 0, 100))

local function UpdateLoopUI()
	if loopEnabled then
		loopBtn.BackgroundColor3 = AppleRed
		loopBtn.TextColor3 = Color3.fromRGB(255,255,255)
	else
		loopBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		loopBtn.TextColor3 = AppleRed
	end
end
UpdateLoopUI()

loopBtn.MouseButton1Click:Connect(function()
	loopEnabled = not loopEnabled
	UpdateLoopUI()
end)

playBtn.MouseButton1Click:Connect(function() if not sound.IsPlaying then sound:Play() end end)
pauseBtn.MouseButton1Click:Connect(function() if sound.IsPlaying then sound:Pause() end end)
stopBtn.MouseButton1Click:Connect(function() sound:Stop() end)
nextBtn.MouseButton1Click:Connect(function() PlaySong((current % #songs) + 1) end)
prevBtn.MouseButton1Click:Connect(function() PlaySong((current - 2) % #songs + 1) end)

-- PROGRESS BAR
local progressBarMain = Instance.new("Frame")
progressBarMain.Size = UDim2.new(0,400,0,5)
progressBarMain.Position=UDim2.new(0,30,0,150)
progressBarMain.BackgroundColor3 = Color3.fromRGB(35,35,35)
progressBarMain.Parent = frame
Instance.new("UICorner",progressBarMain).CornerRadius = UDim.new(0,2)

local progress = Instance.new("Frame")
progress.Size = UDim2.new(0,0,1,0)
progress.BackgroundColor3 = AppleRed
progress.Parent = progressBarMain
Instance.new("UICorner",progress).CornerRadius = UDim.new(0,2)

RunService.RenderStepped:Connect(function()
	if sound.TimeLength>0 then
		progress.Size=UDim2.new(sound.TimePosition/sound.TimeLength,0,1,0)
	end
end)

-- ADD SONG
songBox.FocusLost:Connect(function(enter)
	if enter and tonumber(songBox.Text) then
		local id = songBox.Text
		local name = GetSongName(id)
		table.insert(songs, {Name=name, Id=id})
		RefreshList()
		songBox.Text = ""
	end
end)

-- VOLUME
volumeBox.FocusLost:Connect(function(enter)
	if enter then
		local vol = tonumber(volumeBox.Text)
		if vol then
			sound.Volume = math.clamp(vol,0,1)
		end
	end
end)

-- DRAG MAIN
local dragToggle, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
end)
frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = false
	end
end)

-- DRAG MINI BUTTON
local dragMini, dragStartMini, startPosMini
miniBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragMini = true
		dragStartMini = input.Position
		startPosMini = miniBtn.Position
	end
end)
miniBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragMini then
		local delta = input.Position - dragStartMini
		miniBtn.Position = UDim2.new(startPosMini.X.Scale,startPosMini.X.Offset+delta.X,startPosMini.Y.Scale,startPosMini.Y.Offset+delta.Y)
	end
end)
miniBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragMini = false
	end
end)

-- AUTO NEXT SONG (ADDED)
sound.Ended:Connect(function()
	if loopEnabled then
		current = current + 1
		if current > #songs then
			current = 1
		end
	else
		if current >= #songs then return end
		current = current + 1
	end
	PlaySong(current)
end)
