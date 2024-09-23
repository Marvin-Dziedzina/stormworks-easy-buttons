# Stormworks-Easy-Buttons
This module for Stormworks Lua makes creating buttons on screens very easy. You can create push or toggle buttons. The buttons will trigger your specified functions. Use tags to easily distinguish between buttons.

Use newButton(x, y, width, height, text, target, args, frameColor, innerColor, pressedColor, activeColor, textColor, isToggle, horizontalTextAlign, verticalTextAlign, tag) to create a new button.
Use removeButtons(tag) to remove a button from the screen.

This script also contains the standard isPointInRectangle(x, y, rectX, rectY, rectW, rectH) function for checking if a point is in a rectangle.

Use with the "Stormworks Lua with LifeBoatAPI" extension in VS Code for best usage experience.

## Setup:
- Download file.
- Put it in your project directory.
- Use "require("easyButtons")" to add into your project.
- Create a new button with "newButton(x, y, width, height, text, target, frameColor, innerColor, pressedColor, activeColor, textColor, isToggle, horizontalTextAlign, verticalTextAlign)".
- Put "onTickButtons(isPressed, touchX, touchY)" with your screen touch input into "onTick()".
- Put "onDrawButtons()" in "onDraw()".

### VS Code Extension:
https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi

