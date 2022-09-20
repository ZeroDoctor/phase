package component;

enum Shape {
    CIRCLE;
    ELLIPSE;
    RECT;
}

typedef RenderGeometryDef = { 
    var shape:Shape;
    var color:Int;
}

class RenderGeometry implements IComponent {
    public var shape:Shape;
    public var color:Int;

    public function new(def:RenderGeometryDef) {
        this.shape = def.shape;
        this.color = def.color;
    }

	public function getName():String {
        return "RenderGeometry";
	}
}