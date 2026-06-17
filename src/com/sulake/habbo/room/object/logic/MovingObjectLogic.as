package com.sulake.habbo.room.object.logic
{
    import com.sulake.room.object.logic.ObjectLogicBase;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.object.IRoomObjectModelController;

    public class MovingObjectLogic extends ObjectLogicBase 
    {

        public static const DEFAULT_UPDATE_INTERVAL:int = 500;

        private static var helper_vector:Vector3d = new Vector3d();

        private var _locDelta:Vector3d = new Vector3d();
        private var _loc:Vector3d = new Vector3d();
        private var _liftAmount:Number = 0;
        private var _lastUpdateTime:int = 0;
        private var _changeTime:int;
        private var _updateInterval:int = 500;

        protected function get lastUpdateTime():int
        {
            return (_lastUpdateTime);
        }

        override public function dispose():void
        {
            super.dispose();
            _loc = null;
            _locDelta = null;
        }

        override public function set object(controller:IRoomObjectController):void
        {
            super.object = controller;

            if (controller != null)
            {
                _loc.assign(controller.getLocation());
            };
        }

        protected function set moveUpdateInterval(interval:int):void
        {
            if (interval <= 0)
            {
                interval = 1;
            };

            _updateInterval = interval;
        }

        override public function processUpdateMessage(message:RoomObjectUpdateMessage):void
        {
            var targetLoc:IVector3d;

            if (message == null)
            {
                return;
            };

            super.processUpdateMessage(message);

            if (message.loc != null)
            {
                _loc.assign(message.loc);
            };

            var moveMessage:RoomObjectMoveUpdateMessage = (message as RoomObjectMoveUpdateMessage);

            if (moveMessage == null)
            {
                return;
            };

            if (object != null)
            {
                if (message.loc != null)
                {
                    targetLoc = moveMessage.targetLoc;
                    _changeTime = _lastUpdateTime;
                    if (targetLoc == null)
                    {
                        _locDelta.x = 0;
                        _locDelta.y = 0;
                        _locDelta.z = 0;
                    }
                    else
                    {
                        _locDelta.assign(targetLoc);
                        _locDelta.sub(_loc);
                    };
                };
            };
        }

        protected function getLocationOffset():IVector3d
        {
            return (null);
        }

        override public function update(time:int):void
        {
            var elapsedTime:int;
            var locationOffset:IVector3d = getLocationOffset();
            var modelController:IRoomObjectModelController = object.getModelController();

            if (modelController != null)
            {
                if (locationOffset != null)
                {
                    if (_liftAmount != locationOffset.z)
                    {
                        _liftAmount = locationOffset.z;
                        modelController.setNumber("furniture_lift_amount", _liftAmount);
                    };
                }

                else
                {
                    if (_liftAmount != 0)
                    {
                        _liftAmount = 0;
                        modelController.setNumber("furniture_lift_amount", _liftAmount);
                    };
                };
            };

            if (((_locDelta.length > 0) || (!(locationOffset == null))))
            {
                elapsedTime = (time - _changeTime);

                if (elapsedTime == (_updateInterval >> 1))
                {
                    elapsedTime++;
                };

                if (elapsedTime > _updateInterval)
                {
                    elapsedTime = _updateInterval;
                };

                if (_locDelta.length > 0)
                {
                    helper_vector.assign(_locDelta);
                    helper_vector.mul((elapsedTime / _updateInterval));
                    helper_vector.add(_loc);
                }

                else
                {
                    helper_vector.assign(_loc);
                };

                if (locationOffset != null)
                {
                    helper_vector.add(locationOffset);
                };

                if (object != null)
                {
                    object.setLocation(helper_vector);
                };

                if (elapsedTime == _updateInterval)
                {
                    _locDelta.x = 0;
                    _locDelta.y = 0;
                    _locDelta.z = 0;
                };
            };

            _lastUpdateTime = time;
        }

    }
}
