--#region Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
--#endregion

--#region LibHelp32
local LibHelp32 = {
    Configuration = {
        DefaultItemParent = CoreGui,
        DefaultProperties = {
            TextSize = 12,
            Size = UDim2.fromOffset(100, 100),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }
    },

    TweeningStyles = {
        Default1 = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    }
}

--#region LibHelp32.Item
LibHelp32.Item = {}
LibHelp32.Item.__index = LibHelp32.Item

--#region LibHelp32.Item : Functions
local function CreateConnectable()
    local Connectable = {}

    Connectable.Connections = {}

    function Connectable:Connect(Callback)
        local Connection = {
            Callback = Callback,

            Disconnect = function(Connection)
                table.remove(self.Connections, table.find(self.Connections, Connection))
            end,
            Fire = function()
                Callback()
            end
        }

        table.insert(self.Connections, Connection)

        return Connection
    end

    return Connectable
end

local function HandleMouseEvents(Item)
    Item.MouseStates = {
        Hover = false,
        Down = false,
        Click = false
    }

    pcall(function()
        Item.Instance.MouseEnter:Connect(function()
            for _, Connection in pairs(Item.MouseHover.Connections) do
                Item.MouseStates.Hover = true

                Connection.Fire()
            end
        end)
    
        Item.Instance.MouseLeave:Connect(function()
            for _, Connection in pairs(Item.MouseNeutral.Connections) do
                Item.MouseStates.Hover = false

                if not Item.MouseStates.Down then
                Connection.Fire() 
                end
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(Input, GPE)
        if GPE then return end
        if not Input.UserInputType == Enum.UserInputType.MouseButton1 then return end

        if Item.MouseStates.Hover then
            Item.MouseStates.Down = true

            for _, Connection in pairs(Item.MouseDown.Connections) do
                Connection.Fire()
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(Input, GPE)
        if GPE then return end
        if not Input.UserInputType == Enum.UserInputType.MouseButton1 then return end

        if Item.MouseStates.Down and Item.MouseStates.Hover then
            for _, Connection in pairs(Item.MouseClick.Connections) do
                Connection.Fire()
            end
        elseif Item.MouseStates.Down then
            for _, Connection in pairs(Item.MouseNeutral.Connections) do
                Connection.Fire()
            end
        end

        Item.MouseStates.Down = false
    end)
end

local function HandleProperties(Item)    
    if not Item.Properties.Parent then
        Item.Properties.Parent = Item.Parent.Instance or LibHelp32.Configuration.DefaultItemParent
    end

    if Item.Parent.Children then
        table.insert(Item.Parent.Children, Item)
    end

    for Property, DefaultValue in pairs(LibHelp32.Configuration.DefaultProperties) do
        pcall(function()
            Item.Instance[Property] = DefaultValue
        end)
    end

    for Property, Value in pairs(Item.Properties) do
        pcall(function()
            Item.Instance[Property] = Value
        end)
    end
end
--#endregion

--#region LibHelp32.Item : Constructor
function LibHelp32.Item:Create(Class, Properties)
    local Parent = self
    local Item = setmetatable({}, LibHelp32.Item)

    Item.Instance = Instance.new(Class)
    Item.Parent = Parent.Instance and Parent or "This is a root item."
    Item.Children = {}
    Item.Properties = Properties or {}

    Item.MouseNeutral = CreateConnectable()
    Item.MouseHover = CreateConnectable()
    Item.MouseDown = CreateConnectable()
    Item.MouseClick = CreateConnectable()

    HandleProperties(Item)
    HandleMouseEvents(Item)

    return Item
end
--#endregion

--#region LibHelp32.Item : Methods
function LibHelp32.Item:Tween(Goal, Style, OnCompleted)
    if not self.Instance then return error("Attempted tween on an invalid item.") end

    Style = Style or LibHelp32.TweeningStyles.Default1
    OnCompleted = OnCompleted or function() end
    Goal = Goal or {}

    local Tween = TweenService:Create(self.Instance, Style, Goal)
    
    Tween.Completed:Connect(OnCompleted)

    Tween:Play()

    return Tween
end
--#endregion
--#endregion

return LibHelp32
--#endregion
