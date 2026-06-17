package com.sulake.room.events
{
    import flash.events.Event;

    public class RoomToObjectEvent extends Event 
    {

        public function RoomToObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }

    }
}
