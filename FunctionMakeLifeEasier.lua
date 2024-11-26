local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to send a message to the server via RemoteEvent
function chatMessage(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end
