package com.sulake.room.utils
{
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class BitmapDataTransformUtil
    {
        public static function line(sourceBitmap:BitmapData, from:Point, to:Point, color:int):void
        {
            BitmapDataUtil.drawLine(sourceBitmap, from, to, color);
        }

        public static function getFlipHBitmapData(sourceBitmap:BitmapData):BitmapData
        {
            return (BitmapDataUtil.getFlipHBitmapData(sourceBitmap));
        }

        public static function getFlipVBitmapData(sourceBitmap:BitmapData):BitmapData
        {
            return (BitmapDataUtil.getFlipVBitmapData(sourceBitmap));
        }

        public static function getFlipHVBitmapData(sourceBitmap:BitmapData):BitmapData
        {
            return (BitmapDataUtil.getFlipHVBitmapData(sourceBitmap));
        }
    }
}
