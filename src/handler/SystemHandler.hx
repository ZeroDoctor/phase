package handler;

import system.ISystem;

class SystemHandler {

    private var systemMap:Map<String, ISystem>;

    public function new():Void {
        this.systemMap = new Map<String, ISystem>();
    }

    public function register(system:ISystem):Void {
        systemMap.set(system.getName(), system);
        system.init();
    }
    
    public function deregister(name:String):Void {
        systemMap.remove(name);
    }

    public function update(dt:Float) {
        for(systemName in systemMap.keys()) {
            systemMap.get(systemName).update(dt);
        }
    }
}