package test;

import math.FastSpacialQuadTree;
import math.ISpacialQuadTree;
import h2d.col.Bounds;
import math.SpacialQuadTree;

class TreeTest {

    private var space:Bounds;

    public function new():Void {
        this.space = Bounds.fromValues(0, 0, 100, 100);
    }

    private function populate(tree:ISpacialQuadTree<Int>):Void {
        var bounds:Array<Bounds> = new Array<Bounds>();

        bounds.concat([
            Bounds.fromValues(12, 12, 5, 5),
            Bounds.fromValues(12, 24, 5, 5),
            Bounds.fromValues(24, 12, 5, 5),
            Bounds.fromValues(24, 24, 5, 5),
            Bounds.fromValues(45, 45, 5, 5),
            Bounds.fromValues(45, 74, 5, 5),
            Bounds.fromValues(74, 45, 5, 5),
            Bounds.fromValues(74, 74, 5, 5),
        ]);

        for(i in 0...bounds.length) {
            tree.insert(bounds[i], i+1);
        }
    }

    public function Normal():Void {
        var tree:ISpacialQuadTree<Int> = new SpacialQuadTree<Int>(space, -1, 16, 5);
        populate(tree);
    }

    public function Fast():Void {
        var tree:ISpacialQuadTree<Int> = new FastSpacialQuadTree<Int>(space, -1, 16, 5);
        populate(tree);
    }
}