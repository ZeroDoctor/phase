package math;

import h2d.col.Point;
import haxe.ds.GenericStack;
import h2d.col.Bounds;
import haxe.ds.Vector;

final TOPLEFT:Int = 0;
final TOPRIGHT:Int = 1;
final BOTLEFT:Int = 2;
final BOTRIGHT:Int = 3;

@:generic
private class QuadTreeNode<T> {
	public var data:T;
	public var bounds:Bounds;
	public var children:Vector<QuadTreeNode<T>>;

	// bucket should only be initialized if max depth is reached or using FastSpacialQuadTree
	public var bucket:Array<QuadTreeNode<T>>;

	public function new(bounds:Bounds, data:T):Void {
		this.bounds = bounds;
		this.data = data;
		this.children = new Vector<QuadTreeNode<T>>(4);
	}

	public function intersects(node:QuadTreeNode<T>):Int {
		if(getTopLeftBounds().intersects(node.bounds)) {
			return TOPLEFT;
		}

		if(getTopRightBounds().intersects(node.bounds)) {
			return TOPRIGHT;
		}

		if(getBotLeftBounds().intersects(node.bounds)) {
			return BOTLEFT;
		}

		if(getBotRightBounds().intersects(node.bounds)) {
			return BOTRIGHT;
		}

		return -1;
	}

	public function insertChild(child:QuadTreeNode<T>):Int {
		var index:Int = this.intersects(child);
		if (index == -1) {
			return -2;
		}

		if (children[index].data != null) {
			return index;
		}

		children[index] = child;
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

/**
	SpacialQuadTree 
	an iterate implementation instead of a recursive
	why?... its less common
**/
@:generic
class SpacialQuadTree<T> implements ISpacialQuadTree<T>{
	private var root:QuadTreeNode<T>;
	private var depth:Int;
	private var capacity:Int;

	public function new(depth:Int, capacity:Int, bounds:Bounds, init:T):Void {
		this.depth = depth;
		this.capacity = capacity;
		root = new QuadTreeNode(bounds, init);
	}

	public function search():Array<T> {
		var result:Array<T> = new Array<T>();

		return result;
	}

	public function insert(bounds:Bounds, data:T):Bool {
		var node:QuadTreeNode<T> = new QuadTreeNode<T>(bounds, data);

		var currentDepth:Int = 1;
		var stack:GenericStack<QuadTreeNode<T>> = new GenericStack<QuadTreeNode<T>>();
		stack.add(root);

		while (!stack.isEmpty()) {
			currentDepth--;
			var temp:QuadTreeNode<T> = stack.pop();

			if(!temp.bounds.intersects(node.bounds)) {
				continue;
			}

			if (currentDepth > this.depth) {
				temp.bucket.push(node);
				return true;
			}

			// check if new node is bigger than current node (other than root node)
			if (!stack.isEmpty()) {
				var s1:Point = temp.bounds.getSize(); 
				var s2:Point = node.bounds.getSize(); 
				if(s1.x*s1.y < s2.x*s2.y) {
					var tempBounds:Bounds = temp.bounds.clone();
					var tempData:T = temp.data;
					
					// swap current node with new node 
					temp = node;
					node = new QuadTreeNode<T>(tempBounds, tempData);

					// treat previous current node as new node
					continue;
				}
			}

            var childIndex:Int = temp.insertChild(node);

            // edge cases
			if (childIndex == -1) return true; // node was successfully inserted as child
            if (childIndex == -2) {            // node is at max depth
                temp.bucket.push(node);
                return true;
            }

			currentDepth++;
			stack.add(temp.children[childIndex]); // node collided with an exisiting child
		}

		// should never happen
		return false;
	}

	public function remove(bounds:Bounds, data:T):Bool {
		return false;
	}

	public function allocate():Void {}

	public function clear():Void {}
}