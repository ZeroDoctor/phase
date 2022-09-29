package state;

import system.ColliderSystem;
import system.VelocitySystem;
import system.RenderGeometrySystem;
import init.Init;
import handler.SystemHandler;
import handler.SceneHandler;
import hxd.res.DefaultFont;
import h2d.col.Bounds;

class PlayState implements IState {
    private var scene:h2d.Scene;
    private var g:h2d.Graphics;

    private var fpsText:h2d.Text;
    private var drawCallText:h2d.Text;

    private var sceneHandler:SceneHandler;
    private var systemHandler:SystemHandler;

    public function new(scene:h2d.Scene) {
        this.scene = scene;
        this.g = new h2d.Graphics(this.scene);
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
        
        var velocitySystem:VelocitySystem = new VelocitySystem(sceneHandler);
        systemHandler.register(velocitySystem);

        var sceneSize:Bounds = Bounds.fromValues(-2000.0, -2000.0, 4000.0, 4000.0);
        var colliderSystem:ColliderSystem = new ColliderSystem(sceneHandler, sceneSize);
        systemHandler.register(colliderSystem);
        
        var renderGeometrySystem:RenderGeometrySystem = new RenderGeometrySystem(sceneHandler);
        systemHandler.register(renderGeometrySystem);

        colliderSystem.addResolutionFunction(function(main, other):Void {
            var aDir:Float = main.velocity.direction;
            var bDir:Float = other.velocity.direction;

            main.velocity.direction = bDir;
            other.velocity.direction = aDir;

            // main.velocity.direction = (main.velocity.direction + Math.PI) % (2*Math.PI);
            // other.velocity.direction = (other.velocity.direction + Math.PI) % (2*Math.PI);

            // main.velocity.direction = (main.velocity.direction + Math.PI);
            // other.velocity.direction = (other.velocity.direction + Math.PI);
        });

        initScene(sceneHandler);
    }

    public function update(dt:Float):Void {
        systemHandler.update(dt);
    }

    public function render(e:h3d.Engine):Void {
        g.clear();
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

    var entityCount:Int = 350;
    var row:Int = 25;
    var col:Int = 25;
    var spacing:Float = 25.0;
    var xOffset:Int = 150;
    var yOffset:Int = 150;

    for (i in 0...entityCount) {
        init.newEntity(
            ((i%col)*spacing)+xOffset, ((i/row)*spacing)+yOffset,
            Std.random(0x707070) + 0x8F8F8F,
            25.0, Math.random()+i
        );
    }
}
