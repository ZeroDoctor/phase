package component;

typedef VelocityDef = {
	@:optional var magnitude:Float;
	@:optional var direction:Float;
}

class Velocity implements IComponent {
	public var magnitude:Float = 0.0;
	public var direction:Float = 0.0;

	public function new(def:VelocityDef):Void {
		this.magnitude = def.magnitude != null ? def.magnitude : this.magnitude;
		this.direction = def.direction != null ? def.direction : this.direction;
	}

	public function getName():String {
		return "Velocity";
	}
}