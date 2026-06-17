package com.sulake.habbo.room.object
{
    public class RoomPlaneMaskData 
    {

        private var _leftSideLoc:Number = 0;
        private var _rightSideLoc:Number = 0;
        private var _leftSideLength:Number = 0;
        private var _rightSideLength:Number = 0;

        public function RoomPlaneMaskData(leftSideLoc:Number, rightSideLoc:Number, leftSideLength:Number, rightSideLength:Number)
        {
            _leftSideLoc = leftSideLoc;
            _rightSideLoc = rightSideLoc;
            _leftSideLength = leftSideLength;
            _rightSideLength = rightSideLength;
        }

        public function get leftSideLoc():Number
        {
            return (_leftSideLoc);
        }

        public function get rightSideLoc():Number
        {
            return (_rightSideLoc);
        }

        public function get leftSideLength():Number
        {
            return (_leftSideLength);
        }

        public function get rightSideLength():Number
        {
            return (_rightSideLength);
        }

    }
}