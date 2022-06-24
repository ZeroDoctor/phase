package state;

interface State {
  public function init(sm:StateManager):Void;
  public function update(dt:Float):Void;
  public function render(e:h3d.Engine):Void;
  public function input(event:hxd.Event):Void;
}
