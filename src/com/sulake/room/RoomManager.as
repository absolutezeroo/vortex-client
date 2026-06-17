package com.sulake.room {
    import com.sulake.core.runtime.Component;
    import com.sulake.core.utils.Map;
    import __AS3__.vec.Vector;
    import com.sulake.room.object.IRoomObjectVisualizationFactory;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDRoomObjectFactory;
    import com.sulake.iid.IIDRoomObjectVisualizationFactory;
    import com.sulake.room.exceptions.RoomManagerException;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.object.visualization.IRoomObjectGraphicVisualization;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import com.sulake.room.events.RoomContentLoadedEvent;
    import flash.utils.getTimer;
    import com.sulake.iid.*;

    public class RoomManager extends Component implements IRoomManager, IRoomInstanceContainer {

        public static const ROOM_MANAGER_ERROR:int = -1;
        public static const ROOM_MANAGER_LOADING:int = 0;
        public static const ROOM_MANAGER_LOADED:int = 1;
        public static const ROOM_MANAGER_INITIALIZING:int = 2;
        public static const ROOM_MANAGER_INITIALIZED:int = 3;
        private static const CONTENT_PROCESSING_TIME_LIMIT_MILLISECONDS:int = 40;

        private var _rooms:Map;
        private var _roomContentLoader:IRoomContentLoader;
        private var _pendingContentTypes:Vector.<String>;
        private var _objectUpdateCategories:Vector.<int>;
        private var _contentLoadLimit:int;
        private var _managerListener:IRoomManagerListener;
        private var _objectFactory:IRoomObjectFactory = null;
        private var _visualizationFactory:IRoomObjectVisualizationFactory = null;
        private var _managerState:int = 0;
        private var _pendingInitializationXml:XML = null;
        private var _queuedLoadedContentTypes:Vector.<String> = new Vector.<String>();
        private var _skipContentProcessingForNextFrame:Boolean = false;
        private var _limitContentProcessing:Boolean = true;
        private var _disposed:Boolean = false;

        public function RoomManager(_context:IContext, _flags:uint = 0) {
            super(_context, _flags);

            _rooms = new Map();
            _pendingContentTypes = new Vector.<String>();
            _objectUpdateCategories = new Vector.<int>();

            events.addEventListener(RoomContentLoadedEvent.CONTENT_LOAD_SUCCESS, onContentLoaded);
            events.addEventListener(RoomContentLoadedEvent.CONTENT_LOAD_FAILURE, onContentLoaded);
            events.addEventListener(RoomContentLoadedEvent.CONTENT_LOAD_CANCEL, onContentLoaded);
        }

        override public function get disposed():Boolean {
            return (_disposed);
        }

        public function set limitContentProcessing(_value:Boolean):void {
            _limitContentProcessing = _value;
        }

        override protected function get dependencies():Vector.<ComponentDependency> {
            return (super.dependencies.concat(new <ComponentDependency>[new ComponentDependency(new IIDRoomObjectFactory(), function(_contentFactory:IRoomObjectFactory):void {
                _objectFactory = _contentFactory;
            }), new ComponentDependency(new IIDRoomObjectVisualizationFactory(), function(_visualizationFactoryDependency:IRoomObjectVisualizationFactory):void {
                _visualizationFactory = _visualizationFactoryDependency;
            })]));
        }

        override protected function initComponent():void {
            var _local_1:XML;
            _managerState = 1;

            if (_pendingInitializationXml != null) {
                _local_1 = _pendingInitializationXml;
                _pendingInitializationXml = null;
                initialize(_local_1, _managerListener);
            }
        }

        override public function dispose():void {
            if (disposed) {
                return;
            }


            if (_rooms != null) {
                for each (var _local_1:IRoomInstance in _rooms) {
                    if (_local_1 != null) {
                        _local_1.dispose();
                    }

                }


                _rooms.dispose();
                _rooms = null;
            }


            _managerListener = null;
            _pendingContentTypes = null;
            _objectUpdateCategories = null;
            _roomContentLoader = null;

            super.dispose();
        }

        public function initialize(_configuration:XML, _listener:IRoomManagerListener):Boolean {
            var _local_4:int;
            var _local_5:String;

            if (_managerState == 0) {
                if (_pendingInitializationXml != null) {
                    return (false);
                }


                _pendingInitializationXml = _configuration;
                _managerListener = _listener;

                return (true);
            }


            if (_managerState >= 2) {
                return (false);
            }


            if (_configuration == null) {
                return (false);
            }


            if (_roomContentLoader == null) {
                return (false);
            }


            _contentLoadLimit = 50;
            _managerListener = _listener;

            var _local_3:Array = _roomContentLoader.getPlaceHolderTypes();
            _local_4 = 0;

            while (_local_4 < _local_3.length) {
                _local_5 = _local_3[_local_4];

                if (_pendingContentTypes.indexOf(_local_5) < 0) {
                    _roomContentLoader.loadObjectContent(_local_5, events);
                    _pendingContentTypes.push(_local_5);
                }


                _local_4++;
            }


            _managerState = 2;

            return (true);
        }

        public function setContentLoader(_contentLoader:IRoomContentLoader):void {
            if (_roomContentLoader != null) {
                _roomContentLoader.dispose();
            }


            _roomContentLoader = _contentLoader;
        }

        public function addObjectUpdateCategory(_category:int):void {
            var _local_3:int;
            var _local_4:RoomInstance;
            var _local_2:int = _objectUpdateCategories.indexOf(_category);

            if (_local_2 >= 0) {
                return;
            }


            _objectUpdateCategories.push(_category);
            _local_3 = (_rooms.length - 1);

            while (_local_3 >= 0) {
                _local_4 = (_rooms.getWithIndex(_local_3) as RoomInstance);

                if (_local_4 != null) {
                    _local_4.addObjectUpdateCategory(_category);
                }


                _local_3--;
            }
        }

        public function removeObjectUpdateCategory(_category:int):void {
            var _local_3:int;
            var _local_4:RoomInstance;
            var _local_2:int = _objectUpdateCategories.indexOf(_category);

            if (_local_2 < 0) {
                return;
            }

            _objectUpdateCategories.splice(_local_2, 1);
            _local_3 = (_rooms.length - 1);

            while (_local_3 >= 0) {
                _local_4 = (_rooms.getWithIndex(_local_3) as RoomInstance);

                if (_local_4 != null) {
                _local_4.removeObjectUpdateCategory(_category);
                }
                ;

                _local_3--;
            }
        }

        public function createRoom(_roomId:String, _roomData:XML):IRoomInstance {
            var _local_3:int;
            var _local_4:int;

            if (_managerState < 3) {
                throw(new RoomManagerException());
            }

            if (_rooms.getValue(_roomId) != null) {
                return (null);
            }

            var _local_5:RoomInstance = new RoomInstance(_roomId, this);
            _rooms.add(_roomId, _local_5);
            _local_3 = (_objectUpdateCategories.length - 1);

            while (_local_3 >= 0) {
                _local_4 = _objectUpdateCategories[_local_3];
                _local_5.addObjectUpdateCategory(_local_4);
                _local_3--;
            }

            return (_local_5);
        }

        public function getRoom(_roomId:String):IRoomInstance {
            return (_rooms.getValue(_roomId) as IRoomInstance);
        }

        public function getRoomWithIndex(_index:int):IRoomInstance {
            return (_rooms.getWithIndex(_index));
        }

        public function getRoomCount():int {
            return (_rooms.length);
        }

        public function disposeRoom(_roomId:String):Boolean {
            var _local_2:IRoomInstance = (_rooms.remove(_roomId) as IRoomInstance);

            if (_local_2 != null) {
                _local_2.dispose();
                return (true);
            }

            return (false);
        }

        public function createRoomObject(_roomId:String, _objectId:int, _type:String, _category:int):IRoomObject {
            if (_managerState < 3) {
                throw(new RoomManagerException());
            }

            var _local_11:IRoomInstance = getRoom(_roomId);

            if (_local_11 == null) {
                return (null);
            }
            ;

            if (_roomContentLoader == null) {
                return (null);
            }
            ;

            var _local_7:RoomInstance = (_local_11 as RoomInstance);

            if (_local_7 == null) {
                return (null);
            }
            ;

            var _local_10:IGraphicAssetCollection;
            var _local_15:XML;
            var _local_12:XML;
            var _local_9:String;
            var _local_14:String;
            var _local_5:String = _type;
            var _local_16:Boolean;

            if (!_roomContentLoader.hasInternalContent(_type)) {
                _local_10 = _roomContentLoader.getGraphicAssetCollection(_type);

                if (_local_10 == null) {
                    _local_16 = true;
                    _roomContentLoader.loadObjectContent(_type, events);
                    _local_5 = _roomContentLoader.getPlaceHolderType(_type);
                    _local_10 = _roomContentLoader.getGraphicAssetCollection(_local_5);
                }
                ;

                _local_15 = _roomContentLoader.getVisualizationXML(_local_5);
                _local_12 = _roomContentLoader.getLogicXML(_local_5);

                if (((_local_15 == null) || (_local_10 == null))) {
                    return (null);
                }
                ;

                _local_9 = _roomContentLoader.getVisualizationType(_local_5);
                _local_14 = _roomContentLoader.getLogicType(_local_5);
            }

            else {
                _local_9 = _type;
                _local_14 = _type;
            }
            ;

            var _local_17:int = 1;
            var _local_19:IRoomObject = _local_7.createObjectInternal(_objectId, _local_17, _type, _category);
            var _local_13:IRoomObjectController = (_local_19 as IRoomObjectController);

            if (_local_13 == null) {
                return (null);
            }
            ;

            var _local_8:IRoomObjectGraphicVisualization = _visualizationFactory.createRoomObjectVisualization(_local_9);

            if (_local_8 == null) {
                _local_11.disposeObject(_objectId, _category);
                return (null);
            }
            ;

            _local_8.assetCollection = _local_10;
            _local_8.setExternalBaseUrls(context.configuration.getProperty("stories.image_url_base"), context.configuration.getProperty("extra_data_service_url"), context.configuration.getBoolean("extra_data_batches_enabled"));

            var _local_6:IRoomObjectVisualizationData;
            _local_6 = _visualizationFactory.getRoomObjectVisualizationData(_local_5, _local_9, _local_15);

            if (!_local_8.initialize(_local_6)) {
                _local_11.disposeObject(_objectId, _category);
                return (null);
            }
            ;

            _local_13.setVisualization(_local_8);

            var _local_18:IRoomObjectEventHandler = _objectFactory.createRoomObjectLogic(_local_14);
            _local_13.setEventHandler(_local_18);

            if (((!(_local_18 == null)) && (!(_local_12 == null)))) {
                _local_18.initialize(_local_12);
            }
            ;

            if (!_local_16) {
                _local_13.setInitialized(true);
            }
            ;

            _roomContentLoader.roomObjectCreated(_local_13, _roomId);
            return (_local_13);
        }

        public function createRoomObjectManager():IRoomObjectManager {
            if (_objectFactory != null) {
                return (_objectFactory.createRoomObjectManager());
            }
            ;

            return (null);
        }

        public function isContentAvailable(_contentType:String):Boolean {
            if (_roomContentLoader != null) {
                if (_roomContentLoader.getGraphicAssetCollection(_contentType) != null) {
                    return (true);
                }
                ;
            }
            ;

            return (false);
        }

        private function processInitialContentLoad(_contentType:String):void {
            var _local_2:int;

            if (_contentType == null) {
                return;
            }
            ;

            if (_managerState == -1) {
                return;
            }
            ;

            if (_roomContentLoader == null) {
                _managerState = -1;
                return;
            }
            ;

            if (_roomContentLoader.getGraphicAssetCollection(_contentType) != null) {
                _local_2 = _pendingContentTypes.indexOf(_contentType);

                if (_local_2 >= 0) {
                    _pendingContentTypes.splice(_local_2, 1);
                }
                ;

                if (_pendingContentTypes.length == 0) {
                    _managerState = 3;

                    if (_managerListener != null) {
                        _managerListener.roomManagerInitialized(true);
                    }
                    ;
                }
                ;
            }

            else {
                _managerState = -1;
                _managerListener.roomManagerInitialized(false);
            }
            ;
        }

        private function onContentLoaded(_event:RoomContentLoadedEvent):void {
            if (_roomContentLoader == null) {
                return;
            }
            ;

            var _local_2:String = _event.contentType;

            if (_local_2 == null) {
                if (_managerListener != null) {
                    _managerListener.contentLoaded(null, false);
                }
                ;

                return;
            }
            ;

            if (_queuedLoadedContentTypes.indexOf(_local_2) < 0) {
                _queuedLoadedContentTypes.push(_local_2);
            }
            ;
        }

        private function processLoadedContentTypes():void {
            var _local_4:String;
            var _local_3:IGraphicAssetCollection;
            var elapsedMillis:int;

            if (_skipContentProcessingForNextFrame) {
                _skipContentProcessingForNextFrame = false;
                return;
            }
            ;

            var _local_2:int = getTimer();

            while (_queuedLoadedContentTypes.length > 0) {
                _local_4 = _queuedLoadedContentTypes[0];
                _queuedLoadedContentTypes.splice(0, 1);

                if (!_roomContentLoader.hasVisualizationXML(_local_4)) {
                    if (_managerListener != null) {
                        _managerListener.contentLoaded(_local_4, false);
                    }
                    ;

                    return;
                }
                ;

                _local_3 = _roomContentLoader.getGraphicAssetCollection(_local_4);

                if (_local_3 == null) {
                    if (_managerListener != null) {
                        _managerListener.contentLoaded(_local_4, false);
                    }
                    ;

                    return;
                }
                ;

                updateObjectContents(_local_4);

                if (_managerListener != null) {
                    _managerListener.contentLoaded(_local_4, true);
                }
                ;

                if (_pendingContentTypes.length > 0) {
                    processInitialContentLoad(_local_4);
                }
                ;

                elapsedMillis = getTimer();

                if ((((elapsedMillis - _local_2) >= CONTENT_PROCESSING_TIME_LIMIT_MILLISECONDS) && (_limitContentProcessing))) {
                    _skipContentProcessingForNextFrame = true;
                    return;
                }
                ;
            }
            ;
        }

        private function updateObjectContents(_contentType:String):void {
            var _local_12:XML;
            var _local_8:IGraphicAssetCollection;
            var _local_2:IRoomObjectVisualizationData;
            var _local_14:XML;
            var _local_17:int;
            var _local_9:RoomInstance;
            var _local_11:String;
            var _local_15:Array;
            var _local_10:Boolean;
            var _local_4:int;
            var _local_7:int;
            var _local_18:IRoomObjectController;
            var _local_5:IRoomObjectGraphicVisualization;
            var _local_3:IRoomObjectEventHandler;

            if (_contentType == null) {
                return;
            }
            ;

            if (((_roomContentLoader == null) || (_visualizationFactory == null))) {
                return;
            }
            ;

            var _local_6:String = _roomContentLoader.getVisualizationType(_contentType);
            var _local_13:String = _roomContentLoader.getLogicType(_contentType);
            _local_17 = (_rooms.length - 1);

            while (_local_17 >= 0) {
                _local_9 = (_rooms.getWithIndex(_local_17) as RoomInstance);
                _local_11 = _rooms.getKey(_local_17);

                if (_local_9 != null) {
                    _local_15 = _local_9.getObjectManagerIds();
                    _local_10 = false;

                    for each (var _local_16:int in _local_15) {
                        _local_4 = _local_9.getObjectCountForType(_contentType, _local_16);
                        _local_7 = (_local_4 - 1);

                        while (_local_7 >= 0) {
                            _local_18 = (_local_9.getObjectWithIndexAndType(_local_7, _contentType, _local_16) as IRoomObjectController);

                            if (_local_18 != null) {
                                if (!_local_2) {
                                    _local_14 = _roomContentLoader.getVisualizationXML(_contentType);

                                    if (_local_14 == null) {
                                        return;
                                    }
                                    ;

                                    _local_12 = _roomContentLoader.getLogicXML(_contentType);
                                    _local_8 = _roomContentLoader.getGraphicAssetCollection(_contentType);

                                    if (_local_8 == null) {
                                        return;
                                    }
                                    ;

                                    _local_2 = _visualizationFactory.getRoomObjectVisualizationData(_contentType, _local_6, _local_14);
                                }
                                ;

                                _local_5 = _visualizationFactory.createRoomObjectVisualization(_local_6);

                                if (_local_5 != null) {
                                    _local_5.assetCollection = _local_8;
                                    _local_5.setExternalBaseUrls(context.configuration.getProperty("stories.image_url_base"), context.configuration.getProperty("extra_data_service_url"), context.configuration.getBoolean("extra_data_batches_enabled"));

                                    if (!_local_5.initialize(_local_2)) {
                                        _local_9.disposeObject(_local_18.getId(), _local_16);
                                    }

                                    else {
                                        _local_18.setVisualization(_local_5);
                                        _local_3 = _objectFactory.createRoomObjectLogic(_local_13);
                                        _local_18.setEventHandler(_local_3);

                                        if (_local_3 != null) {
                                            _local_3.initialize(_local_12);
                                        }
                                        ;

                                        _local_18.setInitialized(true);

                                        if (_managerListener != null) {
                                            _managerListener.objectInitialized(_local_11, _local_18.getId(), _local_16);
                                            _local_10 = true;
                                        }
                                        ;
                                    }
                                    ;
                                }

                                else {
                                    _local_9.disposeObject(_local_18.getId(), _local_16);
                                }
                                ;
                            }
                            ;

                            _local_7--;
                        }
                        ;
                    }
                    ;

                    if (((!(_local_9.hasUninitializedObjects())) && (_local_10))) {
                        _managerListener.objectsInitialized(_local_11);
                    }
                    ;
                }
                ;

                _local_17--;
            }
            ;
        }

        public function update(_deltaMillis:uint):void {
            var _local_2:int;
            var _local_3:RoomInstance;
            processLoadedContentTypes();
            _local_2 = (_rooms.length - 1);

            while (_local_2 >= 0) {
                _local_3 = (_rooms.getWithIndex(_local_2) as RoomInstance);

                if (_local_3 != null) {
                    _local_3.update();
                }
                ;

                _local_2--;
            }
            ;
        }

    }
}


