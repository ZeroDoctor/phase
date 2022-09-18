package component;

enum SHAPE {
    Circle;
    Ellipse;
    Rect;
}

class RenderGeometry implements IComponent {
    public var shape:SHAPE;
    public var color:Int;

	public function getName():String {
        return "RenderGeometry";
	}
}