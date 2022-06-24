package state;

import haxe.ds.GenericStack;

class StateManager {

  private var states:GenericStack<State>;
  
  public function new(initState:State) {
    states = new GenericStack<State>();
    states.add(initState);
  }

  public function init():Void {
    var cs:State = states.first();
    cs.init(this);
  }

  public function update(dt:Float):Void {
    var cs:State = states.first();
    cs.update(dt);
  }

  public function render(e:h3d.Engine):Void {
    var cs:State = states.first();
    cs.render(e);
  }
  
  public function input(event:hxd.Event):Void {
    var cs:State = states.first();
    cs.input(event);
  }
}

