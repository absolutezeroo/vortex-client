package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarPlayerValueUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _value:int;

        public function RoomObjectAvatarPlayerValueUpdateMessage(value:int)
        {
            _value = value;
        }

        public function get value():int
        {
            return (_value);
        }

    }
}