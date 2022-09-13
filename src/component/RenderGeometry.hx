package component;

enum SHAPE {
    Circle;
    Ellipse;
    Rect;
}

class RenderGeometry implements IComponent {
    public var shape:SHAPE;
    public var draw:()->Void;
    public var color:Int;
}