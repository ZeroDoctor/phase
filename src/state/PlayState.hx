package state;

import system.VelocitySystem;
import init.Init;
import component.RenderGeometry;
import component.Bounds;
import system.RenderGeometrySystem;
import handler.SystemHandler;
import handler.SceneHandler;
import hxd.res.DefaultFont;

class PlayState implements IState {
  private var scene:h2d.Scene;
  private var g:h2d.Graphics;

  private var fpsText:h2d.Text;
  private var drawCallText:h2d.Text;
  
  private var sceneHandler:SceneHandler;
  private var systemHandler:SystemHandler;

  public function new(scene:h2d.Scene) {
    this.scene = scene;

    g = new h2d.Graphics(this.scene);
  }

  public function init(sm:StateManager):Void {
    trace("init playstate...");
    
    var font:h2d.Font = DefaultFont.get();

    fpsText = new h2d.Text(font);
    fpsText.x = 10;
    fpsText.y = 10;
    fpsText.textAlign = Left;

    drawCallText = new h2d.Text(font);
    drawCallText.textAlign = Left;
    drawCallText.x = 10;
    drawCallText.y = fpsText.textHeight + 15;

    this.scene.addChild(fpsText);
    this.scene.addChild(drawCallText);

    this.sceneHandler = new SceneHandler(scene, g);
    this.systemHandler = new SystemHandler(sceneHandler);

    systemHandler.register(new RenderGeometrySystem(sceneHandler));
    systemHandler.register(new VelocitySystem(sceneHandler));

    initScene(sceneHandler);
  }
  
  public function update(dt:Float):Void {
    systemHandler.update(dt);
  }

  public function render(e:h3d.Engine):Void {
    fpsText.text = "fps: "+Std.string(e.fps);
    drawCallText.text = "draw calls: "+Std.string(e.drawCalls);
    systemHandler.render(e);
  }

  public function input(event:hxd.Event):Void {
    systemHandler.input(event);
  }
}

function initScene(sceneHandler:SceneHandler):Void {
  var init:Init = new Init(sceneHandler);

  var entityCount:Int = 50;

  for (i in 0...entityCount) {
    init.newEntity(Std.random(1000), Std.random(1000), Std.random(0xFFFFFF));
  }
}
