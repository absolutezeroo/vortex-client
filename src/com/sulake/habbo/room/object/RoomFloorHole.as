package com.sulake.habbo.room.object
{
    public class RoomFloorHole 
    {

        private var _x:int;
        private var _y:int;
        private var _width:int;
        private var _height:int;

        public function RoomFloorHole(x:int, y:int, width:int, height:int)
        {
            _x = x;
            _y = y;
            _width = width;
            _height = height;
        }

        public function get x():int
        {
            return (_x);
        }

        public function get y():int
        {
            return (_y);
        }

        public function get width():int
        {
            return (_width);
        }

        public function get height():int
        {
            return (_height);
        }

    }
}