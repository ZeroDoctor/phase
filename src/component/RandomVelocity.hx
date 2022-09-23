package component;

typedef RandomVelocityDef = {
	@:optional var magnitude:Float;
	@:optional var direction:Float;
}

class RandomVelocity implements IComponent {
	public var magnitude:Float = 0.0;
	public var direction:Float = 0.0;

	public function new(def:RandomVelocityDef):Void {
        this.magnitude = def.magnitude != null ? def.magnitude : this.magnitude;
        this.direction = def.direction != null ? def.direction : this.direction;
    }

	public function getName():String {
		return "RandomVelocity";
	}
}