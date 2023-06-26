# stormworks-easy-buttons
Use with Stormworks Lua with LifeBoatAPI in VS Code

This module for stormworks lua creates easy and clean buttons.
Use require("easyButtons") to add into your project.
Create a new button with newButton(x, y, width, height, text, target, frameColor, innerColor, pressedColor, activeColor, textColor, isToggle, horizontalTextAlign, verticalTextAlign)
Put onTickButtons(isPressed, touchX, touchY) with your screen touch input into onTick().
Put onDrawButtons() in onDraw().

The buttons get automatically updated and trigger the target of the button.

Extension:
https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi

