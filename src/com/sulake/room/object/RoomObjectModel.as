package com.sulake.room.object
{
    import flash.utils.Dictionary;
    import com.sulake.core.utils.Map;

    public class RoomObjectModel implements IRoomObjectModelController 
    {

        private static const MAP_KEYS_PREFIX:String = "ROMC_MAP_KEYS_";
        private static const MAP_VALUES_PREFIX:String = "ROMC_MAP_VALUES_";

        private var _numberDataList:Dictionary;
        private var _stringDataList:Dictionary;
        private var _numberArrayDataList:Dictionary;
        private var _stringArrayDataList:Dictionary;
        private var _numberReadOnlyList:Array;
        private var _stringReadOnlyList:Array;
        private var _numberArrayReadOnlyList:Array;
        private var _stringArrayReadOnlyList:Array;
        private var _updateID:int;

        public function RoomObjectModel()
        {
            _numberDataList = new Dictionary();
            _stringDataList = new Dictionary();
            _numberArrayDataList = new Dictionary();
            _stringArrayDataList = new Dictionary();
            _numberReadOnlyList = [];
            _stringReadOnlyList = [];
            _numberArrayReadOnlyList = [];
            _stringArrayReadOnlyList = [];
            _updateID = 0;
        }

        public function dispose():void
        {
            var _local_1:String;

            if (_numberDataList != null)
            {
                for (_local_1 in _numberDataList)
                {
                    delete _numberDataList[_local_1];
                };

                _numberDataList = null;
            };

            if (_stringDataList != null)
            {
                for (_local_1 in _stringDataList)
                {
                    delete _stringDataList[_local_1];
                };

                _stringDataList = null;
            };

            if (_numberArrayDataList != null)
            {
                for (_local_1 in _numberArrayDataList)
                {
                    delete _numberArrayDataList[_local_1];
                };

                _numberArrayDataList = null;
            };

            if (_stringArrayDataList != null)
            {
                for (_local_1 in _stringArrayDataList)
                {
                    delete _stringArrayDataList[_local_1];
                };

                _stringArrayDataList = null;
            };

            _stringReadOnlyList = [];
            _numberReadOnlyList = [];
            _stringArrayReadOnlyList = [];
            _numberArrayReadOnlyList = [];
        }

        public function hasNumber(_variableName:String):Boolean
        {
            return (!(_numberDataList[_variableName] == null));
        }

        public function hasNumberArray(_variableName:String):Boolean
        {
            return (!(_numberArrayDataList[_variableName] == null));
        }

        public function hasString(_variableName:String):Boolean
        {
            return (!(_stringDataList[_variableName] == null));
        }

        public function hasStringArray(_variableName:String):Boolean
        {
            return (!(_stringArrayDataList[_variableName] == null));
        }

        public function getNumber(_variableName:String):Number
        {
            return (_numberDataList[_variableName]);
        }

        public function getString(_variableName:String):String
        {
            return (_stringDataList[_variableName]);
        }

        public function getNumberArray(_variableName:String):Array
        {
            var _local_2:Array = _numberArrayDataList[_variableName];

            if (_local_2 != null)
            {
                _local_2 = _local_2.slice();
            };

            return (_local_2);
        }

        public function getStringArray(_variableName:String):Array
        {
            var _local_2:Array = _stringArrayDataList[_variableName];

            if (_local_2 != null)
            {
                _local_2 = _local_2.slice();
            };

            return (_local_2);
        }

        public function getStringToStringMap(_key:String):Map
        {
            var _local_4:int;
            var _local_5:Map = new Map();
            var _local_2:Array = getStringArray(("ROMC_MAP_KEYS_" + _key));
            var _local_3:Array = getStringArray(("ROMC_MAP_VALUES_" + _key));

            if ((((!(_local_2 == null)) && (!(_local_3 == null))) && (_local_2.length == _local_3.length)))
            {
                _local_4 = 0;

                while (_local_4 < _local_2.length)
                {
                    _local_5.add(_local_2[_local_4], _local_3[_local_4]);
                    _local_4++;
                };
            };

            return (_local_5);
        }

        public function setNumber(_key:String, _value:Number, _readOnly:Boolean=false):void
        {
            if (_numberReadOnlyList.indexOf(_key) >= 0)
            {
                return;
            };

            if (_readOnly)
            {
                _numberReadOnlyList.push(_key);
            };

            if (_numberDataList[_key] != _value)
            {
                _numberDataList[_key] = _value;
                _updateID++;
            };
        }

        public function setString(_key:String, _value:String, _readOnly:Boolean=false):void
        {
            if (_stringReadOnlyList.indexOf(_key) >= 0)
            {
                return;
            };

            if (_readOnly)
            {
                _stringReadOnlyList.push(_key);
            };

            if (_stringDataList[_key] != _value)
            {
                _stringDataList[_key] = _value;
                _updateID++;
            };
        }

        public function setNumberArray(_key:String, _values:Array, _readOnly:Boolean=false):void
        {
            if (_values == null)
            {
                return;
            };

            if (_numberArrayReadOnlyList.indexOf(_key) >= 0)
            {
                return;
            };

            if (_readOnly)
            {
                _numberArrayReadOnlyList.push(_key);
            };

            var _local_6:Array = [];
            var _local_7:int;
            _local_7 = 0;

            while (_local_7 < _values.length)
            {
                if ((_values[_local_7] is Number))
                {
                    _local_6.push(_values[_local_7]);
                };

                _local_7++;
            };

            var _local_5:Array = _numberArrayDataList[_key];
            var _local_4:Boolean = true;

            if (((!(_local_5 == null)) && (_local_5.length == _local_6.length)))
            {
                _local_7 = (_local_6.length - 1);

                while (_local_7 >= 0)
                {
                    if ((_local_6[_local_7] as Number) != (_local_5[_local_7] as Number))
                    {
                        _local_4 = false;
                        break;
                    };

                    _local_7--;
                };
            }

            else
            {
                _local_4 = false;
            };

            if (_local_4)
            {
                return;
            };

            _numberArrayDataList[_key] = _local_6;
            _updateID++;
        }

        public function setStringArray(_key:String, _values:Array, _readOnly:Boolean=false):void
        {
            if (_values == null)
            {
                return;
            };

            if (_stringArrayReadOnlyList.indexOf(_key) >= 0)
            {
                return;
            };

            if (_readOnly)
            {
                _stringArrayReadOnlyList.push(_key);
            };

            var _local_6:Array = [];
            var _local_7:int;
            _local_7 = 0;

            while (_local_7 < _values.length)
            {
                if ((_values[_local_7] is String))
                {
                    _local_6.push(_values[_local_7]);
                };

                _local_7++;
            };

            var _local_5:Array = _stringArrayDataList[_key];
            var _local_4:Boolean = true;

            if (((!(_local_5 == null)) && (_local_5.length == _local_6.length)))
            {
                _local_7 = (_local_6.length - 1);

                while (_local_7 >= 0)
                {
                    if ((_local_6[_local_7] as String) != (_local_5[_local_7] as String))
                    {
                        _local_4 = false;
                        break;
                    };

                    _local_7--;
                };
            }

            else
            {
                _local_4 = false;
            };

            if (_local_4)
            {
                return;
            };

            _stringArrayDataList[_key] = _local_6;
            _updateID++;
        }

        public function setStringToStringMap(_key:String, _value:Map, _readOnly:Boolean=false):void
        {
            if (_value == null)
            {
                return;
            };

            setStringArray(("ROMC_MAP_KEYS_" + _key), _value.getKeys(), _readOnly);
            setStringArray(("ROMC_MAP_VALUES_" + _key), _value.getValues(), _readOnly);
        }

        public function getUpdateID():int
        {
            return (_updateID);
        }

    }
}
