package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarPostureUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _postureType:String;
        private var _parameter:String;

        public function RoomObjectAvatarPostureUpdateMessage(postureType:String, parameter:String="")
        {
            _postureType = postureType;
            _parameter = parameter;
        }

        public function get postureType():String
        {
            return (_postureType);
        }

        public function get parameter():String
        {
            return (_parameter);
        }

    }
}