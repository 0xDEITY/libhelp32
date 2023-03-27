# libhelp
A lua module designed to help with UI library development inside of ROBLOX.

---

## Usage
Load the LibHelp module using loadstring and HttpGet:
```lua
local LibHelp = loadstring(game:HttpGet("https://raw.githubusercontent.com/0xDEITY/libhelp/main/LibHelp.lua", true))
print(LibHelp.Version)
```

Then, you can use the two classes provided by the module, `Object` and `Services`:
```lua
local LibHelp = loadstring(game:HttpGet("https://raw.githubusercontent.com/0xDEITY/libhelp/main/LibHelp.lua", true))

local Object = LibHelp.Object
local Services = LibHelp.Services
```

---

## Documentation

### LibHelp.Object Class
With this class, you can create object easily while everything stays connected in the background.

#### Methods
```lua
LibHelp.Object:new(className, properties): LibHelp.Object
```
Since this method returns itself, it is chainable and thus results in a parent-child structure.

#### Fields
```lua
LibHelp.Object = {
    IsRootObject,   -- Whether the object is a root object (parented to LibHelp.Configuration.RootParent) or has a parent.
    Properties,     -- The properties of this object and it's instance.
    ChildObjects,   -- The child objects.
    ParentObject,   -- The parent object.
    Instance        -- The actual ROBLOX instance.
}
```

#### Examples
```lua
local GUI = Object:new("ScreenGui") -- Root object - automatically parented to CoreGuiService, configurable under LibHelp.Configuration.RootParent
local Frame = GUI:new("Frame", { Size = UDim2.fromOffset(400, 300) }) -- Automatically parented to the GUI object.

-- Since each object is a table, you can add your own functions to them, or overwrite the old ones:
function Frame:Resize(x, y)
    -- Do something fancy...
    Frame.Instance.Size = UDim2.fromOffset(x, y)
end
```


More to be added here.
