

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
        Title = ' NINJA HUB ',
        Author = 'Hoàng',
        Size = UDim2.fromOffset(700, 650),
        Transparent = true,
    })
    
    -- ============================================
    -- TAB: BOSS
    -- ============================================
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
    
    -- ============================================
    -- TAB: ISLAND & DEALER
    -- ============================================
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
    
    -- ============================================
    -- TAB: CHEST & DROP
    -- ============================================
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
    
    -- ============================================
    -- TAB: OTHER (Elite, Dealer, Fruit, Event)
    -- ============================================
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
        Title = '🏴‍☠️ Auto Hop Pirate Raid',
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
    
    -- ============================================
    -- TAB: INFO
    -- ============================================
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

-- ============================================
-- KHỞI ĐỘNG UI
-- ============================================
print("📊 NINJA HUB UI Module V4.1 loaded!")
task.wait(2)
createUI()