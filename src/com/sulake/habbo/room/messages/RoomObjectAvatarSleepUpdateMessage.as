package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarSleepUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _isSleeping:Boolean;

        public function RoomObjectAvatarSleepUpdateMessage(isSleeping:Boolean=false)
        {
            _isSleeping = isSleeping;
        }

        public function get isSleeping():Boolean
        {
            return (_isSleeping);
        }

    }
}