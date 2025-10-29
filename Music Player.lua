local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local Accent = Color3.fromRGB(0,170,255)

-- GUI Root
local gui = Instance.new("ScreenGui")
gui.Name = "MusicPlayer"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Panel
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 460, 0, 410)
frame.Position = UDim2.new(0.5, -230, 0.5, -205)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BackgroundTransparency = 0.18
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

-- Soft Shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.Size = UDim2.new(1,22,1,22)
shadow.Position = UDim2.new(0.5,0,0.5,0)
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.5
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1

-- Title & Now Playing
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-20,0,25)
title.Position = UDim2.new(0,10,0,8)
title.BackgroundTransparency = 1
title.Text = "Apple Music"
title.TextColor3 = Color3.fromRGB(230,230,230)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local currentSongLabel = Instance.new("TextLabel", frame)
currentSongLabel.Size = UDim2.new(1,-20,0,18)
currentSongLabel.Position = UDim2.new(0,10,0,35)
currentSongLabel.BackgroundTransparency = 1
currentSongLabel.Text = "Playing: -"
currentSongLabel.TextColor3 = Color3.fromRGB(180,180,180)
currentSongLabel.Font = Enum.Font.Gotham
currentSongLabel.TextSize = 14
currentSongLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Close & Minimize
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-38,0,10)
closeBtn.BackgroundColor3 = Accent
closeBtn.Text = "×"
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0,28,0,28)
minimizeBtn.Position = UDim2.new(1,-70,0,10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
minimizeBtn.Text = "-"
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local miniBtn = Instance.new("TextButton", gui)
miniBtn.Size = UDim2.new(0,45,0,45)
miniBtn.Position = UDim2.new(1,-60,0,20)
miniBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
miniBtn.Text = "🎵"
miniBtn.TextScaled = true
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextColor3 = Accent
miniBtn.Visible = false
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,23)

-- Song Input Row
local volumeLabel = Instance.new("TextLabel", frame)
volumeLabel.Size = UDim2.new(0,70,0,20)
volumeLabel.Position = UDim2.new(0,20,0,65)
volumeLabel.BackgroundTransparency = 1
volumeLabel.Text = "Volume"
volumeLabel.Font = Enum.Font.GothamBold
volumeLabel.TextSize = 14
volumeLabel.TextColor3 = Color3.fromRGB(230,230,230)

local volumeBox = Instance.new("TextBox", frame)
volumeBox.Size = UDim2.new(0,80,0,24)
volumeBox.Position = UDim2.new(0,90,0,65)
volumeBox.Text = "0.5"
volumeBox.Font = Enum.Font.GothamBold
volumeBox.TextColor3 = Color3.fromRGB(0,0,0)
volumeBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", volumeBox).CornerRadius = UDim.new(0,7)
volumeBox.TextScaled = false
volumeBox.TextSize = 16
volumeBox.TextXAlignment = Enum.TextXAlignment.Center

local songLabel = Instance.new("TextLabel", frame)
songLabel.Size = UDim2.new(0,70,0,20)
songLabel.Position = UDim2.new(0,200,0,65)
songLabel.BackgroundTransparency = 1
songLabel.Text = "Song ID"
songLabel.Font = Enum.Font.GothamBold
songLabel.TextSize = 14
songLabel.TextColor3 = Color3.fromRGB(230,230,230)

local songBox = Instance.new("TextBox", frame)
songBox.Size = UDim2.new(0,120,0,24)
songBox.Position = UDim2.new(0,270,0,65)
songBox.Text = ""
songBox.Font = Enum.Font.GothamBold
songBox.TextSize = 14
songBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
Instance.new("UICorner", songBox).CornerRadius = UDim.new(0,7)

-- Songs Data
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
	{ Name="akcwoe", Id="94813987448722" },
	{ Name="Mimi Cucu", Id="108231437335988" },
	{ Name="DJ Kita Usahakan lagi", Id="96077163288111" },
	{ Name="Nobody But You", Id="118606374244574" },
	{ Name="Terciduk", Id="16662832435" },
	{ Name="Mente MA", Id="98337901681441" },
	{ Name="Miksue der a go", Id="112753938971674" },
	{ Name="Duka", Id="99643379703532" },
	{ Name="DOLA", Id="139590201617508" },
	{ Name="KNMH", Id="130721206402716" },
	{ Name="TANPA JUDUL", Id="128153179827416" },
	{ Name="PASO", Id="114138177515042" },
	{ Name="TANPA JUDUL", Id="88691296316236" },
	{ Name="TANPA JUDUL", Id="118390472006859" },
	{ Name="TANPA JUDUL", Id="88530410077744" },
	{ Name="DJ WG X LIKE", Id="94813987448722" },
	{ Name="DJ feel good", Id="117978799487777" },
	{ Name="DJ cuma kamu", Id="112953653423739" },
	{ Name="NASTY GIRL", Id="129988226070628" },
	{ Name="TANPA JUDUL", Id="129642760509055" },
	{ Name="TANPA JUDUL", Id="133060923832313" },
	{ Name="TANPA JUDUL", Id="90456869588958" },
	{ Name="LINKIN PARK", Id="111417042398302" },
	{ Name="TANPA JUDUL", Id="77533933904801" },
	{ Name="STEREO LOVE", Id="89610760702249" },
	{ Name="TANPA JUDUL", Id="81917604745938" },
	{ Name="DJ ATAS BAWAH", Id="122806298696636" },
	{ Name="CERE BEBEK", Id="107331882843201" },
	{ Name="TANPA JUDUL", Id="133857865643061" },
	{ Name="TANPA JUDUL", Id="16662832435" },
	{ Name="TANTEE", Id="116647235474599" },
	{ Name="Terry Zhong Feat. Conro - Play It Cool", Id="7029017448" },
	{ Name="WHAT I DIDN’T SAY", Id="117400586583464" },
	{ Name="I Believe in You", Id="139126792827321" },
	{ Name="I Will Wait", Id="109931695789778" },
	{ Name="Until We Meet Again", Id="85140042534919" },
	{ Name="I Miss Your Touch", Id="88065276344285" },
	{ Name="Chasing the Horizon", Id="75755514825803" },
	{ Name="WHILE I SLEEP", Id="88871899421346" },
	{ Name="Never Let You Go", Id="116732498632762" },
	{ Name="He Knows My Name", Id="112156011935123" },
	{ Name="Salah Dola-dola", Id="139590201617508" },
	{ Name="DJ Sayang Culik aku dong", Id="119254319180287" }
}
local sound = Instance.new("Sound", workspace)
sound.Volume = tonumber(volumeBox.Text) or 0.5
local current = 1
local loopEnabled = true

