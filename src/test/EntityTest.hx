package test;

import haxe.Exception;
import handler.EntityHandler;

@:generic
function assertArray<T>(got:Array<T>, want:Array<T>):Bool {
    if (got.length != want.length) return false;

    for (i in 0...got.length) {
        if (got[i] != want[i]) return false;
    }

    return true;
}

class EntityTest {
    public function new() {
        var eh:EntityHandler = new EntityHandler();
        var want:Array<Int> = new Array<Int>();
        var got:Array<Int> = new Array<Int>();

        {
            eh.createEntity();
            eh.createEntity();
            eh.createEntity();
            eh.createEntity();
            got = new Array<Int>();
            for(i in eh.iterator()) {
                got.push(i);
            }

            want = [1,2,3,4];
            if(!assertArray(got, want)) {
                throw new Exception('[ERROR] [got=$got}] [want=$want]');
            }
        }

        {
            eh.killEntity(3);
            got = new Array<Int>();
            for(i in eh.iterator()) {
                got.push(i);
            }

            want = [1,2,4];
            if(!assertArray(got, want)) {
                throw new Exception('[ERROR] [got=$got}] [want=$want]');
            }
        }

        {
            eh.createEntity();
            got = new Array<Int>();
            for(i in eh.iterator()) {
                got.push(i);
            }

            want = [1,2,3,4];
            if(!assertArray(got, want)) {
                throw new Exception('[ERROR] [got=$got}] [want=$want]');
            }
        }

        {
            eh.createEntity();
            got = new Array<Int>();
            for(i in eh.iterator()) {
                got.push(i);
            }

            want = [1,2,3,4,5];
            if(!assertArray(got, want)) {
                throw new Exception('[ERROR] [got=$got}] [want=$want]');
            }
        }

        {
            eh.killEntity(5);
            got = new Array<Int>();
            for(i in eh.iterator()) {
                got.push(i);
            }

            want = [1,2,3,4];
            if(!assertArray(got, want)) {
                throw new Exception('[ERROR] [got=$got}] [want=$want]');
            }
        }

        {
            eh.createEntity();
            eh.createEntity();
            got = new Array<Int>();
            for(i in eh.iterator()) {
                got.push(i);
            }

            want = [1,2,3,4,5,6];
            if(!assertArray(got, want)) {
                throw new Exception('[ERROR] [got=$got}] [want=$want]');
            }
        }
    }
}
