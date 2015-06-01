local resource_manager = {}

-- We'll add more resource types in the future: Shaders, audio, maybe levels, etc.
resource_manager.resources = {
    images = {},
    shaders = {}
}

resource_manager.base_path = ""

function resource_manager.getImage(path)
    local images = resource_manager.resources.images -- alias into a local name to shorten code
    -- Check if the resource isn't loaded already, and if not, load it.
    if not images[path] then
        -- Load from the base path
        local fullpath = resource_manager.base_path .. path
        images[path] = love.graphics.newImage(fullpath)
    end
    
    -- Since by now the image is either loaded, or an error occurred, just return
    return images[specifier]
end

function resource_manager.getShader(path)
    local shaders = resource_manager.resources.shaders
    
    if not shaders[path] then
        local fullpath = resource_manager.base_path .. path
        local shader_code = love.filesystem.read(fullpath)
        shaders[path] = love.graphics.newShader(shader_code)
    end
    
    return shaders[path]
end

return resource_manager