--[[
File Name:      LibHelp.lua
Author:         deity#9160
Date:           03-27-2023

Description:    LibHelp.lua is a module developed to be used during UI library development.
                It provides many useful functions and a well-documented framework-like experience.
                Provided by library devs, for library devs.
--]]

--#region "Services"

local CoreGuiService = game:GetService("CoreGui")

--#endregion

--#region "Functions"

local function SetParent(object, parent)
    if parent.ChildObjects then table.insert(parent.ChildObjects, object) end
    object.Instance.Parent = object.Properties.Parent or object.ParentObject.Instance or CoreGuiService
end

local function ApplyProperties(object)
    pcall(function()
        for i, v in pairs(object.Properties) do
            object.Instance[i] = v
        end
    end)
end

local function ApplyDefaultProperties(properties, default)
    for i, v in pairs(default) do
        if properties[i] then default[i] = properties[i] end
    end

    return default
end

--#endregion

--#region "Main"

local LibHelp = {}

--#region "Service Class"

LibHelp.Services = setmetatable({ Cache = {} }, {
    __index = function(t, i)
        if rawget(t.Cache, i) then return rawget(t.Cache, i) end

        rawset(t.Cache, i, game:GetService(i))
        return rawget(t.Cache, i)
    end
})

--#endregion

--#region "Object Class"

LibHelp.Object = {}
LibHelp.Object.__index = LibHelp.Object

function LibHelp.Object:new(className, properties)
    local object = setmetatable({}, LibHelp.Object)
    local parent = self

    object.IsRootObject = parent == nil
    object.Properties = properties or {}
    object.ChildObjects = {}
    object.ParentObject = object.IsRootObject and nil or parent
    object.Instance = Instance.new(className)

    ApplyProperties(object)
    SetParent(object, parent)

    return object
end

--#endregion

--#endregion

-- return LibHelp

local LibHelp = LibHelp
local Object = LibHelp.Object
local Services = LibHelp.Services

print(Services.UserInputService)

local gui = Object:new("ScreenGui")

local frame = gui:new("Frame", {
    Size = UDim2.fromOffset(200, 200)
})