package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarExpressionUpdateMessage extends RoomObjectUpdateStateMessage 
    {

        private var _expressionType:int = -1;

        public function RoomObjectAvatarExpressionUpdateMessage(expressionType:int=-1)
        {
            _expressionType = expressionType;
        }

        public function get expressionType():int
        {
            return (_expressionType);
        }

    }
}