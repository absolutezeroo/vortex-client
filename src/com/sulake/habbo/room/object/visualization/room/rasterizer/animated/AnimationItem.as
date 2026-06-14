package com.sulake.habbo.room.object.visualization.room.rasterizer.animated
{
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class AnimationItem 
    {

        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _speedX:Number = 0;
        private var _speedY:Number = 0;
        private var _bitmapData:BitmapData = null;

        public function AnimationItem(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:BitmapData)
        {
            _x = _arg_1;
            _y = _arg_2;
            _speedX = _arg_3;
            _speedY = _arg_4;

            if (isNaN(_x))
            {
                _x = 0;
            };

            if (isNaN(_y))
            {
                _y = 0;
            };

            if (isNaN(_speedX))
            {
                _speedX = 0;
            };

            if (isNaN(_speedY))
            {
                _speedY = 0;
            };

            _bitmapData = _arg_5;
        }

        public function get bitmapData():BitmapData
        {
            return (_bitmapData);
        }

        public function dispose():void
        {
            _bitmapData = null;
        }

        public function getPosition(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number, _arg_5:int):Point
        {
            var _local_6:Number = _x;
            var _local_7:Number = _y;

            if (_arg_3 > 0)
            {
                _local_6 = (_local_6 + (((_speedX / _arg_3) * _arg_5) / 1000));
            };

            if (_arg_4 > 0)
            {
                _local_7 = (_local_7 + (((_speedY / _arg_4) * _arg_5) / 1000));
            };

            var _local_8:int = ((_local_6 % 1) * _arg_1);
            var _local_9:int = ((_local_7 % 1) * _arg_2);
            return (new Point(_local_8, _local_9));
        }

    }
}
