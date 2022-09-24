package system;

import handler.SceneHandler;
import h3d.Engine;
import hxd.Event;

class RandomVelocitySystem extends System implements ISystem {
    private var entities:Array<Int>;

    public function new(sh:SceneHandler) {
        super(sh);
    }

	public function getSignatures():Array<String> {
        return ["RandomVelocity"];
	}

	public function getName():String {
        return "RandomVelocity";
	}

	public function init() {}

	public function update(entities:Array<Int>, dt:Float) {}

	public function render(e:Engine) {}

	public function input(event:Event) {}
}