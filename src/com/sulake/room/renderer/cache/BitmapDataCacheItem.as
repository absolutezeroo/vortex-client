package com.sulake.room.renderer.cache
{
    import com.sulake.room.renderer.utils.ExtendedBitmapData;

        public class BitmapDataCacheItem 
    {

        private var _bitmapData:ExtendedBitmapData = null;
        private var _name:String = "";
        private var _memUsage:int = 0;

        public function BitmapDataCacheItem(bitmapData:ExtendedBitmapData, name:String)
        {
            _bitmapData = bitmapData;
            _name = name;

            if (bitmapData != null)
            {
                bitmapData.addReference();
                _memUsage = ((_bitmapData.width * _bitmapData.height) * 4);
            };
        }

        public function get bitmapData():ExtendedBitmapData
        {
            return (_bitmapData);
        }

        public function get memUsage():int
        {
            return (_memUsage);
        }

        public function get useCount():int
        {
            if (_bitmapData == null)
            {
                return (0);
            };

            return (_bitmapData.referenceCount);
        }

        public function get name():String
        {
            return (_name);
        }

        public function set bitmapData(bitmapData:ExtendedBitmapData):void
        {
            if (_bitmapData != null)
            {
                _bitmapData.dispose();
            };

            _bitmapData = bitmapData;

            if (_bitmapData != null)
            {
                _bitmapData.addReference();
                _memUsage = ((_bitmapData.width * _bitmapData.height) * 4);
            }

            else
            {
                _memUsage = 0;
            };
        }

        public function dispose():void
        {
            if (_bitmapData != null)
            {
                _bitmapData.dispose();
                _bitmapData = null;
            };

            _memUsage = 0;
        }

    }
}