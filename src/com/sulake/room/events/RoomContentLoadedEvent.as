package com.sulake.room.events
{
    import flash.events.Event;

    public class RoomContentLoadedEvent extends Event 
    {

        public static const CONTENT_LOAD_SUCCESS:String = "RCLE_SUCCESS";
        public static const CONTENT_LOAD_FAILURE:String = "RCLE_FAILURE";
        public static const CONTENT_LOAD_CANCEL:String = "RCLE_CANCEL";

        private var _contentType:String;

        public function RoomContentLoadedEvent(type:String, contentType:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _contentType = contentType;
        }

        public function get contentType():String
        {
            return (_contentType);
        }

    }
}