local function PlaySong(i)
	current = i
	sound.SoundId = "rbxassetid://"..songs[i].Id
	cover.Image = "rbxassetid://"..songs[i].Id
	currentSongLabel.Text = "Playing: "..songs[i].Name
	sound:Play()
end

-- Cover Art
cover = Instance.new("ImageLabel", frame)
cover.Size = UDim2.new(0,70,0,70)
cover.Position = UDim2.new(0,20,0,95)
cover.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", cover).CornerRadius = UDim.new(0,12)

-- Controls Row (Clean Center Aligned)
local function CreateBtn(txt, x)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0,44,0,38)
	b.Position = UDim2.new(0, x, 0, 115)
	b.BackgroundColor3 = Color3.fromRGB(25,25,25)
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.TextSize = 20
	b.Text = txt
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local prevBtn = CreateBtn("⏮", 100)
local playBtn = CreateBtn("▶", 150)
local pauseBtn = CreateBtn("⏸", 200)
local stopBtn = CreateBtn("■", 250)
local nextBtn = CreateBtn("⏭", 300)
local loopBtn = CreateBtn("🔁", 350)

local function UpdateLoopUI()
	loopBtn.BackgroundColor3 = loopEnabled and Accent or Color3.fromRGB(25,25,25)
	loopBtn.TextColor3 = loopEnabled and Color3.new(1,1,1) or Accent
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

sound.Ended:Connect(function()
	current = loopEnabled and (current % #songs) + 1 or current + 1
	if current > #songs then return end
	PlaySong(current)
end)

-- Progress Bar
local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(0,400,0,5)
bar.Position = UDim2.new(0,30,0,155)
bar.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,2)

local prog = Instance.new("Frame", bar)
prog.Size = UDim2.new(0,0,1,0)
prog.BackgroundColor3 = Accent
Instance.new("UICorner", prog).CornerRadius = UDim.new(0,2)

RunService.RenderStepped:Connect(function()
	if sound.TimeLength>0 then
		prog.Size = UDim2.new(sound.TimePosition/sound.TimeLength,0,1,0)
	end
end)

-- Playlist
local listFrame = Instance.new("Frame", frame)
listFrame.Size = UDim2.new(0,420,0,175)
listFrame.Position = UDim2.new(0,20,0,180)
listFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,12)

local scroll = Instance.new("ScrollingFrame", listFrame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1

local function RefreshList()
	scroll:ClearAllChildren()
	scroll.CanvasSize = UDim2.new(0,0,#songs*32)

	for i,v in ipairs(songs) do
		local item = Instance.new("TextButton", scroll)
		item.Size = UDim2.new(1,-10,0,30)
		item.Position = UDim2.new(0,5,0,(i-1)*32)
		item.BackgroundColor3 = Color3.fromRGB(28,28,28)
		item.Text = v.Name
		item.Font = Enum.Font.Gotham
		item.TextSize = 14
		item.TextColor3 = Color3.fromRGB(235,235,235)
		Instance.new("UICorner", item).CornerRadius = UDim.new(0,8)

		item.MouseButton1Click:Connect(function()
			PlaySong(i)
		end)
	end
end

RefreshList()

-- Song Add
songBox.FocusLost:Connect(function(e)
	if e and tonumber(songBox.Text) then
		table.insert(songs,{Name=GetSongName(songBox.Text),Id=songBox.Text})
		RefreshList()
		songBox.Text = ""
	end
end)

volumeBox.FocusLost:Connect(function()
	local v = tonumber(volumeBox.Text)
	if v then sound.Volume = math.clamp(v,0,1) end
end)

-- Minimize / Restore
minimizeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniBtn.Visible = true
end)
miniBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	miniBtn.Visible = false
end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
	sound:Stop()
	gui:Destroy()
	blur.Enabled = false
end)

-- DRAG PANEL
local drag, start, startPos
frame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = true
		start = i.Position
		startPos = frame.Position
	end
end)
frame.InputChanged:Connect(function(i)
	if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
		frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+(i.Position-start).X,startPos.Y.Scale,startPos.Y.Offset+(i.Position-start).Y)
	end
end)
frame.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
