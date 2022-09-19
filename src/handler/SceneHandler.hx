package handler;

import haxe.ds.Option;
import component.IComponent;

class SceneHandler {

    private var entityHandler:EntityHandler;
    private var componentHandler:ComponentHandler;
    private var scene:h2d.Scene;
    private var g:h2d.Graphics;

    public function new(scene:h2d.Scene, g:h2d.Graphics):Void {
        this.entityHandler = new EntityHandler();
        this.componentHandler = new ComponentHandler();
        this.scene = scene;
        this.g = g;
    }

    public function getScene():h2d.Scene {
        return this.scene;
    }

    public function getGraphics():h2d.Graphics {
        return this.g;
    }

    public function getEntitiesCount():Int {
        return this.entityHandler.getEntitesCount();
    }

    public function getDeadEntities():Array<Int> {
        return this.entityHandler.getDeadEntities();
    }

    public function entityIterator():Iterator<Int> {
        return this.entityHandler.iterator();
    }

    public function isAlive(id:Int):Bool {
        return this.entityHandler.isAlive(id);
    }

    public function createEntity():Int {
        return this.entityHandler.createEntity();
    } 

    public function killEntity(id:Int):Void {
        this.entityHandler.killEntity(id);
    }

    public function getComponents(name:String):Iterator<IComponent> {
        return this.componentHandler.getComponents(name);
    }

    public function hasComponent(id:Int, name:String):Bool {
        return this.componentHandler.hasComponent(id, name);
    }

    public function getComponent<T:IComponent>(id:Int, name:String):Option<T> {
        return this.componentHandler.getComponent(id, name);
    }

    public function assignComponent(id:Int, comp:IComponent):Void {
        return this.componentHandler.assignComponent(id, comp);
    }

    public function unassignComponent(id:Int, comp:IComponent):Bool {
        return this.componentHandler.unassignComponent(id, comp);
    }
}