-- Code that is not presently used, but would probably be nice to integrate into the codebase

function processImage(image, shader, shader_data)
    --Process the given image with a shader and return it as a new object
    local canvas = love.graphics.newCanvas(image:getDimensions())
    local love_canvas = love.graphics.getCanvas()

    love.graphics.setCanvas(canvas)
    love.graphics.setShader(shader)

    for name, data in pairs(shader_data) do
        shader:send(name, data)
    end

    love.graphics.draw(image, 0, 0)

    love.graphics.setShader()
    love.graphics.setCanvas(love_canvas)

    return canvas
end

function canvasFromFile(filename)
    local image = love.graphics.newImage(filename)
    local new_canvas = love.graphics.newCanvas(image:getDimensions())
    
    --Set canvas to the new canvas
    local orig_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(new_canvas)
    
        love.graphics.draw(image)
        
    love.graphics.setCanvas(orig_canvas)
    
    return new_canvas
end