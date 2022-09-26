package system;

import haxe.ds.Option;
import handler.SceneHandler;
import h3d.Engine;
import hxd.Event;
import component.Bounds;
import component.Velocity;

class VelocitySystem extends System implements ISystem {
    private var entities:Array<Int>;

    public function new(sh:SceneHandler) {
        super(sh);
    }

	public function getSignatures():Array<String> {
        return ["Bounds", "Velocity"];
	}

	public function getName():String {
        return "Velocity";
	}

	public function init() {}

	public function update(entities:Array<Int>, dt:Float) {
		for (e in entities) {
			var optBounds:Option<Bounds> = sh.getComponent(e, "Bounds");
			var bounds:Bounds = switch (optBounds) {
				case Some(v): v;
				case _: continue;
			}

			var optVelocity:Option<Velocity> = sh.getComponent(e, "Velocity");
			var velocity:Velocity = switch(optVelocity) {
				case Some(v): v;
				case _: continue;
			}

			bounds.x += (velocity.magnitude * Math.cos(velocity.direction)) * dt;
			bounds.y += (velocity.magnitude * Math.sin(velocity.direction)) * dt;
		}
	}

	public function render(e:Engine) {}

	public function input(event:Event) {}
}