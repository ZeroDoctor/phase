package test;

import haxe.Exception;
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
        var tree:FastSpacialQuadTree<Int> = new FastSpacialQuadTree<Int>(space, -1, 16, 4);
        this.populate(tree);

        var gotStack:GenericStack<FastQuadTreeNode<Int>> = new GenericStack<FastQuadTreeNode<Int>>();
        gotStack.add(tree.getRoot());

        var wantStack:GenericStack<Array<Int>> = new GenericStack<Array<Int>>();
        wantStack.add([5]); // top left | child
        wantStack.add([6]); // bottom left | child
        wantStack.add([7,8]); // bottom right | 1 child
        wantStack.add([1,2,3,4]); // at root

        while(!gotStack.isEmpty()) {
            var gotNode:FastQuadTreeNode<Int> = gotStack.pop();
            if(gotNode.bucket.length <= 0 ) continue;

            var want:Array<Int> = wantStack.pop();
            for(i in 0...gotNode.bucket.length) {
                if(gotNode.bucket[i] != want[i]) 
                    throw new Exception('[ERROR] [got=${gotNode.bucket}] [want=${want}]');
            }

            for(i in 0...gotNode.children.length) {
                if(gotNode.children[i] == null) continue;
                gotStack.add(gotNode.children[i]);
            }
        }
    }
}