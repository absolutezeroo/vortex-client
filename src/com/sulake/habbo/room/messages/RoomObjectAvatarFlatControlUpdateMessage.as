package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarFlatControlUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _isAdmin:Boolean = false;
        private var _rawData:String;

        public function RoomObjectAvatarFlatControlUpdateMessage(rawData:String)
        {
            _rawData = rawData;
        }

        public function get isAdmin():Boolean
        {
            return (_isAdmin);
        }

        public function get rawData():String
        {
            return (_rawData);
        }

    }
}