package com.sulake.room.renderer {
    import com.sulake.room.object.IRoomObject;

    public /*dynamic*/interface IRoomRendererBase {

        function dispose():void;
        function reset():void;
        function feedRoomObject(roomObject:IRoomObject):void;
        function removeRoomObject(roomObject:IRoomObject):void;
        function update(timestamp:uint):void;

    }
}
