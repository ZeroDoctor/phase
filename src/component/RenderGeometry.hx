package component;

enum SHAPE {
    Circle;
    Ellipse;
    Rect;
}

class RenderGeometry {
    public var shape:SHAPE;
    public var draw:()->Void;
    public var color:Int;
}