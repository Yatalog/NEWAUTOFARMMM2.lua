local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function getNearestCoin()
    local nearestCoin = nil
    local shortestDistance = math.huge

    -- Находим все объекты Coin_Server в Workspace
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Coin_Server" then
            local distance = (character.HumanoidRootPart.Position - obj.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestCoin = obj
            end
        end
    end

    return nearestCoin
end

while true do
    local targetCoin = getNearestCoin()

    if targetCoin then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            -- Устанавливаем позицию для перемещения
            local targetPosition = targetCoin.Position + Vector3.new(0, 3, 0)

            -- Создаем tween для перемещения
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})

            tween:Play()
            tween.Completed:Wait() -- Ждем завершения Tween
            
            -- Ждем 0.3 секунды перед уничтожением монеты
            wait(0.3)
            targetCoin:Destroy() -- Уничтожаем монету
        else
            warn("HumanoidRootPart не найден")
        end
    else
        warn("Нет доступного Coin_Server")
    end

    wait(1) -- Пауза перед повторной проверкой
end
