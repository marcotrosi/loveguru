--[[
Author: Marco Trosi
--]]

-- overview <<<
--[[
love.load -> load fonts, sounds, mouse pointers and set painting styles like smoothness, line width, etc. ...
love.run  -> does not exist yet, maybe I could bring here the FPS down to 12 or so ?
love.quit -> does not exist yet, either cleanup if necessary or writing program status to file

love.update -> update all data needed for drawing
love.draw   -> draw objects
love.resize -> calculate all position and dimension data

callback              | image  | button | toggle | textbox | textfield | menu | value | list | bar | slider | knob | graph | context | tab | grid | scroller |
-------------------   | ------ | ------ | ------ | ------- | --------- | ---- | ----- | ---- | --- | ------ | ---- | ----- | ------- | --- | ---- | -------- |
love.directorydropped |   -    |   -    |   -    |    O    |     O     |  -   |   -   |  O   |  -  |   -    |  -   |   -   |   -     |  -  |  -   |    -     |
love.filedropped      |   O    |   -    |   -    |    O    |     O     |  -   |   -   |  O   |  -  |   -    |  -   |   -   |   -     |  -  |  -   |    -     |
love.keypressed       |   O    |   O    |   O    |    O    |     O     |  O   |   O   |  O   |  O  |   O    |  O   |   O   |   O     |  O  |  -   |    O     |
love.keyreleased   ?? |        |        |        |         |           |      |       |      |     |        |      |       |         |     |      |          |
love.mousemoved       |   O    |   o    |   o    |    O    |     O     |  O   |   O   |  O   |  O  |   O    |  O   |   O   |   -     |  O  |  O   |    O     | small o for DevMode only
love.mousepressed     |   O    |   O    |   O    |    O    |     O     |  O   |   -   |  O   |  O  |   O    |  O   |   O   |   O     |  O  |      |    O     |
love.mousereleased ?? |        |        |        |         |           |      |       |      |     |        |      |       |         |     |      |          |
love.textinput        |   -    |   -    |   -    |    O    |     O     |  -   |   O   |  O   |  O  |   O    |  O   |   -   |   -     |  -  |  -   |    -     |
love.wheelmoved       |   O    |   -    |   -    |    O    |     O     |  O   |   O   |  O   |  O  |   O    |  O   |   O   |   O     |  -  |  -   |    O     |

-- ignored for now <<<
love.errhand
love.focus
love.lowmemory
love.mousefocus
love.touchmoved
love.touchpressed
love.touchreleased
love.textedited
love.threaderror
love.visible
-- >>>

TODO
- clean-up the color table
- add sound e.g. on mouse clicks
--]]
-- >>>

local WinWidth, WinHeight, CfgFlags = love.window.getMode()

local guru    = {}

-- colors <<<
local color =
{
   -- http://chir.ag/projects/name-that-color/#EFE571

   white       = { 0xFF , 0xFF , 0xFF , 255 },  --  #FFFFFF
   black       = { 0x00 , 0x00 , 0x00 , 255 },  --  #000000

   grey0       = { 0x19 , 0x19 , 0x19 , 255 },  --  #191919
   grey1       = { 0x32 , 0x32 , 0x32 , 255 },  --  #323232
   grey2       = { 0x4B , 0x4B , 0x4B , 255 },  --  #4B4B4B
   grey3       = { 0x64 , 0x64 , 0x64 , 255 },  --  #646464
   grey4       = { 0x7F , 0x7F , 0x7F , 255 },  --  #7F7F7F
   grey5       = { 0x96 , 0x96 , 0x96 , 255 },  --  #969696
   grey6       = { 0xAF , 0xAF , 0xAF , 255 },  --  #AFAFAF
   grey7       = { 0xC8 , 0xC8 , 0xC8 , 255 },  --  #C8C8C8
   grey8       = { 0xE1 , 0xE1 , 0xE1 , 255 },  --  #E1E1E1
   grey9       = { 0xF0 , 0xF0 , 0xF0 , 255 },  --  #F0F0F0

   red         = { 0xFF , 0x00 , 0x00 , 255 },  --  #FF0000
   green       = { 0x00 , 0xFF , 0x00 , 255 },  --  #00FF00
   blue        = { 0x00 , 0x00 , 0xFF , 255 },  --  #0000FF

   yellow      = { 0xFF , 0xFF , 0x00 , 255 },  --  #FFFF00
   cyan        = { 0x00 , 0xFF , 0xFF , 255 },  --  #00FFFF
   magenta     = { 0xFF , 0x00 , 0xFF , 255 },  --  #FF00FF

   darkblue    = { 0x00 , 0x00 , 0x7F , 255 },  --  #00007F
   darkgreen   = { 0x00 , 0x7F , 0x00 , 255 },  --  #007F00
   dardred     = { 0x7F , 0x00 , 0x00 , 255 },  --  #7F0000

   darkyellow  = { 0x7F , 0x7F , 0x00 , 255 },  --  #7F7F00
   darkcyan    = { 0x00 , 0x7F , 0x7F , 255 },  --  #007F7F
   darkmagenta = { 0x7F , 0x00 , 0x7F , 255 },  --  #7F007F

   dolly          = { 0xFF , 0xFF , 0x7F , 255 },  --  #FFFF7F
   chartreuse     = { 0x7F , 0xFF , 0x00 , 255 },  --  #7FFF00
   springgreen    = { 0x00 , 0xFF , 0x7F , 255 },  --  #00FF7F
   mintgreen      = { 0x7F , 0xFF , 0x7F , 255 },  --  #7FFF7F
   aquamarine     = { 0x7F , 0xFF , 0xFF , 255 },  --  #7FFFFF
   azureradiance  = { 0x00 , 0x7F , 0xFF , 255 },  --  #007FFF
   malibu         = { 0x7F , 0x7F , 0xFF , 255 },  --  #7F7FFF
   electricviolet = { 0x7F , 0x00 , 0xFF , 255 },  --  #7F00FF
   blushpink      = { 0xFF , 0x7F , 0xFF , 255 },  --  #FF7FFF
   rose           = { 0xFF , 0x00 , 0x7F , 255 },  --  #FF007F
   vividtangerine = { 0xFF , 0x7F , 0x7F , 255 },  --  #FF7F7F
   flushorange    = { 0xFF , 0x7F , 0x00 , 255 },  --  #FF7F00

   skin        = { 0xF4 , 0xAA , 0x8D , 255 },  --  #F4AA8D
   rosa        = { 0xF7 , 0xCB , 0xDE , 255 },  --  #F7CBDE
   lilac       = { 0xF6 , 0xE3 , 0xFD , 255 },  --  #F6E3FD
   purple      = { 0xCC , 0x5F , 0xB2 , 255 },  --  #CC5FB2
   affair      = { 0x7D , 0x4C , 0x95 , 255 },  --  #7D4C95
   lime        = { 0xD9 , 0xDF , 0xD0 , 255 },  --  #D9DF0D
   lemon       = { 0xFB , 0xE5 , 0x2B , 255 },  --  #FBE52B
   orange      = { 0xFF , 0xAA , 0xB0 , 255 },  --  #FFAA0B
   grapefruit  = { 0xF8 , 0x59 , 0x40 , 255 },  --  #F85904
   wine        = { 0xAA , 0xE0 , 0xE0 , 255 },  --  #AA0E0E
   bordeaux    = { 0x61 , 0x21 , 0x3C , 255 },  --  #61213C
   brown       = { 0x84 , 0x49 , 0xC0 , 255 },  --  #84490C
   butter      = { 0xFB , 0xFA , 0xC5 , 255 },  --  #FBFAC5
   creme       = { 0xF9 , 0xF3 , 0xE5 , 255 },  --  #F9F3E5
   turquoise   = { 0x22 , 0xCB , 0x11 , 255 },  --  #22CB11
   teal        = { 0x50 , 0xAD , 0x83 , 255 },  --  #50AD83
   olive       = { 0x71 , 0x86 , 0x33 , 255 },  --  #718633
   mint        = { 0xE4 , 0xF7 , 0xD7 , 255 },  --  #E4F7D7
   ice         = { 0xDA , 0xF7 , 0xFE , 255 },  --  #DAF7FE
   steel       = { 0x79 , 0xAF , 0xD4 , 255 },  --  #79AFD4
   navy        = { 0x32 , 0x4B , 0x99 , 255 },  --  #324B99

   c1          = { 0xEF , 0x8C , 0xBD , 255 },  --  #EF8CBD
   c2          = { 0xE2 , 0x5E , 0x93 , 255 },  --  #E25E93
   c3          = { 0xEA , 0x2F , 0x70 , 255 },  --  #EA2F70
   c4          = { 0xFC , 0xD4 , 0xBB , 255 },  --  #FCD4BB
   c5          = { 0xC8 , 0x7D , 0x46 , 255 },  --  #C87D00
   c6          = { 0x76 , 0x4C , 0x22 , 255 },  --  #764C00
   c7          = { 0xBF , 0xDD , 0x96 , 255 },  --  #BFDD96
   c8          = { 0x8E , 0xC6 , 0x00 , 255 },  --  #8EC600
   c9          = { 0x29 , 0xB7 , 0x81 , 255 },  --  #29B781
   c10         = { 0xDC , 0xEF , 0xFF , 255 },  --  #DCEFFF
   c11         = { 0x6C , 0xBD , 0xE8 , 255 },  --  #6CBDE8
   c12         = { 0x80 , 0x75 , 0xC2 , 255 },  --  #0875C2
   c13         = { 0x26 , 0x36 , 0x97 , 255 },  --  #263697
   c14         = { 0xEC , 0xF1 , 0xF3 , 255 },  --  #ECF1F3
   c15         = { 0xCA , 0xDC , 0xED , 255 },  --  #CADCED
   c16         = { 0x80 , 0x9F , 0xBB , 255 },  --  #809FBB
   c17         = { 0x59 , 0x7E , 0x9D , 255 },  --  #597E9D
   c18         = { 0x15 , 0x44 , 0x52 , 255 },  --  #154400

   lovered     = { 0xE6 , 0x5A , 0xA5 , 255 },  --  #E65AA5
   lovegreen1  = { 0xC3 , 0xDC , 0x96 , 255 },  --  #C3DC96
   lovegreen2  = { 0x8D , 0xC5 , 0x40 , 255 },  --  #8DC540
   loveblue1   = { 0xE6 , 0xF0 , 0xFA , 255 },  --  #E6F0FA
   loveblue2   = { 0x78 , 0xB4 , 0xE1 , 255 },  --  #78B4E1
   loveblue3   = { 0x19 , 0x7D , 0xBE , 255 },  --  #197DBE

--#6CBEE4
--#D6EEFC
--#D65B5F
--#1C373E
--#2098D4
--#F0B5BF
--#7A96A1
--#3A567A
--#B2C6A0

   transparent   = { 0x00 , 0x00 , 0x00 , 0x00 },
}
-- >>>

-- themes <<<
local Themes_t =
{
   ["love"] = -- <<<
   {
      ["BackgroundColor"]     = color.loveblue1,

      ["FrameColorActive"]    = color.affair,
      -- ["FrameColorInactive"]  = color.transparent,
      -- ["FrameColorSelected"]  = color.orange,
      -- ["FrameColorMouseOver"] = color.transparent,
      -- ["FrameColorDisabled"]  = color.transparent,

      ["ToolTipBackColor"]       = color.butter,
      ["ToolTipFontColor"]       = color.black,

      ["Button"] =
      {
         ["CornerRadius"]  = nil,

         ["ImageFilename"] = nil,

         ["ImageScaling"]  = nil,
 
         ["Font"]          = nil,

         ["FontSize"]      = nil,

         ["State"] =
         {
            ["Normal"] =
            {
               ["FontColor"]   = color.white,
               -- ["ButtonColor"] = color.white,
               ["ButtonColor"] = color.loveblue2,
            },

            ["Hover"] =
            {
               ["FontColor"]   = color.white,
               -- ["ButtonColor"] = color.white,
               ["ButtonColor"] = color.lovegreen2,
            },

            ["Down"] =
            {
               ["FontColor"]   = color.white,
               -- ["ButtonColor"] = color.white,
               ["ButtonColor"] = color.lovered,
            },

            ["Disabled"] =
            {
               ["FontColor"]   = color.grey6,
               -- ["ButtonColor"] = color.white,
               ["ButtonColor"] = color.grey8,
            },

         },
      },
   }, -- >>>
}
-- >>>

guru.Color   = color
guru.DevMode = false

local Fonts_t = {}
local FontSize_n
if CfgFlags.highdpi then
   FontSize_n  = 32
   LineWidth_n = 2
else
   FontSize_n  = 16
   LineWidth_n = 1
end
local Theme_s                = "love"
local MouseOver              = false

local ToolTipTime            = 1
local DrawToolTip            = false
local ToolTipCntD            = ToolTipTime
local ToolTipCntDOn          = false
local ToolTipBackColor       = color.butter
local ToolTipFontColor       = color.black
local ToolTipResetMouseSpeed = 3

local ActiveObject
local MouseOverObject

local DevErrorTxt = "LOVEGURU DEV ERROR"

function activateObjAtPos(self,x,y,key,val) -- <<<

   local x = x - self.OffsetX
   local y = y - self.OffsetY
   local Index

   for i,v in ipairs(self.Objects) do

      local ConditionsFulfilled = false

      --[[
      1. Obj:activateObjAtPos(100,100)                  -- activate Obj at Pos if the position matches
      2. Obj:activateObjAtPos(100,100,keypressed)       -- activate Obj at Pos if the position matches AND if Obj has a value named key
      3. Obj:activateObjAtPos(100,100,isDisabled,false) -- activate Obj at Pos if the position matches AND if Obj has a value named key AND its value is val
      --]]

      if (key==nil) and (val==nil) then -- <<<
         if (x >= v.TopLeftX) and (y >= v.TopLeftY) and (x <= v.BottomRightX) and (y <= v.BottomRightY) then
            ConditionsFulfilled = true
         end
      end -- >>>

      if (key~=nil) and (val==nil) then -- <<<
         if (x >= v.TopLeftX) and (y >= v.TopLeftY) and (x <= v.BottomRightX) and (y <= v.BottomRightY) and (v[key]) then
            ConditionsFulfilled = true
         end
      end -- >>>

      if (key~=nil) and (val~=nil) then -- <<<
         if (x >= v.TopLeftX) and (y >= v.TopLeftY) and (x <= v.BottomRightX) and (y <= v.BottomRightY) and (v[key]) and (v[key]==val) then
            ConditionsFulfilled = true
         end
      end -- >>>

      if ConditionsFulfilled then
         if not Index then
            Index = i
         end
         if v.Layer > self.Objects[Index].Layer then
            Index = i
         end
      end
   end

   if Index then
      if self.Objects[Index].Type == "container" then
         self.Objects[Index]:activateObjAtPos(x,y,key,val)
      else
         self.Objects[Index]:activate()
      end
   else
      self:activate()
   end
end -- >>>

local Backdrop = -- <<<
{
   Type     = "container",
   Objects  = {},
   IsActive = true,
   Layer    = 0,
   OffsetX  = 0,
   OffsetY  = 0,

   activate = function(self) -- <<<
      ActiveObject:deactivate()
      ActiveObject = self
      self.IsActive = true
   end, -- >>>

   deactivate = function(self) -- <<<
      self.IsActive = false
   end, -- >>>

   activateObjAtPos = activateObjAtPos,
}
ActiveObject    = Backdrop -- initialize ActiveObject with Backdrop
MouseOverObject = Backdrop -- initialize MouseOverObject with Backdrop
-- >>>

