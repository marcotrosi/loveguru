local guru = require "guru"

function MyButtonFunc() -- <<<
   --tb1.Text = "button pressed"
   print("button pressed")
end -- >>>


function love.load() -- <<<

   --guru.load({theme = "love"}) -- "love", "white", "lgrey", "dgrey", "macos"
   guru.load()

   -- create gui objects here <<<
   -- guru.newButton(MyButtonFunc, {x=30, y=30, image="graphics/button_graphic.png", width=100, tooltip="fo foo fooo"})
   -- guru.newButton(MyButtonFunc, {x=30, y=200, text="push"})
   -- btn0  = guru.newButton(MyButtonFunc, {x=300, y=10})
   -- btn1  = guru.newButton(MyButtonFunc, {text="Press Me", x=50, y=10, tooltip="Use this button\nto do crazy stuff", name="btn1"})
   -- btn2  = guru.newButton(MyButtonFunc, {x=50, y=100,  image="graphics/button.png", tooltip="vimeo", name="btn2", cornerradius=6})
   -- btn3  = guru.newButton(MyButtonFunc, {x=50, y=350, width=64, height=40, image="graphics/button.png", tooltip="vimeo", name="btn3", cornerradius=6})
   -- btn4  = guru.newButton(MyButtonFunc, {x=50, y=450, width=70, image="graphics/button.png", tooltip="vimeo", name="btn4", cornerradius=6})
   -- btn5  = guru.newButton(MyButtonFunc, {x=50, y=550, height=50, image="graphics/button.png", tooltip="vimeo", name="btn5", cornerradius=6})
   -- btn6  = guru.newButton(MyButtonFunc, {text="click me", x=50, y=800, image="graphics/9.png", cornerradius=4})
   -- btn7  = guru.newButton(MyButtonFunc, {text="click me", x=300, y=800, width=128, height=111, image="graphics/btn.png"})
   -- btn8  = guru.newButton(MyButtonFunc, {text="click me", x=600, y=800, image="graphics/black.png", scaling="stretch"})
   img0  = guru.newImage("graphics/pic.png", {width=800, backcolor=guru.Color.black})
   --tb1   = guru.newTextBox(10, 10, 300, 20)
   --tb2   = guru.newTextBox(320, 10, 300, 20); tb2.MaxCharacters = 5; tb2.ValidCharacters = [[%d]]
   --tog   = guru.newToggle(700, 10, 20)
   --menu  = guru.newMenu(730, 10, 60, 20, {"one", "two", "three", "four", "five"})
   --value = guru.newValue(10, 40, 2, 2, -10, 50, 0)
   --list  = guru.newList(80, 40, 340, 100, {"Das","ist","eine", "laaange", "Liste", "1", "2", "3", "4", "5", "6", "7"})
   --pbar  = guru.newBar(540, 40, 250, 20); pbar:setValue(20); pbar.IsEditable = true
   --txtfld = guru.newTextfield(410,260, 360, 300)
   --scrl  = guru.newScroller(10, 260, 380, 330); scrl:insertElement(img)
   --list:removeElement(4); list:insertElement("Nummern",4); list:removeElement()
   --list:clearList(); list:insertElement("Liste leer")
   --grid = guru.newGrid(440, 80, 400, 400); grid:insertElement(btn1); grid:insertElement(btn2)
   --local Radio = {}
   --rad1 = guru.newToggle(10, 70, 14, Radio)
   --rad2 = guru.newToggle(10, 90, 14, Radio)
   --rad3 = guru.newToggle(10,110, 14, Radio)
   --rad4 = guru.newToggle(10,130, 14, Radio)
   --graph = guru.newGraph{x=20,y=20,width=300,height=300, data={}}
   --graph.Name = "graph"
   -- >>>

end -- >>>

function love.directorydropped(path) -- <<<
   guru.directorydropped(path)
end -- >>>

function love.filedropped(file) -- <<<
   -- print("1", love.mouse.getPosition())
   -- love.event.pump()
   -- print("2", love.mouse.getPosition())
   guru.filedropped(file)
end -- >>>

function love.keypressed(key, sc, isrepeat) -- <<<

   if key == "f12" then
      guru.DevMode = not guru.DevMode
      return
   end

   if key == "f11" then
      guru.saveState()
      return
   end

   if key == "f10" then
      guru.loadState()
      return
   end

   guru.keypressed(key, sc, isrepeat)
end -- >>>

function love.mousepressed(x, y, button, istouch) -- <<<
   guru.mousepressed(x, y, button, istouch)
end -- >>>

function love.mousereleased(x, y, button, istouch) -- <<<
   guru.mousereleased(x, y, button, istouch)
end -- >>>

function love.mousemoved(x, y, dx, dy) -- <<<
   guru.mousemoved(x,y,dx,dy)
end -- >>>

function love.wheelmoved(dx, dy) -- <<<
   guru.wheelmoved(dx, dy)
end -- >>>

function love.textinput(text) -- <<<
   guru.textinput(text)
end -- >>>

function love.resize(w, h) -- <<<
   guru.resize(w,h)
end -- >>>

function love.update(dt) -- <<<
   guru.update(dt)
end -- >>>

function love.draw() -- <<<
   guru.draw()
end -- >>>

--function love.errhand(msg) -- <<<
   --love.window.showMessageBox( "internal error", msg, "error", true )

    --TODO add buttons to ask to send logfile
--end -- >>>
