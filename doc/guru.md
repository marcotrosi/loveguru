#LOVE.GURU

##CONTENT
- [INFO][info]
- [HISTORY][log]
- [DOCUMENTATION][doc]
- [FAQ][faq]
- [TODO][todo]

[comment]: # ("INFO <<<")
##INFO [info]
LoveGuru is a GUI library for Löve2D game engine developed by Marco Trosi (www.marcotrosi.com).
It was tested with Löve2D version 0.10.1 on OSX 10.8.5 only.

[comment]: # (">>>")

[comment]: # ("HISTORY <<<")
##HISTORY[^leg] [log] 
| DATE       | VERSION | DESCRIPTION                                                                                                                 |
| ---------- | ------- | --------------------------------------------------------------------------------------------------------------------------- |
| 2016.10.23 | 0.1.0   | initial version                                                                                                             |

[^leg]: \+ added<br>\- removed<br>\> improved<br>= changed<br>\! bugfix
             
[comment]: # (">>>")

[comment]: # ("DOCUMENTATION <<<")
##DOCUMENTATION [doc]
    function foo(bar)
    end

[comment]: # (">>>")

[comment]: # ("FAQ <<<")
##FAQ [faq]
>Q: What is the purpose of these strange triple angle brackets?
>A: These are fold marks for Vim (www.vim.org). See last line and the Vim documentation (:h folds<CR> OR :h fold-marker<CR>).

>Q: Why is the code so weird?
>A: Because I have no experience in GUI lib programming and therefore had no idea what I was doing. I just started.

>Q: What is the concept?
>A: Em - good question, next question!

[comment]: # (">>>")

[comment]: # ("TODO <<<")
##TODO [todo]
- Bugs
    - drawCoordinates uses red lines with oppacity 100, but sometimes lines appear fully read like with oppacity 255
- General
    - use isDown(a,b,c,d) instead of isDown and isDown and isDown ..
    - test how getWrap behaves if \n is used in string
    - will it make sense to get mouse inside the guru.update function and save x,y globally, CALCULATE values ones in the beginning or in update function only
    - scroller + obj (add metafunction)
    - when is it usefull to call the garbage collector?
    - DevMode
        - user can add OBJ.Name = "myButton"
        - on load.exit or F11 write info file
    - move all masking functions to the new<OBJ> function
    - check which variables shall be private and offer set/get functions for them
    - change structure to real closure OOP
    - calcPos uses private variables which contain the position, the others tlx, tly, brx, bry are calculated
    - OBJ.update -> OBJ.calcPosition, OBJ.update for real updates
    - do same list for mouse buttons as for keystrokes
    - give names to all key_pressed functions and change t to self
    - protect execute function call
    - cleanup object design
    - cleanup colors
    - test and test with others operating systems and change code accordingly e.g. getFinderSelection
    - code documentation
    - markdown documentation
- TextboxObject
    - add update function, in general use new ideas from Textfield
- MenuObject
    - insert,remove Elements
    - use keys to jump to elements (alphabet)
- ValueObject
    - add arithmetic feature to value, so that you can type +123 -123 etc.
    - make value object changeable like a slider -> low prio because scrolling is already supported
    - add an optional unit field to the value object?
        - the unit could be changed with a context menu, automatic value conversion, baseunit needed
        - the unit could be text or image
- ListObject
    - make list elements selectable with shift and ctrl, and change/copy/paste support, add and delete button and shiftable
    - shift multi-selection too and group them
    - make list scrollable horiz, use scrollable object
- ImageObject
    - zoom in/out and reset zoom and orig size
- NewObjects
    - sliders |=======O---------|  |----O===+---------|  |----O========O---|
                   normal                centered             asymetric    
    - knob
    - multiline text field, use scrollable
    - data graph object
    - color picker
    - context menu
    - tab, maybe the tab is not a container but just the tabline
- NewObjectFeatures
    - position & dimensions in %
    - make object invisible
    - make object inactive
    - make object editable -> this way I can have a non-editable object but still can copy from it
    - Add design mode
        - make object movable
        - make object resizeable
        - show pos and size when changing
        - maybe make pos,size storable which would result in a layout feature, loadable layouts

[comment]: # (">>>")

