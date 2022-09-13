package handler;

class EntityHandler {
    private var entities:Array<Entity>;
    private var idCount:Int;

    public function new():Void {
        this.entities = new Array<Entity>();
    }

    public function createEntity():Entity { 
        var index:Int = this.entities.length+1;

        var e:Entity = new Entity(index, idCount++);
        this.entities.push(e);

        return e;
    }

    public function destoryEntity(id:Int):Void {}
}

class Entity {
   public var id:Int; 
   public var index:Int;

   public function new(id:Int, index:Int):Void { 
        this.id = id;
        this.index = index;
   }
}
