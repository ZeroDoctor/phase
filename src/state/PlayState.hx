package state;

import hxd.res.DefaultFont;

class PlayState implements IState {
  private var scene:h2d.Scene;
  private var g:h2d.Graphics;
  private var fps:h2d.Text;

  public function new(scene:h2d.Scene) {
    this.scene = scene;

    g = new h2d.Graphics(this.scene);

    var font:h2d.Font = DefaultFont.get();
    fps = new h2d.Text(font);
    fps.textAlign = Left;

    this.scene.addChild(fps);
  }

  public function init(sm:StateManager):Void {
    trace("init playstate...");
    
  }
  
  public function update(dt:Float):Void {

  }

  public function render(e:h3d.Engine):Void {
    fps.text = "fps: "+Std.string(e.fps);

  }

  public function input(event:hxd.Event):Void {

  }
}
