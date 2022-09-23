package test;

import haxe.ds.GenericStack;
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

        bounds = bounds.concat([
            Bounds.fromValues(12, 12, 5, 5),
            Bounds.fromValues(12, 24, 5, 5),
            Bounds.fromValues(24, 12, 5, 5),
            Bounds.fromValues(24, 24, 5, 5),
            Bounds.fromValues(45, 45, 5, 5),
            Bounds.fromValues(45, 74, 5, 5),
            Bounds.fromValues(74, 67, 5, 5),
            Bounds.fromValues(74, 74, 5, 5),
        ]);

        for(i in 0...bounds.length) {
            tree.insert(bounds[i], i+1);
        }
    }

    public function Normal():Void {
        trace("--------------");

        var tree:SpacialQuadTree<Int> = new SpacialQuadTree<Int>(space, -1, 16, 5);
        this.populate(tree);

        var stack:GenericStack<QuadTreeNode<Int>> = new GenericStack<QuadTreeNode<Int>>();
        stack.add(tree.getRoot());

        while(!stack.isEmpty()) {
            var temp:QuadTreeNode<Int> = stack.pop();
            if(temp.data == null) continue;

            trace(temp);

            for(i in 0...temp.children.length) {
                if(temp.children[i] == null) continue;
                stack.add(temp.children[i]);
            }
        }

        trace(tree.search(Bounds.fromValues(34, 34, 7, 7)));
    }

    public function Fast():Void {
        trace("--------------");

        var tree:FastSpacialQuadTree<Int> = new FastSpacialQuadTree<Int>(space, -1, 16, 4);
        this.populate(tree);

        var stack:GenericStack<FastQuadTreeNode<Int>> = new GenericStack<FastQuadTreeNode<Int>>();
        stack.add(tree.getRoot());

        while(!stack.isEmpty()) {
            var temp:FastQuadTreeNode<Int> = stack.pop();
            if(temp.bucket.length <= 0 ) continue;

            trace(temp);

            for(i in 0...temp.children.length) {
                if(temp.children[i] == null) continue;
                stack.add(temp.children[i]);
            }
        }
    }
}