function activate(self) -- <<<
   if not self.IsActive then -- run activation actions only on state change
      ActiveObject:deactivate()
      ActiveObject = self
      self.IsActive = true
      self.Layer    = 2
      if self.onActivation then
         self:onActivation()
      end
   end
end -- >>>

function deactivate(self) -- <<<
   if self.IsActive then -- run activation actions only on state change
      ActiveObject = Backdrop
      self.IsActive = false
      self.Layer    = 1
      if self.onDeactivation then
         self:onDeactivation()
      end
   end
end -- >>>

function move(self, dx, dy) -- <<<

   if type(self.X) == "number" then
      self.X = self.X + dx
   end
   if type(self.X) == "string" then
      self.X = toXPercentage(self.TopLeftX + dx)
   end

   if type(self.Y) == "number" then
      self.Y = self.Y + dy
   end
   if type(self.Y) == "string" then
      self.Y = toYPercentage(self.TopLeftY + dy)
   end

   self:resize()
end -- >>>

-- class container <<<
local Container =
{
   Type         = "container",
   Objects      = {},
   Parent       = Backdrop,
   Layer        = 1,

   IsActive     = false,
   IsEditable   = false,

   Width        = 0,
   Height       = 0,
   TopLeftX     = 0,
   TopLeftY     = 0,
   BottomRightX = Width,
   BottomRightY = Height,
   OffsetX      = 0,
   OffsetY      = 0,

   activate         = activate,      -- assign global   activate function
   deactivate       = deactivate,    -- assign global deactivate function
   activateObjAtPos = activateObjAtPos,

   insertElement = function(self, e) -- <<<

      -- remove element from old parent
      table.remove(e.Parent.Objects, e.Index)

      -- repair index
      for i,v in ipairs(e.Parent.Objects) do
         e.Parent.Objects[i].Index = i
      end

      -- insert object to objects table of new parent
      table.insert(self.Objects, e)

      -- update parent and index
      e.Parent = self
      e.Index  = #self.Objects

      -- update object
      self:resize()

   end -- >>>
}

local Container_mt = {__index = Container}
-- >>>

-- class object <<<
local Object  = -- base table with attributes valid for all objects
{
   Parent       = Backdrop,
   Layer        = 1, -- all objects start on layer 1, the backdrop is on layer 0 and the active object is on layer 2

   IsDisabled   = false,
   IsInvisible  = false,
   IsMouseOver  = false,
   IsActive     = false,
   IsEditable   = false, -- IsChangeable, IsModfiable - NOT FOR BUTTONS, TOGGLES, GRIDS & SCROLLERS
   IsMoving     = false,
   --IsMoveable   = false,
   --IsResizeable = false,
   --IsSelectable = false,
   --IsSelected   = false,

   Width        = 0,
   Height       = 0,
   TopLeftX     = 0,
   TopLeftY     = 0,
   BottomRightX = 0,
   BottomRightY = 0,

   activate     = activate,      -- assign global   activate function
   deactivate   = deactivate,    -- assign global deactivate function
   move         = move,          -- assign global       move function
}

local Object_mt = {__index = Object} -- object metatable
-- >>>


function printTable(t, f) -- <<<

   local function printTableHelper(obj, cnt)

      local cnt = cnt or 0

      if type(obj) == "table" then

         io.write("\n", string.rep("\t", cnt), "{\n")
         cnt = cnt + 1

         for k,v in pairs(obj) do

            if type(k) == "string" then
               io.write(string.rep("\t",cnt), '["'..k..'"]', ' = ')
            end

            if type(k) == "number" then
               io.write(string.rep("\t",cnt), "["..k.."]", " = ")
            end

            printTableHelper(v, cnt)
            io.write(",\n")
         end

         cnt = cnt-1
         io.write(string.rep("\t", cnt), "}")

      elseif type(obj) == "string" then
         io.write(string.format("%q", obj))

      elseif type(obj) == "function" then
         --io.write(string.format("%q", string.dump(obj)))
         --io.write(string.format("%q", tostring(obj)))
         io.write("nil")

      else
         io.write(tostring(obj))
      end 
   end

   if f == nil then
      printTableHelper(t)
   else
      io.output(f)
      io.write("return")
      printTableHelper(t)
      io.output(io.stdout)
   end
end -- >>>

