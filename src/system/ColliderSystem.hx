package system;

import handler.SceneHandler;
import h3d.Engine;
import hxd.Event;

class ColliderSystem extends System implements ISystem {
    private var entities:Array<Int>;
    
    public function new(sh:SceneHandler) {
        super(sh);
    }

	public function getSignatures():Array<String> {
        return ["RidgidBody", "Collider"];
	}

	public function getName():String {
        return "Collider";
	}

	public function init() {}

	public function update(entities:Array<Int>, dt:Float) {}

	public function render(e:Engine) {}

	public function input(event:Event) {}
}