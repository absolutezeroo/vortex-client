package com.sulake.core.utils
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class XMLVariableParser 
    {

        public static const _SafeStr_879:String = "hex";
        public static const INT:String = "int";
        public static const _SafeStr_880:String = "uint";
        public static const NUMBER:String = "Number";
        public static const FLOAT:String = "float";
        public static const BOOLEAN:String = "Boolean";
        public static const BOOL:String = "bool";
        public static const STRING:String = "String";
        public static const _SafeStr_881:String = "Point";
        public static const RECTANGLE:String = "Rectangle";
        public static const ARRAY:String = "Array";
        public static const MAP:String = "Map";
        private static const KEY:String = "key";
        private static const TYPE:String = "type";
        private static const VALUE:String = "value";
        private static const TRUE:String = "true";
        private static const _SafeStr_658:String = "false";
        private static const X:String = "x";
        private static const _SafeStr_882:String = "y";
        private static const WIDTH:String = "width";
        private static const HEIGHT:String = "height";
        private static const COMMA:String = ",";

        public static function parseVariableList(_arg_1:XMLList, _arg_2:Map, _arg_3:Array=null):uint
        {
            var _local_5:uint;
            var _local_4:uint = _arg_1.length();
            _local_5 = 0;

            while (_local_5 < _local_4)
            {
                XMLVariableParser.parseVariableToken(_arg_1[_local_5], _arg_2, _arg_3);
                _local_5++;
            };

            return (_local_4);
        }

        private static function parseVariableToken(_arg_1:XML, _arg_2:Map, _arg_3:Array=null):void
        {
            var _local_9:String;
            var _local_7:String;
            var _local_8:XMLList;
            var _local_4:XML;
            var _local_5:XML;
            var _local_6:String = "String";
            _local_8 = _arg_1.attribute("key");

            if (_local_8.length() > 0)
            {
                _local_9 = String(_arg_1.attribute("key"));
            }

            else
            {
                _local_9 = _arg_1.child("key")[0];
            };

            _local_8 = _arg_1.attribute("type");

            if (_local_8.length() > 0)
            {
                _local_6 = String(_arg_1.attribute("type"));
            };

            _local_8 = _arg_1.attribute("value");

            if (_local_8.length() > 0)
            {
                _local_7 = String(_arg_1.attribute("value"));
            };

            if (_local_7 != null)
            {
                _arg_2[_local_9] = XMLVariableParser.castStringToType(_local_7, _local_6);
            }

            else
            {
                _local_4 = _arg_1.child("value")[0];

                if (_local_4 != null)
                {
                    _local_5 = _local_4.child(0)[0];
                    _local_7 = _local_5.children()[0];
                    _local_6 = _local_5.localName();
                    _arg_2[_local_9] = XMLVariableParser.parseValueType(_local_5, _local_6);
                }

                else
                {
                    if (((_local_6 == "Map") || (_local_6 == "Array")))
                    {
                        _arg_2[_local_9] = XMLVariableParser.parseValueType(_arg_1, _local_6);
                    };
                };
            };

            if (_arg_3)
            {
                _arg_3.push(_local_6);
            };
        }

        public static function castStringToType(value:String, type:String):Object
        {
            switch (type)
            {
                case "uint":
                    return (uint(value));
                case "int":
                    return (int(value));
                case "Number":
                    return (Number(value));
                case "float":
                    return (Number(value));
                case "Boolean":
                    return ((value == "true") || (int(value) > 0));
                case "bool":
                    return ((value == "true") || (int(value) > 0));
                case "hex":
                    return (uint(value));
                case "Array":
                    return (value.split(","));
                default:
                    return (value);
            };
        }

        public static function parseValueType(xml:XML, type:String):Object
        {
            var _local_5:Map;
            var _local_6:Point;
            var _local_3:Rectangle;
            var _local_7:String;
            var _local_4:Array;
            switch (type)
            {
                case "String":
                    return (String(xml));
                case "Point":
                    _local_6 = new Point();
                    _local_6.x = xml.attribute("x");
                    _local_6.y = xml.attribute("y");
                    return (_local_6);
                case "Rectangle":
                    _local_3 = new Rectangle();
                    _local_3.x = xml.attribute("x");
                    _local_3.y = xml.attribute("y");
                    _local_3.width = xml.attribute("width");
                    _local_3.height = xml.attribute("height");
                    return (_local_3);
                case "Array":
                    _local_5 = new Map();
                    parseVariableList(xml.children(), _local_5);
                    _local_4 = [];

                    for (_local_7 in _local_5)
                    {
                        _local_4.push(_local_5[_local_7]);
                    };

                    return (_local_4);
                case "Map":
                    _local_5 = new Map();
                    XMLVariableParser.parseVariableList(xml.children(), _local_5);
                    return (_local_5);
            };

            throw (new Error((('Unable to parse data type "' + type) + '", unknown type!')));
        }

    }
}
