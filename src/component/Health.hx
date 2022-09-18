package component;

class Health implements IComponent {
    private var value:Int = 100;
    private var regen:Float = 1.0;
    private var immortal:Bool = false;

    public function getName():String {
        return "Health";
    }
}