package system;

import haxe.ds.Option;
import handler.SceneHandler;
import h3d.Engine;
import hxd.Event;
import component.Bounds;
import component.Velocity;

class VelocitySystem extends System implements ISystem {
	private var entities:Array<Int>;

	public function new(sh:SceneHandler):Void {
		super(sh);
	}

	public function getSignatures():Array<String> {
		return ["Bounds", "Velocity"];
	}

	public function getName():String {
		return "Velocity";
	}

	public function init():Void {}

	public function update(entities:Array<Int>, dt:Float):Void {
		for (e in entities) {
			var optBounds:Option<Any> = sh.getComponent(e, "Bounds");
			var bounds:Bounds = switch (optBounds) {
				case Some(v): v;
				case _: continue;
			}

			var optVelocity:Option<Any> = sh.getComponent(e, "Velocity");
			var velocity:Velocity = switch (optVelocity) {
				case Some(v): v;
				case _: continue;
			}

			bounds.x += (velocity.magnitude * Math.cos(velocity.direction)) * dt;
			bounds.y += (velocity.magnitude * Math.sin(velocity.direction)) * dt;
		}
	}

	public function render(e:Engine):Void {}

	public function input(event:Event):Void {}
}
