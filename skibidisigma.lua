local whitelist = {
    "Wojt432", "KajaAja8", "Davikaof2", "FORTESYT"
}

local function isUserAuthorized(username)
    for _, whitelistedName in ipairs(whitelist) do
        if string.lower(whitelistedName) == string.lower(username) then
            return true
        end
    end
    return false
end

game.Players.PlayerAdded:Connect(function(player)
    if not isUserAuthorized(player.Name) then
        print("Access denied: " .. player.Name)
        player:Kick("You are not authorized to use this script!")
    else
        print("Access granted: " .. player.Name)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Access Granted!",
            Text = "Welcome, " .. player.Name .. "! Enjoy your time!",
            Duration = 5
        })
    end
end)
