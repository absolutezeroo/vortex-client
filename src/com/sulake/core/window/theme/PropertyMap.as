package com.sulake.core.window.theme
{
    import flash.utils.Dictionary;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.*;

    public class PropertyMap implements IPropertyMap 
    {

        private var _map:Dictionary = new Dictionary();

        private function add(key:String, value:Object, type:String, range:Array=null):void
        {
            _map[key] = new PropertyStruct(key, value, type, false, range);
        }

        public function addBoolean(key:String, value:Boolean):void
        {
            add(key, value, "Boolean");
        }

        public function addInt(key:String, value:int):void
        {
            add(key, value, "int");
        }

        public function addUint(key:String, value:uint):void
        {
            add(key, value, "uint");
        }

        public function addHex(key:String, value:uint):void
        {
            add(key, value, "hex");
        }

        public function addNumber(key:String, value:Number):void
        {
            add(key, value, "Number");
        }

        public function addString(key:String, value:String):void
        {
            add(key, value, "String");
        }

        public function addEnumeration(key:String, value:String, range:Array):void
        {
            add(key, value, "String", range);
        }

        public function addArray(key:String, value:Array):void
        {
            add(key, value, "Array");
        }

        public function get(key:String):PropertyStruct
        {
            return (_map[key]);
        }

        public function clone():PropertyMap
        {
            var _local_1:PropertyMap = new PropertyMap();

            for (var _local_2:String in _map)
            {
                _local_1._map[_local_2] = _map[_local_2];
            };

            return (_local_1);
        }

    }
}
