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
		this.bucket = new Array<QuadTreeNode<T>>();
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

	public function clone():QuadTreeNode<T> {
		return new QuadTreeNode<T>(bounds.clone(), this.data);
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

	public function new(bounds:Bounds, init:T, depth:Int, capacity:Int=5):Void {
		this.depth = depth;
		this.capacity = capacity;
		root = new QuadTreeNode(bounds, init);
	}

	public function search(node:Bounds):Array<T> {
		var result:Array<T> = new Array<T>();

		var stack:GenericStack<QuadTreeNode<T>> = new GenericStack<QuadTreeNode<T>>();
		stack.add(root);

		while(!stack.isEmpty()) {
			var temp:QuadTreeNode<T> = stack.pop();
			if(temp.data != null && temp.bounds.intersects(node)) {
				result.push(temp.data);
				for(b in temp.bucket) {
					result.push(b.data);
				}
			}

			for(child in temp.children) {
				if(temp.data == null) continue;
				stack.add(child);
			}
		}

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
			if(!temp.bounds.intersects(node.bounds)) continue;

			if (currentDepth > this.depth) {
				temp.bucket.push(node);
				return true;
			}

			// check if new node is bigger than current node (other than root node)
			if (currentDepth > 0) {
				var s1:Point = temp.bounds.getSize(); 
				var s2:Point = node.bounds.getSize(); 
				if(s1.x*s1.y < s2.x*s2.y) {
					var tempBounds:Bounds = temp.bounds.clone();
					var tempData:T = temp.data;
					
					// swap current node with new node 
					temp = node;
					node = new QuadTreeNode<T>(tempBounds, tempData);
					stack.add(node);

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
		if(data == null) return true;

		var stack:GenericStack<QuadTreeNode<T>> = new GenericStack<QuadTreeNode<T>>();
		var parentStack:GenericStack<QuadTreeNode<T>> = new GenericStack<QuadTreeNode<T>>();

		stack.add(root);
		while (!stack.isEmpty()) { 
			var temp:QuadTreeNode<T> = stack.pop();
			if (!temp.bounds.intersects(bounds)) continue;

			for (i in 0...temp.bucket.length) {
				if (temp.bucket[i].data == data) {
					return temp.bucket.remove(temp.bucket[i]);
				}
			}

			if(temp.data == data) { // found element to remove
				var parent:QuadTreeNode<T> = parentStack.pop();
				var index:Int = parent.intersects(temp);

				var otherChildren:Array<Int> = new Array<Int>();
				var maxSize:Point = new Point();
				var maxSizeIndex:Int = -1;
				for(i in 0...temp.children.length) {
					var size:Point = temp.children[i].bounds.getSize();
					if (size.length() > maxSize.length()) {
						maxSize = size;
						maxSizeIndex = i;
						continue;
					}
					otherChildren.push(i);
				}

				var cloner:util.Cloner = new util.Cloner();

				// node was a leaf
				if (maxSizeIndex == -1) { 
					parent.bucket = cloner.clone(temp.children[maxSizeIndex].bucket);
					return true;
				}

				// set the larget child as the new node
				// not the best but its haxe ¯\_(ツ)_/¯
				parent.children[index] = cloner.clone(temp.children[maxSizeIndex]); 

				// insert the other children and their children (less complex way)
				var stack:GenericStack<QuadTreeNode<T>> = new GenericStack<QuadTreeNode<T>>();

				for(childIndex in otherChildren) {
					stack.add(temp.children[childIndex]);

					while(!stack.isEmpty()) {
						var child:QuadTreeNode<T> = stack.pop();

						var ok:Bool = this.insert(child.bounds, child.data);
						if (!ok) {
							trace('[ERROR | SQT(remove)] failed to insert child [data=${child.data}] [bounds=${child.bounds}]');
						}

						for(c in child.children) {
							if (c.data == null) continue;
							stack.add(c);
						}
					}
				}

				return true;
			}

			parentStack.add(temp);
			for (child in temp.children) {
				if (temp.data == null) {
					continue;
				}

				stack.add(child);
			}
		}

		return false;
	}

	public function clear():Void {
		root.children = new Vector<QuadTreeNode<T>>(4);
		root.bucket = new Array<QuadTreeNode<T>>();
	}
}