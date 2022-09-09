
import state.IState;
import state.PlayState;
import state.StateManager;

class Main extends hxd.App {
  private var sm:StateManager;

  public function new():Void {
    super();
  }
  
  public override function init():Void {
    super.init();

    hxd.Res.loader = new hxd.res.Loader(hxd.fs.EmbedFileSystem.create());

    sm = new StateManager(this.s2d);
    hxd.Window.getInstance().addEventTarget(this.input);

    var playState:IState = new PlayState(this.s2d);
    sm.pushState(playState);
    
    sm.init();
  }
  
  public override function update(dt:Float) {
    super.update(dt);

    sm.update(dt);
  }

  public override function render(e:h3d.Engine) {
    e.clear(0x3838D8);
    super.render(e);

    sm.render(e);
  }
  
  public function input(event:hxd.Event) {
    sm.input(event);
  }

  public static function main():Void {
    new Main();
  }
}
