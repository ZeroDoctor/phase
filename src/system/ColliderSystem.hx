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
	private var resolutionFuncs:Array<(ColliderComponentsDef, ColliderComponentsDef)->Void>;


	public function new(sh:SceneHandler):Void {
		super(sh);

		this.sceneSize = Bounds.fromValues(-5000.0, -5000.0, 10000.0, 10000.0);
		this.resolutionFuncs = new Array<(ColliderComponentsDef, ColliderComponentsDef)->Void>();
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

			var collidedEntities:Array<Int> = tree.search(b);
			this.collisionResolution(entity, collidedEntities);
		}
	}

	public function render(e:Engine):Void {}

	public function input(event:Event):Void {}

	private function collisionResolution(entity:Int, collidedEntities:Array<Int>):Void {
		var entityComps:ColliderComponentsDef = getColliderComponents(sh, entity);
		if (!entityComps.ok) {
			trace('failed to get required components from [entity=${entity}]');
			return;
		}
		if (entityComps.collider.type == ColliderType.NONE) return;

		for(collidedEntity in collidedEntities) {
			var collidedComps:ColliderComponentsDef = getColliderComponents(sh, collidedEntity);
			if (!collidedComps.ok) {
				trace('failed to get required components from collided [entity=${collidedEntity}]');
				continue;
			}

			for(funcs in this.resolutionFuncs) {
				funcs(entityComps, collidedComps);
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
