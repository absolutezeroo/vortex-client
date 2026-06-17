package com.sulake.habbo.room.events
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectBadgeAssetEvent extends RoomObjectEvent 
    {

        public static const LOAD_BADGE:String = "ROGBE_LOAD_BADGE";

        private var _badgeId:String;
        private var _groupBadge:Boolean;

        public function RoomObjectBadgeAssetEvent(type:String, roomObject:IRoomObject, badgeId:String, groupBadge:Boolean=true, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, roomObject, bubbles, cancelable);
            _badgeId = badgeId;
            _groupBadge = groupBadge;
        }

        public function get badgeId():String
        {
            return (_badgeId);
        }

        public function get groupBadge():Boolean
        {
            return (_groupBadge);
        }

    }
}