package state;

import haxe.ds.GenericStack;

class StateManager {

  private var states:GenericStack<State>;
  
  public function new(scene2d:h2d.Scene) {
    states = new GenericStack<State>();
  }

  public function init():Void {
    if (states.isEmpty()) {
      return;
    }

    var cs:State = states.first();
    cs.init(this);
  }

  public function update(dt:Float):Void {
    if (states.isEmpty()) {
      return;
    }

    var cs:State = states.first();
    cs.update(dt);
  }

  public function render(e:h3d.Engine):Void {
    if (states.isEmpty()) {
      return;
    }

    var cs:State = states.first();
    cs.render(e);
  }
  
  public function input(event:hxd.Event):Void {
    if (states.isEmpty()) {
      return;
    }

    var cs:State = states.first();
    cs.input(event);
  }

  public function pushState(state:State):Void { this.states.add(state); }

}

