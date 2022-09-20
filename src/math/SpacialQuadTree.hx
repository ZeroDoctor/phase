package math;

import h2d.col.Bounds;
import haxe.ds.Vector;

private final TOPLEFT:Int = 0;
private final TOPRIGHT:Int = 1;
private final BOTLEFT:Int = 2;
private final BOTRIGHT:Int = 3;

@:generic
private class QuadTreeNode<T> {
	public var data:T;
	public var bounds:Bounds;
	public var children:Vector<QuadTreeNode<T>>;
	public var hasChildren:Bool = false;

	// leafs should only be initialized if max depth is reached
	public var leafs:Array<QuadTreeNode<T>>;

	public function new(bounds:Bounds, data:T):Void {
		this.bounds = bounds;
		this.data = data;
		this.children = new Vector<QuadTreeNode<T>>(4);
	}

	public function insertChild(child:QuadTreeNode<T>):Int {
		if (getTopLeftBounds().intersects(child.bounds)) {
            if(children[TOPLEFT].data != null) {
                return TOPLEFT;
            }

			children[TOPLEFT] = child;
			return -1;
		}

		if (getTopRightBounds().intersects(child.bounds)) {
            if (children[TOPRIGHT].data == null){
                return TOPRIGHT;
            }

			children[TOPRIGHT] = child;
			return -1;
		}

		if (getBotLeftBounds().intersects(child.bounds)) {
            if (children[BOTLEFT].data == null ) {
                return BOTLEFT;
            }

			children[BOTLEFT] = child;
			return -1;
		}

		if (getBotRightBounds().intersects(child.bounds)) {
            if(children[BOTRIGHT].data == null) {
                return BOTRIGHT;
            }

			children[BOTRIGHT] = child;
			return -1;
		}

		return -2;
	}

	// ------- HELPER -------
	public function getTopLeftBounds():Bounds {
		return Bounds.fromValues(
            bounds.x, bounds.y, bounds.width / 2, bounds.height / 2
        );
	}

	public function getTopRightBounds():Bounds {
		return Bounds.fromValues(
            bounds.x + (bounds.width / 2), bounds.y, bounds.width / 2, bounds.height / 2
        );
	}

	public function getBotLeftBounds():Bounds {
		return Bounds.fromValues(
            bounds.x, bounds.y + (bounds.height / 2), bounds.width / 2, bounds.height / 2
        );
	}

	public function getBotRightBounds():Bounds {
		return Bounds.fromValues(
            bounds.x + (bounds.width / 2), bounds.y + (bounds.height / 2), bounds.width / 2, bounds.height / 2
        );
	}
}

/**
	SpacialQuadTree 
	an iterate implementation instead of a recursive
	why?... its less common
**/
@:generic
class SpacialQuadTree<T> {
	private var root:QuadTreeNode<T>;
	private var depth:Int;

	public function new(depth:Int, bounds:Bounds, init:T):Void {
		this.depth = depth;
		root = new QuadTreeNode(bounds, init);
	}

	public function search():Void {}

	public function insert(bounds:Bounds, data:T):Void {
		var temp:QuadTreeNode<T> = root;
		var node:QuadTreeNode<T> = new QuadTreeNode(bounds, data);

		while (temp.bounds.intersects(bounds)) {
            var childIndex:Int = temp.insertChild(node);
            // edge cases
			if (childIndex == -1) return; // node was successfully inserted
            if (childIndex == -2) {       // node is at max depth
                temp.leafs.push(node);
                return;
            }

		}
	}

	public function remove(bounds:Bounds, data:T):Void {}

	public function removeArea(bounds:Bounds):Void {}

	public function allocate():Void {}

	public function clear():Void {}
}