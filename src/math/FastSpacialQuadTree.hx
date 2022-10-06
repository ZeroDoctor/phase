package math;

import haxe.Exception;
import math.SpacialQuadTree.TOPLEFT;
import math.SpacialQuadTree.TOPRIGHT;
import math.SpacialQuadTree.BOTLEFT;
import math.SpacialQuadTree.BOTRIGHT;
import haxe.ds.GenericStack;
import h2d.col.Bounds;
import haxe.ds.Vector;

@:generic
class FastQuadTreeNode<T> {
	public var bounds:Bounds;
	public var children:Vector<FastQuadTreeNode<T>>;
	public var bucket:Array<T>;

	public function new(bounds:Bounds):Void {
		this.bounds = bounds;
		this.children = new Vector<FastQuadTreeNode<T>>(4);
		this.bucket = new Array<T>();
	}

	// ------- HELPER -------
	public function getTopLeftBounds():Bounds {
		return Bounds.fromValues(bounds.x, bounds.y, bounds.width / 2, bounds.height / 2);
	}

	public function getTopRightBounds():Bounds {
		return Bounds.fromValues(bounds.x + (bounds.width / 2), bounds.y, bounds.width / 2, bounds.height / 2);
	}

	public function getBotLeftBounds():Bounds {
		return Bounds.fromValues(bounds.x, bounds.y + (bounds.height / 2), bounds.width / 2, bounds.height / 2);
	}

	public function getBotRightBounds():Bounds {
		return Bounds.fromValues(bounds.x + (bounds.width / 2), bounds.y + (bounds.height / 2), bounds.width / 2, bounds.height / 2);
	}
}

@:generic
class FastSpacialQuadTree<T> implements ISpacialQuadTree<T> {
	private var root:FastQuadTreeNode<T>;
	private var depth:Int;
	private var capacity:Int;

	public function new(bounds:Bounds, init:T, depth:Int, capacity:Int = 10):Void {
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
			if (!temp.bounds.intersects(bounds)) continue;

			result = result.concat(temp.bucket);

			for (i in 0...temp.children.length) {
				if (temp.children[i] == null) continue;

				stack.add(temp.children[i]);
			}
		}

		return result;
	}

	public function insert(bounds:Bounds, data:T):Bool {
		var stack:GenericStack<FastQuadTreeNode<T>> = new GenericStack<FastQuadTreeNode<T>>();
		stack.add(root);

		while (!stack.isEmpty()) {
			var temp:FastQuadTreeNode<T> = stack.pop();
			if (!temp.bounds.intersects(bounds))
				continue;

			if (temp.bucket.length < this.capacity) {
				temp.bucket.push(data);
				return true;
			}

			for (i in 0...temp.children.length) {
				if (temp.children[i] == null) {
					switch (i) {
						case TOPLEFT: 
							temp.children[i] = new FastQuadTreeNode<T>(temp.getTopLeftBounds());
						case TOPRIGHT: 
							temp.children[i] = new FastQuadTreeNode<T>(temp.getTopRightBounds());
						case BOTLEFT: 
							temp.children[i] = new FastQuadTreeNode<T>(temp.getBotLeftBounds());
						case BOTRIGHT: 
							temp.children[i] = new FastQuadTreeNode<T>(temp.getBotRightBounds());
						default:
							throw new Exception("invalid number of children");
					}
				}

				stack.add(temp.children[i]);
			}
		}

		return false;
	}

	public function remove(bounds:Bounds, data:T):Bool {
		var stack:GenericStack<FastQuadTreeNode<T>> = new GenericStack<FastQuadTreeNode<T>>();
		stack.add(root);

		while (!stack.isEmpty()) {
			var temp:FastQuadTreeNode<T> = stack.pop();
			if (temp.bucket.length <= 0)
				continue;
			if (!temp.bounds.intersects(bounds))
				continue;

			if (temp.bucket.contains(data)) {
				return temp.bucket.remove(data);
			}

			for (i in 0...temp.children.length) {
				if (temp.children[i] == null)
					continue;

				stack.add(temp.children[i]);
			}
		}

		return false;
	}

	public function clear():Void {
		root.children = new Vector<FastQuadTreeNode<T>>(4);
		root.bucket = new Array<T>();
	}

	public function getRoot():FastQuadTreeNode<T> {
		return root;
	}
}