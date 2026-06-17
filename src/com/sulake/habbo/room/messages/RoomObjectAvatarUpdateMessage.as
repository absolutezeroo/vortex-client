package com.sulake.habbo.room.messages
{
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectAvatarUpdateMessage extends RoomObjectMoveUpdateMessage 
    {

        private var _dirHead:int;
        private var _canStandUp:Boolean;
        private var _baseY:Number;

        public function RoomObjectAvatarUpdateMessage(location:IVector3d, previousLocation:IVector3d, headLocation:IVector3d, dirHead:int, canStandUp:Boolean, baseY:Number)
        {
            super(location, previousLocation, headLocation);
            _dirHead = dirHead;
            _canStandUp = canStandUp;
            _baseY = baseY;
        }

        public function get dirHead():int
        {
            return (_dirHead);
        }

        public function get canStandUp():Boolean
        {
            return (_canStandUp);
        }

        public function get baseY():Number
        {
            return (_baseY);
        }

    }
}