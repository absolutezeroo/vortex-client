package com.sulake.room.renderer.cache
{
    import com.sulake.core.utils.Map;
    import com.sulake.room.renderer.utils.ExtendedBitmapData;
    import flash.display.BitmapData;

        public class BitmapDataCache 
    {

        private var _dataMap:Map;
        private var _memUsage:int = 0;
        private var _memLimit:int = 0;
        private var _maxMemory:int = 0;
        private var _increaseSize:int = 0;

        public function BitmapDataCache(_arg_1:int, _arg_2:int, _arg_3:int=1)
        {
            _dataMap = new Map();
            _memLimit = ((_arg_1 * 0x0400) * 0x0400);
            _maxMemory = ((_arg_2 * 0x0400) * 0x0400);
            _increaseSize = ((_arg_3 * 0x0400) * 0x0400);

            if (_increaseSize < 0)
            {
                _increaseSize = 0;
            };
        }

        public function get memUsage():int
        {
            return (_memUsage);
        }

        public function get memLimit():int
        {
            return (_memLimit);
        }

        public function dispose():void
        {
            var _local_1:Array;

            if (_dataMap != null)
            {
                _local_1 = _dataMap.getKeys();

                for each (var _local_2:String in _local_1)
                {
                    if (!removeItem(_local_2))
                    {
                        Logger.log((("Failed to remove item " + _local_2) + " from room canvas bitmap cache!"));
                    };
                };

                _dataMap.dispose();
                _dataMap = null;
            };
        }

        public function compress():void
        {
            var _local_1:Array;
            var _local_2:BitmapDataCacheItem;
            var _local_3:int;

            if (memUsage > memLimit)
            {
                _local_1 = _dataMap.getValues();
                _local_1.sortOn("useCount", 16);
                _local_1.reverse();
                _local_3 = (_local_1.length - 1);

                while (_local_3 >= 0)
                {
                    _local_2 = (_local_1[_local_3] as BitmapDataCacheItem);

                    if (_local_2.useCount <= 1)
                    {
                        removeItem(_local_2.name);
                    }

                    else
                    {
                        break;
                    };

                    _local_3--;
                };

                increaseMemoryLimit();
            };
        }

        private function increaseMemoryLimit():void
        {
            _memLimit = (_memLimit + _increaseSize);

            if (_memLimit > _maxMemory)
            {
                _memLimit = _maxMemory;
            };
        }

        private function removeItem(_arg_1:String):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };

            var _local_2:BitmapDataCacheItem = (_dataMap.getValue(_arg_1) as BitmapDataCacheItem);

            if (_local_2 != null)
            {
                if (_local_2.useCount <= 1)
                {
                    _dataMap.remove(_local_2.name);
                    _memUsage = (_memUsage - _local_2.memUsage);
                    _local_2.dispose();
                    return (true);
                };

                return (false);
            };

            return (false);
        }

        public function getBitmapData(_arg_1:String):ExtendedBitmapData
        {
            var _local_2:BitmapDataCacheItem = (_dataMap.getValue(_arg_1) as BitmapDataCacheItem);

            if (_local_2 == null)
            {
                return (null);
            };

            return (_local_2.bitmapData);
        }

        public function addBitmapData(_arg_1:String, _arg_2:ExtendedBitmapData):void
        {
            var _local_4:BitmapData;

            if (_arg_2 == null)
            {
                return;
            };

            var _local_3:BitmapDataCacheItem = (_dataMap.getValue(_arg_1) as BitmapDataCacheItem);

            if (_local_3 != null)
            {
                _local_4 = _local_3.bitmapData;

                if (_local_4 != null)
                {
                    _memUsage = (_memUsage - ((_local_4.width * _local_4.height) * 4));
                };

                _local_3.bitmapData = _arg_2;
            }

            else
            {
                _local_3 = new BitmapDataCacheItem(_arg_2, _arg_1);
                _dataMap.add(_arg_1, _local_3);
            };

            _memUsage = (_memUsage + ((_arg_2.width * _arg_2.height) * 4));
        }

    }
}
