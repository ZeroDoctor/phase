package component;

class Bounds implements IComponent {
    public var x:Float;
    public var y:Float;
    public var z:Float;

    public var width:Float;
    public var length:Float;
    public var height:Float;

    public var radius:Float;
    public var radiusX:Float;
    public var radiusY:Float;

    public var originIsCenter:Bool;

    public function getName():String {
        return "Bounds";
    }
}