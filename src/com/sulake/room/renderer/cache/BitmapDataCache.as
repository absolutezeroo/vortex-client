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

        public function BitmapDataCache(memLimitMb:int, maxMemoryMb:int, increaseSizeMb:int=1)
        {
            _dataMap = new Map();
            _memLimit = ((memLimitMb * 0x0400) * 0x0400);
            _maxMemory = ((maxMemoryMb * 0x0400) * 0x0400);
            _increaseSize = ((increaseSizeMb * 0x0400) * 0x0400);

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
            var _keys:Array;

            if (_dataMap != null)
            {
                _keys = _dataMap.getKeys();

                for each (var _key:String in _keys)
                {
                    if (!removeItem(_key))
                    {
                        Logger.log((("Failed to remove item " + _key) + " from room canvas bitmap cache!"));
                    };
                };

                _dataMap.dispose();
                _dataMap = null;
            };
        }

        public function compress():void
        {
            var _values:Array;
            var _item:BitmapDataCacheItem;
            var _index:int;

            if (memUsage > memLimit)
            {
                _values = _dataMap.getValues();
                _values.sortOn("useCount", 16);
                _values.reverse();
                _index = (_values.length - 1);

                while (_index >= 0)
                {
                    _item = (_values[_index] as BitmapDataCacheItem);

                    if (_item.useCount <= 1)
                    {
                        removeItem(_item.name);
                    }

                    else
                    {
                        break;
                    };

                    _index--;
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

        private function removeItem(name:String):Boolean
        {
            if (name == null)
            {
                return (false);
            };

            var _item:BitmapDataCacheItem = (_dataMap.getValue(name) as BitmapDataCacheItem);

            if (_item != null)
            {
                if (_item.useCount <= 1)
                {
                    _dataMap.remove(_item.name);
                    _memUsage = (_memUsage - _item.memUsage);
                    _item.dispose();
                    return (true);
                };

                return (false);
            };

            return (false);
        }

        public function getBitmapData(name:String):ExtendedBitmapData
        {
            var _item:BitmapDataCacheItem = (_dataMap.getValue(name) as BitmapDataCacheItem);

            if (_item == null)
            {
                return (null);
            };

            return (_item.bitmapData);
        }

        public function addBitmapData(name:String, bitmapData:ExtendedBitmapData):void
        {
            var _previousBitmapData:BitmapData;

            if (bitmapData == null)
            {
                return;
            };

            var _item:BitmapDataCacheItem = (_dataMap.getValue(name) as BitmapDataCacheItem);

            if (_item != null)
            {
                _previousBitmapData = _item.bitmapData;

                if (_previousBitmapData != null)
                {
                    _memUsage = (_memUsage - ((_previousBitmapData.width * _previousBitmapData.height) * 4));
                };

                _item.bitmapData = bitmapData;
            }

            else
            {
                _item = new BitmapDataCacheItem(bitmapData, name);
                _dataMap.add(name, _item);
            };

            _memUsage = (_memUsage + ((bitmapData.width * bitmapData.height) * 4));
        }

    }
}
