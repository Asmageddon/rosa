local SceneGraphNode = class()

function SceneGraphNode:__init(is_scene, scene, parent, ...)
    -- Child objects
    self._children = {
        all = {},
        by_id = {},
        by_class = {},
        by_tag = {}
    }
    self._parent = parent
    self._scene = scene
    self._is_scene = is_scene
end



function SceneGraphNode:addChild(ObjectType, ...)
    error_check(
        SceneObject.is(ObjectType, SceneObject),
        "Only SceneObject subclasses can be added as children"
    )
    local object
    if self._is_scene then
        object = ObjectType(self, nil, ...)
    else
        object = ObjectType(self._scene, self, ...)
    end
    
    -- Store object in "all objects" table
    self._children.all[object] = object
    
    -- Store object by its type
    self._children.by_class[ObjectType] = self._children.by_class[ObjectType] or {}
    self._children.by_class[ObjectType][object] = object
    
    -- Store object by its ID
    if object.id ~= nil then
        error_check(
            not self._children.by_id[object.id],
            "An object cannot have two children with identical ID: " .. object.id
        )
        self._children.by_id[object.id] = object
    end
    
    -- Store object by its tags
    for _, tag in ipairs(object.tags) do
        self._children.by_tag[tag] = self._children.by_tag[tag] or {}
        self._children.by_tag[tag][object] = object
    end
    
    object._parent = self
    
    return object
end

function SceneGraphNode:removeChild(object)
    error_check(object._parent == self, "Given object is not a child of this object")
    
    self._children.all[object] = object
    
    self._children[object.__class][object] = nil
    
    if object.id ~= nil then
        self._children.by_id[object.id] = nil
    end
    
    for _, tag in ipairs(object.tags) do
        self._children.by_tag[tag] = self._children.by_tag[tag] or {}
        self._children.by_tag[tag][object] = nil
    end
    
    object._parent = nil
end

function SceneGraphNode:getChild(id)
    return self._children.by_id[id] or error("Object with given id not found")
end

function SceneGraphNode:getChildren()
    return self._children.all
end

function SceneGraphNode:getChildrenByClass(ObjectType)
    return self._children.by_class[ObjectType] or {}
end

function SceneGraphNode:getChildrenByTag(tag)
    return self._children.by_tag[tag] or {}
end

SceneGraphNode:property("parent", function(self) return self._parent end, nil)
SceneGraphNode:property("scene", function(self) return self._scene end, nil)


return SceneGraphNode