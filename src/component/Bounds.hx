package component;

typedef BoundsDef = {
	@:optional var x:Float;
	@:optional var y:Float;
	@:optional var z:Float;

	@:optional var width:Float;
	@:optional var length:Float;
	@:optional var height:Float;
	@:optional var radius:Float;
	@:optional var radiusX:Float;
	@:optional var radiusY:Float;
	@:optional var originIsCenter:Bool;
};

class Bounds implements IComponent {
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	public var z:Float = 0.0;

	public var width:Float = 0.0;
	public var length:Float = 0.0;
	public var height:Float = 0.0;

	public var radius:Float = 0.0;
	public var radiusX:Float = 0.0;
	public var radiusY:Float = 0.0;

	public var originIsCenter:Bool = false;

	public function new(def:BoundsDef):Void {
		this.x = def.x != null ? def.x : this.x;
		this.y = def.y != null ? def.y : this.y;
		this.z = def.z != null ? def.z : this.z;

		this.width = def.width != null ? def.width : this.width;
		this.length = def.length != null ? def.length : this.length;
		this.height = def.height != null ? def.height : this.height;

		this.radius = def.radius != null ? def.radius : this.radius;
		this.radiusX = def.radiusX != null ? def.radiusX : this.radiusX;
		this.radiusY = def.radiusY != null ? def.radiusY : this.radiusY;

		this.originIsCenter = def.originIsCenter != null ? def.originIsCenter : this.originIsCenter;
	}

	public function getName():String {
		return "Bounds";
	}
}