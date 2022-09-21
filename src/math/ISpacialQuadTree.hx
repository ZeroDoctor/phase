package math;

import h2d.col.Bounds;

@:generic
interface ISpacialQuadTree<T> {
    public function search():Array<T>;
    public function insert(bounds:Bounds, data:T):Bool;
    public function remove(bounds:Bounds, data:T):Bool;
    public function allocate():Void;
    public function clear():Void;
}