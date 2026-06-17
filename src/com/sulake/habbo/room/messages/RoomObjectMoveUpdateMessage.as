package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectMoveUpdateMessage extends RoomObjectUpdateMessage 
    {

        private var _realTargetLoc:IVector3d;
        private var _isSlideUpdate:Boolean;

        public function RoomObjectMoveUpdateMessage(oldLoc:IVector3d, targetLoc:IVector3d, newLoc:IVector3d, isSlideUpdate:Boolean=false)
        {
            super(oldLoc, newLoc);
            _isSlideUpdate = isSlideUpdate;
            _realTargetLoc = targetLoc;
        }

        public function get targetLoc():IVector3d
        {
            if (_realTargetLoc == null)
            {
                return (loc);
            };

            return (_realTargetLoc);
        }

        public function get realTargetLoc():IVector3d
        {
            return (_realTargetLoc);
        }

        public function get isSlideUpdate():Boolean
        {
            return (_isSlideUpdate);
        }

    }
}