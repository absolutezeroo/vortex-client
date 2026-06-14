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

        public function hasNumber(_arg_1:String):Boolean
        {
            return (!(_numberDataList[_arg_1] == null));
        }

        public function hasNumberArray(_arg_1:String):Boolean
        {
            return (!(_numberArrayDataList[_arg_1] == null));
        }

        public function hasString(_arg_1:String):Boolean
        {
            return (!(_stringDataList[_arg_1] == null));
        }

        public function hasStringArray(_arg_1:String):Boolean
        {
            return (!(_stringArrayDataList[_arg_1] == null));
        }

        public function getNumber(_arg_1:String):Number
        {
            return (_numberDataList[_arg_1]);
        }

        public function getString(_arg_1:String):String
        {
            return (_stringDataList[_arg_1]);
        }

        public function getNumberArray(_arg_1:String):Array
        {
            var _local_2:Array = _numberArrayDataList[_arg_1];

            if (_local_2 != null)
            {
                _local_2 = _local_2.slice();
            };

            return (_local_2);
        }

        public function getStringArray(_arg_1:String):Array
        {
            var _local_2:Array = _stringArrayDataList[_arg_1];

            if (_local_2 != null)
            {
                _local_2 = _local_2.slice();
            };

            return (_local_2);
        }

        public function getStringToStringMap(_arg_1:String):Map
        {
            var _local_4:int;
            var _local_5:Map = new Map();
            var _local_2:Array = getStringArray(("ROMC_MAP_KEYS_" + _arg_1));
            var _local_3:Array = getStringArray(("ROMC_MAP_VALUES_" + _arg_1));

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

        public function setNumber(_arg_1:String, _arg_2:Number, _arg_3:Boolean=false):void
        {
            if (_numberReadOnlyList.indexOf(_arg_1) >= 0)
            {
                return;
            };

            if (_arg_3)
            {
                _numberReadOnlyList.push(_arg_1);
            };

            if (_numberDataList[_arg_1] != _arg_2)
            {
                _numberDataList[_arg_1] = _arg_2;
                _updateID++;
            };
        }

        public function setString(_arg_1:String, _arg_2:String, _arg_3:Boolean=false):void
        {
            if (_stringReadOnlyList.indexOf(_arg_1) >= 0)
            {
                return;
            };

            if (_arg_3)
            {
                _stringReadOnlyList.push(_arg_1);
            };

            if (_stringDataList[_arg_1] != _arg_2)
            {
                _stringDataList[_arg_1] = _arg_2;
                _updateID++;
            };
        }

        public function setNumberArray(_arg_1:String, _arg_2:Array, _arg_3:Boolean=false):void
        {
            if (_arg_2 == null)
            {
                return;
            };

            if (_numberArrayReadOnlyList.indexOf(_arg_1) >= 0)
            {
                return;
            };

            if (_arg_3)
            {
                _numberArrayReadOnlyList.push(_arg_1);
            };

            var _local_6:Array = [];
            var _local_7:int;
            _local_7 = 0;

            while (_local_7 < _arg_2.length)
            {
                if ((_arg_2[_local_7] is Number))
                {
                    _local_6.push(_arg_2[_local_7]);
                };

                _local_7++;
            };

            var _local_5:Array = _numberArrayDataList[_arg_1];
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

            _numberArrayDataList[_arg_1] = _local_6;
            _updateID++;
        }

        public function setStringArray(_arg_1:String, _arg_2:Array, _arg_3:Boolean=false):void
        {
            if (_arg_2 == null)
            {
                return;
            };

            if (_stringArrayReadOnlyList.indexOf(_arg_1) >= 0)
            {
                return;
            };

            if (_arg_3)
            {
                _stringArrayReadOnlyList.push(_arg_1);
            };

            var _local_6:Array = [];
            var _local_7:int;
            _local_7 = 0;

            while (_local_7 < _arg_2.length)
            {
                if ((_arg_2[_local_7] is String))
                {
                    _local_6.push(_arg_2[_local_7]);
                };

                _local_7++;
            };

            var _local_5:Array = _stringArrayDataList[_arg_1];
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

            _stringArrayDataList[_arg_1] = _local_6;
            _updateID++;
        }

        public function setStringToStringMap(_arg_1:String, _arg_2:Map, _arg_3:Boolean=false):void
        {
            if (_arg_2 == null)
            {
                return;
            };

            setStringArray(("ROMC_MAP_KEYS_" + _arg_1), _arg_2.getKeys(), _arg_3);
            setStringArray(("ROMC_MAP_VALUES_" + _arg_1), _arg_2.getValues(), _arg_3);
        }

        public function getUpdateID():int
        {
            return (_updateID);
        }

    }
}
