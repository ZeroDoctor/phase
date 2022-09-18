package component;

enum SHAPE {
    Circle;
    Ellipse;
    Rect;
}

typedef RenderGeometryDef = { 
    var shape:SHAPE;
    var color:Int;
}

class RenderGeometry implements IComponent {
    public var shape:SHAPE;
    public var color:Int;

    public function new(def:RenderGeometryDef) {
        this.shape = def.shape;
        this.color = def.color;
    }

	public function getName():String {
        return "RenderGeometry";
	}
}