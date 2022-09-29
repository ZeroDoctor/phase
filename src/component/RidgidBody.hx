package component;

typedef RidgidBodyDef = {
	@:optional var mass:Float;
	@:optional var friction:Float;
	@:optional var acceleration:Float;
};

class RidgidBody implements IComponent {
	public var mass:Float = 1.0;
	public var friction:Float = 0.25;
	public var acceleration:Float = 0.0;

	public function new(def:RidgidBodyDef):Void {
		this.mass = def.mass != null ? def.mass : this.mass;
		this.friction = def.friction != null ? def.friction : this.friction;
		this.acceleration = def.acceleration != null ? def.acceleration : this.acceleration;
	}

	public function getName():String {
		return "RidgidBody";
	}
}