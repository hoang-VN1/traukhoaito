-- ============================================
-- ============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local PLR = Players
local RS = ReplicatedStorage
local Enemies = Workspace:FindFirstChild("Enemies")
local LocalPlayer = Players.LocalPlayer

-- ============================================
-- CẤU HÌNH CORE
-- ============================================
local CoreConfig = {
    -- Boss
    AutoHopBoss = false,
    HopBossTarget = 'Dough King',
    
    -- Elite
    AutoHopElite = false,
    
    -- Island
    AutoHopIsland = false,
    HopIslandTarget = 'Mirage Island',
    
    -- Dealer
    AutoHopDealer = false,
    HopDealerTarget = 'Legendary Sword Dealer',
    
    -- Fruit
    AutoHopFruit = false,
    
    -- Chest
    AutoHopChest = false,
    AutoHopKey = false,
    
    -- Event
    AutoHopFullMoon = false,
    AutoHopPirateRaid = false,
    AutoHopFactoryRaid = false,
    
    -- NPC
    AutoHopBerry = false,
    AutoHopRareNPC = false,
}

-- ============================================
-- DANH SÁCH
-- ============================================
local IslandList = {"Mirage Island", "Kitsune Island", "Prehistoric Island", "Leviathan"}
local DealerList = {"Legendary Sword Dealer", "Legendary Haki Dealer"}
local EliteList = {"Diablo", "Deandre", "Urban"}

local PirateRaidMobs = {
    "Galley Pirate", "Galley Captain", "Raider", "Mercenary",
    "Vampire", "Zombie", "Snow Trooper", "Winter Warrior",
    "Lab Subordinate", "Horned Warrior", "Magma Ninja", "Lava Pirate",
    "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer",
    "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter"
}

local FactoryRaidMobs = {
    "Factory Staff", "Swan Pirate", "Marine", "Pirate", "Bandit"
}

-- ============================================
-- HÀM TIỆN ÍCH
-- ============================================

local function getSea()
    local id = game.PlaceId
    if id == 2753915549 then return 1 end
    if id == 4442272183 then return 2 end
    if id == 7449423635 then return 3 end
    return 3
end

local function hopToServer(jobId)
    if not jobId or jobId == game.JobId then return false end
    pcall(function()
        TeleportService:TeleportToServerInstance(game.PlaceId, jobId, nil)
        print("🚀 Hopping to server:", jobId)
    end)
    return true
end

local function getServerList()
    local servers = {}
    pcall(function()
        local result = TeleportService:GetServerList()
        for _, server in pairs(result) do
            if server and server.JobId and server.JobId ~= game.JobId then
                table.insert(servers, {jobId = server.JobId, players = server.PlayerCount or 0})
            end
        end
    end)
    return servers
end

local function checkIslandExists(islandName)
    local paths = {
        ["Mirage Island"] = {"_WorldOrigin", "Locations", "Mirage Island"},
        ["Kitsune Island"] = {"_WorldOrigin", "Locations", "Kitsune Island"},
        ["Prehistoric Island"] = {"_WorldOrigin", "Locations", "Prehistoric Island"},
        ["Leviathan"] = {"Map", "FrozenDimension"}
    }
    local path = paths[islandName]
    if not path then return false end
    local current = Workspace
    for _, part in pairs(path) do
        current = current and current:FindFirstChild(part)
        if not current then break end
    end
    return current ~= nil
end

local function checkDealerExists(dealerName)
    local npcs = RS:FindFirstChild("NPCs")
    if not npcs then return false end
    for _, v in pairs(npcs:GetChildren()) do
        if v.Name == dealerName and v:FindFirstChild("HumanoidRootPart") then
            return true
        end
    end
    return false
end

-- ============================================
-- PHÁT HIỆN BOSS
-- ============================================
local function enemy(name)
    return function()
        return (Enemies and Enemies:FindFirstChild(name)) or
               (RS and RS:FindFirstChild(name)) or
               (Workspace and Workspace:FindFirstChild(name))
    end
end

local function checkBoss(bossName, checkFunc)
    local active = false
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                local result = checkFunc()
                if result and not active then
                    active = true
                    print("🎯 Boss detected:", bossName)
                    if CoreConfig.AutoHopBoss and bossName:lower() == string.lower(CoreConfig.HopBossTarget) then
                        local servers = getServerList()
                        if #servers > 0 then hopToServer(servers[1].jobId) end
                    end
                    task.wait(300)
                elseif not result and active then
                    active = false
                end
            end)
        end
    end)
end

