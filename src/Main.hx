
class Main extends hxd.App {
  public function new() {
    super();
  }
  
  public override function init():Void {
    var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
    tf.text = "Hello Watching!";
  }

  public static function main():Void {
    new Main();
  }
}
