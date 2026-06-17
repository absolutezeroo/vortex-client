package com.sulake.room.object.logic
{
    import flash.events.IEventDispatcher;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

    public class ObjectLogicBase implements IRoomObjectEventHandler 
    {

        private var _eventDispatcher:IEventDispatcher;
        private var _object:IRoomObjectController;

        public function get eventDispatcher():IEventDispatcher
        {
            return (_eventDispatcher);
        }

        public function set eventDispatcher(_dispatcher:IEventDispatcher):void
        {
            _eventDispatcher = _dispatcher;
        }

        public function getEventTypes():Array
        {
            return ([]);
        }

        protected function getAllEventTypes(_target:Array, _extra:Array):Array
        {
            var _local_3:Array = _target.concat();

            for each (var _local_4:String in _extra)
            {
                if (_local_3.indexOf(_local_4) < 0)
                {
                    _local_3.push(_local_4);
                };
            };

            return (_local_3);
        }

        public function dispose():void
        {
            _object = null;
        }

        public function set object(_newObject:IRoomObjectController):void
        {
            if (_object == _newObject)
            {
                return;
            };

            if (_object != null)
            {
                _object.setEventHandler(null);
            };

            if (_newObject == null)
            {
                dispose();
                _object = null;
            }

            else
            {
                _object = _newObject;
                _object.setEventHandler(this);
            };
        }

        public function get object():IRoomObjectController
        {
            return (_object);
        }

        public function mouseEvent(_event:RoomSpriteMouseEvent, _geometry:IRoomGeometry):void
        {
        }

        public function initialize(_data:XML):void
        {
        }

        public function update(_time:int):void
        {
        }

        public function processUpdateMessage(_message:RoomObjectUpdateMessage):void
        {
            if (_message != null)
            {
                if (_object != null)
                {
                    _object.setLocation(_message.loc);
                    _object.setDirection(_message.dir);
                };
            };
        }

        public function useObject():void
        {
        }

        public function tearDown():void
        {
        }

        public function get widget():String
        {
            return (null);
        }

        public function get contextMenu():String
        {
            return (null);
        }

    }
}


