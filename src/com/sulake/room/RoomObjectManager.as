package com.sulake.room {
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.RoomObject;
    import com.sulake.room.object.IRoomObjectController;

    public class RoomObjectManager implements IRoomObjectManager {

        private var _objectsById:Map;
        private var _objectsByType:Map;

        public function RoomObjectManager() {
            _objectsById = new Map();
            _objectsByType = new Map();
        }

        public function dispose():void {
            reset();

            if (_objectsById != null) {
                _objectsById.dispose();
                _objectsById = null;
            }

            if (_objectsByType != null) {
                _objectsByType.dispose();
                _objectsByType = null;
            }
        }

        public function createObject(_objectId:int, _instanceId:uint, _type:String):IRoomObjectController {
            var _local_4:RoomObject = new RoomObject(_objectId, _instanceId, _type);

            return (addObject(String(_objectId), _type, _local_4));
        }

        private function addObject(_objectId:String, _type:String, _roomObject:IRoomObjectController):IRoomObjectController {
            if (_objectsById.getValue(_objectId) != null) {
                _roomObject.dispose();

                return (null);
            }

            _objectsById.add(_objectId, _roomObject);

            var _local_4:Map = getObjectsForType(_type);
            _local_4.add(_objectId, _roomObject);

            return (_roomObject);
        }

        private function getObjectsForType(_type:String, _autoCreate:Boolean = true):Map {
            var _local_3:Map = _objectsByType.getValue(_type);

            if (((_local_3 == null) && (_autoCreate))) {
                _local_3 = new Map();
                _objectsByType.add(_type, _local_3);
            }

            return (_local_3);
        }

        public function getObject(_objectId:int):IRoomObjectController {
            return (_objectsById.getValue(String(_objectId)) as IRoomObjectController);
        }

        public function getObjects():Array {
            return (_objectsById.getValues());
        }

        public function getObjectWithIndex(_index:int):IRoomObjectController {
            return (_objectsById.getWithIndex(_index) as IRoomObjectController);
        }

        public function getObjectCount():int {
            return (_objectsById.length);
        }

        public function getObjectCountForType(_type:String):int {
            var _local_2:Map = getObjectsForType(_type, false);

            if (_local_2 != null) {
                return (_local_2.length);
            }

            return (0);
        }

        public function getObjectWithIndexAndType(_index:int, _type:String):IRoomObjectController {
            var _local_4:IRoomObjectController;
            var _local_3:Map = getObjectsForType(_type, false);

            if (_local_3 != null) {
                _local_4 = (_local_3.getWithIndex(_index) as IRoomObjectController);

                return (_local_4);
            }

            return (null);
        }

        public function disposeObject(_objectId:int):Boolean {
            var _local_4:String;
            var _local_2:Map;
            var _local_3:String = String(_objectId);
            var _local_5:RoomObject = (_objectsById.remove(_local_3) as RoomObject);

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

            if (_objectsById != null) {
                _local_2 = 0;

                while (_local_2 < _objectsById.length) {
                    _local_4 = (_objectsById.getWithIndex(_local_2) as IRoomObjectController);

                    if (_local_4 != null) {
                        _local_4.dispose();
                    }

                    _local_2++;
                }

                _objectsById.reset();
            }

            if (_objectsByType != null) {
                _local_3 = 0;

                while (_local_3 < _objectsByType.length) {
                    _local_1 = (_objectsByType.getWithIndex(_local_3) as Map);

                    if (_local_1 != null) {
                        _local_1.dispose();
                    }
                    ;

                    _local_3++;
                }

                _objectsByType.reset();
            }
        }
    }
}

