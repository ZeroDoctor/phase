package system;

import handler.SceneHandler;

abstract class System {
	private var sh:SceneHandler;

	public function new(sh:SceneHandler):Void {
		this.sh = sh;
	}
}