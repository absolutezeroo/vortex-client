package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarChatUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _numberOfWords:int;

        public function RoomObjectAvatarChatUpdateMessage(numberOfWords:int)
        {
            _numberOfWords = numberOfWords;
        }

        public function get numberOfWords():int
        {
            return (_numberOfWords);
        }

    }
}