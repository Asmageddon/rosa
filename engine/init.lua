-- This is only necessary within the module
rosa_prefix = ({...})[1] .. "."
local p = rosa_prefix

-- Modified love.run, with support for multiple callbacks and error handling
runman = require(p.."lib.modrun").setup()

-- Miscellaneous utilities
require(p.."utils") 

-- Class system
class = require(p.."lib.30log-llama")

-- Tweening, e.g. smoothly transitioning from one (numerical)state to another, such as position or rotation
tween = require(p.."lib.flux.flux")


-- Base types
Scene = require(p.."Scene")
SceneObject = require(p.."SceneObject")

-- Subtypes
Camera = require(p.."Camera")

-- Components
BaseComponent = require(p.."components.BaseComponent")
BaseBehavior = require(p.."components.BaseBehavior")

Transform = require(p.."components.Transform")

PhysicsBody = require(p.."components.PhysicsBody")
PhysicsShape = require(p.."components.PhysicsShape")

Renderable = require(p.."components.Renderable")
BaseDrawable = require(p.."components.BaseDrawable")
ImageDrawable = require(p.."components.ImageDrawable")

-- Systems
BaseSystem = require(p.."systems.BaseSystem")
PhysicsSystem = require(p.."systems.PhysicsSystem")
RenderingSystem = require(p.."systems.RenderingSystem")

-- Load core modules and utilities
sceneman = require(p.."modules.scene_manager")
resman = require(p.."modules.resource_manager")
projman = require(p.."modules.project_manager")
-- Keyboard and mouse input utilities
keyboard = require(p.."modules.keyboard_input")
mouse = require(p.."modules.mouse_input")

-- Configure Love2D and setup callbacks
love.keyboard.setKeyRepeat(false)
math.randomseed(os.time())

local function dispatchEvent(event, ...)
    if event == "keypressed" then
        local key, isrepeat = ...
        if keyboard.isPressed("alt") then
            if key == "f12" then
                filename = "screenshot_" .. os.time() .. ".png"
                screenshot = love.graphics.newScreenshot( true )
                screenshot:encode(filename)
                print("Saved screenshot: " .. filename)
            end
        end
        keyboard.keypressed(...)
    elseif event == "keyreleased" then
        keyboard.keyreleased(...)
    elseif event == "mousepressed" then
        mouse.mousepressed(...)
    elseif event == "mousereleased" then
        mouse.mousereleased(...)
    elseif event == "mousemoved" then
        mouse.mousemoved(...)
    elseif event == "pre_update" then
        tween.update(...)
    elseif event == "post_update" then
        keyboard.update(...)
        mouse.update(...)
    end
    
    sceneman.dispatchEvent(event, ...)
end

local function onLoad(arg)
    if arg[#arg] == "-profile" then
        ProFi = require(p.."lib.ProFi")
        ProFi:start()
    end
end
local function onQuit()
    if ProFi then
		ProFi:stop()
        local filename = string.format("%s/profiling_report_%s.txt", projman.current_project, os.time())
		ProFi:writeReport(filename)
    end
end

runman.addCallback("dispatch", dispatchEvent)
runman.addCallback("load", onLoad)
runman.addCallback("quit", onQuit)


-- TODO: Think about using external modules, e.g.:
--     GUI:
--         https://github.com/adonaac/thranduil/blob/master/ui/UI.lua
--         https://love2d.org/forums/viewtopic.php?f=5&t=9116