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

        public function AnimationItem(posX:Number, posY:Number, speedX:Number, speedY:Number, bitmapData:BitmapData)
        {
            _x = posX;
            _y = posY;
            _speedX = speedX;
            _speedY = speedY;

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

            _bitmapData = bitmapData;
        }

        public function get bitmapData():BitmapData
        {
            return (_bitmapData);
        }

        public function dispose():void
        {
            _bitmapData = null;
        }

        public function getPosition(width:int, height:int, maxX:Number, maxY:Number, timeSinceStartMs:int):Point
        {
            var posX:Number = _x;
            var posY:Number = _y;

            if (maxX > 0)
            {
                posX = (posX + (((_speedX / maxX) * timeSinceStartMs) / 1000));
            };

            if (maxY > 0)
            {
                posY = (posY + (((_speedY / maxY) * timeSinceStartMs) / 1000));
            };

            var pixelX:int = ((posX % 1) * width);
            var pixelY:int = ((posY % 1) * height);
            return (new Point(pixelX, pixelY));
        }

    }
}
