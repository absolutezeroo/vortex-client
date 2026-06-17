package com.sulake.room.object.logic
{
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

    public /*dynamic*/ interface IRoomObjectMouseHandler 
    {

        function mouseEvent(_event:RoomSpriteMouseEvent, _geometry:IRoomGeometry):void;

    }
}

