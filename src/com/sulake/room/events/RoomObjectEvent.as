package com.sulake.room.events
{
    import flash.events.Event;
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectEvent extends Event 
    {

        private var _object:IRoomObject;

        public function RoomObjectEvent(type:String, roomObject:IRoomObject, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _object = roomObject;
        }

        public function get object():IRoomObject
        {
            return (_object);
        }

        public function get objectId():int
        {
            if (_object != null)
            {
                return (_object.getId());
            };

            return (-1);
        }

        public function get objectType():String
        {
            if (_object != null)
            {
                return (_object.getType());
            };

            return (null);
        }

    }
}
