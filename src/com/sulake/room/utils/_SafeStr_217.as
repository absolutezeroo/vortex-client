package com.sulake.room.utils
{
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class _SafeStr_217
    {
        public static function line(sourceBitmap:BitmapData, from:Point, to:Point, color:int):void
        {
            BitmapDataTransformUtil.line(sourceBitmap, from, to, color);
        }

        public static function getFlipHBitmapData(sourceBitmap:BitmapData):BitmapData
        {
            return (BitmapDataTransformUtil.getFlipHBitmapData(sourceBitmap));
        }

        public static function getFlipVBitmapData(sourceBitmap:BitmapData):BitmapData
        {
            return (BitmapDataTransformUtil.getFlipVBitmapData(sourceBitmap));
        }

        public static function getFlipHVBitmapData(sourceBitmap:BitmapData):BitmapData
        {
            return (BitmapDataTransformUtil.getFlipHVBitmapData(sourceBitmap));
        }
    }
}
