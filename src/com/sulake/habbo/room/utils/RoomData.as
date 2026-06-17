package com.sulake.habbo.room.utils
{
        public class RoomData 
    {

        private var _roomId:int;
        private var _data:XML;
        private var _floorType:String = null;
        private var _wallType:String = null;
        private var _landscapeType:String = null;

        public function RoomData(roomId:int, data:XML)
        {
            _roomId = roomId;
            _data = data;
        }

        public function get roomId():int
        {
            return (_roomId);
        }

        public function get data():XML
        {
            return (_data);
        }

        public function get floorType():String
        {
            return (_floorType);
        }

        public function set floorType(floorType:String):void
        {
            _floorType = floorType;
        }

        public function get wallType():String
        {
            return (_wallType);
        }

        public function set wallType(wallType:String):void
        {
            _wallType = wallType;
        }

        public function get landscapeType():String
        {
            return (_landscapeType);
        }

        public function set landscapeType(landscapeType:String):void
        {
            _landscapeType = landscapeType;
        }

    }
}