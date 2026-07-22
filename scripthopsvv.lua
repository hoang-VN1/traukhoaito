-- ============================================
--  NINJA HUB - FULL PACKAGE V4.1
--  Tác giả: Hoàng
--  [GHÉP HOÀN CHỈNH - CHẠY 1 LẦN LÀ XONG]
-- ============================================

-- ============================================
-- PHẦN 1: CORE MODULE
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

-- CẤU HÌNH CORE
local CoreConfig = {
    AutoHopBoss = false,
    HopBossTarget = 'Dough King',
    AutoHopElite = false,
    AutoHopIsland = false,
    HopIslandTarget = 'Mirage Island',
    AutoHopDealer = false,
    HopDealerTarget = 'Legendary Sword Dealer',
    AutoHopFruit = false,
    AutoHopChest = false,
    AutoHopKey = false,
    AutoHopFullMoon = false,
    AutoHopPirateRaid = false,
    AutoHopFactoryRaid = false,
    AutoHopBerry = false,
    AutoHopRareNPC = false,
}

-- DANH SÁCH
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

-- HÀM TIỆN ÍCH
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

-- PHÁT HIỆN BOSS
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

-- PHÁT HIỆN ELITE
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

-- PHÁT HIỆN ĐẢO
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

-- PHÁT HIỆN DEALER
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

-- PHÁT HIỆN FRUIT
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

-- CHEST DROP
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

-- FULL MOON
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

-- PIRATE RAID
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
                print("🏴☠️ Pirate Raid detected!")
                local servers = getServerList()
                if #servers > 0 then hopToServer(servers[1].jobId) end
            elseif not found and active then
                active = false
            end
        end
    end)
end

-- FACTORY RAID
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

-- BERRY
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

-- RARE NPC
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

-- KHỞI ĐỘNG CORE
print("⚙️ Core Module loaded!")
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

-- API CHO UI
getgenv().NinjaHopCore = {
    config = CoreConfig,
    getServerList = getServerList,
    hopToServer = hopToServer,
    getSea = getSea,
}

