package component;

typedef HealthDef = {
	@:optional var value:Int;
	@:optional var regen:Float;
	@:optional var immortal:Bool;
};

class Health implements IComponent {
	private var value:Int = 100;
	private var regen:Float = 1.0;
	private var immortal:Bool = false;

	public function new(def:HealthDef):Void {
		this.value = def.value != null ? def.value : this.value;
		this.regen = def.regen != null ? def.regen : this.regen;
		this.immortal = def.immortal != null ? def.immortal : this.immortal;
	}

	public function getName():String {
		return "Health";
	}
}