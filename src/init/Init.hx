package init;

import h3d.Vector;
import component.Velocity;
import component.RidgidBody;
import component.Collider;
import component.RenderGeometry;
import component.IComponent;
import component.Bounds;
import handler.SceneHandler;

class Init {
	public var sceneHandler:SceneHandler;

	public function new(sceneHandler:SceneHandler):Void {
		this.sceneHandler = sceneHandler;
	}

	public function newEntity(x:Float, y:Float, color:Int, magnitude:Float, direction:Float):Int {
		var entity:Int = this.sceneHandler.createEntity();

		var bounds:IComponent = new Bounds({
			x: x,
			y: y,
			width: 15.0,
			height: 15.0,
			radius: 7.0,
		});

		var geometry:RenderGeometry = new RenderGeometry({
			shape: Shape.RECT,
			color: color,
		});

		var collider:Collider = new Collider({
			type: ColliderType.SOLID,
		});

		var body:RidgidBody = new RidgidBody({});

		var velocity:Velocity = new Velocity({magnitude: magnitude, direction: direction});

		this.sceneHandler.assignComponent(entity, bounds);
		this.sceneHandler.assignComponent(entity, geometry);
		this.sceneHandler.assignComponent(entity, collider);
		this.sceneHandler.assignComponent(entity, body);
		this.sceneHandler.assignComponent(entity, velocity);

		return entity;
	}
}
