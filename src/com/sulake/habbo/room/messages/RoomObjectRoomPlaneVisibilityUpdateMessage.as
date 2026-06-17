package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;

    public class RoomObjectRoomPlaneVisibilityUpdateMessage extends RoomObjectUpdateMessage 
    {

        public static const _SafeStr_3172:String = "RORPVUM_WALL_VISIBILITY";
        public static const _SafeStr_3173:String = "RORPVUM_FLOOR_VISIBILITY";

        private var _type:String = "";
        private var _visible:Boolean = false;

        public function RoomObjectRoomPlaneVisibilityUpdateMessage(type:String, visible:Boolean)
        {
            super(null, null);
            _type = type;
            _visible = visible;
        }

        public function get type():String
        {
            return (_type);
        }

        public function get visible():Boolean
        {
            return (_visible);
        }

    }
}
