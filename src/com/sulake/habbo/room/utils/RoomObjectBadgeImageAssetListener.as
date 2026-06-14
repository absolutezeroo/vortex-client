package com.sulake.habbo.room.utils
{
    import com.sulake.room.object.IRoomObjectController;

        public class RoomObjectBadgeImageAssetListener 
    {

        private var _object:IRoomObjectController;
        private var _groupBadge:Boolean;

        public function RoomObjectBadgeImageAssetListener(object:IRoomObjectController, groupBadge:Boolean)
        {
            _object = object;
            _groupBadge = groupBadge;
        }

        public function get object():IRoomObjectController
        {
            return (_object);
        }

        public function get groupBadge():Boolean
        {
            return (_groupBadge);
        }

    }
}