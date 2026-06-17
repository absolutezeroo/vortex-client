package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarMutedUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _isMuted:Boolean;

        public function RoomObjectAvatarMutedUpdateMessage(isMuted:Boolean=false)
        {
            _isMuted = isMuted;
        }

        public function get isMuted():Boolean
        {
            return (_isMuted);
        }

    }
}