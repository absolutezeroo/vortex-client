package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;

    public class RoomObjectRoomFloorHoleUpdateMessage extends RoomObjectUpdateMessage 
    {

        public static const ADD_HOLE:String = "RORPFHUM_ADD";
        public static const REMOVE_HOLE:String = "RORPFHUM_REMOVE";

        private var _type:String = "";
        private var _id:int;
        private var _x:int;
        private var _y:int;
        private var _width:int;
        private var _height:int;

        public function RoomObjectRoomFloorHoleUpdateMessage(type:String, id:int, x:int=0, y:int=0, width:int=0, height:int=0)
        {
            super(null, null);
            _type = type;
            _id = id;
            _x = x;
            _y = y;
            _width = width;
            _height = height;
        }

        public function get type():String
        {
            return (_type);
        }

        public function get id():int
        {
            return (_id);
        }

        public function get x():int
        {
            return (_x);
        }

        public function get y():int
        {
            return (_y);
        }

        public function get width():int
        {
            return (_width);
        }

        public function get height():int
        {
            return (_height);
        }

    }
}