package test;

import handler.EntityHandler;

class EntityTest {
    public function new() {
        var eh:EntityHandler = new EntityHandler();
        trace("-- created", eh.createEntity());
        trace("-- created", eh.createEntity());
        trace("-- created", eh.createEntity());
        trace("-- created", eh.createEntity());

        for(i in eh.iterator()) {
            trace("-- seen", i);
        }

        eh.killEntity(3);
        trace("-- killed entity 3");

        for(i in eh.iterator()) {
            trace("-- seen", i);
        }

        trace("-- created", eh.createEntity());

        for(i in eh.iterator()) {
            trace("-- seen", i);
        }

        trace("-- created", eh.createEntity());

        for(i in eh.iterator()) {
            trace("-- seen", i);
        }

        eh.killEntity(5);
        trace("-- killed entity 5");

        for(i in eh.iterator()) {
            trace("-- seen", i);
        }

        trace("-- created", eh.createEntity());
        trace("-- created", eh.createEntity());

        for(i in eh.iterator()) {
            trace("-- seen", i);
        }
    }
}
