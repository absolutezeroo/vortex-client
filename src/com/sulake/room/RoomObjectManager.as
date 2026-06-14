package com.sulake.room {
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.RoomObject;
    import com.sulake.room.object.IRoomObjectController;

    public class RoomObjectManager implements IRoomObjectManager {

        private var _objects:Map;
        private var _objectsPerType:Map;

        public function RoomObjectManager() {
            _objects = new Map();
            _objectsPerType = new Map();
        }

        public function dispose():void {
            reset();

            if (_objects != null) {
                _objects.dispose();
                _objects = null;
            }

            if (_objectsPerType != null) {
                _objectsPerType.dispose();
                _objectsPerType = null;
            }
        }

        public function createObject(_arg_1:int, _arg_2:uint, _arg_3:String):IRoomObjectController {
            var _local_4:RoomObject = new RoomObject(_arg_1, _arg_2, _arg_3);

            return (addObject(String(_arg_1), _arg_3, _local_4));
        }

        private function addObject(_arg_1:String, _arg_2:String, _arg_3:IRoomObjectController):IRoomObjectController {
            if (_objects.getValue(_arg_1) != null) {
                _arg_3.dispose();

                return (null);
            }

            _objects.add(_arg_1, _arg_3);

            var _local_4:Map = getObjectsForType(_arg_2);
            _local_4.add(_arg_1, _arg_3);

            return (_arg_3);
        }

        private function getObjectsForType(_arg_1:String, _arg_2:Boolean = true):Map {
            var _local_3:Map = _objectsPerType.getValue(_arg_1);

            if (((_local_3 == null) && (_arg_2))) {
                _local_3 = new Map();
                _objectsPerType.add(_arg_1, _local_3);
            }

            return (_local_3);
        }

        public function getObject(_arg_1:int):IRoomObjectController {
            return (_objects.getValue(String(_arg_1)) as IRoomObjectController);
        }

        public function getObjects():Array {
            return (_objects.getValues());
        }

        public function getObjectWithIndex(_arg_1:int):IRoomObjectController {
            return (_objects.getWithIndex(_arg_1) as IRoomObjectController);
        }

        public function getObjectCount():int {
            return (_objects.length);
        }

        public function getObjectCountForType(_arg_1:String):int {
            var _local_2:Map = getObjectsForType(_arg_1, false);

            if (_local_2 != null) {
                return (_local_2.length);
            }

            return (0);
        }

        public function getObjectWithIndexAndType(_arg_1:int, _arg_2:String):IRoomObjectController {
            var _local_4:IRoomObjectController;
            var _local_3:Map = getObjectsForType(_arg_2, false);

            if (_local_3 != null) {
                _local_4 = (_local_3.getWithIndex(_arg_1) as IRoomObjectController);

                return (_local_4);
            }

            return (null);
        }

        public function disposeObject(_arg_1:int):Boolean {
            var _local_4:String;
            var _local_2:Map;
            var _local_3:String = String(_arg_1);
            var _local_5:RoomObject = (_objects.remove(_local_3) as RoomObject);

            if (_local_5 != null) {
                _local_4 = _local_5.getType();
                _local_2 = getObjectsForType(_local_4, false);

                if (_local_2 != null) {
                    _local_2.remove(_local_3);
                }

                _local_5.dispose();

                return (true);
            }

            return (false);
        }

        public function reset():void {
            var _local_2:int;
            var _local_4:IRoomObjectController;
            var _local_3:int;
            var _local_1:Map;

            if (_objects != null) {
                _local_2 = 0;

                while (_local_2 < _objects.length) {
                    _local_4 = (_objects.getWithIndex(_local_2) as IRoomObjectController);

                    if (_local_4 != null) {
                        _local_4.dispose();
                    }

                    _local_2++;
                }

                _objects.reset();
            }

            if (_objectsPerType != null) {
                _local_3 = 0;

                while (_local_3 < _objectsPerType.length) {
                    _local_1 = (_objectsPerType.getWithIndex(_local_3) as Map);

                    if (_local_1 != null) {
                        _local_1.dispose();
                    }
                    ;

                    _local_3++;
                }

                _objectsPerType.reset();
            }
        }
    }
}

