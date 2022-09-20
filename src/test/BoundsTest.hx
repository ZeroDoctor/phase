package test;

import h2d.col.Bounds;

class BoundsTest {
    public function new():Void {
        var a:Bounds = new Bounds();
        a.set(12.0, 12.0, 2.5,2.5);

        var b:Bounds = new Bounds();
        b.set(10.0, 10.0, 5.0, 5.0);

        if (a.intersects(b)) {
            trace("-- they intersects", a, b);
        }

        b.set(b.x, b.y+10.0, b.width, b.height);

        if (a.intersects(b)) {
            trace("-- they intersects", a, b);
        }
    }
}