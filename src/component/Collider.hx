package component;

enum ColliderType {
    SOLID;
    HOLE;
}

typedef ColliderDef = {
    @:optional var type:ColliderType;
};

class Collider implements IComponent {
    public var type:ColliderType = SOLID;

    public function new(def:ColliderDef):Void {
        this.type = def.type != null ? def.type : this.type;
    }

    public function getName():String {
        return "Collider";
    }
}