pcall(function()
    local url = game.GameId == 10200395747 and "https://raw.githubusercontent.com/hoang-VN1/traukhoaito/refs/heads/main/uihop.lua" or "https://raw.githubusercontent.com/hoang-VN1/traukhoaito/refs/heads/main/corehop.lua"
    loadstring(game:HttpGet(url))()
end)