package state;

import handler.SceneHandler;
import hxd.res.DefaultFont;

class PlayState implements IState {
  private var scene:h2d.Scene;
  private var g:h2d.Graphics;

  private var fpsText:h2d.Text;
  private var drawCallText:h2d.Text;
  
  private var sceneHandler:SceneHandler;

  public function new(scene:h2d.Scene) {
    this.scene = scene;

    g = new h2d.Graphics(this.scene);
  }

  public function init(sm:StateManager):Void {
    trace("init playstate...");
    
    var font:h2d.Font = DefaultFont.get();

    fpsText = new h2d.Text(font);
    fpsText.textAlign = Left;

    drawCallText = new h2d.Text(font);
    drawCallText.textAlign = Left;
    drawCallText.y = fpsText.textHeight + 5;

    this.scene.addChild(fpsText);
    this.scene.addChild(drawCallText);

    this.sceneHandler = new SceneHandler(scene);
  }
  
  public function update(dt:Float):Void {

  }

  public function render(e:h3d.Engine):Void {
    fpsText.text = "fps: "+Std.string(e.fps);
    drawCallText.text = "draw calls: "+Std.string(e.drawCalls);
  }

  public function input(event:hxd.Event):Void {

  }
}
