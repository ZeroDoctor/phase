package system;

import component.Collider.ColliderType;
import haxe.ds.Option;
import h2d.col.Bounds;
import math.FastSpacialQuadTree;
import math.ISpacialQuadTree;
import handler.SceneHandler;
import h3d.Engine;
import hxd.Event;

class ColliderSystem extends System implements ISystem {
    private var entities:Array<Int>;
    private var sceneSize:Bounds;
    private var resolutionFuncs:Array<(main:ColliderComponentsDef, other:ColliderComponentsDef)->Void>;


    public function new(sh:SceneHandler, sceneSize:Bounds):Void {
        super(sh);

        this.sceneSize = sceneSize;
        this.resolutionFuncs = new Array<(main:ColliderComponentsDef, other:ColliderComponentsDef)->Void>();
    }

    public function addResolutionFunction(funcs:(ColliderComponentsDef, ColliderComponentsDef)->Void):Void {
        this.resolutionFuncs.push(funcs);
    }

    public function getSignatures():Array<String> {
        return ["Bounds", "Collider", "Velocity"];
    }

    public function getName():String {
        return "Collider";
    }

    public function init():Void {}

    public function update(entities:Array<Int>, dt:Float):Void {
        var tree:ISpacialQuadTree<Int> = new FastSpacialQuadTree<Int>(this.sceneSize, -1, 64);

        for (entity in entities) {
            var optBounds:Option<component.Bounds> = sh.getComponent(entity, "Bounds");
            var bounds:component.Bounds = switch (optBounds) {
                case Some(v): v;
                case _:
                    trace('failed to get bounds component with [entity=${entity}]');
                    continue;
            }

            var b:Bounds = Bounds.fromValues(bounds.x, bounds.y, bounds.width, bounds.height);
            var ok:Bool = tree.insert(b, entity);
            if (!ok) continue;

            var potentialCollidedEntities:Array<Int> = tree.search(b);
            this.collisionResolution(entity, potentialCollidedEntities);
        }
    }

    public function render(e:Engine):Void {}

    public function input(event:Event):Void {}

    private function collisionResolution(entityID:Int, potentialCollidedEntities:Array<Int>):Void {
        var entityComps:ColliderComponentsDef = getColliderComponents(sh, entityID);
        if (!entityComps.ok) {
            trace('failed to get required components from [entity=${entityID}]');
            return;
        }
        if (entityComps.collider.type == ColliderType.NONE) return;

        for(potentialID in potentialCollidedEntities) {
            if (entityID == potentialID) continue; // can't collided with itself
            
            var potentialComps:ColliderComponentsDef = getColliderComponents(sh, potentialID);
            if (!potentialComps.ok) {
                trace('failed to get required components from collided [entity=${potentialID}]');
                continue;
            }
            if(potentialComps.collider.type == ColliderType.NONE) continue; // TODO: will update with more features

            var entityBounds:Bounds = Bounds.fromValues(
                entityComps.bounds.x, entityComps.bounds.y, 
                entityComps.bounds.width, entityComps.bounds.height
            );
            var potentialBounds:Bounds = Bounds.fromValues(
                potentialComps.bounds.x, potentialComps.bounds.y, 
                potentialComps.bounds.width, potentialComps.bounds.height
            );
            if(!entityBounds.intersects(potentialBounds)) continue; // does not collide

            // iterate through collision resolution functions i.e. health, velocity, damage callback
            for(funcs in this.resolutionFuncs) {
                funcs(entityComps, potentialComps);
            }
        }
    }
}

private typedef ColliderComponentsDef = {
    var ok:Bool;
    var entityID:Int;
    @:optional var bounds:component.Bounds;
    @:optional var collider:component.Collider;
    @:optional var velocity:component.Velocity;
};

function getColliderComponents(sh:SceneHandler, entity:Int):ColliderComponentsDef {
    var comps:ColliderComponentsDef = { 
        ok: false,
        entityID: entity,
    };

    var optCollider:Option<component.Collider> = sh.getComponent(entity, "Collider");
    comps.collider = switch (optCollider) {
        case Some(v): v;
        case _:
            trace('failed to get collider component with [entity=${entity}]');
            return comps;
    }

    var optBounds:Option<component.Bounds> = sh.getComponent(entity, "Bounds");
    comps.bounds = switch (optBounds) {
        case Some(v): v;
        case _:
            trace('failed to get bounds component with [entity=${entity}]');
            return comps;
    }

    var optVelocity:Option<component.Velocity> = sh.getComponent(entity, "Velocity");
    comps.velocity = switch (optVelocity) {
        case Some(v): v;
        case _:
            trace('failed to get velocity component with [entity=${entity}]');
            return comps;
    }

    comps.ok = true;
    return comps;
}