function getFinderSelection() -- <<<
   local d=love.keyboard.isDown
   if not (d("lshift") or d("rshift")) and not (d("lalt") or d("ralt")) and (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then

      local TmpFile = os.tmpname()
      local t = {}
      local r = {}

      os.execute([[osascript -e 'set S to (selection of application "Finder") as text' > ]] .. TmpFile)

      for line in io.lines(TmpFile) do
         table.insert(t,line)
      end

      os.remove(TmpFile)

      local s = table.concat(t)
      local DiskName = string.match(s, ".-:")
      if DiskName then
         s = string.gsub(s, DiskName, " /")
         s = string.gsub(s, ":", "/")
         s = string.gsub(s, " /", "::/") .. ":"
         for m in string.gmatch(s, ":(/.-):") do table.insert(r, m) end
      end

      return r
   end
end -- >>>


function math.round(n,p) -- <<<
   local p = p or 1 -- to full integers by default
   return math.floor((n / p) + 0.5) * p
end -- >>>

function math.isEqualFloat(a,b) -- <<<
   return ( math.abs(a - b) < 5e-16 )
end -- >>>

function math.keepWithinBounds(v,min,max) -- <<<

   if v > max then
      return max
   end

   if v < min then
      return min
   end

   return v
end -- >>>


function string.count(s,c) -- <<<
   local _, count = string.gsub(s,c,'')
   return count
end -- >>>


function toXPixel(v) -- <<<
   if type(v) == "nil" then
      return 0
   end
   if type(v) == "number" then
      return math.round(v)
   end
   if type(v) == "string" then
      return tonumber(v)*love.graphics.getWidth()
   end
end -- >>>

function toYPixel(v) -- <<<
   if type(v) == "nil" then
      return 0
   end
   if type(v) == "number" then
      return math.round(v)
   end
   if type(v) == "string" then
      return math.round(tonumber(v)*love.graphics.getHeight())
   end
end -- >>>

function toXPercentage(v) -- <<<
   return tostring(v/love.graphics.getWidth())
end -- >>>

function toYPercentage(v) -- <<<
   return tostring(v/love.graphics.getHeight())
end -- >>>

function setStencil(f) -- <<<
   love.graphics.setColor(255,255,255,255)
   love.graphics.stencil(f, "replace", 1)
   love.graphics.setStencilTest("greater", 0)
end -- >>>

function unsetStencil() -- <<<
   love.graphics.setStencilTest()
end -- >>>

function centerText(Width,Height,Font,Text) -- <<<
   return (Width-Font:getWidth(Text or ""))/2, (Height-Font:getHeight())/2
end -- >>>

function drawCoordinates(x, y, idx) -- <<<

   local XMouse = love.mouse.getX()
   local YMouse = love.mouse.getY()

   local x = x or XMouse
   local y = y or YMouse

   local Text = "X: ".. x .. "\nY: " .. y
   local Font = Fonts_t.sans

   local Width = Font:getWidth(Text)    +20
   local Height=(Font:getHeight(Text)*2)+20

   local XPos = XMouse
   local YPos = YMouse

   local w,h = love.graphics.getDimensions()

   if XPos >= w/2 then
      XPos = XPos-10-Width
   else
      XPos = XPos+10
   end

   if YPos >= h/2 then
      YPos = YPos-10-Height
   else
      YPos = YPos+10
   end

   local XMatch = false
   local YMatch = false

   Font:setLineHeight(1)
   love.graphics.setColor(255, 0, 0, 100)

   for i,v in ipairs(Backdrop.Objects) do

      if (idx ~= i) then -- don't match object with itself
         --if math.isEqualFloat(v.TopLeftX , x) or math.isEqualFloat(v.BottomRightX , x) then
         if ((v.TopLeftX == x) or (v.BottomRightX == x)) then
            XMatch = true
         end

         --if math.isEqualFloat(v.TopLeftY , y) or math.isEqualFloat(v.BottomRightY , y) then
         if ((v.TopLeftY == y) or (v.BottomRightY == y)) then
            YMatch = true
         end
      end
   end

   if XMatch then
      love.graphics.line(x,0,x,h)
   end

   if YMatch then
      love.graphics.line(0,y,w,y)
   end

   love.graphics.setColor(0, 0, 0, 150)
   love.graphics.rectangle( "fill", XPos, YPos, Width, Height, 15, 15, 20)

   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.setFont(Font)
   love.graphics.print(Text, XPos+10, YPos+10)

end -- >>>

function drawToolTip(s) -- <<<

   -- TODO calculate ones and store info in self
   local Margin = 12
   local Offset = 14
   local Font   = Fonts_t.tool
   local w,h    = love.graphics.getDimensions()
   local XPos   = love.mouse.getX()
   local YPos   = love.mouse.getY()
   local Width  = Font:getWidth(s)+(2*Margin)

   Font:setLineHeight(1)
   local Height = Font:getAscent() - Font:getDescent() + string.count(s, "\n")*(Font:getHeight() * Font:getLineHeight()) + (2*Margin)

   if XPos >= w/2 then
      XPos = XPos-Margin-Width-Offset
   else
      XPos = XPos+Margin+Offset
   end

   if YPos >= h/2 then
      YPos = YPos-Margin-Height
   else
      YPos = YPos+Margin
   end

   love.graphics.setColor(ToolTipBackColor)
   love.graphics.rectangle( "fill", XPos, YPos, Width, Height)
   love.graphics.setColor(ToolTipFontColor)
   love.graphics.rectangle( "line", XPos, YPos, Width, Height)
   love.graphics.setFont(Font)
   love.graphics.print(s, XPos+Margin, YPos+Margin)
end -- >>>

function drawScrollerX(x,y,w,h) -- <<<
   local ScrollPosY = self.TopLeftY + ((self.Offset / self.MaxOffset) * self.MaxOffsetCorrected)
   love.graphics.setColor(color.grey9)
   love.graphics.rectangle("fill", self.BottomRightX-self.ScrollerWidth, self.TopLeftY, self.ScrollerWidth, self.Height)
   love.graphics.setColor(color.grey8)
   drawScrollerHandleX(self.BottomRightX-self.ScrollerWidth, ScrollPosY, self.ScrollerWidth, self.ScrollerHeight)
end -- >>>

function drawScrollerY(x,y,w,h) -- <<<
   local ScrollPosY = self.TopLeftY + ((self.Offset / self.MaxOffset) * self.MaxOffsetCorrected)
   love.graphics.setColor(color.grey9)
   love.graphics.rectangle("fill", self.BottomRightX-self.ScrollerWidth, self.TopLeftY, self.ScrollerWidth, self.Height)
   love.graphics.setColor(color.grey8)
   drawScrollerHandle(self.BottomRightX-self.ScrollerWidth, ScrollPosY, self.ScrollerWidth, self.ScrollerHeight)
end -- >>>

function drawScrollerHandleX(x,y,w,h) -- <<<
   local Radius = w/2
   love.graphics.arc( "fill"      , x+Radius , y+Radius  , Radius , 1.0*math.pi , 2.0*math.pi , 20)
   love.graphics.arc( "fill"      , x+Radius , y+h-Radius, Radius , 2.0*math.pi , 3.0*math.pi , 20)
   love.graphics.rectangle("fill" , x        , y+Radius  , w      , h-(2*Radius))
end -- >>>

function drawScrollerHandleY(x,y,w,h) -- <<<
   local Radius = w/2
   love.graphics.arc( "fill"      , x+Radius , y+Radius  , Radius , 1.0*math.pi , 2.0*math.pi , 20)
   love.graphics.arc( "fill"      , x+Radius , y+h-Radius, Radius , 2.0*math.pi , 3.0*math.pi , 20)
   love.graphics.rectangle("fill" , x        , y+Radius  , w      , h-(2*Radius))
end -- >>>

function resetToolTip() -- <<<
   DrawToolTip   = false
   ToolTipCntD   = ToolTipTime
   ToolTipCntDOn = false
end -- >>>


function guru.activateNextObject() -- <<<

   if ActiveObject == Backdrop then
      if #ActiveObject.Objects ~= 0 then
         ActiveObject.Objects[1]:activate()
      end
      return
   end

   -- do nothing if object table contains no objects
   --if #ActiveObject.Parent.Objects == 0 then
      --return
   --end

   -- store index of active object
   local IndexOfActiveObj = ActiveObject.Index

   -- deactivate current active object
   --ActiveObject:deactivate()

   -- calculate next active object
   local IndexOfNextObj = IndexOfActiveObj + 1
   if IndexOfNextObj > #ActiveObject.Parent.Objects then
      IndexOfNextObj = 1
   end
   --print(IndexOfActiveObj, IndexOfNextObj, #ActiveObject.Parent.Objects, ActiveObject.Parent)

   ActiveObject.Parent.Objects[IndexOfNextObj]:activate()
end -- >>>

function guru.activatePrevObject() -- <<<

   if ActiveObject == Backdrop then
      if #ActiveObject.Objects ~= 0 then
         ActiveObject.Objects[#ActiveObject.Objects]:activate()
      end
      return
   end

   -- do nothing if object table contains no objects
   --if #ActiveObject.Parent.Objects == 0 then
      --return
   --end

   -- store index of active object
   local IndexOfActiveObj = ActiveObject.Index

   -- deactivate current active object
   --ActiveObject:deactivate()

   -- calculate previous active object
   local IndexOfPrevObj = IndexOfActiveObj - 1

   if IndexOfPrevObj == 0 then
      IndexOfPrevObj = #ActiveObject.Parent.Objects
   end
   --print(IndexOfActiveObj, IndexOfPrevObj, #ActiveObject.Parent.Objects, ActiveObject.Parent)

   ActiveObject.Parent.Objects[IndexOfPrevObj]:activate()
end -- >>>

function guru.saveState() -- <<<

   local Directory_s = love.filesystem.getSaveDirectory() .. "/"
   local File_s      = love.filesystem.getIdentity() .. ".state"
   local success     = love.filesystem.createDirectory( "." )

   if not success then
       love.window.showMessageBox( "ERROR", 'could not create output directory "' .. Directory_s .. '"', "error", true )
       return
   --else
       --love.window.showMessageBox( "INFO", 'could create output directory "' .. Directory_s .. '"', "info", true )
   end

   local State_t = {}
   for i,v in ipairs(Backdrop.Objects) do
      if v.Name then
         --table.insert(State_t, Backdrop.Objects[i])
         State_t[v.Name] = Backdrop.Objects[i]
      end
   end
   printTable(State_t, Directory_s .. File_s)
end -- >>>

function guru.loadState() -- <<<
   local Directory_s = love.filesystem.getSaveDirectory() .. "/"
   local StateFile_s = love.filesystem.getIdentity() .. ".state"
   local State_t

   if love.filesystem.isFile( StateFile_s ) then
      love.window.showMessageBox( "INFO", 'trying to load state file', "info", true )
      State_t = dofile( Directory_s .. StateFile_s )
   else
      love.window.showMessageBox( "INFO", 'is not a file '..StateFile_s, "info", true )
   end

   for i,v in ipairs(Backdrop.Objects) do
      if v.Name and State_t[v.Name] then
         for k,w in pairs(State_t[v.Name]) do
            if Backdrop.Objects[i][k] and (Backdrop.Objects[i][k] ~= w) and (type(w) ~= "table") then
               Backdrop.Objects[i][k] = w
            end
         end
      end
   end
end -- >>>


function guru.load(cfg) -- <<<

   Config_t   = cfg or {}
   Theme_s    = Config_t.theme    or Theme_s
   FontSize_n = Config_t.fontsize or FontSize_n

   -- general <<<
   love.keyboard.setKeyRepeat(true)
   love.graphics.setLineWidth(LineWidth_n)
   love.graphics.setLineStyle("smooth")
   love.graphics.setLineJoin("miter")
   love.graphics.setBackgroundColor(Themes_t[Theme_s].BackgroundColor)
   -- >>>

   -- fonts <<<
   Fonts_t.tool  = love.graphics.newFont("fonts/arial.ttf"         , FontSize_n-6)
   Fonts_t.sans  = love.graphics.newFont("fonts/arial.ttf"         , FontSize_n)
-- Fonts_t.serif = love.graphics.newFont("fonts/timesnewroman.ttf" , FontSize_n)
   Fonts_t.mono  = love.graphics.newFont("fonts/couriernew.ttf"    , FontSize_n)
-- Fonts_t.digit = love.graphics.newFont("fonts/digital.ttf"       , FontSize_n)
-- Fonts_t.hand  = love.graphics.newFont("fonts/hand.ttf"          , FontSize_n)
   -- >>>

   -- graphics <<<
   -- >>>

   -- sounds <<<
   --guru.sound = {}
   --guru.sound.click = love.audio.newSource("sounds/click.wav", "static")
   --guru.sound.fail  =
   --guru.sound.info  =
   --guru.sound.open  =
   --guru.sound.close =
   -- >>>

   -- mouse cursors <<<
   guru.cursor = {}
   guru.cursor.arrow     = love.mouse.getSystemCursor("arrow")     -- An arrow pointer.
   --guru.cursor.crosshair = love.mouse.getSystemCursor("crosshair") -- Crosshair symbol.
   guru.cursor.hand      = love.mouse.getSystemCursor("hand")      -- Hand symbol.
   --guru.cursor.ibeam     = love.mouse.getSystemCursor("ibeam")     -- An I-beam, normally used when mousing over editable or selectable text.
   --guru.cursor.no        = love.mouse.getSystemCursor("no")        -- Slashed circle or crossbones.
   --guru.cursor.sizeall   = love.mouse.getSystemCursor("sizeall")   -- Four-pointed arrow pointing up, down, left, and right.
   --guru.cursor.sizenesw  = love.mouse.getSystemCursor("sizenesw")  -- Double arrow pointing to the top-right and bottom-left.
   --guru.cursor.sizens    = love.mouse.getSystemCursor("sizens")    -- Double arrow pointing up and down.
   --guru.cursor.sizenwse  = love.mouse.getSystemCursor("sizenwse")  -- Double arrow pointing to the top-left and bottom-right.
   --guru.cursor.sizewe    = love.mouse.getSystemCursor("sizewe")    -- Double arrow pointing left and right.
   --guru.cursor.wait      = love.mouse.getSystemCursor("wait")      -- Wait graphic.
   --guru.cursor.waitarrow = love.mouse.getSystemCursor("waitarrow") -- Small wait cursor with an arrow pointer.
   -- >>>

   -- print info <<<
   if guru.DevMode then
      print("love.filesystem.getAppdataDirectory",love.filesystem.getAppdataDirectory())
      print("love.filesystem.getDirectoryItems",love.filesystem.getDirectoryItems("."))
      print("love.filesystem.getIdentity",love.filesystem.getIdentity())
      print("love.filesystem.getLastModified",love.filesystem.getLastModified("fonts/arial.ttf"))
      print("love.filesystem.getRealDirectory",love.filesystem.getRealDirectory("fonts/arial.ttf"))
      print("love.filesystem.getRequirePath",love.filesystem.getRequirePath())
      print("love.filesystem.getSaveDirectory",love.filesystem.getSaveDirectory())
      print("love.filesystem.getSize",love.filesystem.getSize("fonts/arial.ttf"))
      print("love.filesystem.getSource",love.filesystem.getSource())
      print("love.filesystem.getSourceBaseDirectory",love.filesystem.getSourceBaseDirectory())
      print("love.filesystem.getUserDirectory",love.filesystem.getUserDirectory())
      print("love.filesystem.getWorkingDirectory",love.filesystem.getWorkingDirectory())
   end
   -- >>>

   collectgarbage()
end -- >>>

function guru.draw() -- <<<

   -- TODO this will fail if an active object is actually hidden in the scroller

   local ActiveObjIdx

   for i,v in ipairs(Backdrop.Objects) do

      if v.IsActive then
         ActiveObjIdx = i
      else
         Backdrop.Objects[i]:draw()
      end

      if ActiveObjIdx then
         Backdrop.Objects[ActiveObjIdx]:draw()
      end
         
   end

   if guru.DevMode and love.keyboard.isDown('lshift') then
      drawCoordinates()
   end

   if (not guru.DevMode) and DrawToolTip and MouseOverObject.ToolTip then
      drawToolTip(MouseOverObject.ToolTip)
   end

end -- >>>

function guru.update(dt) -- <<<

   -- TODO update objects in containers
   for i,v in ipairs(Backdrop.Objects) do
      if Backdrop.Objects[i].update then
         Backdrop.Objects[i]:update(dt)
      end
   end

   if MouseOver and ToolTipCntDOn then
      ToolTipCntD = ToolTipCntD - dt
      if ToolTipCntD < 0 then
         ToolTipCntD = 0
         DrawToolTip = true
      end
   end
end -- >>>

function guru.resize(w, h) -- <<<

   for i,o in ipairs(Backdrop.Objects) do

      if Backdrop.Objects[i].resize then
         Backdrop.Objects[i]:resize()
      end
         
   end

end -- >>>

function guru.keypressed(key, sc, isrepeat) -- <<<

   resetToolTip()

   if (key ~= "numlock") and (key ~= "capslock") and (key ~= "scrolllock") and (key ~= "rshift") and (key ~= "lshift") and (key ~= "rctrl") and (key ~= "lctrl") and (key ~= "ralt") and (key ~= "lalt") and (key ~= "rgui") and (key ~= "lgui") and (key ~= "mode") then
      love.mouse.setVisible(false)
      MouseOver = false
   end

   if key == "tab" then
      if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
         guru.activatePrevObject()
      else
         guru.activateNextObject()
      end
   end

   if ActiveObject.keypressed then
      ActiveObject:keypressed(key,sc,isrepeat)
   end

end -- >>>

function guru.mousepressed(x, y, button, istouch) -- <<<

   resetToolTip()

   Backdrop:activateObjAtPos(x,y)

   if ActiveObject.mousepressed then
      ActiveObject:mousepressed(x,y,button,istouch)
   end
end -- >>>

function guru.mousereleased(x, y, button, istouch) -- <<<

   if ActiveObject.mousereleased then
      ActiveObject:mousereleased(x,y,button,istouch)
   end

end -- >>>

function guru.mousemoved(x, y, dx, dy, istouch) -- <<<

   love.mouse.setVisible(true)
   ToolTipCntDOn = true

   local NoMouseOver = true
   for i,v in ipairs(Backdrop.Objects) do
      if (x >= v.TopLeftX) and (y >= v.TopLeftY) and (x <= v.BottomRightX) and (y <= v.BottomRightY) then
         Backdrop.Objects[i].IsMouseOver = true
         NoMouseOver = false
         MouseOverObject = Backdrop.Objects[i] -- TODO current layer is not considered
      else
         Backdrop.Objects[i].IsMouseOver = false
      end
   end

   if (((dx)^2+(dy)^2)^0.5) > ToolTipResetMouseSpeed then
      ToolTipCntD = ToolTipTime -- reset tooltip countdown
      DrawToolTip = false
   end

   if NoMouseOver then
      love.mouse.setCursor()
      MouseOverObject = Backdrop
   end
   MouseOver = not NoMouseOver

   if ActiveObject.mousemoved then
      ActiveObject:mousemoved(x,y,dx,dy,istouch)
   end

end -- >>>

function guru.wheelmoved(dx, dy) -- <<<

   love.mouse.setVisible(true)

   --if not ActiveObject.wheelmoved then
   --   local xpos,ypos = love.mouse.getPosition()
   --   Backdrop:activateObjAtPos(xpos, ypos, "wheelmoved")
   --end

   if ActiveObject.wheelmoved then
      ActiveObject:wheelmoved(dx,dy)
   end

end -- >>>

function guru.textinput(text) -- <<<

   if ActiveObject.textinput then
      ActiveObject:textinput(text)
   end

end -- >>>

function guru.directorydropped(path) -- <<<

   Backdrop:activateObjAtPos(love.mouse.getPosition())

   if ActiveObject.directorydropped then
      ActiveObject:directorydropped(path)
   end
end -- >>>

function guru.filedropped(file) -- <<<

   Backdrop:activateObjAtPos(love.mouse.getPosition())

   if ActiveObject.filedropped then
      ActiveObject:filedropped(file)
   end
end -- >>>


-- btn alias button <<<
local btn = {} -- button table

-- table button keys <<<
btn.Keys =
{
   ["space"]  = function(t) if t.Function then t.Function() end end,
   ["return"] = function(t) if t.Function then t.Function() end end,
}
-- >>>

btn.draw = function(self) -- <<<

   -- draw button -- <<<
   love.graphics.setColor(self.CurrState.ButtonColor)

   if self.CurrState.ButtonImage then
      love.graphics.draw(self.CurrState.ButtonImage, self.TopLeftX, self.TopLeftY, 0, self.Width/self.ButtonImageWidth, self.Height/self.ButtonImageHeight)
   else
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.CornerRadius, self.CornerRadius)
   end
   -- >>>

   -- draw text <<<
   if self.Text then
      love.graphics.setFont(self.Font)
      setStencil(self.mask)
      love.graphics.setColor(self.CurrState.FontColor)
      love.graphics.print(self.Text, self.TopLeftX+self.TextPosX, self.TopLeftY+self.TextPosY)
      unsetStencil()
   end
   -- >>>

   -- draw frame <<<
   if self.IsActive then
      love.graphics.setColor(Themes_t[Theme_s].FrameColorActive)
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.CornerRadius, self.CornerRadius)
   end
   -- >>>

   if self.IsMoving then
      drawCoordinates(self.TopLeftX, self.TopLeftY, self.Index)
   end

end -- >>>

btn.keypressed = function(self, key, sc, isrepeat) -- <<<
   if btn.Keys[key] and (not isrepeat) then
      btn.Keys[key](self)
   end
end -- >>>

btn.mousepressed = function(self, x, y, button, istouch) -- <<<

   if button == 1 then -- left button <<<
      self.ButtonDown = true -- TODO differentiate between gui button down and mouse button down; one naming either ButtonDown or IsButtonDown
   end -- >>>

   if button == 2 then -- right button <<<
   end -- >>>

   if button == 3 then -- middle button <<<
      if guru.DevMode == true then
         self.IsMoving = true
      end
   end -- >>>

end -- >>>

btn.mousereleased = function(self, x, y, button, istouch) -- <<<

   -- left button <<<
   --if button == 1 and self.Function and (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) then
   if button == 1 then
      if self.Function and self.ButtonDown and self.IsMouseOver and (not self.IsDisabled) and (not self.IsInvisible) then
         self.Function()
      end
      self.ButtonDown = false
   end -- >>>

   -- right button <<<
   if button == 2 then
   end -- >>>

   -- middle button <<<
   if button == 3 then
      self.IsMoving = false
   end -- >>>

   self:deactivate()
end -- >>>

btn.mousemoved = function(self, x, y, dx, dy) -- <<<
   if self.IsMoving then
      self:move(dx,dy)
   end
end -- >>>

btn.update = function(self, dt) -- <<<

   --[[
   IsDisabled | IsMouseOver | IsButtonDown | NextState
       0            0              0       |  normal
       0            -              1       |  down
       0            1              0       |  hover
       1            -              -       |  disabled
   --]]

   -- next state logic
   if (not self.IsDisabled) and (not self.IsMouseOver) and (not self.ButtonDown) then
      self.NextState = self.State.Normal
   elseif (not self.IsDisabled) and (self.ButtonDown) then
      self.NextState = self.State.Down
   elseif (not self.IsDisabled) and (self.IsMouseOver) and (not self.ButtonDown) then
      self.NextState = self.State.Hover
   elseif (self.IsDisabled) then
      self.NextState = self.State.Disabled
   end

   -- transition action
   if self.NextState ~= self.CurrState then

      self.CurrState = self.NextState

      if (not self.IsDisabled) and (self.IsMouseOver or self.ButtonDown) then
         love.mouse.setCursor(guru.cursor.hand)
      -- else -- TODO decide whether to keep this here or the global cursor reset or both
      --    love.mouse.setCursor()
      end
   end

end -- >>>

btn.resize = function(self) -- <<<

   --[[
   ┌──────────────────────────┬───────┬──────┬───────────────────┬───────────────────┐
   │                          │ ~T&~I │ T&~I │ ~T&I              │ T&I               │
   ├──────────────────────────┼───────┼──────┼───────────────────┼───────────────────┤
   │ Type                     │  gen  │ gen  │ image             │ extendable image  │
   ├──────────────────────────┼───────┼──────┼───────────────────┼───────────────────┤
   │ Scaling                  │  n.a. │ n.a. │ down recommended, │ extend middle col │
   │                          │       │      │ keep aspect ratio │ and row           │
   ├──────────────────────────┼───────┼──────┼───────────────────┼───────────────────┤
   │                          │       │      │                   │                   │
   ├──────────────────────────┼───────┼──────┼───────────────────┼───────────────────┤
   │                          │       │      │                   │                   │
   ├──────────────────────────┼───────┼──────┼───────────────────┼───────────────────┤
   │                          │       │      │                   │                   │
   └──────────────────────────┴───────┴──────┴───────────────────┴───────────────────┘
   --]]

   if (not self.Text) and (not self.State.Normal.ButtonImageData) then -- no text, no image <<<
      if self.W == nil then self.W = math.ceil(self.FontSize * 1.5) end
      if self.H == nil then self.H = math.ceil(self.FontSize * 1.5) end
   end -- >>>

   if (self.Text) and (not self.State.Normal.ButtonImageData) then -- text, no image <<<
      if self.W == nil then self.W = self.TextWidth  + self.FontSize              end
      if self.H == nil then self.H = self.TextHeight + math.ceil(self.FontSize/2) end
   end -- >>>

   if self.State.Normal.ButtonImageData then -- with image <<<

      if self.Text then
         if self.W == nil then self.W = self.TextWidth  + (self.FontSize*2) end
         if self.H == nil then self.H = self.TextHeight +  self.FontSize    end
      end

      if self.ImageScaling == "none" then -- <<<

         for i,v in pairs(self.State) do
            self.State[i].ButtonImage = love.graphics.newImage(self.State[i].ButtonImageData) -- convert all image data to images
         end

         self.ButtonImageWidth, self.ButtonImageHeight = self.State.Normal.ButtonImageData:getDimensions()

         self.W = self.ButtonImageWidth
         self.H = self.ButtonImageHeight
      end -- >>>

      if self.ImageScaling == "extend" then
         extendButtonImages(self)
      end

      if self.ImageScaling == "stretch" then -- <<<

         for i,v in pairs(self.State) do
            self.State[i].ButtonImage = love.graphics.newImage(self.State[i].ButtonImageData) -- convert all image data to images
         end

         -- get dimensions from Normal state image
         self.ButtonImageWidth, self.ButtonImageHeight = self.State.Normal.ButtonImageData:getDimensions()

         if (not self.W) and (not self.H) then
            self.W = self.ButtonImageWidth
            self.H = self.ButtonImageHeight
         end

         if (self.W) and (not self.H) then
            self.H = self.W*(self.ButtonImageHeight/self.ButtonImageWidth)
         end

         if (not self.W) and (self.H) then
            self.W = self.H*(self.ButtonImageWidth/self.ButtonImageHeight)
         end
      end -- >>>
   end -- >>>

   self.Height = toYPixel(self.H or math.floor(self.FontSize * 1.5))

   if not self.CornerRadius then
      if self.State.Normal.ButtonImageData then
         self.CornerRadius = 0
      else
         self.CornerRadius = self.Height/2
      end
   end

   self.Width        = toXPixel(self.W or (self.Font:getWidth(self.Text)+(2*self.CornerRadius)))
   self.TopLeftX     = toXPixel(self.X)
   self.TopLeftY     = toYPixel(self.Y)
   self.BottomRightX = self.TopLeftX + self.Width
   self.BottomRightY = self.TopLeftY + self.Height

   self.TextPosX, self.TextPosY = centerText(self.Width, self.Height, self.Font, self.Text)

end -- >>>

-- button image functions <<<

function splitImageData(data) -- <<<

   local w = data:getWidth()
   local h = data:getHeight()/4

   local NormalData   = love.image.newImageData(w, h)
   local HoverData    = love.image.newImageData(w, h)
   local DownData     = love.image.newImageData(w, h)
   local DisabledData = love.image.newImageData(w, h)

--    ImageData:paste(src , dx, dy, sx, sy     , sw, sh)
     NormalData:paste(data,  0,  0,  0, 0      ,  w,  h)
      HoverData:paste(data,  0,  0,  0, 0+h    ,  w,  h)
       DownData:paste(data,  0,  0,  0, 0+(2*h),  w,  h)
   DisabledData:paste(data,  0,  0,  0, 0+(3*h),  w,  h)

   return NormalData, HoverData, DownData, DisabledData

end -- >>>

function createButtonImageData(self) -- <<<

   local Status, ButtonImage = pcall(love.graphics.newImage, self.ImageFilename)

   if not Status then
      love.window.showMessageBox( "GURU DEV ERROR", 'loading image "' .. self.ImageFilename .. '" failed', "error", true)
      return
   end

   local ButtonImageData = ButtonImage:getData()

   if self.ImageFilename:match("_4in1") then

      if (ButtonImageData:getHeight() % 4) ~= 0 then
         love.window.showMessageBox( "GURU DEV ERROR", 'the 4in1 button image "' .. self.ImageFilename .. '" can not be divided into 4 equally sized pieces', "error", true)
         return
      end

      self.State.Normal.ButtonImageData, self.State.Hover.ButtonImageData, self.State.Down.ButtonImageData, self.State.Disabled.ButtonImageData = splitImageData(ButtonImageData)

   else
      self.State.Normal.ButtonImageData   = ButtonImageData
      self.State.Hover.ButtonImageData    = ButtonImageData
      self.State.Down.ButtonImageData     = ButtonImageData
      self.State.Disabled.ButtonImageData = ButtonImageData
   end

end -- >>>

function extendButtonImages(self) -- <<<

   --[[ extending the middle rows and columns

   012345    012345678
   odd  --+--  -> --+++++--
   even --+--- -> --++++---
   in which Col/Row do I start to extend and when do I have to stop?
   odd  (5+1)/2 = 3   -> 3-1   -> floor(2)  =2
   even (6+1)/2 = 3.5 -> 3.5-1 -> floor(2.5)=2

   --]]

   for i,v in pairs(self.State) do

      local FromRow  = 0
      local FromCol  = 0

      local ImageDataWidth, ImageDataHeight = self.State[i].ButtonImageData:getDimensions()

      local StartCol = math.floor((( ImageDataWidth  + 1)/2) - 1)
      local StartRow = math.floor((( ImageDataHeight + 1)/2) - 1)

      local EndCol   = StartCol + (self.W - ImageDataWidth ) - 1
      local EndRow   = StartRow + (self.H - ImageDataHeight) - 1

      local ButtonImageData = love.image.newImageData(self.W, self.H)

      -- print(string.format("SC = %d, EC = %d, SR = %d, ER = %d, W = %d, H = %d, IW = %d, IH = %d",StartCol,EndCol,StartRow,EndRow,self.W,self.H,self.BtnImgW,self.BtnImgH))

      for ToRow=0,self.H-1 do

         for ToCol=0,self.W-1 do

            -- print(string.format("TR = %d, TC = %d, FR = %d, FC = %d",ToRow, ToCol, FromRow, FromCol))

            local r,g,b,a = self.State[i].ButtonImageData:getPixel(FromCol,FromRow)

            ButtonImageData:setPixel(ToCol, ToRow, r,g,b,a)

            if (ToCol < StartCol) or (ToCol > EndCol) then
               FromCol = FromCol + 1
            end
         end

         if (ToRow < StartRow) or (ToRow > EndRow) then
            FromRow = FromRow + 1
         end

         FromCol = 0
      end

      self.State[i].ButtonImage = love.graphics.newImage(ButtonImageData)
      self.ButtonImageWidth  = self.W
      self.ButtonImageHeight = self.H

   end
end -- >>>
-- >>>

function guru.newButton(f,cfg) -- <<<

   if type(f) ~= "function" then
      love.window.showMessageBox( DevErrorTxt, 'newButton() expects a function as first parameter!', "error", true)
   end

   if (type(cfg) ~= "table") and (cfg ~= nil) then
      love.window.showMessageBox( DevErrorTxt, "newButton()'s second parameter must be a config table or nil!", "error", true)
   end

   local self = setmetatable({}, Object_mt)

   self.Function = f

   Config_t      = cfg or {}

   -- TODO add fonts info to theme too
   self.Font     = Config_t.font     or Fonts_t.sans
   self.FontSize = Config_t.fontsize or FontSize_n

   self.Name     = Config_t.name
   self.ToolTip  = Config_t.tooltip
   self.Parent   = Config_t.parent   or Backdrop
   self.X        = Config_t.x        or 0
   self.Y        = Config_t.y        or 0

   self.Text     = Config_t.text

   self.ImageFilename = Config_t.image        or Themes_t[Theme_s].Button.ImageFilename
   self.CornerRadius  = Config_t.cornerradius or Themes_t[Theme_s].Button.CornerRadius

   if self.Text then
      self.TextWidth  = self.Font:getWidth(self.Text)
      self.TextHeight = self.Font:getHeight()
      self.ImageScaling = Config_t.scaling or Themes_t[Theme_s].Button.ImageScaling or "extend"
   else
      self.ImageScaling = Config_t.scaling or Themes_t[Theme_s].Button.ImageScaling or "stretch"
   end

   self.W = Config_t.width
   self.H = Config_t.height

   self.State =
   {
      ["Normal"] =
      {
         ["FontColor"]   = Config_t.fontcolor            or Themes_t[Theme_s].Button.State.Normal.FontColor,
         ["ButtonColor"] = Config_t.buttoncolor          or Themes_t[Theme_s].Button.State.Normal.ButtonColor,
      },

      ["Down"] =
      {
         ["FontColor"]   = Config_t.fontcolordown        or Themes_t[Theme_s].Button.State.Down.FontColor,
         ["ButtonColor"] = Config_t.buttoncolordown      or Themes_t[Theme_s].Button.State.Down.ButtonColor,
      },

      ["Hover"] =
      {
         ["FontColor"]   = Config_t.fontcolormouseover   or Themes_t[Theme_s].Button.State.Hover.FontColor,
         ["ButtonColor"] = Config_t.buttoncolormouseover or Themes_t[Theme_s].Button.State.Hover.ButtonColor,
      },

      ["Disabled"] =
      {
         ["FontColor"]   = Config_t.fontcolordisabled    or Themes_t[Theme_s].Button.State.Disabled.FontColor,
         ["ButtonColor"] = Config_t.buttoncolordisabled  or Themes_t[Theme_s].Button.State.Disabled.ButtonColor,
      },
   }

   if self.ImageFilename then
      createButtonImageData(self)
   end

   self.CurrState = self.State.Normal
   self.NextState = self.State.Normal
   -- self.PrevState = self.State.Normal

   self.mask          = function() love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.CornerRadius, self.CornerRadius) end
   self.keypressed    = btn.keypressed
   self.mousepressed  = btn.mousepressed
   self.mousereleased = btn.mousereleased
   self.mousemoved    = btn.mousemoved
   self.update        = btn.update
   self.resize        = btn.resize
   self.draw          = btn.draw

   self:resize()

   table.insert(self.Parent.Objects, self)

   self.Index = #self.Parent.Objects

   return self
end -- >>>
-- >>>

-- img alias image <<<
local img = {} -- button table

img.resize = function(self) -- <<<

-- position,dimensions of viewport
   -- calc viewport width,height
   if (self.W == nil) and (self.H == nil) then
      self.Width  = self.ImageWidth
      self.Height = self.ImageHeight
   end

   if (self.W == nil) and (self.H ~= nil) then
      self.Width  = toYPixel(self.H) * (self.ImageWidth/self.ImageHeight)
      self.Height = toXPixel(self.H)
   end

   if (self.W ~= nil) and (self.H == nil) then
      self.Width  = toYPixel(self.W)
      self.Height = toXPixel(self.W) * (self.ImageHeight/self.ImageWidth)
   end

   if (self.W ~= nil) and (self.H ~= nil) then
      self.Width  = toYPixel(self.W)
      self.Height = toXPixel(self.H)
   end

   -- calc viewport corners
   self.TopLeftX     = toXPixel(self.X)
   self.TopLeftY     = toYPixel(self.Y)
   self.BottomRightX = self.TopLeftX + self.Width
   self.BottomRightY = self.TopLeftY + self.Height

-- offset,scaling of image
   self.OffsetX = 0
   self.OffsetY = 0
   self.ScaleX  = self.Width  / self.ImageWidth
   self.ScaleY  = self.Height / self.ImageHeight

end -- >>>

img.draw = function(self) -- <<<

   if self.BackColor then
      love.graphics.setColor(self.BackColor)
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.CornerRadius, self.CornerRadius)
   end

   setStencil(self.mask)
   love.graphics.setColor(255,255,255)
   love.graphics.draw(self.Image, self.TopLeftX+self.OffsetX, self.TopLeftY+self.OffsetY, 0, self.ScaleX, self.ScaleY, 0, 0, 0, 0)
   unsetStencil()

   if self.ShowScrollerX then
      drawScrollerX(self.BottomRightX-self.ScrollerWidth, ScrollPosY, self.ScrollerWidth, self.ScrollerHeight)
   end

   if self.ShowScrollerY then
      drawScrollerY()
   end

   if self.IsActive then
      love.graphics.setColor(Themes_t[Theme_s].FrameColorActive)
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.CornerRadius, self.CornerRadius)
   end
