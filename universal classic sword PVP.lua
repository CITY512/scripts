if _G.universalswordscriptalreadyexecuted then return end
_G.universalswordscriptalreadyexecuted = true

local Configs = {
	AutoPlayerLock = false;
	LockRange = 16;
	AttackRange = 12;
}
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local PhantomForcesWindow = Library:NewWindow("Combat")#

local MainCheats = PhantomForcesWindow:NewSection("Main")

MainCheats:CreateToggle("Auto-Player Lock", function(value)
	Configs.AutoPlayerLock = value
end)
MainCheats:CreateSlider("Lock Range", 0, 100, 16, false, function(value)
	Configs.LockRange = value
end)
MainCheats:CreateSlider("Attack Range", 0, 100, 12, false, function(value)
	Configs.AttackRange = value
end)

local lplr = game.Players.LocalPlayer
local mouse = lplr:GetMouse()

function slash(tool)
	if mouse.Icon ~= "rbxasset://textures/GunWaitCursor.png" then
		print("slash")
		tool:Activate()
		task.wait(0.01)
		tool:Activate()
		task.wait(0.049)
	end
end
while true do
	local npchrp
	if Configs.AutoPlayerLock then
		local lplrchar = lplr.Character
		if lplrchar then
			local Tool = lplrchar:FindFirstChildOfClass("Tool")
			local hrp = lplrchar:FindFirstChild("HumanoidRootPart")
			if Tool and hrp then
				local att = Instance.new("Attachment", hrp)
				att.Position = Vector3.new(1.5, 0.5, -1.5)

				local closest

				local detectnearest = Instance.new("Part", workspace)
				detectnearest.Anchored = true
				detectnearest.Size = Vector3.new(Configs.LockRange*2,Configs.LockRange*2,Configs.LockRange*2)
				detectnearest.Shape = Enum.PartType.Ball
				detectnearest.Position = hrp.Position

				local tp = detectnearest:GetTouchingParts()
				detectnearest:Destroy()

				for _, i in ipairs(tp) do
					local char = i:FindFirstAncestorOfClass("Model")
					if char and char ~= lplrchar then
						local npchum = char:FindFirstChildOfClass("Humanoid")
						local npchrp = char:FindFirstChild("HumanoidRootPart")
						local npctorso = char:FindFirstChild("Torso")
						if npchum and npchrp and npctorso then
							local distance = (npctorso.Position - hrp.Position).Magnitude
							if (not closest or distance < closest[2]) and distance >= 0.5 then
								closest = {char,distance}
							end
						end
					end
				end

				if closest then
					local npchum = closest[1].Humanoid
					npchrp = closest[1].HumanoidRootPart
					local npctorso = closest[1].Torso
					if (npctorso.Position - hrp.Position).Magnitude <= Configs.AttackRange and npchum.Health > 0 then
						hrp.CFrame = CFrame.new(hrp.Position,hrp.Position + CFrame.new(att.WorldPosition,(npctorso.Position + npchum.MoveDirection * npchum.WalkSpeed * lplr:GetNetworkPing()) * Vector3.new(1,0,1) + att.WorldPosition * Vector3.new(0,1,0)).LookVector)
						npchrp.Size = Vector3.new(100,100,100)
						coroutine.wrap(slash)(Tool)
					end
				end
				
				att:Destroy()
			end
		end
	end
	task.wait()
	if npchrp then
		npchrp.Size = Vector3.new(2,2,1)
		npchrp = nil
	end
end
