package math;

import h2d.col.Bounds;

@:generic
interface ISpacialQuadTree<T> {
	public function search(bounds:Bounds):Array<T>;
	public function insert(bounds:Bounds, data:T):Bool;
	public function remove(bounds:Bounds, data:T):Bool;
	public function clear():Void;
}