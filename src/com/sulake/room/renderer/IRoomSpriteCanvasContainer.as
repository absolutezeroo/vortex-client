package com.sulake.room.renderer {
    import com.sulake.room.object.IRoomObject;

    public /*dynamic*/interface IRoomSpriteCanvasContainer {

        function get roomObjectVariableAccurateZ():String;
        function getRoomObject(roomObjectId:String):IRoomObject;
        function getRoomObjectWithIndex(index:int):IRoomObject;
        function getRoomObjectIdWithIndex(index:int):String;
        function getRoomObjectCount():int;
        function getRoomObjectIdentifier(roomObject:IRoomObject):String;

    }
}
