package com.sulake.room.utils
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Matrix;

    public class BitmapDataUtil
    {

        public static function drawLine(target:BitmapData, from:Point, to:Point, color:int):void
        {
            var deltaX:int;
            var deltaY:int;
            var lineErrorAccumulator:int;
            var verticalProgress:int;
            var horizontalProgress:int;
            var stepX:int;
            var stepY:int;
            var currentX:int = from.x;
            var currentY:int = from.y;
            deltaX = (to.x - from.x);
            deltaY = (to.y - from.y);
            stepX = ((deltaX > 0) ? 1 : -1);
            stepY = ((deltaY > 0) ? 1 : -1);
            deltaX = Math.abs(deltaX);
            deltaY = Math.abs(deltaY);
            target.lock();
            target.setPixel32(currentX, currentY, color);

            if (((deltaX == 0) && (deltaY == 0)))
            {
                return;
            }

            if (deltaX > deltaY)
            {
                lineErrorAccumulator = (deltaX - 1);

                while (lineErrorAccumulator >= 0)
                {
                    verticalProgress = (verticalProgress + deltaY);
                    currentX = (currentX + stepX);

                    if (verticalProgress >= (deltaX / 2))
                    {
                        verticalProgress = (verticalProgress - deltaX);
                        currentY = (currentY + stepY);
                    }

                    target.setPixel32(currentX, currentY, color);
                    lineErrorAccumulator--;
                }
            }
            else
            {
                lineErrorAccumulator = (deltaY - 1);

                while (lineErrorAccumulator >= 0)
                {
                    horizontalProgress = (horizontalProgress + deltaX);
                    currentY = (currentY + stepY);

                    if (horizontalProgress >= (deltaY / 2))
                    {
                        horizontalProgress = (horizontalProgress - deltaY);
                        currentX = (currentX + stepX);
                    }

                    target.setPixel32(currentX, currentY, color);
                    lineErrorAccumulator--;
                }
            }

            target.setPixel32(to.x, to.y, color);
            target.unlock();
        }

        public static function getFlipHBitmapData(source:BitmapData):BitmapData
        {
            if (source == null)
            {
                return (null);
            }

            var flipped:BitmapData;
            flipped = new BitmapData(source.width, source.height, true, 0xFFFFFF);

            var transform:Matrix = new Matrix();
            transform.scale(-1, 1);
            transform.translate(source.width, 0);
            flipped.draw(source, transform);
            return (flipped);
        }

        public static function getFlipVBitmapData(source:BitmapData):BitmapData
        {
            if (source == null)
            {
                return (null);
            }

            var flipped:BitmapData;
            flipped = new BitmapData(source.width, source.height, true, 0xFFFFFF);

            var transform:Matrix = new Matrix();
            transform.scale(1, -1);
            transform.translate(0, source.height);
            flipped.draw(source, transform);
            return (flipped);
        }

        public static function getFlipHVBitmapData(source:BitmapData):BitmapData
        {
            if (source == null)
            {
                return (null);
            }

            var flipped:BitmapData;
            flipped = new BitmapData(source.width, source.height, true, 0xFFFFFF);

            var transform:Matrix = new Matrix();
            transform.scale(-1, -1);
            transform.translate(source.width, source.height);
            flipped.draw(source, transform);
            return (flipped);
        }

    }
}
