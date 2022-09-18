package handler;

import system.ISystem;

class SystemHandler {

    private var systemMap:Map<String, ISystem>; // could use array instead
    private var sceneHandler:SceneHandler;

    public function new(sceneHandler:SceneHandler):Void {
        this.systemMap = new Map<String, ISystem>();
        this.sceneHandler = sceneHandler;
    }

    public function register(system:ISystem):Void {
        systemMap.set(system.getName(), system);
        system.init();
    }
    
    public function deregister(name:String):Void {
        systemMap.remove(name);
    }

    public function update(dt:Float) {
        var entities:Array<Int> = new Array<Int>();

        for(name in systemMap.keys()) {
            entities = getEntitiesForSystem(name);
            
            systemMap.get(name).update(entities, dt);
        }
    }

    public function render(e:h3d.Engine) {
        var entities:Array<Int> = new Array<Int>();

        for(name in systemMap.keys()) {
            entities = getEntitiesForSystem(name);
            
            systemMap.get(name).render(e);
        }
    }

    private function getEntitiesForSystem(name:String):Array<Int> {
        var entities:Array<Int> = new Array<Int>();

        // this could be better
        for (sign in systemMap.get(name).getSignatures()) {
            for(entity in sceneHandler.entityIterator()) {
                switch(sceneHandler.getComponent(entity, sign)) {
                    case Some(_):
                        entities.push(entity);
                    case _:
                }
            }
        }

        return entities;
    }
}