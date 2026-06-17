package com.sulake.habbo.room.messages
{
    public class RoomObjectSelectedMessage extends RoomObjectUpdateStateMessage 
    {

        private var _selected:Boolean;

        public function RoomObjectSelectedMessage(selected:Boolean)
        {
            _selected = selected;
        }

        public function get selected():Boolean
        {
            return (_selected);
        }

    }
}