package com.sulake.room {
    import com.sulake.room.object.IRoomObjectController;

    public /*dynamic*/interface IRoomObjectManager {

        function dispose():void;
        function createObject(_objectId:int, _instanceId:uint, _type:String):IRoomObjectController;
        function getObject(_objectId:int):IRoomObjectController;
        function getObjects():Array;
        function disposeObject(_objectId:int):Boolean;
        function getObjectCount():int;
        function getObjectWithIndex(_index:int):IRoomObjectController;
        function getObjectCountForType(_type:String):int;
        function getObjectWithIndexAndType(_index:int, _type:String):IRoomObjectController;
        function reset():void;

    }
}
