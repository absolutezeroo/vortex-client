package com.sulake.room.object
{
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import Logger;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.logic.IRoomObjectMouseHandler;
    import com.sulake.room.utils.*;

    public class RoomObject implements IRoomObjectController 
    {

        private static var _nextRoomObjectInstanceId:int = 0;

        private var _id:int;
        private var _type:String = "";
        private var _location:Vector3d;
        private var _direction:Vector3d;
        private var _cachedLocation:Vector3d;
        private var _cachedDirection:Vector3d;
        private var _states:Array;
        private var _model:RoomObjectModel;
        private var _visualization:IRoomObjectVisualization;
        private var _eventHandler:IRoomObjectEventHandler;
        private var _updateCounter:int;
        private var _avatarLibraryAssetName:String;
        private var _instanceId:int = 0;
        private var _initialized:Boolean = false;

        public function RoomObject(id:int, stateCount:int, type:String)
        {
            var stateIndex:Number;
            super();
            _id = id;
            _location = new Vector3d();
            _direction = new Vector3d();
            _cachedLocation = new Vector3d();
            _cachedDirection = new Vector3d();
            _states = new Array(stateCount);
            stateIndex = (stateCount - 1);

            while (stateIndex >= 0)
            {
                _states[stateIndex] = 0;
                stateIndex--;
            };

            _type = type;
            _model = new RoomObjectModel();
            _visualization = null;
            _eventHandler = null;
            _updateCounter = 0;
            _instanceId = _nextRoomObjectInstanceId++;
        }

        public function dispose():void
        {
            _location = null;
            _direction = null;
            _states = null;
            _avatarLibraryAssetName = null;
            setVisualization(null);
            setEventHandler(null);

            if (_model != null)
            {
                _model.dispose();
                _model = null;
            };
        }

        public function setInitialized(_initialized:Boolean):void
        {
            this._initialized = _initialized;
        }

        public function isInitialized():Boolean
        {
            return (_initialized);
        }

        public function getId():int
        {
            return (_id);
        }

        public function getInstanceId():int
        {
            return (_instanceId);
        }

        public function getType():String
        {
            return (_type);
        }

        public function getLocation():IVector3d
        {
            _cachedLocation.assign(_location);
            return (_cachedLocation);
        }

        public function getDirection():IVector3d
        {
            _cachedDirection.assign(_direction);
            return (_cachedDirection);
        }

        public function getModel():IRoomObjectModel
        {
            return (_model);
        }

        public function getModelController():IRoomObjectModelController
        {
            return (_model);
        }

        public function getState(_stateIndex:int):int
        {
            if (((_stateIndex >= 0) && (_stateIndex < _states.length)))
            {
                return (_states[_stateIndex]);
            };

            return (-1);
        }

        public function getVisualization():IRoomObjectVisualization
        {
            return (_visualization);
        }

        public function setLocation(_newLocation:IVector3d):void
        {
            if (_newLocation == null)
            {
                return;
            };

            if ((((!(_location.x == _newLocation.x)) || (!(_location.y == _newLocation.y))) || (!(_location.z == _newLocation.z))))
            {
                this._location.x = _newLocation.x;
                this._location.y = _newLocation.y;
                this._location.z = _newLocation.z;
                _updateCounter++;
            };
        }

        public function setDirection(_newDirection:IVector3d):void
        {
            if (_newDirection == null)
            {
                return;
            };

            if ((((!(_direction.x == _newDirection.x)) || (!(_direction.y == _newDirection.y))) || (!(_direction.z == _newDirection.z))))
            {
                this._direction.x = (((_newDirection.x % 360) + 360) % 360);
                this._direction.y = (((_newDirection.y % 360) + 360) % 360);
                this._direction.z = (((_newDirection.z % 360) + 360) % 360);
                _updateCounter++;
            };
        }

        public function setState(_state:int, _stateIndex:int):Boolean
        {
            if (((_stateIndex >= 0) && (_stateIndex < _states.length)))
            {
                if (_states[_stateIndex] != _state)
                {
                    _states[_stateIndex] = _state;
                    _updateCounter++;
                };

                return (true);
            };

            return (false);
        }

        public function setVisualization(_visualization:IRoomObjectVisualization):void
        {
            if (_visualization != this._visualization)
            {
                if (_visualization != null)
                {
                    try
                    {
                        this._visualization.dispose();
                    }
                    catch (error:Error)
                    {
                        Logger.log(("RoomObject#setVisualization failed to dispose previous visualization for #" + _id + ": " + error));
                    }
                };

                this._visualization = _visualization;

                if (this._visualization != null)
                {
                    this._visualization.object = this;
                };
            };
        }

        public function setEventHandler(_handler:IRoomObjectEventHandler):void
        {
            if (_handler == _eventHandler)
            {
                return;
            };

            var _previousHandler:IRoomObjectEventHandler = _eventHandler;

            if (_previousHandler != null)
            {
                _eventHandler = null;
                _previousHandler.object = null;
            };

            _eventHandler = _handler;

            if (_eventHandler != null)
            {
                _eventHandler.object = this;
            };
        }

        public function getEventHandler():IRoomObjectEventHandler
        {
            return (_eventHandler);
        }

        public function getUpdateID():int
        {
            return (_updateCounter);
        }

        public function getMouseHandler():IRoomObjectMouseHandler
        {
            return (getEventHandler());
        }

        public function getAvatarLibraryAssetName():String
        {
            if (!_avatarLibraryAssetName)
            {
                _avatarLibraryAssetName = ("avatar_" + getId());
            };

            return (_avatarLibraryAssetName);
        }

        public function tearDown():void
        {
            if (_eventHandler)
            {
                _eventHandler.tearDown();
            };
        }

    }
}


