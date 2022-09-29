package test;

import haxe.Exception;
import h2d.col.Bounds;

class BoundsTest {
    public function new():Void {
        var a:Bounds = Bounds.fromValues(12.5, 12.5, 2.5,2.5);

        var b:Bounds = Bounds.fromValues(10.0, 10.0, 5.0, 5.0);

        if (!a.intersects(b)) {
            throw new Exception("[ERROR]: bounds do not intersect [want=intersect]");
        }

        b.set(b.x, b.y+5.1, b.width, b.height);

        if (a.intersects(b)) {
            throw new Exception("[ERROR]: bounds intersect [want=do not intersect]");
        }
    }
}