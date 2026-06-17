package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarCarryObjectUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _itemType:int;
        private var _itemName:String;

        public function RoomObjectAvatarCarryObjectUpdateMessage(itemType:int, itemName:String)
        {
            _itemType = itemType;
            _itemName = itemName;
        }

        public function get itemType():int
        {
            return (_itemType);
        }

        public function get itemName():String
        {
            return (_itemName);
        }

    }
}