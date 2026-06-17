package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarSelectedMessage extends RoomObjectUpdateStateMessage 
    {

        private var _selected:Boolean;

        public function RoomObjectAvatarSelectedMessage(selected:Boolean)
        {
            _selected = selected;
        }

        public function get selected():Boolean
        {
            return (_selected);
        }

    }
}