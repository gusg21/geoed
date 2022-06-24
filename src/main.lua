-- LIBRARIES
local nuklear = require "nuklear"

Ed = {
    -- UI STATE
    ui = nil,

    -- CAMERA
    x = 0,
    y = 0,
    zoom = 1,
    
    initial_drag_pos = {x = 0, y = 0},
    dragging = false,
    apply_cam = function ()
        love.graphics.push()
        love.graphics.translate(math.floor(Ed.x), math.floor(Ed.y))
    end,
    remove_cam = function ()
        love.graphics.pop()
    end,

    -- SETTINGS
    show_settings = false,
    bg_color = "#000000",
    grid_size = 16,
    grid_cell_canvas = nil,
    update_grid = function()
        Ed.grid_cell_canvas = love.graphics.newCanvas(Ed.grid_size, Ed.grid_size)
        Ed.grid_cell_canvas:setWrap("repeat", "repeat")
        love.graphics.setCanvas(Ed.grid_cell_canvas)
        love.graphics.setColor(Ed.parseColor("#55555588"))
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", 0, 0, 16, 16)
        love.graphics.setCanvas()
    end,

    -- TOOLS
    current_tool = "line",
    tools = {
        ["line"] = require "tools.line",
        ["eraser"] = require "tools.eraser"
    },
    tool_call = function(func_name, ...)
        if Ed.tools[Ed.current_tool][func_name] then
            Ed.tools[Ed.current_tool][func_name](...)
        end
    end,

    -- UTILITIES
    parseColor = function(colorStr)
        r2, g2, b2, a2 = nuklear.colorParseRGBA(colorStr)
        return r2 / 255, g2 / 255, b2 / 255, a2 / 255
    end
}

--
-- LOVE callbacks
--
function love.load(arg)
    Ed.ui = nuklear.newUI()
    require("skin1")(Ed.ui)

    Ed.update_grid()
end

function love.update(dt)
    -- Dragging
    if Ed.dragging then
        wx, wy = love.graphics.inverseTransformPoint(love.mouse.getPosition())
        Ed.x = Ed.initial_drag_pos.x + wx
        Ed.y = Ed.initial_drag_pos.y + wy
    end

    -- UI structure
    Ed.ui:frameBegin()
	if Ed.ui:windowBegin("G E O E D", 0, 0, 140, love.graphics.getHeight(), "border", "title") then
        Ed.ui:layoutRow("static", 20, 120, 1)

        -- HEADER
		Ed.ui:label("by Angus Goucher", "centered")

        -- TOOLS
        Ed.ui:label("- TOOLS -", "centered")
        Ed.ui:label("Current tool: " .. Ed.current_tool, "centered")
        if Ed.ui:button("LINE") then Ed.current_tool = "line" end
        if Ed.ui:button("ERASER") then Ed.current_tool = "eraser" end

        Ed.tool_call("ui", Ed.ui)

        -- SETTINGS
        Ed.show_settings = Ed.ui:checkbox("Show Settings", Ed.show_settings)
        if Ed.show_settings then
            Ed.ui:label("Background Color")
            Ed.ui:layoutRow("static", 100, 120, 1)
            Ed.bg_color = Ed.ui:colorPicker(Ed.bg_color)
        end
	end
	Ed.ui:windowEnd()
	Ed.ui:frameEnd()
end

function love.draw()
    love.graphics.clear(Ed.parseColor(Ed.bg_color))

    Ed.apply_cam()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw( -- Draw grid
        Ed.grid_cell_canvas, 
        love.graphics.newQuad(0, 0, 2000, 2000,  Ed.grid_size, Ed.grid_size), -1000, -1000
    )
    love.graphics.setColor(Ed.parseColor("#e29eff44"))
    love.graphics.setLineWidth(1)
    love.graphics.line(0, -5, 0, 5)
    love.graphics.line(-5, 0, 5, 0)

    Ed.tool_call("draw")

    Ed.remove_cam()

	Ed.ui:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if Ed.ui:keypressed(key, scancode, isrepeat) then return end
    Ed.tool_call("keypressed", key)
end

function love.keyreleased(key, scancode)
	if Ed.ui:keyreleased(key, scancode) then return end
    Ed.tool_call("keyreleased", key)
end

function love.mousepressed(x, y, button, istouch, presses)
	if Ed.ui:mousepressed(x, y, button, istouch, presses) then return end
    if button == 3 then
        Ed.initial_drag_pos.x, Ed.initial_drag_pos.y = love.graphics.inverseTransformPoint(love.mouse.getPosition())
        Ed.dragging = true
    end
    Ed.tool_call("mousepressed", x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)
	if Ed.ui:mousereleased(x, y, button, istouch, presses) then return end
    Ed.tool_call("mousereleased", x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
	if Ed.ui:mousemoved(x, y, dx, dy, istouch) then return end
    Ed.tool_call("mousemoved", x, y)
end

function love.textinput(text)
	if Ed.ui:textinput(text) then return end
    Ed.tool_call("textinput", text)
end

function love.wheelmoved(x, y)
	if Ed.ui:wheelmoved(x, y) then return end
    Ed.tool_call("wheelmoved", x, y)
end