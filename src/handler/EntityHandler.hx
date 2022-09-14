package handler;

class EntityHandler {
    private var deadEntities:Array<Int>;
    private var entitiesCount:Int;

    public function new():Void {
        this.deadEntities = new Array<Int>();
    }

    public function getEntitesCount():Int { 
        return this.entitiesCount;
    }

    public function isAlive(id:Int):Bool {
        return id > 0 &&
            id <= this.entitiesCount && 
            !this.deadEntities.contains(id);
    }

    public function createEntity():Int { 
        if (this.deadEntities.length <= 0) {
            return ++this.entitiesCount;
        }

        return this.deadEntities.pop();
    }

    public function killEntity(id:Int):Void {
        this.deadEntities.push(id);
    }
}
