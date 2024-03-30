local MessagingService = game:GetService("MessagingService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Fusion = require(script.Packages.Fusion)

local New = Fusion.New
local Children = Fusion.Children

local function subscribeAsync(topic: string, callback: (request: { [string]: any }) -> ())
    MessagingService:SubscribeAsync(topic, function(message)
        local success, request = pcall(HttpService.JSONDecode, HttpService, message.Data)
        if success then
            callback(request)
        end
    end)
end

subscribeAsync("kick", function(request)
    for _, player in Players:GetPlayers() do
        if player.UserId == request.id then
            player:Kick("Player kicked!")
        end
    end
end)

subscribeAsync("announce", function(request)
    if not request.message then return end

    local gui = New("ScreenGui") {
        [Children] = New("TextLabel") {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),

            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.8,
            
            Text = request.message,
            TextSize = 50
        }
    }

    for _, player in Players:GetPlayers() do
        gui:Clone().Parent = player.PlayerGui
    end
end)