package component;

typedef BoundsDef = {
    var x:Float;
    var y:Float;
    var z:Float;

    var width:Float;
    var length:Float;
    var height:Float;

    var radius:Float;
    var radiusX:Float;
    var radiusY:Float;

    var originIsCenter:Bool;
}

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

    public function new(def:BoundsDef):Void {
        this.x = def.x;
        this.y = def.y;
        this.z = def.z;

        this.width = def.width;
        this.length = def.length;
        this.height = def.height;

        this.radius = def.radius;
        this.radiusX = def.radiusX;
        this.radiusY = def.radiusY;

        this.originIsCenter = def.originIsCenter;
    }

    public function getName():String {
        return "Bounds";
    }
}