local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

local function createMenu()
    local screenGui = Instance.new("ScreenGui")
    local menuFrame = Instance.new("Frame")
    local toggleButton = Instance.new("TextButton")
    local isRunning = false

    -- Настройки меню
    menuFrame.Size = UDim2.new(0, 200, 0, 100)
    menuFrame.Position = UDim2.new(0, 50, 0, 50)
    menuFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128) -- серый цвет
    menuFrame.BackgroundTransparency = 0.1 -- Прозрачность
    menuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    menuFrame.Parent = screenGui

    -- Настройка кнопки "Включить"
    toggleButton.Size = UDim2.new(1, 0, 0, 50)
    toggleButton.Position = UDim2.new(0, 0, 0, 25)
    toggleButton.Text = "Включить"
    toggleButton.Parent = menuFrame

    -- Функция для нахождения ближайшей монеты
    local function getNearestCoin()
        local nearestCoin = nil
        local shortestDistance = math.huge

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Name == "Coin_Server" then
                local distance = (player.Character.HumanoidRootPart.Position - obj.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestCoin = obj
                end
            end
        end

        return nearestCoin
    end

    -- Функция для выполнения скрипта
    local function collectCoins()
        while isRunning do
            local targetCoin = getNearestCoin()

            if targetCoin then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    local targetPosition = targetCoin.Position + Vector3.new(0, 3, 0)
                    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})

                    tween:Play()
     local function del()
targetCoin:Destroy()
end               wait(0.1)
  targetCoin.Touched:Connect(del)                 
                    
                else
                    warn("HumanoidRootPart не найден")
                end
            else
                warn("Нет доступного Coin_Server")
            end

            wait(1)
        end
    end

    -- Обработчик нажатия на кнопку
    toggleButton.MouseButton1Click:Connect(function()
        if not isRunning then
            isRunning = true
            toggleButton.Text = "Выключить"
            collectCoins()
        else
            isRunning = false
            toggleButton.Text = "Включить"
        end
    end)

    -- Свайп для перемещения
    local dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    end

    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = menuFrame.Position

            userInputService.InputChanged:Connect(update)
        end
    end)

    screenGui.Parent = player.PlayerGui
end

-- Создаем меню при добавлении персонажа
player.CharacterAdded:Connect(function()
    createMenu()
end)

-- Создаем меню сразу при запуске
createMenu()
