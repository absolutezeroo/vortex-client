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

        override public function set object(_arg_1:IRoomObjectController):void
        {
            super.object = _arg_1;

            if (_arg_1 != null)
            {
                _loc.assign(_arg_1.getLocation());
            };
        }

        protected function set moveUpdateInterval(_arg_1:int):void
        {
            if (_arg_1 <= 0)
            {
                _arg_1 = 1;
            };

            _updateInterval = _arg_1;
        }

        override public function processUpdateMessage(_arg_1:RoomObjectUpdateMessage):void
        {
            var _local_3:IVector3d;

            if (_arg_1 == null)
            {
                return;
            };

            super.processUpdateMessage(_arg_1);

            if (_arg_1.loc != null)
            {
                _loc.assign(_arg_1.loc);
            };

            var _local_2:RoomObjectMoveUpdateMessage = (_arg_1 as RoomObjectMoveUpdateMessage);

            if (_local_2 == null)
            {
                return;
            };

            if (object != null)
            {
                if (_arg_1.loc != null)
                {
                    _local_3 = _local_2.targetLoc;
                    _changeTime = _lastUpdateTime;
                    if (_local_3 == null)
                    {
                        _locDelta.x = 0;
                        _locDelta.y = 0;
                        _locDelta.z = 0;
                    }
                    else
                    {
                        _locDelta.assign(_local_3);
                        _locDelta.sub(_loc);
                    };
                };
            };
        }

        protected function getLocationOffset():IVector3d
        {
            return (null);
        }

        override public function update(_arg_1:int):void
        {
            var _local_3:int;
            var _local_2:IVector3d = getLocationOffset();
            var _local_4:IRoomObjectModelController = object.getModelController();

            if (_local_4 != null)
            {
                if (_local_2 != null)
                {
                    if (_liftAmount != _local_2.z)
                    {
                        _liftAmount = _local_2.z;
                        _local_4.setNumber("furniture_lift_amount", _liftAmount);
                    };
                }

                else
                {
                    if (_liftAmount != 0)
                    {
                        _liftAmount = 0;
                        _local_4.setNumber("furniture_lift_amount", _liftAmount);
                    };
                };
            };

            if (((_locDelta.length > 0) || (!(_local_2 == null))))
            {
                _local_3 = (_arg_1 - _changeTime);

                if (_local_3 == (_updateInterval >> 1))
                {
                    _local_3++;
                };

                if (_local_3 > _updateInterval)
                {
                    _local_3 = _updateInterval;
                };

                if (_locDelta.length > 0)
                {
                    helper_vector.assign(_locDelta);
                    helper_vector.mul((_local_3 / _updateInterval));
                    helper_vector.add(_loc);
                }

                else
                {
                    helper_vector.assign(_loc);
                };

                if (_local_2 != null)
                {
                    helper_vector.add(_local_2);
                };

                if (object != null)
                {
                    object.setLocation(helper_vector);
                };

                if (_local_3 == _updateInterval)
                {
                    _locDelta.x = 0;
                    _locDelta.y = 0;
                    _locDelta.z = 0;
                };
            };

            _lastUpdateTime = _arg_1;
        }

    }
}
