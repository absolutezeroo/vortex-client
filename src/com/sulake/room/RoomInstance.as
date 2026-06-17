package com.sulake.room {
    import flash.utils.Dictionary;
    import com.sulake.core.utils.Map;
    import com.sulake.room.renderer.IRoomRendererBase;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import flash.utils.getTimer;
    import com.sulake.room.object.IRoomObject;

    public class RoomInstance implements IRoomInstance {

        private var _numberData:Dictionary;
        private var _stringData:Dictionary;
        private var _numberReadOnlyKeys:Array;
        private var _stringReadOnlyKeys:Array;
        private var _roomManagers:Map;
        private var _roomUpdateCategories:Array;
        private var _renderer:IRoomRendererBase;
        private var _roomContainer:IRoomInstanceContainer;
        private var _roomId:String;

        public function RoomInstance(roomId:String, roomContainer:IRoomInstanceContainer) {
            _roomManagers = new Map();
            _roomUpdateCategories = [];
            _roomContainer = roomContainer;
            _roomId = roomId;
            _numberData = new Dictionary();
            _stringData = new Dictionary();
            _numberReadOnlyKeys = [];
            _stringReadOnlyKeys = [];
        }

        public function get id():String {
            return (_roomId);
        }

        public function dispose():void {
            var _local_2:int;
            var _local_1:IRoomObjectManager;
            var _local_3:String;

            if (_roomManagers != null) {
                _local_2 = 0;

                while (_local_2 < _roomManagers.length) {
                    _local_1 = (_roomManagers.getWithIndex(_local_2) as IRoomObjectManager);

                    if (_local_1 != null) {
                        _local_1.dispose();
                    }
                    ;

                    _local_2++;
                }
                ;

                _roomManagers.dispose();
                _roomManagers = null;
            }
            ;

            if (_renderer != null) {
                _renderer.dispose();
                _renderer = null;
            }
            ;

            _roomContainer = null;
            _roomUpdateCategories = null;

            if (_numberData != null) {
                for (_local_3 in _numberData) {
                    delete _numberData[_local_3];
                }
                ;

                _numberData = null;
            }
            ;

            if (_stringData != null) {
                for (_local_3 in _stringData) {
                    delete _stringData[_local_3];
                }
                ;

                _stringData = null;
            }
            ;

            _stringReadOnlyKeys = [];
            _numberReadOnlyKeys = [];
        }

        public function getNumber(_key:String):Number {
            return (_numberData[_key]);
        }

        public function setNumber(_key:String, _value:Number, _isReadOnly:Boolean = false):void {
            if (_numberReadOnlyKeys.indexOf(_key) >= 0) {
                return;
            }
            ;

            if (_isReadOnly) {
                _numberReadOnlyKeys.push(_key);
            }
            ;

            if (_numberData[_key] != _value) {
                _numberData[_key] = _value;
            }
            ;
        }

        public function getString(_key:String):String {
            return (_stringData[_key]);
        }

        public function setString(_key:String, _value:String, _isReadOnly:Boolean = false):void {
            if (_stringReadOnlyKeys.indexOf(_key) >= 0) {
                return;
            }
            ;

            if (_isReadOnly) {
                _stringReadOnlyKeys.push(_key);
            }
            ;

            if (_stringData[_key] != _value) {
                _stringData[_key] = _value;
            }
            ;
        }

        public function addObjectUpdateCategory(_category:int):void {
            var _local_2:int = _roomUpdateCategories.indexOf(_category);

            if (_local_2 >= 0) {
                return;
            }
            ;

            _roomUpdateCategories.push(_category);
        }

        public function removeObjectUpdateCategory(_category:int):void {
            var _local_2:int = _roomUpdateCategories.indexOf(_category);

            if (_local_2 >= 0) {
                _roomUpdateCategories.splice(_local_2, 1);
            }
            ;
        }

        public function update():void {
            var _local_3:int;
            var _local_6:int;
            var _local_2:IRoomObjectManager;
            var _local_4:int;
            var _local_7:IRoomObjectController;
            var _local_5:IRoomObjectEventHandler;
            var _local_1:int = getTimer();
            _local_3 = (_roomUpdateCategories.length - 1);

            while (_local_3 >= 0) {
                _local_6 = _roomUpdateCategories[_local_3];
                _local_2 = getObjectManager(_local_6);

                if (_local_2 != null) {
                    _local_4 = (_local_2.getObjectCount() - 1);

                    while (_local_4 >= 0) {
                        _local_7 = _local_2.getObjectWithIndex(_local_4);

                        if (_local_7 != null) {
                            _local_5 = _local_7.getEventHandler();

                            if (_local_5 != null) {
                                _local_5.update(_local_1);
                            }
                            ;
                        }
                        ;

                        _local_4--;
                    }
                    ;
                }
                ;

                _local_3--;
            }
            ;
        }

        public function createRoomObject(_objectId:int, _objectType:String, _category:int):IRoomObject {
            if (_roomContainer != null) {
                return (_roomContainer.createRoomObject(_roomId, _objectId, _objectType, _category));
            }
            ;

            return (null);
        }

        public function createObjectInternal(_objectId:int, _instanceId:int, _objectType:String, _category:int):IRoomObject {
            var _local_6:IRoomObjectController;
            var _local_5:IRoomObjectManager = createObjectManager(_category);

            if (_local_5 != null) {
                _local_6 = _local_5.createObject(_objectId, _instanceId, _objectType);

                if (_renderer != null) {
                    _renderer.feedRoomObject(_local_6);
                }
                ;

                return (_local_6);
            }
            ;

            return (null);
        }

        public function getObject(_objectId:int, _category:int):IRoomObject {
            var _local_3:IRoomObjectManager = getObjectManager(_category);

            if (_local_3 != null) {
                return (_local_3.getObject(_objectId));
            }
            ;

            return (null);
        }

        public function getObjects(_category:int):Array {
            var _local_2:IRoomObjectManager = getObjectManager(_category);
            return ((_local_2) ? _local_2.getObjects() : []);
        }

        public function getObjectWithIndex(_index:int, _category:int):IRoomObject {
            var _local_3:IRoomObjectManager = getObjectManager(_category);

            if (_local_3 != null) {
                return (_local_3.getObjectWithIndex(_index));
            }
            ;

            return (null);
        }

        public function getObjectCount(_category:int):int {
            var _local_2:IRoomObjectManager = getObjectManager(_category);

            if (_local_2 != null) {
                return (_local_2.getObjectCount());
            }
            ;

            return (0);
        }

        public function getObjectWithIndexAndType(_index:int, _objectType:String, _category:int):IRoomObject {
            var _local_4:IRoomObjectManager = getObjectManager(_category);

            if (_local_4 != null) {
                return (_local_4.getObjectWithIndexAndType(_index, _objectType));
            }
            ;

            return (null);
        }

        public function getObjectCountForType(_objectType:String, _category:int):int {
            var _local_3:IRoomObjectManager = getObjectManager(_category);

            if (_local_3 != null) {
                return (_local_3.getObjectCountForType(_objectType));
            }
            ;

            return (0);
        }

        public function disposeObject(_objectId:int, _category:int):Boolean {
            var _local_4:IRoomObject;
            var _local_3:IRoomObjectManager = getObjectManager(_category);

            if (_local_3 != null) {
                _local_4 = _local_3.getObject(_objectId);

                if (_local_4 != null) {
                    _local_4.tearDown();

                    if (_renderer) {
                        _renderer.removeRoomObject(_local_4);
                    }
                    ;

                    return (_local_3.disposeObject(_objectId));
                }
                ;
            }
            ;

            return (false);
        }

        public function disposeObjects(_category:int):int {
            var _local_4:int;
            var _local_5:IRoomObjectController;
            var _local_3:int;
            var _local_2:IRoomObjectManager = getObjectManager(_category);

            if (_local_2 != null) {
                _local_3 = _local_2.getObjectCount();
                _local_4 = 0;

                while (_local_4 < _local_3) {
                    _local_5 = (_local_2.getObjectWithIndex(_local_4) as IRoomObjectController);

                    if (_local_5 != null) {
                        if (_renderer) {
                            _renderer.removeRoomObject(_local_5);
                        }
                        ;

                        _local_5.dispose();
                    }
                    ;

                    _local_4++;
                }
                ;

                _local_2.reset();
            }
            ;

            return (_local_3);
        }

        public function setRenderer(_roomRenderer:IRoomRendererBase):void {
            var _local_3:int;
            var _local_6:int;
            var _local_2:int;
            var _local_4:int;
            var _local_7:IRoomObjectController;
            Logger.log("Renderer: " + _roomRenderer);

            if (_roomRenderer == _renderer) {
                return;
            }
            ;

            if (_renderer != null) {
                _renderer.dispose();
            }
            ;

            _renderer = _roomRenderer;

            if (_renderer == null) {
                return;
            }
            ;

            _renderer.reset();

            var _local_5:Array = getObjectManagerIds();
            _local_3 = (_local_5.length - 1);

            while (_local_3 >= 0) {
                _local_6 = _local_5[_local_3];
                _local_2 = getObjectCount(_local_6);
                _local_4 = (_local_2 - 1);

                while (_local_4 >= 0) {
                    _local_7 = (getObjectWithIndex(_local_4, _local_6) as IRoomObjectController);

                    if (_local_7 != null) {
                        _renderer.feedRoomObject(_local_7);
                    }
                    ;

                    _local_4--;
                }
                ;

                _local_3--;
            }
            ;
        }

        public function getRenderer():IRoomRendererBase {
            return (_renderer);
        }

        public function getObjectManagerIds():Array {
            return (_roomManagers.getKeys());
        }

        protected function createObjectManager(_category:int):IRoomObjectManager {
            var _local_3:String = String(_category);

            if (_roomManagers.getValue(_local_3) != null) {
                return (_roomManagers.getValue(_local_3) as IRoomObjectManager);
            }
            ;

            if (_roomContainer == null) {
                return (null);
            }
            ;

            var _local_2:IRoomObjectManager = _roomContainer.createRoomObjectManager();

            if (_local_2 != null) {
                _roomManagers.add(_local_3, _local_2);
            }
            ;

            return (_local_2);
        }

        protected function getObjectManager(_category:int):IRoomObjectManager {
            return (_roomManagers.getValue(String(_category)) as IRoomObjectManager);
        }

        protected function disposeObjectManager(_category:int):Boolean {
            var _local_2:IRoomObjectManager;
            var _local_3:String = String(_category);
            disposeObjects(_category);

            if (_roomManagers.getValue(_local_3) != null) {
                _local_2 = (_roomManagers.remove(_local_3) as IRoomObjectManager);

                if (_local_2 != null) {
                    _local_2.dispose();
                }
                ;

                return (true);
            }
            ;

            return (false);
        }

        public function hasUninitializedObjects():Boolean {
            var _local_1:int;
            var _local_3:int;

            for each (var _local_2:RoomObjectManager in _roomManagers) {
                _local_1 = _local_2.getObjectCount();
                _local_3 = 0;

                while (_local_3 < _local_1) {
                    if (!_local_2.getObjectWithIndex(_local_3).isInitialized()) {
                        return (true);
                    }
                    ;

                    _local_3++;
                }
                ;
            }
            ;

            return (false);
        }

    }
}

