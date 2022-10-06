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

	public function init():Void {}

	public function update(entities:Array<Int>, dt:Float):Void {
		this.entities = entities;
	}

	public function render(e:h3d.Engine):Void {
		for (entity in entities) {
			var optBounds:Option<Bounds> = sh.getComponent(entity, "Bounds");
			var bounds:Bounds = switch (optBounds) {
				case Some(v): v;
				case _: continue;
			}

			var optGeo:Option<RenderGeometry> = sh.getComponent(entity, "RenderGeometry");
			var geo:RenderGeometry = switch (optGeo) {
				case Some(v): v;
				case _: continue;
			}

			switch (geo.shape) {
				case RECT:
					sh.getGraphics().beginFill(geo.color, geo.alpha);
					sh.getGraphics().drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
					sh.getGraphics().endFill();
				case CIRCLE:
					sh.getGraphics().beginFill(geo.color, geo.alpha);
					sh.getGraphics().drawCircle(bounds.x, bounds.y, bounds.radius, 0);
					sh.getGraphics().endFill();
				case ELLIPSE:
					sh.getGraphics().beginFill(geo.color, geo.alpha);
					sh.getGraphics().drawEllipse(bounds.x, bounds.y, bounds.radiusX, bounds.radiusY, 0, 0);
					sh.getGraphics().endFill();
				case OUTLINE_RECT:
					sh.getGraphics().lineStyle(geo.lineSize, geo.color);
					sh.getGraphics().drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				case OUTLINE_CIRCLE:
					sh.getGraphics().lineStyle(geo.lineSize, geo.color);
					sh.getGraphics().drawCircle(bounds.x, bounds.y, bounds.radius, 0);
			}
		}
	}

	public function input(event:hxd.Event):Void {}
}