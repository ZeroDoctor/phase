package system;

import handler.SceneHandler;

class RenderGeometrySystem extends System implements ISystem {
    public function new(sceneHandler:SceneHandler):Void {
        super(sceneHandler);
    }

	public function getSignatures():Array<String> {
        return ["Bounds", "RenderGeometry"];
	}

	public function getName():String {
        return "RenderGeometry";
	}

	public function init() {

    }

	public function update(entities:Array<Int>, dt:Float) {

    }
}