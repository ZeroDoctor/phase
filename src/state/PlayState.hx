package state;

import component.Velocity;
import system.ColliderSystem;
import system.VelocitySystem;
import system.RenderGeometrySystem;
import init.Init;
import handler.SystemHandler;
import handler.SceneHandler;
import hxd.res.DefaultFont;
import h2d.col.Bounds;
import haxe.ds.Option;

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
        
        var sceneSize:Bounds = Bounds.fromValues(-2000.0, -2000.0, 4000.0, 4000.0);
        var colliderSystem:ColliderSystem = new ColliderSystem(sceneHandler, sceneSize);
        systemHandler.register(colliderSystem);

        var velocitySystem:VelocitySystem = new VelocitySystem(sceneHandler);
        systemHandler.register(velocitySystem);
        
        var renderGeometrySystem:RenderGeometrySystem = new RenderGeometrySystem(sceneHandler);
        systemHandler.register(renderGeometrySystem);

        colliderSystem.addResolutionFunction(function(main, other):Void {
            var angle:Float = Math.atan2(other.bounds.y-main.bounds.y, other.bounds.x-main.bounds.x);
            if (angle < 0.0) {
                angle += Math.PI*2;
            }

            main.velocity.direction = Math.PI + angle;
            other.velocity.direction = angle;

			var optRender:Option<component.RenderGeometry> = sceneHandler.getComponent(main.entityID, "RenderGeometry");
			var render:component.RenderGeometry = switch (optRender) {
				case Some(v): v;
				case _:
					trace('failed to get bounds component with [entity=${main.entityID}]');
                    new component.RenderGeometry({});
			}
            render.color = 0xFFFFFF;

			var optRender:Option<component.RenderGeometry> = sceneHandler.getComponent(other.entityID, "RenderGeometry");
			var render:component.RenderGeometry = switch (optRender) {
				case Some(v): v;
				case _:
					trace('failed to get bounds component with [entity=${main.entityID}]');
                    new component.RenderGeometry({});
			}
            render.color = 0xFF00FF;
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

    var entityCount:Int = 100;
    var row:Int = 25;
    var col:Int = 25;
    var spacing:Float = 35.0;
    var xOffset:Int = cast(300/2, Int);
    var yOffset:Int = cast(768/2, Int);

    var initSpeed:Float = 25.0;

    for (i in 0...entityCount) {
        init.newEntity(
            ((i%col)*spacing)+xOffset, ((i/row)*spacing)+yOffset,
            Std.random(0x707070) + 0x8F8F8F,
            initSpeed, Math.random()+i
        );
    }
}
