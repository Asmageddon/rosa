local TextureAtlas = class()
local TexturePage = class()
local Bin = class()

function Bin:__init(x, y, w, h, used_w, used_h)
    self.x = x
    self.y = y
    
    self.used_w = used_w or w
    self.used_h = used_h or h
    
    self.w = w
    self.h = h
    
    self.area = w * h
    
    self.content = nil
end

function Bin:splitVertically(y)
    local top = Bin(self.x, self.y    , self.w, y)
    local bot = Bin(self.x, self.y + y, self.w, self.h - y)
    return top, bot
end

function Bin:splitHorizontally(x)
    local left  = Bin(self.x    , self.y, x, self.h)
    local right = Bin(self.x + x, self.y, self.w - x, self.h)
    return left, right
end

function Bin:split(x, y)
    if self.w - x > self.h - y then
        local top, bot = self:splitVertically(y)
        local top_left, top_right = top:splitHorizontally(x)
        local bot_left, bot_right = bot:splitHorizontally(x)
        return top_left, {top_right, bot_left, bot_right}
    else
        local left, right = self:splitHorizontally(x)
        local top_left, bot_left = left:splitVertically(y)
        local top_right, bot_right = right:splitVertically(y)
        return top_left, {top_right, bot_left, bot_right}
    end
end



function TexturePage:__init(w, h, layers)
    self.layers = {}
    for _, layer in ipairs(layers) do
        self.layers[layer] = love.graphics.newCanvas(w, h)
    end
    self.w = w
    self.h = h
    
    self.min_h = 8
    self.min_w = 8
    
    self.root = Bin(0, 0, w, h)
    self.used = {}
    self.free = {self.root}
end

function TexturePage:drawImages(bin, images)
    for layer, image in pairs(images) do
        love.graphics.setCanvas(self.layers[layer])
        love.graphics.draw(image, bin.x, bin.y)
    end
    love.graphics.setCanvas()
end

function TexturePage:add(images)
    local bin = self:findSpace(images[""]:getWidth() + 2, images[""]:getHeight() + 2)
    if bin ~= nil then
        local quad = love.graphics.newQuad(bin.x + 1, bin.y + 1, bin.w - 2, bin.h - 2, self.w, self.h)
        
        self:drawImages(bin, images)
        
        bin.content = quad
        
        return bin
    end
    
    return nil
end

function TexturePage:findSpace(w, h)
    for i, bin in ipairs(self.free) do
        if bin.w >= w and bin.h >= h then
            if bin.w - w < self.min_w and bin.h - h < self.min_h then
                bin.used_w = w
                bin.used_h = h
                table.remove(self.free, i)
                table.insert(self.used, bin)
                table.sort(self.free, "area")
                return bin
            else
                local used, rest = bin:split(w, h)
                table.remove(self.free, i)
                table.insert(self.used, used)
                table.extend(self.free, rest)
                table.sort(self.free, "area")
                return used
            end
        end
    end
    
    return nil
end



function TextureAtlas:__init(w, h, layers)
    layers = layers or {""}
    self.page_w = w
    self.page_h = h
    
    self.pages = {TexturePage(w, h)}
    self.layers = {}
    self.images = {} -- name: {page_n, quad, bin, source}
    self.sheets = {} -- name: {image, width, height}
end

function findLayers(name, layers)
    local pre, post = name.
    for _, layer in ipairs(layers) do
        !!TODO!!
    end
    love.filesystem.exists(new_name)
end

-- Source can be nil to reload the same file
function TextureAtlas:reload(name, source)
    local page_n, quad, bin, original_source = unpack(self.images[name])
    local image = resman.getImage(source or original_source)
    if image:getWidth() ~= bin.used_w or image:getHeight() ~= bin.used_h then
        error("Reloaded " .. name .. " image loaded from: " .. source .. " has different size", 2)
    end
    self.images[name][4] = source or original_source 
    self.pages[page_n]:drawImage(bin, image)
    
    return self:get(name)
end

function TextureAtlas:load(name, source)
    if self.images[name] then
        self:reload(name, source)
    else
        local page_n, quad, bin = nil
        local image = resman.getImage(source)
        
        for i, page in ipairs(self.pages) do
            bin = page:add(image)
            if bin ~= nil then
                page_n = i
                break
            end
        end
        if quad == nil then
            table.insert(self.pages, TexturePage(self.page_w, self.page_h))
            bin = self.pages[#self.pages]:add(image)
            page_n = #self.pages
        end
        
        self.images[name] = {page_n, bin.content, bin, source}
    end
    
    return self:get(name)
end

function TextureAtlas:makeSheet(name_prefix, tile_width, tile_height, sprite_name)
    local page_n, quad, bin, original_source = unpack(self.images[sprite_name])
    local canvas_w, canvas_h = self.pages[page_n].canvas:getDimensions()
    local tc_h, tc_v = bin.used_w / tile_width, bin.used_h / tile_height
    for x=1, tc_h do
        for y=1, tc_v do
            local x2 = bin.x + bin.w * ((x-1) / tc_h)
            local y2 = bin.y + bin.h * ((y-1) / tc_v)
            local subquad = love.graphics.newQuad(x2, y2, tile_width, tile_height, canvas_w, canvas_h)
            local name = string.format("%s%i_%i", name_prefix, x, y)
            self.images[name] = {page_n, subquad, nil, nil}
        end
    end
end

function TextureAtlas:get(name)
    return self.pages[self.images[name][1]].layers, self.images[name][2]
end

function TextureAtlas:alias(alias_to, alias_what)
    self.images[alias_to] = self.images[alias_what]
    
    return self:get(alias_to)
end



return TextureAtlas