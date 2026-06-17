package com.sulake.room.renderer {
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IRoomGeometry;

    public /*dynamic*/interface IRoomRenderingCanvasMouseListener {

        function processRoomCanvasMouseEvent(mouseEvent:RoomSpriteMouseEvent, roomObject:IRoomObject, geometry:IRoomGeometry):void;

    }
}
