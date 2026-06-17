package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import flash.display.BitmapData;

    public class PlaneTextureBitmap 
    {

        public static const _SafeStr_3425:Number = -1;
        public static const MAX_NORMAL_COORDINATE_VALUE:Number = 1;

        private var _bitmap:BitmapData = null;
        private var _normalMinX:Number = -1;
        private var _normalMaxX:Number = 1;
        private var _normalMinY:Number = -1;
        private var _normalMaxY:Number = 1;
        private var _assetName:String = null;

        public function PlaneTextureBitmap(bitmapData:BitmapData, normalMinX:Number=-1, normalMaxX:Number=1, normalMinY:Number=-1, normalMaxY:Number=1, assetName:String=null)
        {
            _normalMinX = normalMinX;
            _normalMaxX = normalMaxX;
            _normalMinY = normalMinY;
            _normalMaxY = normalMaxY;
            _assetName = assetName;
            _bitmap = bitmapData;
        }

        public function get bitmap():BitmapData
        {
            return (_bitmap);
        }

        public function get normalMinX():Number
        {
            return (_normalMinX);
        }

        public function get normalMaxX():Number
        {
            return (_normalMaxX);
        }

        public function get normalMinY():Number
        {
            return (_normalMinY);
        }

        public function get normalMaxY():Number
        {
            return (_normalMaxY);
        }

        public function get assetName():String
        {
            return (_assetName);
        }

        public function dispose():void
        {
            _bitmap = null;
        }

    }
}
