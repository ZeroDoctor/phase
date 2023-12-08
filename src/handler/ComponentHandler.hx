package handler;

import js.html.TableRowElement;
import format.swf.Constants.TagId;
import haxe.ds.Option;
import component.IComponent;

@:generic
private class Components<T:IComponent> {
	private var componentMap:Map<Int, T>;

	public function new():Void {
		this.componentMap = new Map<Int, T>();
	}

	public function get(id:Int):T {
		return this.componentMap.get(id);
	}

	public function has(id:Int):Bool {
		return this.componentMap.exists(id);
	}

	public function push(id:Int, component:T):Void {
		this.componentMap.set(id, component);
	}

	public function remove(id:Int):Bool {
		return this.componentMap.remove(id);
	}

	public function getComponents():Iterator<T> {
		return this.componentMap.iterator();
	}
}

class ComponentHandler{
	private var componentSetMap:Map<String, Components<IComponent>>;

	public function new():Void {
		this.componentSetMap = new Map<String, Components<IComponent>>();
	}

	public function getComponents(name:String):Iterator<IComponent> {
		if (this.componentSetMap.exists(name)) {
			return this.componentSetMap.get(name).getComponents();
		}

		var comp:Components<IComponent> = new Components<IComponent>();
		return comp.getComponents();
	}

	public function hasComponent(id:Int, name:String):Bool {
		if (!this.componentSetMap.exists(name)) {
			return false;
		}

		return this.componentSetMap.get(name).has(id);
	}

	public function getComponent(id:Int, name:String):Option<IComponent> {
		if (!this.componentSetMap.exists(name)) {
			return None;
		}

		var comps:Components<IComponent> = this.componentSetMap.get(name);
		var opt:IComponent = comps.get(id);
		if (opt != null) {
			// var t:T = cast opt; // <-- optimize this by avoiding cast
			return Some(opt);
		}

		return None;
	}

	public function assignComponent(id:Int, comp:IComponent):Void {
		if (this.componentSetMap.exists(comp.getName())) {
			this.componentSetMap.get(comp.getName()).push(id, comp);
			return;
		}

		var ec:Components<IComponent> = new Components<IComponent>();
		ec.push(id, comp);
		this.componentSetMap.set(comp.getName(), ec);
	}

	public function unassignComponent(id:Int, comp:IComponent):Bool {
		if (this.componentSetMap.exists(comp.getName())) {
			this.componentSetMap.get(comp.getName()).remove(id);
			return true;
		}

		return false;
	}
}
