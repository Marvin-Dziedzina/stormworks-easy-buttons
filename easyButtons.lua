local __buttons = {}

local t = true
local f = false

--- Use this function to create new buttons.
---@param x number The left upper coordinate in px.
---@param y number The left upper coordinate in px.
---@param width number The width of the button in px.
---@param height number The height of the button in px.
---@param text string The text that is displayed on the button.
---@param horizontalTextAlign number | nil = 0; -1: left; 0: center; 1: right.
---@param verticalTextAlign number | nil = 0; -1: top; 0: center; 1: bottom.
---@param target function The function that should get executed if clicked or toggled.
---@param args table | nil The arguments to the target function. Input a table with the parameters in right order. Example: {246, 900}.
---@param frameColor table | nil = {255, 255, 255}; RGB or RGBA colors in a table.
---@param innerColor table | nil RGB or RGBA colors in a table.
---@param pressedColor table | nil RGB or RGBA colors in a table just for push button.
---@param activeColor table | nil RGB or RGBA colors in a table just for toggle button.
---@param textColor table | nil = {255, 255, 255}; RGB or RGBA colors in a table.
---@param toggle boolean | nil = false; If the button should be a push or a toggle button.
---@param tags table<string> | nil If you want to identify this special button. Can also be used on more buttons to identify groups. If `nil` this button will always be active and displayed.
---@return boolean isSuccessful If the operation was successful.
function newButton(x, y, width, height, text, target, args, frameColor, innerColor, pressedColor, activeColor, textColor,
                   toggle, horizontalTextAlign, verticalTextAlign, tags)
    if not (x and y and width and height and target) then return f end

    __buttons[#__buttons + 1] = {
        tags = tags or {},
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        toggle = toggle or f,
        horizAlign = horizontalTextAlign or 0,
        vertAlign = verticalTextAlign or 0,
        target = target,
        args = args,
        frameColor = frameColor or { 255, 255, 255 },
        innerColor = innerColor,
        pressedColor = pressedColor,
        activeColor = activeColor,
        textColor = textColor or { 255, 255, 255 },
        pressed = f,
        held = f,
        active = f
    }

    return t
end

--- This function removes all buttons if nil as argument or all buttons with the tag specified.
---@param tags table<string> | nil The tag you want to delete leave empty if you want to delete all.
function removeButtons(tags)
    if tags == nil then
        __buttons = {}
    else
        local filtered = {}
        for i = 1, #__buttons do
            if tableContainsValueFromTable(__buttons[i].tags, tags) then
                filtered[#filtered + 1] = __buttons[i]
            end
        end
        __buttons = filtered
    end
end

--- Put this in your onTick function. This calculates all presses and callbacks of each button in the `tags` table.
--- If `tags` is nil all buttons will be updated.
--- All buttons that have no tags will be updated independent of the args supplied.
---@param isPressed boolean If the screen was pressed.
---@param touchX number The x coordinate in px where the screen got pressed.
---@param touchY number The y coordinate in px where the screen got pressed.
---@param tags table<string> | nil Update just the buttons with the tags provided.
---@return boolean isPressOnBtn If the touch position is over at least one button.
---@return boolean isBtnActivated If the press activated at least one button.
function onTickButtons(isPressed, touchX, touchY, tags)
    tags = tags or {}

    local isPressOnBtn, isBtnActivated = f, f

    local function updateButton(btn)
        -- get button press status
        local pressed = isPressed and
            isPointInRectangle(touchX, touchY, btn.x, btn.y, btn.width, btn.height)
        btn.pressed = pressed

        -- check if button pressed
        -- just execute when button is freshly pushed
        local held = btn.held
        if pressed and not held then
            -- check if toggle.
            if btn.toggle then
                btn.active = not btn.active
            else
                btn.active = t
            end
            held = t
        elseif not pressed and held then
            -- check if button released
            held = f
        end

        -- execute if active
        if btn.active then
            if btn.args ~= nil then
                btn.target(table.unpack(btn.args))
            else
                btn.target()
            end

            -- reset active if a push button
            if not btn.toggle then
                btn.active = f
            end

            isBtnActivated = t
        end

        if pressed then
            isPressOnBtn = t
        end
    end

    for i = 1, #__buttons do
        local btn = __buttons[i]
        if next(tags) == nil then
            updateButton(btn)
        else
            if tableContainsValueFromTable(btn.tags, tags) or next(btn.tags) == nil then
                updateButton(btn)
            end
        end
    end

    return isPressOnBtn, isBtnActivated
end

--- Put this function in your onDraw function. This will draw all buttons on their specified place.
--- All buttons that have no tags will be drawn independent of the tags supplied.
---@param tags table<string> | nil Update the buttons that are marked with a tag in `tags`. Buttons without `tags` will be updated too.
function onDrawButtons(tags)
    tags = tags or {}

    local function drawButton(btn)
        local innerColor = btn.innerColor
        -- button background
        -- toggle
        if btn.toggle then
            local active = btn.active
            if active then
                local activeColor = btn.activeColor
                if activeColor then
                    screen.setColor(table.unpack(activeColor))
                end
            elseif innerColor then
                screen.setColor(table.unpack(innerColor))
            end
        else
            -- button background
            -- push
            local isPressed = btn.pressed
            if isPressed then
                -- check if pressed color exists and apply it
                local pressedColor = btn.pressedColor
                if pressedColor ~= nil then
                    screen.setColor(table.unpack(pressedColor))
                elseif innerColor then
                    screen.setColor(table.unpack(innerColor))
                end
            elseif innerColor then
                -- inactive
                screen.setColor(table.unpack(innerColor))
            end
        end

        local x, y, w, h = btn.x, btn.y, btn.width, btn.height
        -- button background
        screen.drawRectF(x, y, w, h)

        -- button frame
        screen.setColor(table.unpack(btn.frameColor))
        screen.drawRect(x, y, w, h)

        -- button text
        screen.setColor(table.unpack(btn.textColor))
        screen.drawTextBox(x + 1, y + 1, w + 1, h, btn.text,
            btn.horizAlign, btn.vertAlign)
    end

    for i = 1, #__buttons do
        local btn = __buttons[i]
        if next(tags) == nil then
            drawButton(btn)
        else
            if tableContainsValueFromTable(btn.tags, tags) or next(btn.tags) == nil then
                drawButton(btn)
            end
        end
    end
end

---Check if `table1` contains at least one of the elements that `table2` contains.
---All elements from `table1` and `table2` should be comparable with each other.
---@param table1 table The table thats gets checked for all table2's values.
---@param table2 table The table that's elements get compared.
---@return boolean | nil contains If `table1` contains at least one element of `table2`.
function tableContainsValueFromTable(table1, table2)
    for i = 1, #table2 do
        if tableContainsValue(table1, table2[i]) then return t end
    end
end

---Check if `table` contains `value`.
---All elements from `table` should be comparable to `value`.
---@param table table The table that gets checked for `value`.
---@param value all The value that get compared.
---@return boolean | nil contains If `table` contains `value`.
function tableContainsValue(table, value)
    for i = 1, #table do
        if table[i] == value then return t end
    end
end

-- Return true if point is in rect when not return false
function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end
