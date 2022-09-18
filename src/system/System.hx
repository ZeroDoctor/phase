package system;

import handler.SceneHandler;

abstract class System {
    private var sceneHandler:SceneHandler;

    public function new(sceneHandler:SceneHandler):Void {
        this.sceneHandler = sceneHandler;
    }
}