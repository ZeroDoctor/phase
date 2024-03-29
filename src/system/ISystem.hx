package system;

interface ISystem {
	public function getSignatures():Array<String>;
	public function getName():String;
	public function init():Void;
	public function update(entities:Array<Int>, dt:Float):Void;
	public function render(e:h3d.Engine):Void;
	public function input(event:hxd.Event):Void;
}