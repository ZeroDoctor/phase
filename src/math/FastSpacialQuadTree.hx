package math;

import math.SpacialQuadTree.TOPLEFT;
import math.SpacialQuadTree.TOPRIGHT;
import math.SpacialQuadTree.BOTLEFT;
import math.SpacialQuadTree.BOTRIGHT;

import haxe.ds.GenericStack;
import h2d.col.Bounds;
import haxe.ds.Vector;

@:generic
private class FastQuadTreeNode<T>  {
	public var bounds:Bounds;
	public var children:Vector<FastQuadTreeNode<T>>;

	// bucket should only be initialized if max depth is reached or using FastSpacialQuadTree
	public var bucket:Array<T>;

	public function new(bounds:Bounds):Void {
		this.bounds = bounds;
		this.children = new Vector<FastQuadTreeNode<T>>(4);
		this.bucket = new Array<T>();
	}

	public function insertChild(child:FastQuadTreeNode<T>, data:T):Int {
		if (getTopLeftBounds().intersects(child.bounds)) {
            this.children[TOPLEFT] = new FastQuadTreeNode<T>(getTopLeftBounds());
			this.children[TOPLEFT].bucket.push(data);
            return TOPLEFT;
		}

		if (getTopRightBounds().intersects(child.bounds)) {
            this.children[TOPRIGHT] = new FastQuadTreeNode<T>(getTopRightBounds());
			this.children[TOPRIGHT].bucket.push(data);
            return TOPRIGHT;
		}

		if (getBotLeftBounds().intersects(child.bounds)) {
            this.children[BOTLEFT] = new FastQuadTreeNode<T>(getBotLeftBounds());
			this.children[BOTLEFT].bucket.push(data);
            return BOTLEFT;
		}

		if (getBotRightBounds().intersects(child.bounds)) {
            this.children[BOTRIGHT] = new FastQuadTreeNode<T>(getBotRightBounds());
			this.children[BOTRIGHT].bucket.push(data);
            return BOTRIGHT;
		}

		return -1;
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

@:generic
class FastSpacialQuadTree<T> implements ISpacialQuadTree<T> {
    private var root:FastQuadTreeNode<T>;
	private var depth:Int;
	private var capacity:Int;

	public function new(bounds:Bounds, init:T, depth:Int, capacity:Int = 5):Void {
		this.depth = depth;
		this.capacity = capacity;
		root = new FastQuadTreeNode(bounds);
	}

	public function search(bounds:Bounds):Array<T> {
		var result:Array<T> = new Array<T>();

		var stack:GenericStack<FastQuadTreeNode<T>> = new GenericStack<FastQuadTreeNode<T>>();
		stack.add(root);

		while (!stack.isEmpty()) {
			var temp:FastQuadTreeNode<T> = stack.pop();
			if(!temp.bounds.intersects(bounds)) continue;

			result = result.concat(temp.bucket);

			for(i in 0...temp.children.length) {
				if(temp.children[i] == null) continue;

				stack.add(temp.children[i]);
			}
		}

		return result;
	}

	public function insert(bounds:Bounds, data:T):Bool {
		var node:FastQuadTreeNode<T> = new FastQuadTreeNode<T>(bounds);

		var stack:GenericStack<FastQuadTreeNode<T>> = new GenericStack<FastQuadTreeNode<T>>();
		stack.add(root);

		while (!stack.isEmpty()) {
			var temp:FastQuadTreeNode<T> = stack.pop();
			if(!temp.bounds.intersects(node.bounds)) continue;

            if (temp.bucket.length < this.capacity) {
                temp.bucket.push(data);
                return true;
            }

            var childIndex:Int = temp.insertChild(node, data);

			if (childIndex == -1) {
				trace("[ERROR | FSQT(insert)] should never happen but [error=node failed to subdivide]"); // node failed to subdivide 
				return false;
			}

			stack.add(temp.children[childIndex]);
		}

		// should never happen
		return false;
	}

	public function remove(bounds:Bounds, data:T):Bool {
		var stack:GenericStack<FastQuadTreeNode<T>> = new GenericStack<FastQuadTreeNode<T>>();
		stack.add(root);
		
		while (!stack.isEmpty()) { 
			var temp:FastQuadTreeNode<T> = stack.pop();
			if(!temp.bounds.intersects(bounds)) continue;

			if(temp.bucket.contains(data)) {
				return temp.bucket.remove(data);
			}

			for(i in 0...temp.children.length) {
				if(temp.children[i] == null || temp.children[i].bucket.length <= 0 ) continue;

				stack.add(temp.children[i]);
			}
		}

		return false;
	}

	public function clear():Void {
		root.children = new Vector<FastQuadTreeNode<T>>(4);
		root.bucket = new Array<T>();
	}
}