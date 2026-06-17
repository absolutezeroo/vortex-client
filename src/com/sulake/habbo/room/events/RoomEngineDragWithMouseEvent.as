package com.sulake.habbo.room.events
{
    public class RoomEngineDragWithMouseEvent extends RoomEngineEvent 
    {

        public static const _SafeStr_3156:String = "REDWME_DRAG_START";
        public static const _SafeStr_3157:String = "REDWME_DRAG_END";

        public function RoomEngineDragWithMouseEvent(type:String, roomId:int, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, roomId, bubbles, cancelable);
        }

    }
}