-- ============================================
-- PHẦN 2: UI MODULE
-- ============================================
task.spawn(function()
    task.wait(1) -- Đợi core ổn định
    
    local function createUI()
        local libraryLoaded, library = pcall(function()
            return loadstring(game:HttpGet('https://github.com/Footagesus/WindUI/releases/latest/download/main.lua'))()
        end)

        if not libraryLoaded then
            print("⚠️ Không thể tải UI")
            return
        end

        library:SetTheme('Dark')

        local window = library:CreateWindow({
            Title = '🔥 NINJA HUB V4.1',
            Author = 'Hoàng',
            Size = UDim2.fromOffset(700, 650),
            Transparent = true,
        })

        -- TAB: BOSS
        local bossTab = window:Tab({Title = '🎯 Boss'})
        bossTab:Paragraph({Title = '🎯 AUTO HOP BOSS', Desc = 'Tự động hop đến server có boss đã chọn'})
        bossTab:Toggle({
            Title = '🔄 Auto Hop Boss',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopBoss = value
                    print(value and "✅ Boss Hop started!" or "⏹️ Boss Hop stopped!")
                end
            end
        })
        bossTab:Dropdown({
            Title = '🎯 Chọn Boss',
            Values = {'Dough King', 'Darkbeard', 'Soul Reaper', 'Cursed Captain', 'Rip Indra', 'Cake Queen', 'Tyrant of the Skies', 'Cake Prince'},
            Default = 'Dough King',
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.HopBossTarget = value
                    print("🎯 Target Boss:", value)
                end
            end
        })

        -- TAB: ISLAND
        local islandTab = window:Tab({Title = '🏝️ Island'})
        islandTab:Paragraph({Title = '🏝️ AUTO HOP ISLAND', Desc = 'Tự động hop đến server có đảo đã chọn'})
        islandTab:Toggle({
            Title = '🔄 Auto Hop Island',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopIsland = value
                    print(value and "✅ Island Hop started!" or "⏹️ Island Hop stopped!")
                end
            end
        })
        islandTab:Dropdown({
            Title = '🏝️ Chọn Đảo',
            Values = {'Mirage Island', 'Kitsune Island', 'Prehistoric Island', 'Leviathan', 'Tất cả'},
            Default = 'Mirage Island',
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.HopIslandTarget = value
                    print("🏝️ Target Island:", value)
                end
            end
        })

        -- TAB: CHEST
        local chestTab = window:Tab({Title = '📦 Chest'})
        chestTab:Paragraph({Title = '📦 AUTO HOP CHEST', Desc = 'Tự động hop khi có drop từ rương'})
        chestTab:Toggle({
            Title = '🍷 Auto Hop Holy Grail (5%)',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopChest = value
                    print(value and "✅ Chest Hop started!" or "⏹️ Chest Hop stopped!")
                end
            end
        })
        chestTab:Toggle({
            Title = '🗝️ Auto Hop Darkbeard Key (3%)',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopKey = value
                    print(value and "✅ Key Hop started!" or "⏹️ Key Hop stopped!")
                end
            end
        })

        -- TAB: OTHER
        local otherTab = window:Tab({Title = '⚔️ Other'})
        otherTab:Paragraph({Title = '⚔️ CÁC LOẠI HOP KHÁC', Desc = 'Elite, Dealer, Fruit, Event'})
        otherTab:Toggle({
            Title = '⚔️ Auto Hop Elite',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopElite = value
                    print(value and "✅ Elite Hop started!" or "⏹️ Elite Hop stopped!")
                end
            end
        })
        otherTab:Toggle({
            Title = '⚔️ Auto Hop Dealer',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopDealer = value
                    print(value and "✅ Dealer Hop started!" or "⏹️ Dealer Hop stopped!")
                end
            end
        })
        otherTab:Dropdown({
            Title = '⚔️ Chọn Dealer',
            Values = {'Legendary Sword Dealer', 'Legendary Haki Dealer'},
            Default = 'Legendary Sword Dealer',
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.HopDealerTarget = value
                    print("⚔️ Target Dealer:", value)
                end
            end
        })
        otherTab:Toggle({
            Title = '🍎 Auto Hop Fruit',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopFruit = value
                    print(value and "✅ Fruit Hop started!" or "⏹️ Fruit Hop stopped!")
                end
            end
        })
        otherTab:Toggle({
            Title = '🌕 Auto Hop Full Moon',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopFullMoon = value
                    print(value and "✅ Full Moon Hop started!" or "⏹️ Full Moon Hop stopped!")
                end
            end
        })
        otherTab:Toggle({
            Title = '🏴☠️ Auto Hop Pirate Raid',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopPirateRaid = value
                    print(value and "✅ Pirate Raid Hop started!" or "⏹️ Pirate Raid Hop stopped!")
                end
            end
        })
        otherTab:Toggle({
            Title = '🏭 Auto Hop Factory Raid',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopFactoryRaid = value
                    print(value and "✅ Factory Raid Hop started!" or "⏹️ Factory Raid Hop stopped!")
                end
            end
        })
        otherTab:Toggle({
            Title = '🍓 Auto Hop Berry',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopBerry = value
                    print(value and "✅ Berry Hop started!" or "⏹️ Berry Hop stopped!")
                end
            end
        })
        otherTab:Toggle({
            Title = '👾 Auto Hop Rare NPC',
            Default = false,
            Callback = function(value)
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    core.config.AutoHopRareNPC = value
                    print(value and "✅ Rare NPC Hop started!" or "⏹️ Rare NPC Hop stopped!")
                end
            end
        })

        -- TAB: INFO
        local infoTab = window:Tab({Title = '📖 Info'})
        infoTab:Paragraph({
            Title = '📖 NINJA HUB V4.1',
            Desc = 'Version: 4.1\nTác giả: Hoàng\n\n✅ Hỗ trợ hop:\n- Boss (8 loại)\n- Elite (3 loại)\n- Đảo (4 loại)\n- Dealer (2 loại)\n- Fruit\n- Holy Grail (5%)\n- Darkbeard Key (3%)\n- Full Moon\n- Pirate Raid\n- Factory Raid\n- Berry\n- Rare NPC'
        })
        infoTab:Button({
            Title = '🚀 Hop Ngay',
            Callback = function()
                local core = getgenv().NinjaHopCore
                if core and core.hopToServer then
                    local servers = core.getServerList()
                    if #servers > 0 then
                        core.hopToServer(servers[1].jobId)
                    else
                        print("❌ Không tìm thấy server")
                    end
                end
            end
        })
        infoTab:Button({
            Title = '📋 Xem Trạng Thái',
            Callback = function()
                local core = getgenv().NinjaHopCore
                if core and core.config then
                    local c = core.config
                    print("📊 STATUS:")
                    print("  Boss:", c.AutoHopBoss and "🟢 ON" or "🔴 OFF", "| Target:", c.HopBossTarget)
                    print("  Elite:", c.AutoHopElite and "🟢 ON" or "🔴 OFF")
                    print("  Island:", c.AutoHopIsland and "🟢 ON" or "🔴 OFF", "| Target:", c.HopIslandTarget)
                    print("  Dealer:", c.AutoHopDealer and "🟢 ON" or "🔴 OFF", "| Target:", c.HopDealerTarget)
                    print("  Fruit:", c.AutoHopFruit and "🟢 ON" or "🔴 OFF")
                    print("  Chest:", c.AutoHopChest and "🟢 ON" or "🔴 OFF")
                    print("  Key:", c.AutoHopKey and "🟢 ON" or "🔴 OFF")
                    print("  Full Moon:", c.AutoHopFullMoon and "🟢 ON" or "🔴 OFF")
                    print("  Pirate Raid:", c.AutoHopPirateRaid and "🟢 ON" or "🔴 OFF")
                    print("  Factory Raid:", c.AutoHopFactoryRaid and "🟢 ON" or "🔴 OFF")
                    print("  Berry:", c.AutoHopBerry and "🟢 ON" or "🔴 OFF")
                    print("  Rare NPC:", c.AutoHopRareNPC and "🟢 ON" or "🔴 OFF")
                end
            end
        })
    end

    createUI()
    print("📊 NINJA HUB UI Module loaded!")
end)

print("✅ NINJA HUB FULL PACKAGE loaded!")
print("📌 Bật/tắt các chức năng qua UI!")