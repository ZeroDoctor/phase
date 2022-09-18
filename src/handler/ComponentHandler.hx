package handler;

import haxe.ds.Option;
import component.IComponent;

private class Components<T> {
    private var componentMap:Map<Int, T>;

    private var signature:String;

    public function new():Void {
        this.componentMap = new Map<Int, T>();
    }

    public function get(id:Int):Option<T> {
        if (this.componentMap.exists(id)) {
            return Some(this.componentMap.get(id));
        }

        return None; 
    }

    public function has(id:Int):Bool {
        return this.componentMap.exists(id);
    }

    public function push(id:Int, component:T):Void {
        this.componentMap.set(id, component);
    }

    public function remove(id:Int):Bool {
        return this.componentMap.remove(id);
    }

    public function getComponents():Iterator<T> {
        return this.componentMap.iterator();
    }
}

class ComponentHandler {
    private var componentSetMap:Map<String, Components<IComponent>>;

    public function new():Void {
        this.componentSetMap = new Map<String, Components<IComponent>>();
    }

    public function getComponents(name:String):Iterator<IComponent> {
        if (this.componentSetMap.exists(name)) {
            return this.componentSetMap.get(name).getComponents();
        }

        var comp:Components<IComponent> = new Components<IComponent>();
        return comp.getComponents();
    }

    public function getComponent<T>(id:Int, name:String):Option<T> {
        if (!this.componentSetMap.exists(name)) {
            return None;
        }

        var comps:Components<IComponent> = this.componentSetMap.get(name);
        var opt:Option<IComponent> = comps.get(id);

        switch (opt) {
            case Some(v):
                var t:T = cast v;
                return Some(t);
            case _:
                return None;
        }
    }

    public function assignComponent(id:Int, comp:IComponent):Void {
        if (this.componentSetMap.exists(comp.getName())) {
            this.componentSetMap.get(comp.getName()).push(id, comp);
            return;
        }

        var ec:Components<IComponent> = new Components<IComponent>();
        ec.push(id, comp);
        this.componentSetMap.set(comp.getName(), ec);
    }

    public function unassignComponent(id:Int, comp:IComponent):Bool {
        if (this.componentSetMap.exists(comp.getName())) {
            this.componentSetMap.get(comp.getName()).remove(id);
            return true;
        }

        return false;
    }
}