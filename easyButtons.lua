__buttons = {}

--- @param x number
---@param y number
---@param width number
---@param height number
---@param text string
---@param target function
---@param frameColor table = {255, 255, 255}
---@param innerColor table | nil
---@param pressedColor table | nil
---@param activeColor table | nil
---@param textColor table = {255, 255, 255}
---@param isToggle boolean | nil = false
---@param horizontalAlign number -1: left; 0: center; 1: right
---@param verticalAlign number -1: top; 0: center; 1: bottom
function newButton(x, y, width, height, text, target, frameColor, innerColor, pressedColor, activeColor, textColor,
                   isToggle, horizontalAlign, verticalAlign)
    if x == nil or y == nil or width == nil or height == nil or text == nil or target == nil then
        return
    end

    if frameColor == nil then
        frameColor = { 255, 255, 255 }
    end
    if textColor == nil then
        textColor = { 255, 255, 255 }
    end

    if isToggle == nil then
        isToggle = false
    end

    if horizontalAlign == nil then
        horizontalAlign = 0
    end
    if verticalAlign == nil then
        verticalAlign = 0
    end

    buttonNew = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["text"] = text,
        ["isToggle"] = isToggle,
        ["horizontalAlign"] = horizontalAlign,
        ["verticalAlign"] = verticalAlign,
        ["target"] = target,
        ["frameColor"] = frameColor,
        ["innerColor"] = innerColor,
        ["pressedColor"] = pressedColor,
        ["activeColor"] = activeColor,
        ["textColor"] = textColor,
        ["isPressed"] = false,
        ["isHeld"] = false,
        ["isActive"] = false
    }

    table.insert(__buttons, buttonNew)
end

function buttonTick(isPressed, touchX, touchY)
    for key, button in pairs(__buttons) do
        -- check if button is pressed
        isBtnPressed = isPressed and
            __isPointInRectangle(touchX, touchY, button["x"], button["y"], button["width"], button["height"])
        __buttons[key]["isPressed"] = isBtnPressed

        -- check if button pressed
        if isBtnPressed then
            -- just execute when button is freshly pushed
            if not button["isHeld"] then
                -- function of button
                if button["isToggle"] then
                    __buttons[key]["isActive"] = not button["isActive"]
                else
                    __buttons[key]["isActive"] = true
                    button["target"]()
                end
            else
                if not button["isToggle"] then
                    __buttons[key]["isActive"] = false
                end
            end
            __buttons[key]["isHeld"] = true

            -- check if button released
        elseif not isBtnPressed and button[key]["isHeld"] then
            __buttons[key]["isHeld"] = false
        end

        -- execute constant if toggle button and active
        if button["isToggle"] and button["isActive"] then
            button["target"]()
        end
    end
end

function drawButton()
    for key, button in pairs(__buttons) do
        -- button background
        if button["innerColor"] ~= nil then
            -- decides the color after is isActive and isToggle
            if not button["isActive"] then
                screen.setColor(button["innerColor"].unpack)
            elseif button["isActive"] then
                -- set color when active
                if button["isToggle"] then
                    -- check if active color exists
                    if not button["activeColor"] == nil then
                        screen.setColor(button["activeColor"].unpack)
                    else
                        screen.setColor(button["innerColor"].unpack)
                    end
                else
                    -- check if pressed color exists
                    if not button["pressedColor"] == nil then
                        screen.setColor(button["pressedColor"].unpack)
                    else
                        screen.setColor(button["innerColor"].unpack)
                    end
                end
            end

            screen.drawRectF(button["x"], button["y"], button["width"], button["height"])
        end

        -- button frame
        screen.setColor(button["frameColor"].unpack)
        screen.drawRect(button["x"], button["y"], button["width"], button["height"])

        -- button text
        screen.setColor(button["textColor"].unpack)
        screen.drawTextBox(button["x"], button["y"], button["width"], button["height"], button["text"],
            button["horizontalAlign"], button["verticalAlign"])
    end
end

-- private functions
function __isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end
