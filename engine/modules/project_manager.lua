local project_manager = {}

-- We'll add more resource types in the future: Shaders, audio, maybe levels, etc.
project_manager.original_path = package.path
project_manager.current_project = nil

function project_manager.loadProject(path)
    -- Add project directory to Lua search path
    local orig_path = project_manager.original_path
    package.path = string.format("%s;%s/?.lua;%s/?/init.lua", orig_path, path, path)
    -- Set base path for resources
    resman.base_path = path .. "/"
    -- Load the project's main.lua
    require(string.gsub(path, "/", ".") .. ".main")
    -- Store the path we were given as current project's identifier
    project_manager.current_project = path
end

return project_manager