package handler;

private class EntitiesIterator {
    private var deadEntites:Array<Int>;
    private var entitiesCount:Int;
    private var index:Int;

    public function new(deadEntities:Array<Int>, entitiesCount:Int):Void {
        this.deadEntites = deadEntities;
        this.entitiesCount = entitiesCount;
        this.index = 0;
    }

    public function hasNext():Bool {
        return index < (entitiesCount-this.deadEntites.length);
    }

    public function next():Int {
        index++;

        var entity:Int = index;
        while (deadEntites.contains(entity)) {
            entity++;
        }

        return entity;
    }
}

class EntityHandler {
    private var deadEntities:Array<Int>;
    private var entitiesCount:Int;

    public function new():Void {
        this.deadEntities = new Array<Int>();
        this.entitiesCount = 0;
    }

    public function getEntitesCount():Int { 
        return this.entitiesCount;
    }

    public function getDeadEntities():Array<Int> {
        return this.deadEntities;
    }

    public function iterator():Iterator<Int> {
        return new EntitiesIterator(this.deadEntities, this.entitiesCount);
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
