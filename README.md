# Stormworks-Easy-Buttons
Use with Stormworks Lua with LifeBoatAPI in VS Code

This module for Stormworks Lua creates easy and clean buttons.
The button can be a push or a toggle button.
The buttons get automatically updated and trigger the target functions of the button.

<h2>Setup:</h2>
<ul>
<li>Download file.</li>
<li>Put it in your project directory.</li>
<li>Use "require("easyButtons")" to add into your project.</li>
<li>Create a new button with "newButton(x, y, width, height, text, target, frameColor, innerColor, pressedColor, activeColor, textColor, isToggle, horizontalTextAlign, verticalTextAlign)".</li>
<li>Put "onTickButtons(isPressed, touchX, touchY)" with your screen touch input into "onTick()".</li>
<li>Put "onDrawButtons()" in "onDraw()".</li>
</ul>

<h3>VS Code Extension:</h3>
https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi

