package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarTypingUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _isTyping:Boolean;

        public function RoomObjectAvatarTypingUpdateMessage(isTyping:Boolean=false)
        {
            _isTyping = isTyping;
        }

        public function get isTyping():Boolean
        {
            return (_isTyping);
        }

    }
}