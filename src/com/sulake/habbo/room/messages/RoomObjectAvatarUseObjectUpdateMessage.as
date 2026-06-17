package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarUseObjectUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _itemType:int;

        public function RoomObjectAvatarUseObjectUpdateMessage(itemType:int)
        {
            _itemType = itemType;
        }

        public function get itemType():int
        {
            return (_itemType);
        }

    }
}