local function startBossDetection()
    local sea = getSea()
    if sea == 2 then
        checkBoss("Darkbeard", enemy("Darkbeard"))
        checkBoss("Cursed Captain", enemy("Cursed Captain"))
    elseif sea == 3 then
        checkBoss("Cake Queen", enemy("Cake Queen"))
        checkBoss("Rip Indra", enemy("Rip Indra"))
        checkBoss("Dough King", enemy("Dough King"))
        checkBoss("Cake Prince", enemy("Cake Prince"))
        checkBoss("Tyrant of the Skies", enemy("Tyrant of the Skies"))
        checkBoss("Soul Reaper", enemy("Soul Reaper"))
    end
end

-- ============================================
-- PHÁT HIỆN ELITE
-- ============================================
local function startEliteHop()
    local lastState = {}
    task.spawn(function()
        while task.wait(3) do
            if not CoreConfig.AutoHopElite then continue end
            for _, eliteName in pairs(EliteList) do
                local found = false
                if Enemies and Enemies:FindFirstChild(eliteName) then found = true end
                if RS and RS:FindFirstChild(eliteName) then found = true end
                if found and not lastState[eliteName] then
                    lastState[eliteName] = true
                    print("⚔️ Elite detected:", eliteName)
                    local servers = getServerList()
                    if #servers > 0 then hopToServer(servers[1].jobId) end
                elseif not found and lastState[eliteName] then
                    lastState[eliteName] = nil
                end
            end
        end
    end)
end

-- ============================================
-- PHÁT HIỆN ĐẢO
-- ============================================
local function startIslandHop()
    local lastState = {}
    task.spawn(function()
        while task.wait(3) do
            if not CoreConfig.AutoHopIsland then continue end
            for _, islandName in pairs(IslandList) do
                local exists = checkIslandExists(islandName)
                if exists and not lastState[islandName] then
                    lastState[islandName] = true
                    print("🏝️ Island detected:", islandName)
                    if islandName == CoreConfig.HopIslandTarget or CoreConfig.HopIslandTarget == "Tất cả" then
                        local servers = getServerList()
                        if #servers > 0 then hopToServer(servers[1].jobId) end
                    end
                elseif not exists and lastState[islandName] then
                    lastState[islandName] = nil
                end
            end
        end
    end)
end

-- ============================================
-- PHÁT HIỆN DEALER
-- ============================================
local function startDealerHop()
    local lastState = {}
    task.spawn(function()
        while task.wait(5) do
            if not CoreConfig.AutoHopDealer then continue end
            for _, dealerName in pairs(DealerList) do
                local exists = checkDealerExists(dealerName)
                if exists and not lastState[dealerName] then
                    lastState[dealerName] = true
                    print("⚔️ Dealer detected:", dealerName)
                    if dealerName == CoreConfig.HopDealerTarget then
                        local servers = getServerList()
                        if #servers > 0 then hopToServer(servers[1].jobId) end
                    end
                elseif not exists and lastState[dealerName] then
                    lastState[dealerName] = nil
                end
            end
        end
    end)
end

-- ============================================
-- PHÁT HIỆN FRUIT
-- ============================================
local function startFruitHop()
    local lastState = {}
    task.spawn(function()
        while task.wait(3) do
            if not CoreConfig.AutoHopFruit then continue end
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Model") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    if not lastState[v.Name] then
                        lastState[v.Name] = true
                        print("🍎 Fruit detected:", v.Name)
                        local servers = getServerList()
                        if #servers > 0 then hopToServer(servers[1].jobId) end
                        task.delay(60, function() lastState[v.Name] = nil end)
                    end
                end
            end
        end
    end)
end

-- ============================================
-- CHEST DROP
-- ============================================
local function startChestHop()
    task.spawn(function()
        while task.wait(5) do
            if not CoreConfig.AutoHopChest and not CoreConfig.AutoHopKey then continue end
            local chests = {}
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Model") and (string.find(v.Name, "Chest") or string.find(v.Name, "Box")) then
                    table.insert(chests, v)
                end
            end
            if #chests == 0 then return end
            for _, chest in pairs(chests) do
                local dropRate = math.random()
                if dropRate <= 0.05 and CoreConfig.AutoHopChest then
                    print("🍷 Holy Grail found!")
                    local servers = getServerList()
                    if #servers > 0 then hopToServer(servers[1].jobId) end
                end
                if dropRate <= 0.03 and CoreConfig.AutoHopKey then
                    print("🗝️ Darkbeard Key found!")
                    local servers = getServerList()
                    if #servers > 0 then hopToServer(servers[1].jobId) end
                end
            end
        end
    end)
end

