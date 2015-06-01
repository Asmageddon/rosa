-- Load essentials into the global scope

require "utils" -- Various utility functions

-- Class system
class = require "lib.30log-llama"

-- Tweening, e.g. smoothly transitioning from one state to another
tween = require "lib.flux.flux"

-- Base classes
Scene = require "Scene"
SceneObject = require "SceneObject"

-- Components
Component = require "components.Component"
Behavior = require "components.Behavior"
PhysicsBody = require "components.PhysicsBody"
PhysicsShape = require "components.PhysicsShape"

-- Systems
System = require "systems.System"
PhysicsSystem = require "systems.PhysicsSystem"

-- Load core modules and utilities
sceneman = require "modules.scene_manager"
resman = require "modules.resource_manager"
-- Keyboard and mouse input utilities
keyboard = require "modules.keyboard_input"
mouse = require "modules.mouse_input"

-- Configure Love2D and setup callbacks
love.keyboard.setKeyRepeat(false)
math.randomseed(os.time())

function love.keypressed(key, isrepeat)
    keyboard.keypressed(key, isrepeat)
    
    if keyboard.isPressed("alt") then
        if key == "f12" then
            filename = "screenshot_" .. os.time() .. ".png"
            screenshot = love.graphics.newScreenshot( true )
            screenshot:encode(filename)
            print("Saved screenshot: " .. filename)
        end
    end
end
function love.keyreleased(key)
    keyboard.keyreleased(key)
end

function love.mousepressed(button, x, y)
    mouse.mousepressed(button, x, y)
end
function love.mousepressed(button, x, y)
    mouse.mousereleased(button, x, y)
end
function love.mousemoved(x, y, dx, dy)
    mouse.mousemoved(x, y, dx, dy)
end

function love.update(dt)
    keyboard.update(dt)
    mouse.update(dt)
    
    tween.update(dt)
    
    sceneman.update(dt)
end

function love.draw()
    sceneman.draw()
end



function loadProject(path)
    resman.base_path = path .. "/"
    require(string.gsub(path, "/", ".") .. ".main")
end

-- TODO: Think about using external modules, e.g.:
--     GUI:
--         https://github.com/adonaac/thranduil/blob/master/ui/UI.lua
--         https://love2d.org/forums/viewtopic.php?f=5&t=9116