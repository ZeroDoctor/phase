package component;

enum Shape {
	CIRCLE;
	ELLIPSE;
	RECT;
}

typedef RenderGeometryDef = {
	var shape:Shape;
	var color:Int;
};

class RenderGeometry implements IComponent {
	public var shape:Shape = RECT;
	public var color:Int = 0xFF0000;

	public function new(def:RenderGeometryDef) {
		this.shape = def.shape != null ? def.shape : this.shape;
		this.color = def.color != null ? def.color : this.color;
	}

	public function getName():String {
		return "RenderGeometry";
	}
}