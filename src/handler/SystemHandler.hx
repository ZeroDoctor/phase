package handler;

import system.ISystem;

class SystemHandler {
	private var systems:Array<ISystem>; // could use array instead
	private var sceneHandler:SceneHandler;

	public function new(sceneHandler:SceneHandler):Void {
		this.systems = new Array<ISystem>();
		this.sceneHandler = sceneHandler;
	}

	public function register(system:ISystem):Void {
		systems.push(system);
		system.init();
	}

	public function deregister(name:String):Void {
		for (system in this.systems) {
			if (system.getName() == name) {
				systems.remove(system);
				return;
			}
		}
	}

	public function update(dt:Float):Void {
		var entities:Array<Int> = new Array<Int>();

		for (system in systems) {
			entities = getEntitiesForSystem(system.getName());
			system.update(entities, dt);
		}
	}

	public function render(e:h3d.Engine):Void {
		for (system in systems) {
			system.render(e);
		}
	}

	public function input(event:hxd.Event):Void {
		for (system in systems) {
			system.input(event);
		}
	}

	private function getEntitiesForSystem(name:String):Array<Int> {
		var entities:Array<Int> = new Array<Int>();
		var system:ISystem = null;

		for (s in systems) {
			if (s.getName() == name) {
				system = s;
				break;
			}
		}

		if (system == null) return entities;

		for (entity in sceneHandler.entityIterator()) {
			var shouldPush:Bool = true;
			for (sign in system.getSignatures()) {
				if (!sceneHandler.hasComponent(entity, sign)) {
					shouldPush = false;
					break;
				}
			}

			if (shouldPush) {
				entities.push(entity);
			}
		}

		return entities;
	}
}