package component;

enum Shape {
	CIRCLE;
	ELLIPSE;
	RECT;
	OUTLINE_RECT;
}

typedef RenderGeometryDef = {
	@:optional var shape:Shape;
	@:optional var color:Int;
	@:optional var lineSize:Float;
};

class RenderGeometry implements IComponent {
	public var shape:Shape = RECT;
	public var color:Int = 0xFF0000;
	public var lineSize:Float = 1.0;

	public function new(def:RenderGeometryDef) {
		this.shape = def.shape != null ? def.shape : this.shape;
		this.color = def.color != null ? def.color : this.color;
		this.lineSize = def.lineSize != null ? def.lineSize : this.lineSize;
	}

	public function getName():String {
		return "RenderGeometry";
	}
}