package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarGuideStatusUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _guideStatus:int;

        public function RoomObjectAvatarGuideStatusUpdateMessage(guideStatus:int)
        {
            _guideStatus = guideStatus;
        }

        public function get guideStatus():int
        {
            return (_guideStatus);
        }

    }
}