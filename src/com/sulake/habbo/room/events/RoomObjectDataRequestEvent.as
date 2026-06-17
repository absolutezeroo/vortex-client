package com.sulake.habbo.room.events
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectDataRequestEvent extends RoomObjectEvent 
    {

        public static const CURRENT_USER_ID:String = "RODRE_CURRENT_USER_ID";
        public static const URL_PREFIX:String = "RODRE_URL_PREFIX";

        public function RoomObjectDataRequestEvent(type:String, roomObject:IRoomObject, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, roomObject, bubbles, cancelable);
        }

    }
}