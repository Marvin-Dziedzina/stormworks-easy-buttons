screen = {
    drawRectF = function() end,
    drawRect = function() end,
    setColor = function() end,
    drawTextBox = function() end,
}

input = {
    getBool = function() end,
    getNumber = function() end,
}


require("easyButtons")

local drawRect = false
local function testBtn()
    drawRect = true
end

local startup = true
function onTick()
    if startup then
        newButton(4, 4, 10, 10, "T", testBtn, nil, { 255, 255, 255 }, nil, nil, nil, { 255, 0, 0 }, nil, nil, nil, nil)
    end

    local isPressed = input.getBool(1)
    local touchX, touchY = input.getNumber(3), input.getNumber(4)

    onTickButtons(isPressed, touchX, touchY)
end

function onDraw()
    onDrawButtons()

    if drawRect then
        screen.drawRectF(0, 0, 3, 3)
        drawRect = false
    end
end

while true do
    onTick()
    onDraw()
end