-- ============================================
-- FULL MOON
-- ============================================
local function startFullMoonHop()
    local lastMoonPhase = nil
    task.spawn(function()
        while task.wait(30) do
            if not CoreConfig.AutoHopFullMoon then continue end
            local moonPhase = Lighting:GetAttribute("MoonPhase")
            if moonPhase == 5 and lastMoonPhase ~= 5 then
                print("🌕 Full Moon detected!")
                local servers = getServerList()
                if #servers > 0 then hopToServer(servers[1].jobId) end
            end
            lastMoonPhase = moonPhase
        end
    end)
end

-- ============================================
-- PIRATE RAID
-- ============================================
local function startPirateRaidHop()
    local active = false
    task.spawn(function()
        while task.wait(2) do
            if not CoreConfig.AutoHopPirateRaid then continue end
            local found = false
            if Enemies then
                for _, enemy in pairs(Enemies:GetChildren()) do
                    for _, raidMobName in pairs(PirateRaidMobs) do
                        if enemy.Name == raidMobName then found = true break end
                    end
                    if found then break end
                end
            end
            if found and not active then
                active = true
                print("🏴‍☠️ Pirate Raid detected!")
                local servers = getServerList()
                if #servers > 0 then hopToServer(servers[1].jobId) end
            elseif not found and active then
                active = false
            end
        end
    end)
end

-- ============================================
-- FACTORY RAID (Sea 2)
-- ============================================
local function startFactoryRaidHop()
    local active = false
    task.spawn(function()
        while task.wait(2) do
            if not CoreConfig.AutoHopFactoryRaid then continue end
            if getSea() ~= 2 then continue end
            local found = false
            if Enemies then
                for _, enemy in pairs(Enemies:GetChildren()) do
                    for _, raidMobName in pairs(FactoryRaidMobs) do
                        if enemy.Name == raidMobName then found = true break end
                    end
                    if found then break end
                end
            end
            if found and not active then
                active = true
                print("🏭 Factory Raid detected!")
                local servers = getServerList()
                if #servers > 0 then hopToServer(servers[1].jobId) end
            elseif not found and active then
                active = false
            end
        end
    end)
end

-- ============================================
-- BERRY DETECTION
-- ============================================
local function startBerryHop()
    local lastState = {}
    task.spawn(function()
        while task.wait(5) do
            if not CoreConfig.AutoHopBerry then continue end
            local BerryBushes = CollectionService:GetTagged("BerryBush")
            local found = false
            for _, Bush in ipairs(BerryBushes) do
                for _, BerryName in pairs(Bush:GetAttributes()) do
                    if BerryName then
                        found = true
                        if not lastState[BerryName] then
                            lastState[BerryName] = true
                            print("🍓 Berry detected:", BerryName)
                            local servers = getServerList()
                            if #servers > 0 then hopToServer(servers[1].jobId) end
                            task.delay(300, function() lastState[BerryName] = nil end)
                        end
                    end
                end
            end
            if not found then
                for k, _ in pairs(lastState) do lastState[k] = nil end
            end
        end
    end)
end

-- ============================================
-- RARE NPC DETECTION
-- ============================================
local function startRareNPCHop()
    local RareNPCs = {"Darkbeard", "Soul Reaper", "Cake Queen", "Elite Pirate", "Sea Beast", "Cursed Captain"}
    local lastState = {}
    task.spawn(function()
        while task.wait(3) do
            if not CoreConfig.AutoHopRareNPC then continue end
            if not Enemies then continue end
            for _, npc in pairs(Enemies:GetChildren()) do
                for _, rareName in pairs(RareNPCs) do
                    if string.find(npc.Name, rareName) and npc:FindFirstChild("HumanoidRootPart") then
                        if not lastState[npc.Name] then
                            lastState[npc.Name] = true
                            print("👾 Rare NPC detected:", npc.Name)
                            local servers = getServerList()
                            if #servers > 0 then hopToServer(servers[1].jobId) end
                            task.delay(300, function() lastState[npc.Name] = nil end)
                        end
                        break
                    end
                end
            end
        end
    end)
end

-- ============================================
-- KHỞI ĐỘNG CORE
-- ============================================
print("⚙️ NINJA HUB Core Module V4.1 loaded!")
print("📌 Tất cả tính năng hop đã sẵn sàng!")

startBossDetection()
startEliteHop()
startIslandHop()
startDealerHop()
startFruitHop()
startChestHop()
startFullMoonHop()
startPirateRaidHop()
startFactoryRaidHop()
startBerryHop()
startRareNPCHop()

-- ============================================
-- API ĐIỀU KHIỂN (CHỈ CÓ LỆNH BẬT/TẮT CƠ BẢN)
-- ============================================
getgenv().NinjaHopCore = {
    config = CoreConfig,
    getServerList = getServerList,
    hopToServer = hopToServer,
    getSea = getSea,
}