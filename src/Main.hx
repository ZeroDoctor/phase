import test.QuadTreeTest.TreeTest;
import test.BoundsTest;
import test.EntityTest;
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

	public override function update(dt:Float):Void {
		super.update(dt);

		sm.update(dt);
  }

  public override function render(e:h3d.Engine):Void {
    super.render(e);

    sm.render(e);
  }
  
  public function input(event:hxd.Event):Void {
    sm.input(event);
  }

  public static function main():Void {
    trace("------ entity ------");
    new EntityTest();
    trace("------ bounds ------");
    new BoundsTest();
    trace("------ tree ------");
    var treeTest:TreeTest = new TreeTest();
    treeTest.Normal();
    treeTest.Fast();
    trace("------ main ------");
    new Main();
  }
}
