package com.sulake.core.utils
{
    import flash.utils.Proxy;
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.Dictionary;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

        public class Map extends Proxy implements IDisposable 
    {

        private var _length:uint;
        private var _dictionary:Dictionary;
        private var _array:Array;
        private var _keys:Array;

        public function Map()
        {
            _length = 0;
            _dictionary = new Dictionary();
            _array = [];
            _keys = [];
        }

        public function get length():uint
        {
            return (_length);
        }

        public function get disposed():Boolean
        {
            return (_dictionary == null);
        }

        public function dispose():void
        {
            var _local_1:Object;

            if (_dictionary != null)
            {
                for (_local_1 in _dictionary)
                {
                    delete _dictionary[_local_1];
                };

                _dictionary = null;
            };

            _length = 0;
            _array = null;
            _keys = null;
        }

        public function reset():void
        {
            var _local_1:Object;

            for (_local_1 in _dictionary)
            {
                delete _dictionary[_local_1];
            };

            _length = 0;
            _array = [];
            _keys = [];
        }

        public function unshift(key:*, value:*):Boolean
        {
            if (_dictionary[key] != null)
            {
                return (false);
            };

            _dictionary[key] = value;
            _array.unshift(value);
            _keys.unshift(key);
            _length++;
            return (true);
        }

        public function add(key:*, value:*):Boolean
        {
            if (_dictionary[key] != null)
            {
                return (false);
            };

            _dictionary[key] = value;
            _array[_length] = value;
            _keys[_length] = key;
            _length++;
            return (true);
        }

        public function remove(key:*):*
        {
            var _local_2:Object = _dictionary[key];

            if (_local_2 == null)
            {
                return (null);
            };

            var _local_3:int = _array.indexOf(_local_2);

            if (_local_3 >= 0)
            {
                _array.splice(_local_3, 1);
                _keys.splice(_local_3, 1);
                _length--;
            };

            delete _dictionary[key];
            return (_local_2);
        }

        public function getWithIndex(index:int):*
        {
            if (((index < 0) || (index >= _length)))
            {
                return (null);
            };

            return (_array[index]);
        }

        public function getKey(index:int):*
        {
            if (((index < 0) || (index >= _length)))
            {
                return (null);
            };

            return (_keys[index]);
        }

        public function getKeys():Array
        {
            return (_keys.slice());
        }

        public function hasKey(key:*):Boolean
        {
            return (_keys.indexOf(key) > -1);
        }

        public function getValue(key:*):*
        {
            return (_dictionary[key]);
        }

        public function getValues():Array
        {
            return (_array.slice());
        }

        public function hasValue(value:*):Boolean
        {
            return (_array.indexOf(value) > -1);
        }

        public function indexOf(value:*):int
        {
            return (_array.indexOf(value));
        }

        public function concatenate(newValues:Map):void
        {
            var _local_3:*;
            var _local_2:Array = newValues._keys;

            for each (_local_3 in _local_2)
            {
                add(_local_3, newValues[_local_3]);
            };
        }

        public function clone():Map
        {
            var _local_1:Map = new Map();
            _local_1.concatenate(this);
            return (_local_1);
        }

        override flash_proxy function getProperty(key:*):*
        {
            if ((key is QName))
            {
                key = QName(key).localName;
            };

            return (_dictionary[key]);
        }

        override flash_proxy function setProperty(key:*, value:*):void
        {
            if ((key is QName))
            {
                key = QName(key).localName;
            };

            _dictionary[key] = value;

            var _local_3:int = _keys.indexOf(key);

            if (_local_3 == -1)
            {
                _array[_length] = value;
                _keys[_length] = key;
                _length++;
            }

            else
            {
                _array.splice(_local_3, 1, value);
            };
        }

        override flash_proxy function nextNameIndex(index:int):int
        {
            return ((index < _length) ? (index + 1) : 0);
        }

        override flash_proxy function nextName(index:int):String
        {
            return (_keys[(index - 1)]);
        }

        override flash_proxy function nextValue(index:int):*
        {
            return (_array[(index - 1)]);
        }

        override flash_proxy function callProperty(property:*, ... _args):*
        {
            return ((property.localName == "toString") ? "Map" : null);
        }

    }
}