end -- >>>

img.wheelmoved = function(self,dx,dy) -- <<<

   -- sensitivity <<<
   if (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
      ScalingSensitivity  = 0.001
      ShiftingSensitivity = 1
   else
      ScalingSensitivity  = 0.005
      ShiftingSensitivity = 5
   end
   -- >>>

   -- shifting <<<
   if (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then
      if (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")) then

         self.OffsetX = self.OffsetX + (dy * ShiftingSensitivity)
         if self.OffsetX < 0 then
            self.OffsetX = 0
         end

         if self.OffsetX > (self.Width - (self.ImageWidth * self.ScaleX)) then
            self.OffsetX = (self.Width - (self.ImageWidth * self.ScaleX))
         end

      else

         self.OffsetY = self.OffsetY + (dy * ShiftingSensitivity)
         if self.OffsetY < 0 then
            self.OffsetY = 0
         end

         if self.OffsetY > (self.Height - (self.ImageHeight * self.ScaleY)) then
            self.OffsetY = (self.Height - (self.ImageHeight * self.ScaleY))
         end
      end
   -- >>>

   else -- scaling <<<
      self.ScaleX = self.ScaleX + (dy * ScalingSensitivity)
      self.ScaleY = self.ScaleY + (dy * ScalingSensitivity)

      if self.ScaleX < 0 then
         self.ScaleX = 0
      end

      if self.ScaleY < 0 then
         self.ScaleY = 0
      end

      if (self.ScaleX*self.ImageWidth) < self.Width then
         self.OffsetX = (self.Width - (self.ScaleX*self.ImageWidth))/2
      else
         self.OffsetX = 0
      end

      if (self.ScaleY*self.ImageHeight) < self.Height then
         self.OffsetY = (self.Height - (self.ScaleY*self.ImageHeight))/2
      else
         self.OffsetY = 0
      end
   end
   -- >>>

   if (self.ImageWidth  * self.ScaleX) > self.Width  then
      self.ShowScrollerX = true
   else
      self.ShowScrollerX = false
   end

   if (self.ImageHeight * self.ScaleY) > self.Height then
      self.ShowScrollerY = true
   else
      self.ShowScrollerY = false
   end

end -- >>>

img.updateImage = function() -- <<<
   --print(collectgarbage("count"))
   i = nil
   --collectgarbage()
   --print(collectgarbage("count"))
   i = love.graphics.newImage(f)
   --print(collectgarbage("count"))
   --collectgarbage()
   --print(collectgarbage("count"))
end -- >>>

-- image keys <<<
-- key functions <<<
img.pressed_up = function(self) -- <<<
end -- >>>
-- >>>

img.Keys =
{
   ["up"] = pressed_up,
}
-- >>>

function guru.newImage(i, cfg) -- <<<

   if type(i) ~= "string" then
      love.window.showMessageBox( DevErrorTxt, 'newImage() expects a filename as first parameter!', "error", true)
   end

   if (type(cfg) ~= "table") and (cfg ~= nil) then
      love.window.showMessageBox( DevErrorTxt, "newImage()'s second parameter must be a config table or nil!", "error", true)
   end

   local self = setmetatable({}, Object_mt)

   self.Image = love.graphics.newImage(i)

   Config_t   = cfg or {}

   self.Name     = Config_t.name
   self.ToolTip  = Config_t.tooltip
   self.Parent   = Config_t.parent   or Backdrop
   self.X        = Config_t.x        or 0
   self.Y        = Config_t.y        or 0

   self.CornerRadius = Config_t.cornerradius or 0 --or Themes_t[Theme_s].Image.CornerRadius
   self.BackColor    = Config_t.backcolor    or Themes_t[Theme_s].Image.BackColor
   self.Alignment    = Config_t.align        or "NW"

   self.ImageWidth  = self.Image:getWidth() 
   self.ImageHeight = self.Image:getHeight()

   self.W = Config_t.width
   self.H = Config_t.height

   self.mask          = function() love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.CornerRadius, self.CornerRadius) end
   self.wheelmoved    = img.wheelmoved
   self.keypressed    = img.keypressed
   -- self.mousepressed  = img.mousepressed
   -- self.mousereleased = img.mousereleased
   -- self.mousemoved    = img.mousemoved
   self.update        = img.update
   self.resize        = img.resize
   self.draw          = img.draw

   self:resize()

   table.insert(self.Parent.Objects, self)

   self.Index = #self.Parent.Objects

   return self
end -- >>>
-- >>>


--[===[

-- tgl alias toggle <<<
local tgl = {} -- toggle table

tgl.drawBackground = function(self) -- <<<

   if self.Value then
      ToggleColor = self.TrueColor
   else
      ToggleColor = self.FalseColor
   end

   love.graphics.setColor(ToggleColor)
   love.graphics.circle("fill", self.TopLeftX+self.Radius, self.TopLeftY+self.Radius, self.Radius, 50)

end -- >>>

tgl.drawObject = function(self) -- <<<
end -- >>>

tgl.drawFrame = function(self) -- <<<
   if self.IsActive then
      love.graphics.setColor(color.ActiveFrame)
   end
   love.graphics.circle("line", self.TopLeftX+self.Radius, self.TopLeftY+self.Radius, self.Radius, 50)
end -- >>>

tgl.draw = function(self) -- <<<
   self:drawBackground()
   self:drawObject()
   self:drawFrame()
end -- >>>

function guru.newToggle(x,y,w,RadioGroup) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 20

   local self = setmetatable({}, Object_mt)

   self.Value          = false
   self.TrueColor      = color.c8
   self.FalseColor     = color.c2

   self.keypressed     = tgl.keypressed
   self.mousepressed   = tgl.mousepressed
   self.drawBackground = tgl.drawBackground
   self.drawObject     = tgl.drawObject
   self.drawFrame      = tgl.drawFrame
   self.draw           = tgl.draw

   -- table Keys <<<
   local Keys =
   {
      ["space"]  = function(self) -- <<<
         if RadioGroup then
            for i,v in ipairs(RadioGroup) do
               v.Value = false
            end
         end
         self.Value = not self.Value
      end, -- >>>
      ["return"] = function(self) -- <<<
         if RadioGroup then
            for i,v in ipairs(RadioGroup) do
               v.Value = false
            end
         end
         self.Value = not self.Value
      end, -- >>>
   }
   -- >>>

   self.resize = function(self) -- <<<
      self.Width        = toXPixel(w)
      self.Height       = toXPixel(w)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height
      self.Radius       = self.Width/2
   end -- >>>

   self.keypressed = function(self, key, sc, isrepeat) -- <<<
      if Keys[key] and not isrepeat then
         Keys[key](self)
      end
   end -- >>>

   self.mousepressed = function(self, x, y, button) -- <<<
      local x = x - self.Parent.OffsetX
      local y = y - self.Parent.OffsetY
      --if (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) and (button == 1) then

      if RadioGroup then
         for i,v in ipairs(RadioGroup) do
            v.Value = false
         end
      end

      self.Value = not self.Value
      self:deactivate()
      --end
   end -- >>>

   if type(RadioGroup) == "table" then
      table.insert(RadioGroup, self)
      if #RadioGroup == 1 then
         self.Value = true
      end
   end

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

-- tbx alias textbox <<<
local tbx = {} -- textbox table

tbx.calcPositionOffset = function(txt, cpos, fnt) -- <<<
   local TextTilCursor = string.sub(txt, 0, cpos)
   return fnt:getWidth(TextTilCursor)
end -- >>>

tbx.findStartOfPreviousWord = function(str, pos) -- <<<

   local s=0 -- start
   local e=0 -- end
   local r=0 -- result

   while e < pos do
      s,e = string.find(str, "%W%w", e+1)

      if not e then
         break
      end

      if (e-1) < pos then
         r=e-1
      end
   end

   return r
end -- >>>

tbx.findEndOfNextWord = function(str, pos) -- <<<

   local s=0 -- start
   local e=0 -- end
   local r=0 -- result

   s,e = string.find(str, "%w%W", pos+1)

   if s then
      r=s
   else
      r=#str
   end

   return r
end -- >>>

tbx.insertText = function(t, InsertText) -- <<<
   if InsertText then
      if t.SelectionStart then
         tbx.deleteSelectedText(t)
         t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition)
         t.SelectionStart = nil
      end

      local Text1 = string.sub(t.Text, 0, t.CursorPosition )
      local Text2 = string.sub(t.Text, t.CursorPosition + 1)

      local Text  = Text1 .. InsertText .. Text2

      if (t.MaxCharacters ~= 0) and (#Text > t.MaxCharacters) then -- text longer then max char

         NumOfCharsToRemove = #Text - t.MaxCharacters

         if #InsertText > NumOfCharsToRemove then -- try to strip, necessary when text comes from clipboard
            Text  = Text1 .. string.sub(InsertText,1, #InsertText-NumOfCharsToRemove) .. Text2
         else
            return -- text cannot be stripped in a useful way
         end
      end

      t.Text  = Text
      t.CursorPosition  = t.CursorPosition + #InsertText
   end
end -- >>>

tbx.deleteCharBeforeCursor = function(t) -- <<<
   if (#t.Text > 0) then
      Text1 = string.sub(t.Text, 0, t.CursorPosition )
      Text2 = string.sub(t.Text, t.CursorPosition + 1)
      Text1 = string.sub(Text1, 1, -2)
      t.Text = Text1 .. Text2
      t.CursorPosition  = t.CursorPosition - 1
      if t.CursorPosition < 0 then t.CursorPosition = 0 end
      t.DrawCursor = true
   end
end -- >>>

tbx.deleteCharAfterCursor = function(t) -- <<<
   if (#t.Text > 0) then
      Text1 = string.sub(t.Text, 0, t.CursorPosition )
      Text2 = string.sub(t.Text, t.CursorPosition + 1)
      Text2 = string.sub(Text2, 2)
      t.Text = Text1 .. Text2
      t.DrawCursor = true
   end
end -- >>>

tbx.shiftCursorLeft = function(t) -- <<<
   local d=love.keyboard.isDown

   if (d("lshift") or d("rshift")) then
      if not t.SelectionStart then
         t.SelectionStart = t.CursorPosition
      end
   else
      if t.SelectionStart then
         t.CursorPosition = math.min( t.SelectionStart or t.CursorPosition, t.CursorPosition )
         t.SelectionStart = nil
         t.DrawCursor = true
         return
      end
   end

   if not (d("lalt") or d("ralt")) and not (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
      if t.CursorPosition > 0 then
         t.CursorPosition = t.CursorPosition - 1 -- set cursor positon one character left
         t.DrawCursor = true
         return
      end
   end

   if not (d("lalt") or d("ralt")) and (d("lgui") or d("rgui")) or (d("lctrl") or d("rctrl")) then
      t.CursorPosition = 0 -- set cursor to beginn of line
      t.DrawCursor = true
      return
   end

   if (d("lalt") or d("ralt")) and not (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
      t.CursorPosition = tbx.findStartOfPreviousWord(t.Text, t.CursorPosition)
      t.DrawCursor = true
      return
   end
end -- >>>

tbx.shiftCursorRight = function(t) -- <<<
   local d=love.keyboard.isDown

   if (d("lshift") or d("rshift")) then
      if not t.SelectionStart then
         t.SelectionStart = t.CursorPosition
      end
   else
      if t.SelectionStart then
         t.CursorPosition = math.max( t.SelectionStart or t.CursorPosition, t.CursorPosition )
         t.SelectionStart = nil
         t.DrawCursor = true
         return
      end
   end

   if not (d("lalt") or d("ralt")) and not (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
      if t.CursorPosition < #t.Text then
         t.CursorPosition = t.CursorPosition + 1 -- set cursor position one character right
         t.DrawCursor = true
         return
      end
   end

   if not (d("lalt") or d("ralt")) and (d("lgui") or d("rgui")) or (d("lctrl") or d("rctrl")) then
      t.CursorPosition = #t.Text -- set cursor to end of line
      t.DrawCursor = true
      return
   end

   if (d("lalt") or d("ralt")) and not (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
      t.CursorPosition = tbx.findEndOfNextWord(t.Text, t.CursorPosition)
      t.DrawCursor = true
      return
   end
end -- >>>

tbx.pasteFromClipboard = function() -- <<<
   local d=love.keyboard.isDown
   if not (d("lshift") or d("rshift")) and not (d("lalt") or d("ralt")) and (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
      local ClipText = love.system.getClipboardText()
      ClipText = string.gsub(ClipText, "\n", "")
      ClipText = string.gsub(ClipText, "\r", "")
      ClipText = string.gsub(ClipText, "\t", " ") -- I'm not sure if this is a good idea
      return ClipText
   end
end -- >>>

tbx.copyToClipboard = function(txt) -- <<<
   if txt then
      local d=love.keyboard.isDown
      if not (d("lshift") or d("rshift")) and not (d("lalt") or d("ralt")) and (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
         love.system.setClipboardText(txt)
      end
   end
end -- >>>

tbx.getSelectedText = function(t) -- <<<
   if t.SelectionStart then
      return string.sub(t.Text, math.min(t.CursorPosition, t.SelectionStart)+1, math.max(t.CursorPosition, t.SelectionStart))
   end
end -- >>>

tbx.selectAllText = function(t) -- <<<
   if #t.Text ~= 0 then
      t.SelectionStart = 0
      t.CursorPosition = #t.Text
   end
end -- >>>

tbx.deleteSelectedText = function(t) -- <<<
   if t.SelectionStart then
      local s = math.min(t.CursorPosition, t.SelectionStart)
      local e = math.max(t.CursorPosition, t.SelectionStart)
      local Text1 = string.sub(t.Text, 0, s )
      local Text2 = string.sub(t.Text, e + 1)
      t.Text = Text1 .. Text2
   end
end -- >>>

tbx.onActivation = function(self) -- <<<
   tbx.selectAllText(self)
end -- >>>

tbx.onDeactivation = function(self) -- <<<
   self.SelectionStart = nil
end -- >>>

tbx.pressed_A = function(self) -- <<<
   local d=love.keyboard.isDown
   if not (d("lshift") or d("rshift")) and not (d("lalt") or d("ralt")) and (d("lgui") or d("rgui")) and not (d("lctrl") or d("rctrl")) then
      tbx.selectAllText(self)
   end
end -- >>>

-- table Keys <<<
tbx.Keys =
{
   ["return"]    = function(t) t.OldText = t.Text; t:deactivate(); end, -- accept changes and set text box inactive
   ["escape"]    = function(t) if t.SelectionStart then t.SelectionStart = nil else t.Text = t.OldText; t:deactivate(); end end, -- drop changes and set text box inactive
   ["left"]      = function(t) tbx.shiftCursorLeft(t) ; if t.SelectionStart == t.CursorPosition then t.SelectionStart = nil end end,
   ["right"]     = function(t) tbx.shiftCursorRight(t); if t.SelectionStart == t.CursorPosition then t.SelectionStart = nil end end,
   ["backspace"] = function(t) if t.SelectionStart then tbx.deleteSelectedText(t); t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition); t.SelectionStart = nil else tbx.deleteCharBeforeCursor(t) end end,
   ["delete"]    = function(t) if t.SelectionStart then tbx.deleteSelectedText(t); t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition); t.SelectionStart = nil else tbx.deleteCharAfterCursor(t) end end,
   ["v"]         = function(t) tbx.insertText(t, tbx.pasteFromClipboard()) end,
   ["c"]         = function(t) tbx.copyToClipboard(tbx.getSelectedText(t)) end,
   ["a"]         = tbx.pressed_A,
   ["x"]         = function(t) tbx.copyToClipboard(tbx.getSelectedText(t)); if t.SelectionStart then tbx.deleteSelectedText(t); t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition); t.SelectionStart = nil end end,
   ["l"]         = function(t) s=getFinderSelection(); if s then tbx.insertText(t,  table.concat(s, ";")) end end,
}
-- >>>

tbx.keypressed = function(self, key, sc, isrepeat) -- <<<
   if tbx.Keys[key] then
      tbx.Keys[key](self)
   end
end -- >>>

tbx.textinput = function(self, text) -- <<<
   if type(self.ValidCharacters) == "string" then
      if string.match(text, self.ValidCharacters) then
         tbx.insertText(self, text)
      end
   else
      tbx.insertText(self, text)
   end
end -- >>>

tbx.mousepressed = function(self, x, y, button) -- <<<
   local x = x - self.Parent.OffsetX
   local y = y - self.Parent.OffsetY
   local ExpCursorPositionX = 0
   local NearestCursorPos   = 0
   local PrevDistance       = nil

   if (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) and (button == 1) then
      self.SelectionStart = nil
      for i=0, #self.Text do
         ExpCursorPositionX = self.CursorPosition0 + tbx.calcPositionOffset(self.Text, i, self.Font) + 1
         Distance = math.abs(ExpCursorPositionX - x)
         if PrevDistance and ( Distance > PrevDistance ) then
            break
         end
         NearestCursorPos = i
         PrevDistance     = Distance
      end
      self.CursorPosition = NearestCursorPos
   end
end -- >>>

tbx.directorydropped = function(self, path) -- <<<
   self.Text = path
end -- >>>

tbx.filedropped = function(self, file) -- <<<
   self.Text = file:getFilename()
end -- >>>

tbx.drawBackground = function(self) -- <<<
   love.graphics.setColor(self.BackColor)
   love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
end -- >>>

tbx.drawObject = function(self) -- <<<
   local OffsetX = 0
   local maskTextBox = function() love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height) end

   love.graphics.setFont(self.Font)

   self.CursorPositionX = self.CursorPosition0 + tbx.calcPositionOffset(self.Text, self.CursorPosition, self.Font) + 1

   if #self.Text ~= 0 then

      if self.CursorPositionX > self.BottomRightX then
         OffsetX = (self.CursorPositionX - self.BottomRightX)
      end

      setStencil(maskTextBox)

      if self.SelectionStart then
         local SelStartX = self.CursorPosition0 + tbx.calcPositionOffset(self.Text, math.min(self.CursorPosition, self.SelectionStart), self.Font) + 1
         local SelWidth = self.Font:getWidth(tbx.getSelectedText(self))
         love.graphics.setColor(self.SelectColor)
         love.graphics.rectangle("fill", SelStartX - OffsetX, self.TopLeftY, SelWidth, self.Height)
      end

      love.graphics.setColor(self.TextColor)
      love.graphics.print(self.Text, self.TopLeftX+3-OffsetX, self.TopLeftY+4)
      unsetStencil()
   else
      love.graphics.setColor(self.HintColor)
      love.graphics.print(self.HintText, self.TopLeftX+3, self.TopLeftY+4)
   end

   if self.IsActive then
      if not self.SelectionStart then
         if self.DrawCursor then
            love.graphics.setColor(self.TextColor)
            love.graphics.line(self.CursorPositionX-OffsetX, self.TopLeftY+4, self.CursorPositionX-OffsetX, self.TopLeftY+4+self.FontSize) -- blinking cursor
         end
      end
   end


end -- >>>

tbx.drawFrame = function(self) -- <<<
   if self.IsActive then
      love.graphics.setColor(color.ActiveFrame)
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end
end -- >>>

tbx.draw = function(self) -- <<<
   self:drawBackground()
   self:drawObject()
   self:drawFrame()
end -- >>>

tbx.update = function(self, dt) -- <<<
   self.DeltaTime = self.DeltaTime + dt

   if self.DeltaTime > 0.5 then
      self.DrawCursor = not self.DrawCursor
      self.DeltaTime = 0
   end
end -- >>>

function guru.newTextBox(x,y,w,h) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 400
   local h = h or 20

   local FontSize = 12

   local self = setmetatable({}, Object_mt)

   self.FontSize         = FontSize
   self.Font             = love.graphics.newFont("fonts/arial.ttf", FontSize)
   self.TextColor        = color.black
   self.HintColor        = color.grey7
   self.BackColor        = color.white
   self.SelectColor      = color.mint
   self.Text             = ""
   self.OldText          = ""
   self.HintText         = "type here"
   self.MaxCharacters    = 0 -- 0 means no maximum

   self.DrawCursor       = false -- TODO make private
   self.DeltaTime        = 0     -- TODO make private
   self.CursorPosition0  = x+3 -- TODO move to calcPos and make private
   self.CursorPositionX  = 0   -- TODO move to calcPos and make private
   self.CursorPosition   = 0   -- TODO move to calcPos and make private

   self.keypressed       = tbx.keypressed
   self.textinput        = tbx.textinput
   self.mousepressed     = tbx.mousepressed
   self.directorydropped = tbx.directorydropped
   self.filedropped      = tbx.filedropped
   self.drawBackground   = tbx.drawBackground
   self.drawObject       = tbx.drawObject
   self.drawFrame        = tbx.drawFrame
   self.draw             = tbx.draw
   self.update           = tbx.update

   self.activate         = tbx.activate
   self.deactivate       = tbx.deactivate
   self.onActivation     = tbx.onActivation
   self.onDeactivation   = tbx.onDeactivation

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

function guru.newTextfield(x,y,w,h,r) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 400
   local h = h or 400
   local r = r or 0
   local tm = 6  -- top margin
   local bm = 6  -- bottom margin
   local lm = 6  -- left margin
   local rm = 6  -- right margin
   local ls = 4  -- line skip
   local lnm=20  -- line number margin
   local YPos = 0
   local FontSize = 12
   local Cursor = { row = 1, col = 0 , x = 10, y = 10, draw = true, time = 0}

   local self = setmetatable({}, Object_mt)

   self.Text =
   {
      "A TEXT BOX, TEXT FIELD OR TEXT ENTRY BOX IS A GRAPHICAL CONTROL",
      "ELEMENT INTENDED TO ENABLE THE USER TO INPUT TEXT INFORMATION",
      "TO BE USED BY THE PROGRAM.",
      "Wow it is working",
   }

   self.BGColor = color.white
   self.FGColor = color.black
   self.Font    = Fonts_t.sans
   self.ShowLineNum = false
   self.TextWrap    = false

   --self.mousepressed   = xxx.mousepressed
   --self.activate       = xxx.activate
   --self.deactivate     = xxx.deactivate

   local Keys = -- <<<
   {
      ["left"]      = function(self) -- <<<
         if Cursor.col > 0 then 
            Cursor.col = Cursor.col - 1
         elseif (Cursor.col == 0) and (Cursor.row > 1) then
            Cursor.row = Cursor.row - 1
            Cursor.col = #self.Text[Cursor.row]
         end
      end, -- >>>
      ["right"]     = function(self) -- <<<
         if Cursor.col < #self.Text[Cursor.row] then 
            Cursor.col = Cursor.col + 1
         elseif (Cursor.col == #self.Text[Cursor.row]) and (Cursor.row < #self.Text) then
            Cursor.row = Cursor.row + 1
            Cursor.col = 0
         end
      end, -- >>>
      ["down"]      = function(self) -- <<<
         if Cursor.row < #self.Text then
            Cursor.row = Cursor.row + 1
            if Cursor.col > #self.Text[Cursor.row] then
               Cursor.col = #self.Text[Cursor.row]
            end
         end
      end, -- >>>
      ["up"]        = function(self) -- <<<
         if Cursor.row > 1 then
            Cursor.row = Cursor.row - 1
            if Cursor.col > #self.Text[Cursor.row] then
               Cursor.col = #self.Text[Cursor.row]
            end
         end
      end, -- >>>

      --["return"]    = function(t) end, -- accept changes and set text box inactive
      --["escape"]    = function(t) if t.SelectionStart then t.SelectionStart = nil else t.Text = t.OldText; t:deactivate(); end end, -- drop changes and set text box inactive
      --["backspace"] = function(t) if t.SelectionStart then tbx.deleteSelectedText(t); t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition); t.SelectionStart = nil else tbx.deleteCharBeforeCursor(t) end end,
      --["delete"]    = function(t) if t.SelectionStart then tbx.deleteSelectedText(t); t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition); t.SelectionStart = nil else tbx.deleteCharAfterCursor(t) end end,
      --["v"]         = function(t) tbx.insertText(t, tbx.pasteFromClipboard()) end,
      --["c"]         = function(t) tbx.copyToClipboard(tbx.getSelectedText(t)) end,
      --["a"]         = tbx.pressed_A,
      --["x"]         = function(t) tbx.copyToClipboard(tbx.getSelectedText(t)); if t.SelectionStart then tbx.deleteSelectedText(t); t.CursorPosition = math.min(t.SelectionStart, t.CursorPosition); t.SelectionStart = nil end end,
      --["l"]         = function(t) s=getFinderSelection(); if s then tbx.insertText(t,  table.concat(s, ";")) end end,
   } -- >>>

   updateCursorPos = function(self) -- <<<
      Cursor.x = self.TopLeftX + lm + lnm + self.Font:getWidth( string.sub(self.Text[Cursor.row], 0, Cursor.col) )
      Cursor.y = self.TopLeftY + tm + ((Cursor.row-1) * (FontSize + ls))
      Cursor.draw = true
   end -- >>>

   self.update = function(self, dt) -- <<<
      Cursor.time = Cursor.time + dt

      if Cursor.time > 0.5 then
         Cursor.draw = not Cursor.draw
         Cursor.time = 0
      end
   end -- >>>

   self.insertText = function(self, InsertText) -- <<<
      local Text1 = string.sub(self.Text[Cursor.row], 0, Cursor.col )
      local Text2 = string.sub(self.Text[Cursor.row], Cursor.col + 1)
      local Text  = Text1 .. InsertText .. Text2
      self.Text[Cursor.row] = Text
      Cursor.col  = Cursor.col + #InsertText
   end -- >>>

   self.keypressed = function(self, key, sc, isrepeat) -- <<<
      if Keys[key] then
         Keys[key](self)
      end
      updateCursorPos(self)
   end -- >>>

   self.textinput = function(self, text) -- <<<
      self.insertText(self, text)
   end -- >>>

   self.drawBackground = function(self) -- <<<
      love.graphics.setColor(self.BGColor)
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end -- >>>

   maskTextfield = function() -- <<<
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end -- >>>

   self.drawObject = function(self) -- <<<

      setStencil(maskTextfield)

      -- draw line numbers <<<
      if self.ShowLineNum then
         love.graphics.setColor(color.grey8)
         love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, lnm, self.Height)
      end
      -- >>>

      love.graphics.setColor(self.FGColor)
      love.graphics.setFont(self.Font)

      YPos = self.TopLeftY+tm
      for i,v in ipairs(self.Text) do

         if self.ShowLineNum then
            love.graphics.print(i, self.TopLeftX+lnm-4-self.Font:getWidth(i), YPos)
         end

         local text = v
         if self.TextWrap then

            textwidth, text = self.Font:getWrap(v, self.Width - lnm - lm - rm )

            for j,w in ipairs(text) do
               love.graphics.print(w, self.TopLeftX+lm+lnm, YPos)
               YPos = YPos + FontSize + ls
            end

         else

            love.graphics.print(text, self.TopLeftX+lm+lnm, YPos)
            YPos = YPos + FontSize + ls

         end

         -- draw cursor <<<
         if self.IsActive == true then
            if Cursor.draw then
               love.graphics.line(Cursor.x, Cursor.y, Cursor.x, Cursor.y + FontSize)
            end
         end
         -- >>>
      end

      unsetStencil()
   end -- >>>

   self.drawFrame = function(self) -- <<<
      if self.IsActive then
         love.graphics.setColor(color.ActiveFrame)
         love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
      end
   end -- >>>

   self.draw = function(self) -- <<<
      self:drawBackground()
      self:drawObject()
      self:drawFrame()
   end -- >>>

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

      if self.ShowLineNum then
         lnm = self.Font:getWidth(#(self.Text))+8
      else
         lnm = 0
      end

   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>

-- mnu alias menu <<<
local mnu = {} -- menu table

mnu.openMenu = function(self) -- <<<
   self.IsOpen = true
   self.Height = self.ClosedHeight * #self.Values
   self.BottomRightY = self.TopLeftY + (self.Height * #self.Values)
end -- >>>

mnu.closeMenu = function(self) -- <<<
   self.IsOpen = false
   self.Height = self.ClosedHeight
   self.BottomRightY = self.TopLeftY + self.Height
end -- >>>

mnu.onDeactivation = function(self) -- <<<
   self:closeMenu()
end -- >>>

-- table Keys <<<
mnu.Keys =
{
   ["down"]   = function(t) if t.IsOpen == false then t:openMenu(); t.OldSelectedValue = t.SelectedValue else if t.SelectedValue < #t.Values then t.SelectedValue = t.SelectedValue + 1 end end end,
   ["up"]     = function(t) if t.IsOpen == false then t:openMenu(); t.OldSelectedValue = t.SelectedValue else if t.SelectedValue > 1         then t.SelectedValue = t.SelectedValue - 1 end end end,
   ["escape"] = function(t) if t.IsOpen == true  then t:closeMenu(); t.SelectedValue = t.OldSelectedValue else t:deactivate() end end,
   ["return"] = function(t) t:closeMenu(); t:deactivate(); t.OldSelectedValue = t.SelectedValue end,
   ["space"]  = function(t) t:closeMenu(); t.OldSelectedValue = t.SelectedValue end,
}
-- >>>

mnu.keypressed = function(self, key, sc, isrepeat) -- <<<
   if mnu.Keys[key] and not isrepeat then
      mnu.Keys[key](self)
   end
end -- >>>

mnu.mousepressed = function(self, x, y, button) -- <<<
      if (button == 1) then
         if (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) then
            if not self.IsOpen then
               self:openMenu()
            else -- select another entry
               for i,v in ipairs(self.Values) do
                  if (y > (self.TopLeftY + ((i-1)*self.ClosedHeight))) and (y < (self.TopLeftY + (i * self.ClosedHeight))) then
                     self.SelectedValue = i
                     self.OldSelectedValue = i
                     self:closeMenu()
                     return
                  end
               end
            end
         end
      end
end -- >>>

mnu.wheelmoved = function(self, msx, msy) -- <<<
   if msy < 0 then
      if self.SelectedValue < #self.Values then
         self.SelectedValue = self.SelectedValue + 1
         self.OldSelectedValue = self.SelectedValue
      end

      elseif msy > 0 then
         if self.SelectedValue > 1 then
            self.SelectedValue = self.SelectedValue - 1
            self.OldSelectedValue = self.SelectedValue
         end
      end
end -- >>>

mnu.drawBackground = function(self) -- <<<
   love.graphics.setColor(color.white)
   love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
end -- >>>

mnu.drawObject = function(self) -- <<<

   love.graphics.setFont(self.Font)

   if self.IsOpen then
      setStencil(self.maskOpenMenu)
      for i,v in ipairs(self.Values) do
         if self.SelectedValue == i then
            love.graphics.setColor(color.lovegreen)
            love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY+(i-1)*self.ClosedHeight, self.Width, self.ClosedHeight)
         else
            local x,y = love.mouse.getPosition()
            if (x > self.TopLeftX) and (x < self.BottomRightX) and (y > (self.TopLeftY+((i-1)*self.ClosedHeight))) and (y < (self.TopLeftY+((i-1)*self.ClosedHeight)+self.ClosedHeight)) then
               love.graphics.setColor(color.mint)
               love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY+(i-1)*self.ClosedHeight, self.Width, self.ClosedHeight)
            end
         end
         love.graphics.setColor(color.black)
         love.graphics.print(v, self.TopLeftX+3, self.TopLeftY+4+(i-1)*self.ClosedHeight)
      end
      unsetStencil()
   else
      setStencil(self.maskClosedMenu)
      love.graphics.setColor(color.black)
      love.graphics.print(self.Values[self.SelectedValue], self.TopLeftX+3, self.TopLeftY+4)
      unsetStencil()
      love.graphics.polygon("fill", self.BottomRightX-5, self.BottomRightY-11, self.BottomRightX-15, self.BottomRightY-11, self.BottomRightX-10, self.BottomRightY-16)
      love.graphics.polygon("fill", self.BottomRightX-5, self.BottomRightY-9, self.BottomRightX-15, self.BottomRightY-9, self.BottomRightX-10, self.BottomRightY-4)
   end

end -- >>>

mnu.drawFrame = function(self) -- <<<
   if self.IsActive then
      love.graphics.setColor(color.ActiveFrame)
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end
end -- >>>

mnu.draw = function(self) -- <<<
   self:drawBackground()
   self:drawObject()
   self:drawFrame()
end -- >>>

function guru.newMenu(x,y,w,h,v) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 20
   local h = h or 20

   local self = setmetatable({}, Object_mt)

   self.FontSize         = 12
   self.Font             = love.graphics.newFont("fonts/arial.ttf", self.FontSize)
   self.Values           = v
   self.SelectedValue    = 1
   self.OldSelectedValue = 1
   self.IsOpen           = false

   self.keypressed       = mnu.keypressed
   self.mousepressed     = mnu.mousepressed
   self.wheelmoved       = mnu.wheelmoved
   self.openMenu         = mnu.openMenu
   self.closeMenu        = mnu.closeMenu
   self.drawBackground   = mnu.drawBackground
   self.drawObject       = mnu.drawObject
   self.drawFrame        = mnu.drawFrame
   self.draw             = mnu.draw

   self.onDeactivation   = mnu.onDeactivation

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.ClosedHeight = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self.maskClosedMenu = function() -- <<<
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width-20, self.ClosedHeight)
   end -- >>>

   self.maskOpenMenu = function() -- <<<
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width   , self.ClosedHeight * #self.Values)
   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

-- val alias value <<<
-- TODO
-- min-max-check as part of updateValueTable function
-- updateValueTable - remove unnecessary parts ???
local val = {} -- value table

val.initValueTable = function(v,b,a) -- <<<

   if type(v) ~= "number" then return end
   local t = {}

   if v >= 0 then
      sign = "+"
   else
      sign = "-"
   end

   local v = math.abs(v)

   s = tostring(v)
   blen = string.len(string.format("%d",v))
   if blen > b then return end

   if a > 0 then
      t.DotPos = b + 1
   end

   t.b = b
   t.a = a

   strform = "%."..a.."f"
   fs = sign..string.rep(" ",b-blen)..string.format(strform,v)
   s = string.gsub(fs,"%.","")

   for i=1,b+a+1 do
      local Disp=string.sub(s,i,i)
      local Exp
      if i > 1 then
         Exp = b+1-i
      else
         Exp = nil
      end
      t[i] = {["Disp"]=Disp, ["Exp"] = Exp}
   end

   return t
end -- >>>

val.updateValueTable = function(t,v) -- <<<

   if type(v) ~= "number" then return end

   if v >= 0 then
      sign = "+"
   else
      sign = "-"
   end

   local v = math.abs(v)

   s = tostring(v)
   blen = string.len(string.format("%d",v))
   if blen > t.b then return end

   if t.a > 0 then
      t.DotPos = t.b + 1
   end

   strform = "%.".. t.a .."f"
   fs = sign..string.rep(" ",t.b-blen)..string.format(strform,v)
   s = string.gsub(fs,"%.","")

   for i=1,t.b + t.a + 1 do
      local Disp=string.sub(s,i,i)
      local Exp
      if i > 1 then
         Exp = t.b+1-i
      else
         Exp = nil
      end
      t[i] = {["Disp"]=Disp, ["Exp"] = Exp}
   end

   return t
end -- >>>

val.changeValue = function(self, text) -- <<<
   self.Selection = nil
   if string.match(text, "[%-%+0-9%.]") then
      self.ValueString = (self.ValueString or "") .. text
   end
end -- >>>

val.convValueTable2Value = function(t) -- <<<

   local Value_t = {}

   for _,v in ipairs(t) do
      table.insert(Value_t, v.Disp)
   end

   table.insert(Value_t, t.DotPos+1, ".")

   local Value_s = table.concat(Value_t)

   Value_s = string.gsub(Value_s, " ", "")

   return tonumber(Value_s)

end -- >>>

val.deactivate = function(self) -- <<<
   self.IsActive    = false
   self.Layer       = 1
   self.Selection   = nil
   self.ValueString = nil
end -- >>>

-- table Keys <<<

val.pressed_Return = function(self) -- <<<
   if self.ValueString then
      self.Value = tonumber(self.ValueString) or self.OldValue
      if self.Value > self.Max then
         self.Value = self.Max
      end
      if self.Value < self.Min then
         self.Value = self.Min
      end
      val.updateValueTable(self.ValueTable, self.Value)
      self.ValueString=nil
   else self.OldValue = self.Value
      self.Selection=nil
   end
   self:deactivate()
end -- >>>

val.pressed_Escape = function(self) -- <<<
   if self.ValueString then
      self.ValueString = nil
   end
   if self.Selection then
      self.Selection = nil
      self.Value = self.OldValue
   else self:deactivate()
   end
end -- >>>

val.pressed_Left = function(self) -- <<<
   if self.Selection then
      self.Selection = self.Selection - 1
      if self.Selection < 1 then
         self.Selection = 1
      end
   else
      self.OldValue = self.Value
      self.Selection = #self.ValueTable
   end
end -- >>>

val.pressed_Right = function(self) -- <<<
   if self.Selection then
      self.Selection = self.Selection + 1
      if self.Selection > #self.ValueTable then
         self.Selection = #self.ValueTable
      end
   else
      self.OldValue = self.Value
      self.Selection = 2
   end
end -- >>>

val.pressed_Up = function(self) -- <<<

   if self.Selection then

      if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then

         if (self.Selection > 1) then
            self.ValueTable[self.Selection].Disp = (tonumber(self.ValueTable[self.Selection].Disp) or 0) + 1
            if self.ValueTable[self.Selection].Disp > 9 then 
               self.ValueTable[self.Selection].Disp = 0
            end
         end

         if (self.Selection == 1) then
            if self.ValueTable[self.Selection].Disp == "-" then
               self.ValueTable[self.Selection].Disp = "+"
            else
               self.ValueTable[self.Selection].Disp = "-"
            end
         end

         self.Value = val.convValueTable2Value(self.ValueTable)
         val.updateValueTable(self.ValueTable, self.Value)

      else

         if (self.Selection > 1) and ((self.Value + 10^self.ValueTable[self.Selection].Exp) <= self.Max) then
            self.Value = self.Value + 10^self.ValueTable[self.Selection].Exp
         end

         if (self.Selection == 1) then
            self.Value = self.Value * (-1)
         end

         val.updateValueTable(self.ValueTable, self.Value)
      end
   end
end -- >>>

val.pressed_Down = function(self) -- <<<

   if self.Selection then

      if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then

         if (self.Selection > 1) then
            self.ValueTable[self.Selection].Disp = (tonumber(self.ValueTable[self.Selection].Disp) or 0) - 1
            if self.ValueTable[self.Selection].Disp < 0 then 
               self.ValueTable[self.Selection].Disp = 9
            end
         end

         if (self.Selection == 1) then
            if self.ValueTable[self.Selection].Disp == "-" then
               self.ValueTable[self.Selection].Disp = "+"
            else
               self.ValueTable[self.Selection].Disp = "-"
            end
         end

         self.Value = val.convValueTable2Value(self.ValueTable)
         val.updateValueTable(self.ValueTable, self.Value)

      else

         if (self.Selection > 1) and ((self.Value - 10^self.ValueTable[self.Selection].Exp) >= self.Min) then
            self.Value = self.Value - 10^self.ValueTable[self.Selection].Exp
         end

         if (self.Selection == 1) then
            self.Value = self.Value * (-1)
         end

         val.updateValueTable(self.ValueTable, self.Value)
      end
   end

end -- >>>

val.pressed_Backspace = function(self) -- <<<
   if self.ValueString then
      self.ValueString = string.sub(self.ValueString, 1, -2)
   end
end -- >>>

val.Keys =
{
   ["return"]    = val.pressed_Return,
   ["escape"]    = val.pressed_Escape,
   ["left"]      = val.pressed_Left,
   ["right"]     = val.pressed_Right,
   ["up"]        = val.pressed_Up,
   ["down"]      = val.pressed_Down,
   ["backspace"] = val.pressed_Backspace,
}
-- >>>

val.keypressed = function(self, key, sc, isrepeat) -- <<<
   if val.Keys[key] then
      val.Keys[key](self)
   end
end -- >>>

val.textinput = function(self, text) -- <<<
   val.changeValue(self, text)
end -- >>>

val.wheelmoved = function(self, msx, msy) -- <<<

   local x,y = love.mouse.getPosition()

   if (y >= self.TopLeftY) and (y <= self.BottomRightY) then

      for i,v in ipairs(self.ValueTable) do
         if (v.Exp or 0) < 0 then DotOffset = 4 else DotOffset = 0 end
         if (x > self.TopLeftX+((i-1)*self.Font:getWidth("0"))+DotOffset) and (x < self.TopLeftX+(i*self.Font:getWidth("0"))+DotOffset) then

            if msy > 0 then
               if (i > 1) and ((self.Value + 10^v.Exp) <= self.Max) then
                  self.Value = self.Value + 10^v.Exp
                  val.updateValueTable(self.ValueTable, self.Value)
               end

            elseif msy < 0 then
               if (i > 1) and ((self.Value - 10^v.Exp) >= self.Min) then
                     self.Value = self.Value - 10^v.Exp
                     val.updateValueTable(self.ValueTable, self.Value)
               end
            end

         end
      end
   end
end -- >>>

val.drawBackground = function(self) -- <<<
   love.graphics.setColor(color.white)
   if self.ValueTable.DotPos then DotOffset = 4 else DotOffset = 0 end
   love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, (#self.ValueTable*self.Font:getWidth("0"))+DotOffset, self.Height)
end -- >>>

val.drawObject = function(self) -- <<<
   if self.Selection then
      love.graphics.setColor(color.lovegreen)
      if (self.ValueTable[self.Selection].Exp or 0) < 0 then DotOffset = 4 else DotOffset = 0 end
      love.graphics.rectangle("fill", self.TopLeftX+((self.Selection-1)*self.Font:getWidth("0"))+DotOffset, self.TopLeftY, self.Font:getWidth("0"), self.Height)
   end

   love.graphics.setFont(self.Font)
   love.graphics.setColor(color.black)
   if not self.ValueString then
      for i,v in ipairs(self.ValueTable) do
         if (v.Exp or 0) < 0 then DotOffset = 4 else DotOffset = 0 end
         love.graphics.print(v.Disp, self.TopLeftX+((i-1)*self.Font:getWidth("0"))+(DotOffset or 0), self.TopLeftY+7)
      end
      if self.ValueTable.DotPos then
         love.graphics.circle("fill", self.TopLeftX+((self.ValueTable.DotPos)*self.Font:getWidth("0"))+2, self.TopLeftY+self.Font:getHeight("0")+5, 1, 5)
      end
   else
      local maskValue = function() love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height) end
      local OffsetX = 0
      if self.Font:getWidth(self.ValueString) > self.Width then
         OffsetX = self.Width - self.Font:getWidth(self.ValueString)
      end
      setStencil(maskValue)
      love.graphics.print(self.ValueString, self.TopLeftX+1+OffsetX, self.TopLeftY+7)
      unsetStencil()
   end
end -- >>>

val.drawFrame = function(self) -- <<<
   if self.IsActive then
      love.graphics.setColor(color.ActiveFrame)
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, (#self.ValueTable*self.Font:getWidth("0"))+DotOffset, self.Height)
   end
end -- >>>

val.draw = function(self) -- <<<
   self:drawBackground()
   self:drawObject()
   self:drawFrame()
end -- >>>

function guru.newValue(x, y, numofdig, numofdigdecplace, min, max, init) -- <<<

   local x = x or 0
   local y = y or 0
   local h = h or 20

   local FontSize = 20
   local Font     = love.graphics.newFont("fonts/digital.ttf", FontSize)

   local self = setmetatable({}, Object_mt)

   self.FontSize   = FontSize
   self.Font       = Font
   self.Value      = init
   self.OldValue   = init
   self.ValueTable = val.initValueTable(init, numofdig, numofdigdecplace)
   self.Min        = min
   self.Max        = max

   self.keypressed     = val.keypressed
   self.wheelmoved     = val.wheelmoved
   self.textinput      = val.textinput
   self.drawBackground = val.drawBackground
   self.drawObject     = val.drawObject
   self.drawFrame      = val.drawFrame
   self.draw           = val.draw

   self.deactivate     = val.deactivate

   self.resize = function(self) -- <<<

      if self.ValueTable.DotPos then
         DotOffset = 4
      else
         DotOffset = 0
      end
      self.Width        = (#self.ValueTable * self.Font:getWidth("0")) + DotOffset
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

-- lst alias list <<<
local lst = {} -- list table

lst.insertElement = function(self, s, pos) -- <<<
   if type(s) ~= "string" then return end
   if (type(pos) ~= "number") and (pos ~= nil) then return end
   local pos = pos or (#self.List+1)
   if pos > (#self.List+1) then pos = #self.List+1 end
   table.insert(self.List, pos, s)
   self:update()
end -- >>>

lst.removeElement = function(self, pos) -- <<<
   if (type(pos) ~= "number") and (pos ~= nil) then return end
   local pos = pos or #self.List
   if pos > (#self.List) then return end
   table.remove(self.List, pos)
   self:update()
end -- >>>

lst.clearList = function(self) -- <<<
   local Size = #self.List
   for i=0, Size do self.List[i]=nil end
   self:update()
end -- >>>

-- table Keys <<<
lst.Keys =
{
   --["return"] = function(t) t.OldValue = t.Value; t.Selection=nil; t:deactivate() end,
   ["escape"] = function(t) t:deactivate() end,
   ["up"]     = function(t) t.Offset = t.Offset + 8; if t.Offset > 0   then t.Offset = 0   end end,
   ["down"]   = function(t) t.Offset = t.Offset - 8; if t.Offset < (t.Height-(#t.List * (t.FontSize+4))) then t.Offset = (t.Height-(#t.List * (t.FontSize+4))) end end,
   ["l"]      = function(t) t.List = getFinderSelection(); t.Offset = 0; t:update(); end,
}
-- >>>

lst.keypressed = function(self, key, sc, isrepeat) -- <<<
   if lst.Keys[key] then
      lst.Keys[key](self)
   end
end -- >>>

lst.mousepressed = function(self, x, y, button) -- <<<
   --local x = x - self.Parent.OffsetX
   --local y = y - self.Parent.OffsetY
   --if (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) then
   --   if button == "wu" then
   --      self.Offset = self.Offset + 8
   --      if self.Offset > 0 then
   --         self.Offset = 0
   --      end
   --   end
   --   if button == "wd" then
   --      self.Offset = self.Offset - 8
   --      if self.Offset < (self.Height-(#self.List * (self.FontSize+4))) then
   --         self.Offset = (self.Height-(#self.List * (self.FontSize+4)))
   --      end
   --   end
   --end
end -- >>>

lst.wheelmoved = function(self, msx, msy) -- <<<
   local x,y = love.mouse.getPosition()
   if (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) then
      if msy > 0 then
         self.Offset = self.Offset + 8
         if self.Offset > 0 then
            self.Offset = 0
         end
      elseif msy < 0 then
         self.Offset = self.Offset - 8
         if self.Offset < (self.Height-(#self.List * (self.FontSize+4))) then
            self.Offset = (self.Height-(#self.List * (self.FontSize+4)))
         end
      end
   end
end -- >>>

lst.drawScroller = function(x,y,w,h) -- <<<
   local Radius = w/2
   love.graphics.arc( "fill"      , x+Radius , y+Radius  , Radius , 1.0*math.pi , 2.0*math.pi , 20)
   love.graphics.arc( "fill"      , x+Radius , y+h-Radius, Radius , 2.0*math.pi , 3.0*math.pi , 20)
   love.graphics.rectangle("fill" , x        , y+Radius  , w      , h-(2*Radius))
end -- >>>

lst.drawBackground = function(self) -- <<<
   love.graphics.setColor(color.white)
   love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
end -- >>>

lst.drawObject = function(self) -- <<<
   local maskList = function() love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height) end

   if self.Height >= (#self.List * (self.FontSize+4)) then
      self.Offset = 0
      self.ScrollerNeeded = false
   else
      self.ScrollerNeeded = true
   end

   if type(self.List) == "table" then
      love.graphics.setFont(self.Font)
      setStencil(maskList)
      for i,v in ipairs(self.List) do
         love.graphics.setColor(color.black)
         love.graphics.print(v, self.TopLeftX+4, self.TopLeftY+self.Offset+((i-1)*(self.FontSize+4))+2)
         love.graphics.setColor(color.grey8)
         love.graphics.line( self.TopLeftX, self.TopLeftY+self.Offset+(i*(self.FontSize+4)), self.TopLeftX+self.Width, self.TopLeftY+self.Offset+(i*(self.FontSize+4)))
      end
      unsetStencil()
   end

   if self.ScrollerNeeded == true then
      local ScrollPosY = self.TopLeftY + ((self.Offset / self.MaxOffset) * self.MaxOffsetCorrected)
      love.graphics.setColor(color.grey9)
      love.graphics.rectangle("fill", self.BottomRightX-self.ScrollerWidth, self.TopLeftY, self.ScrollerWidth, self.Height)
      love.graphics.setColor(color.grey8)
      lst.drawScroller(self.BottomRightX-self.ScrollerWidth, ScrollPosY, self.ScrollerWidth, self.ScrollerHeight)
   end
end -- >>>

lst.drawFrame = function(self) -- <<<
   if self.IsActive then
      love.graphics.setColor(color.ActiveFrame)
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end
end -- >>>

lst.draw = function(self) -- <<<
   self:drawBackground()
   self:drawObject()
   self:drawFrame()
end -- >>>

lst.update = function(self) -- <<<

   self.ScrollerHeight     = math.max(25, self.Height * (self.Height/(#self.List * (self.FontSize+4))))
   self.ScrollerWidth      = 10
   self.MaxOffset          = self.Height - (#self.List * (self.FontSize+4))
   self.MaxOffsetCorrected = self.Height - self.ScrollerHeight

end -- >>>

function guru.newList(x, y, w, h, l) -- <<<

   local x = x or 0
   local y = y or 0

   local FontSize = 12
   local Font     = love.graphics.newFont("fonts/arial.ttf", FontSize)

   local self = setmetatable({}, Object_mt)

   self.FontSize     = FontSize
   self.Font         = Font
   self.List         = l or {}
   self.Offset       = 0

   self.keypressed     = lst.keypressed
   self.mousepressed   = lst.mousepressed
   self.wheelmoved     = lst.wheelmoved
   self.drawBackground = lst.drawBackground
   self.drawObject     = lst.drawObject
   self.drawFrame      = lst.drawFrame
   self.draw           = lst.draw
   self.update         = lst.update

   self.insertElement  = lst.insertElement
   self.removeElement  = lst.removeElement
   self.clearList      = lst.clearList

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self:resize()
   self:update()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

-- bar alias progressbar/slider <<<
local bar = {} -- bar table

bar.drawBackground = function(self) -- <<<
   love.graphics.setColor(color.white)
   love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.Height/2, self.Height/2, 20)
end -- >>>

bar.drawObject = function(self) -- <<<
   setStencil(self.maskBar)
   love.graphics.setColor(color.steel)
   love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, (self.Width * self.ValueNorm), self.Height)
   love.graphics.setColor(color.black)
   love.graphics.setFont(Fonts_t.sans)
   love.graphics.print(self.Value .. self.Unit, self.TopLeftX+(self.Width/2), self.TopLeftY+4) -- TODO fix printing coordinates
   unsetStencil()
end -- >>>

bar.drawFrame = function(self) -- <<<
   if self.IsActive then
      love.graphics.setColor(color.ActiveFrame)
   else
      love.graphics.setColor(color.InactiveFrame)
   end
   love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.Height/2, self.Height/2, 20)
end -- >>>

bar.draw = function(self) -- <<<
   self:drawBackground()
   self:drawObject()
   self:drawFrame()
end -- >>>

function guru.newBar(x,y,w,h,min,max,unit) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 20
   local h = h or 20
   local min = min or 0
   local max = max or 100
   local unit = unit or "%"

   local self = setmetatable({}, Object_mt)

   --self.keypressed     = bar.keypressed
   --self.mousepressed   = bar.mousepressed
   --self.textinput      = bar.textinput
   --self.activate       = bar.activate
   --self.deactivate     = bar.deactivate
   self.drawBackground = bar.drawBackground
   self.drawObject     = bar.drawObject
   self.drawFrame      = bar.drawFrame
   self.draw           = bar.draw
   --self.update         = bar.update

   self.Value     = 70
   self.ValueNorm = self.Value/(max-min) -- TODO make negative values work too
   self.Precision = 0.1
   self.Unit      = unit

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self.maskBar = function() -- <<<
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height, self.Height/2, self.Height/2, 20)
   end -- >>>

   self.setValue = function(self, value) -- <<<

      self.Value = value

      if self.Value > max then
         self.Value = max
      end

      if self.Value < min then
         self.Value = min
      end

      self.ValueNorm = math.abs(self.Value/(max-min))

   end -- >>>

   self.mousepressed = function(self, x, y, button, istouch) -- <<<
      local x = x - self.Parent.OffsetX
      local y = y - self.Parent.OffsetY

      if (self.IsEditable) and (button == 1) and (x >= self.TopLeftX) and (y >= self.TopLeftY) and (x <= self.BottomRightX) and (y <= self.BottomRightY) then
      --[[ EXAMPLE
      Precision = 0.1
      Value = 54.129 -> 54.1
      --]]
      -- TODO write a math.round function and maybe operate on self.Value instead of self.ValueNorm
         self.ValueNorm = math.floor((((x - self.TopLeftX)/self.Width)/(self.Precision/100)) + 0.5) * (self.Precision/100)
         self.Value = self.ValueNorm * max

         self.IsMouseEdit = true
      end
   end -- >>>

   self.mousereleased = function(self, x, y, button, istouch) -- <<<
      if (self.IsEditable) and (button == 1) then
         self.IsMouseEdit = false
      end
   end -- >>>

   self.mousemoved = function(self, x, y, dx, dy, istouch) -- <<<
      local x = x - self.Parent.OffsetX
      local y = y - self.Parent.OffsetY

      if self.IsMouseEdit then
         -- TODO write a math.round function and maybe operate on self.Value instead of self.ValueNorm
         self.ValueNorm = math.floor((((x - self.TopLeftX)/self.Width)/(self.Precision/100)) + 0.5) * (self.Precision/100)
         self.ValueNorm = math.keepWithinBounds(self.ValueNorm, 0, 1)
         self.Value = self.ValueNorm * max
      end
   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

function guru.newSlider(x,y,l,o,t) -- <<<

   local x = x or 0
   local y = y or 0
   local l = l or 300
   local o = o or "horizontal"
   local t = t or "classic"

   local self = setmetatable({}, Object_mt)

   --self.keypressed     = xxx.keypressed
   --self.mousepressed   = xxx.mousepressed
   --self.textinput      = xxx.textinput
   --self.activate       = xxx.activate
   --self.deactivate     = xxx.deactivate
   --self.drawBackground = xxx.drawBackground
   --self.drawObject     = xxx.drawObject
   --self.drawFrame      = xxx.drawFrame
   --self.draw           = xxx.draw
   --self.update         = xxx.update


   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self:resize()

   table.insert(Objects, self)

   self.Index = #Objects

   return self
end -- >>>

function guru.newGraph(t) -- <<<

   t.x      = t.x      or 0
   t.y      = t.y      or 0
   t.width  = t.width  or 400
   t.height = t.height or 400
   t.data   = t.data   or {}

   local self = setmetatable({}, Object_mt)

   -- public variables <<<
   t.BackgroundColor = t.BackgroundColor or color.white
   self.BackgroundColor = t.BackgroundColor
   -- >>>

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(t.width)
      self.Height       = toYPixel(t.height)
      self.TopLeftX     = toXPixel(t.x)
      self.TopLeftY     = toYPixel(t.y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self.draw = function(self) -- <<<
      -- draw background <<<
      love.graphics.setColor(self.BackgroundColor)
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
      -- >>>
      -- draw grid <<<
      -- >>>
      -- draw graph <<<
      -- >>>
      -- draw frame <<<
      if self.IsActive then
         love.graphics.setColor(color.ActiveFrame)
      else
         love.graphics.setColor(color.InactiveFrame)
      end
      love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
      -- >>>
   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>

-- grd alias grid <<<
local grd = {} -- grid table

grd.insertElement = function(self, e, pos) -- <<<
   if type(e) ~= "table" then return end
   if (type(pos) ~= "number") and (pos ~= nil) then return end
   local pos = pos or (#self.Elements+1)
   if pos > (#self.Elements+1) then pos = #self.Elements+1 end
   table.insert(self.Elements, pos, e)
   self.ElementHeight = math.max(self.ElementHeight, e.Height)
   self.ElementWidth  = math.max(self.ElementWidth , e.Width )
   self:resize()
end -- >>>

grd.removeElement = function(self, pos) -- <<<
   if (type(pos) ~= "number") and (pos ~= nil) then return end
   local pos = pos or #self.Elements
   if pos > (#self.Elements) then return end
   table.remove(self.Elements, pos)
   self:resize()
end -- >>>

function guru.newGrid(x,y,w,h) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 20
   local h = h or 20

   local self = setmetatable({}, Object_mt)

   self.MinSpacingX    = 20
   self.SpacingX       = 20
   self.SpacingY       = 20
   self.MarginX        = 10
   self.MarginY        = 10
   self.ElementsPerRow = 1
   self.Elements       = {}
   self.ElementHeight  = 0
   self.ElementWidth   = 0
   self.insertElement  = grd.insertElement
   self.removeElement  = grd.removeElement

   self.draw = function(self)
      if self.IsActive then
         love.graphics.setColor(color.ActiveFrame)
         love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
      end
   end

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

      self.ElementsPerRow = math.floor(self.Width / (self.ElementWidth + self.MinSpacingX))

      if #self.Elements < self.ElementsPerRow then
         self.SpacingX = self.MinSpacingX
      else
         self.SpacingX = (self.Width - self.MinSpacingX - (self.ElementWidth*self.ElementsPerRow)) / (self.ElementsPerRow-1)
      end

      for i,e in ipairs(self.Elements) do

         local col =           ((i-1) % self.ElementsPerRow) + 1
         local row = math.floor((i-1) / self.ElementsPerRow) + 1

         self.Elements[i].TopLeftX     = self.TopLeftX + self.MarginX + ((col-1)*(self.SpacingX+self.ElementWidth))
         self.Elements[i].TopLeftY     = self.TopLeftY + self.MarginY + ((row-1)*(self.SpacingY+self.ElementHeight))
         self.Elements[i].BottomRightX = self.Elements[i].TopLeftX + self.Elements[i].Width
         self.Elements[i].BottomRightY = self.Elements[i].TopLeftY + self.Elements[i].Height

      end
   end -- >>>

   self:resize()

   --table.insert(Backdrop.Objects, self)
   --self.Index = #Backdrop.Objects

   return self
end -- >>>
-- >>>

function guru.newScroller(x,y,w,h) -- <<<

   local x = x or 0    -- top left pos x
   local y = y or 0    -- top left pos y
   local w = w or "1"  -- window width
   local h = h or "1"  -- window height

   local ww = 0        -- world width
   local wh = 0        -- world height
   local tm = 0        -- top margin
   local bm = 0        -- bottom margin
   local lm = 0        -- left margin
   local rm = 0        -- right margin
   local sx = 0        -- scroll value x
   local sy = 0        -- scroll value y
   local px = 5        -- scroll amount/speed x
   local py = 5        -- scroll amount/speed y
   local dx =-1        -- scroll direction x
   local dy = 1        -- scroll direction y
   local sw = 8        -- scroll width
   local syl =25       -- y scroller length
   local sxl =25       -- x scroller length
   local sr =sw/2      -- scroll radius
   local syneed=false
   local sxneed=false

   local self = setmetatable({}, Container_mt)


   maskWorld = function() -- <<<
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end -- >>>

   drawScroller = function(x,y,w,h) -- <<<
      love.graphics.setColor(0,0,0,100)
      love.graphics.rectangle("fill", x, y, w, h, sr, sr, 10)
      love.graphics.setColor(255,255,255,100)
      love.graphics.rectangle("line", x, y, w, h, sr, sr, 10)
   end -- >>>


   self.calcOffset = function(self) -- <<<
      self.OffsetX = (self.TopLeftX+sx+lm)
      self.OffsetY = (self.TopLeftY+sy+tm)
   end -- >>>

   self.update = function(self, dt) -- <<<
      for i,v in ipairs(self.Objects) do
         if self.Objects[i].update then
            self.Objects[i]:update(dt)
         end
      end
   end -- >>>

   self.wheelmoved = function(self,x,y) -- <<<

      local XPos,YPos = love.mouse.getPosition()
      if (XPos >= self.TopLeftX) and (YPos >= self.TopLeftY) and (XPos <= self.BottomRightX) and (YPos <= self.BottomRightY) then

         local d=love.keyboard.isDown
         if (syneed or sxneed) and (not d("lshift")) and (not d("rshift"))
                               and (not d("lalt"))   and (not d("ralt"))
                               and (not d("lgui"))   and (not d("rgui"))
                               and (not d("lctrl"))  and (not d("rctrl")) then

            sx = math.keepWithinBounds(sx + (x * px * dx), self.Width  - ww, 0)
            sy = math.keepWithinBounds(sy + (y * py * dy), self.Height - wh, 0)

            self:calcOffset()

         end
      end 
   end -- >>>

   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

      for i,e in ipairs(self.Objects) do
         ww = math.max(self.Width , ww, e.TopLeftX + e.Width  + lm + rm)
         wh = math.max(self.Height, wh, e.TopLeftY + e.Height + tm + bm)
      end

      if ww > self.Width then
         sxl = math.max(25, (self.Width/ww)*self.Width)
         sxneed = true
      else
         sxneed = false
      end

      if wh > self.Height then
         syl = math.max(25, (self.Height/wh)*self.Height)
         syneed = true
      else
         syneed = false
      end

      self:calcOffset()

   end -- >>>

   self.drawBackground = function(self) -- <<<
      love.graphics.setColor(color.white)
      love.graphics.rectangle("fill", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
   end -- >>>

   self.drawObject = function(self) -- <<<

      love.graphics.setScissor(self.TopLeftX, self.TopLeftY, self.Width, self.Height)
      love.graphics.push()
      love.graphics.translate(self.TopLeftX+sx+lm, self.TopLeftY+sy+tm)

      for i,e in ipairs(self.Objects) do
         e:draw()
      end

      love.graphics.pop()
      love.graphics.setScissor()

      if syneed then
         drawScroller(self.BottomRightX-sw, self.TopLeftY+((math.abs(sy)/(wh-self.Height))*(self.Height-syl)), sw , syl)
      end

      if sxneed then
         drawScroller(self.TopLeftX+((math.abs(sx)/(ww-self.Width))*(self.Width-sxl)), self.BottomRightY-sw, sxl, sw)
      end

   end -- >>>

   self.drawFrame = function(self) -- <<<
      if self.IsActive then
         love.graphics.setColor(color.ActiveFrame)
         love.graphics.rectangle("line", self.TopLeftX, self.TopLeftY, self.Width, self.Height)
      end
   end -- >>>

   self.draw = function(self) -- <<<
      self:drawBackground()
      self:drawObject()
      self:drawFrame()
   end -- >>>

   self:resize()

   table.insert(Backdrop.Objects, self)

   self.Index = #Backdrop.Objects

   return self
end -- >>>

--]===]


--[[ TEMPLATE
function guru.newFoo(x,y,w,h) -- <<<

   local x = x or 0
   local y = y or 0
   local w = w or 20
   local h = h or 20

   local self = setmetatable({}, Object_mt)

   self.keypressed     = xxx.keypressed
   self.mousepressed   = xxx.mousepressed
   self.textinput      = xxx.textinput
   self.activate       = xxx.activate
   self.deactivate     = xxx.deactivate
   self.drawBackground = xxx.drawBackground
   self.drawObject     = xxx.drawObject
   self.drawFrame      = xxx.drawFrame
   self.draw           = xxx.draw
   self.update         = xxx.update


   self.resize = function(self) -- <<<

      self.Width        = toXPixel(w)
      self.Height       = toYPixel(h)
      self.TopLeftX     = toXPixel(x)
      self.TopLeftY     = toYPixel(y)
      self.BottomRightX = self.TopLeftX + self.Width
      self.BottomRightY = self.TopLeftY + self.Height

   end -- >>>

   self:resize()

   table.insert(Objects, self)

   self.Index = #Objects

   return self
end -- >>>
--]]

return guru

-- vim: fmr=<<<,>>> fdm=marker
