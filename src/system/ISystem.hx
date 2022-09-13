package system;

interface ISystem {
   public function getSignature():Array<String>;
   public function getName():String;
   public function init():Void;
   public function update(dt:Float):Void;
}