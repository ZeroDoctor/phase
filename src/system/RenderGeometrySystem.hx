package system;

import component.RenderGeometry;
import haxe.ds.Option;
import component.Bounds;
import handler.SceneHandler;

class RenderGeometrySystem extends System implements ISystem {
    private var entities:Array<Int>;
    public function new(sh:SceneHandler):Void {
        super(sh);
    }

	public function getSignatures():Array<String> {
        return ["Bounds", "RenderGeometry"];
	}

	public function getName():String {
        return "RenderGeometry";
	}

	public function init():Void { }

	public function update(entities:Array<Int>, dt:Float):Void {
        this.entities = entities;
    }

   public function render(e:h3d.Engine):Void {
        for (e in entities) {
            var optBounds:Option<Bounds> = sh.getComponent(e, "Bounds");
            var bounds:Bounds = switch(optBounds) {
                case Some(v): v;
                case _: continue;
            }

            var optGeo:Option<RenderGeometry> = sh.getComponent(e, "RenderGeometry");
            var geo:RenderGeometry = switch(optGeo) {
                case Some(v): v;
                case _: continue;
            }

            if (geo.color > 0) {
                sh.getGraphics().beginFill(geo.color, 1.0);
            }

            switch(geo.shape) {
                case RECT:
                    sh.getGraphics().drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
                case CIRCLE:
                    sh.getGraphics().drawCircle(bounds.x, bounds.y, bounds.radius, 0);
                case ELLIPSE:
                    sh.getGraphics().drawEllipse(bounds.x, bounds.y, bounds.radiusX, bounds.radiusY, 0, 0);
            }

            if (geo.color > 0) {
                sh.getGraphics().endFill();
            }
        }
   }

   public function input(event:hxd.Event):Void {}
}