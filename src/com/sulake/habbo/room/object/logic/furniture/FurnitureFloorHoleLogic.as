package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.events.RoomObjectFloorHoleEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObject;

    public class FurnitureFloorHoleLogic extends FurnitureMultiStateLogic 
    {

        private static const STATE_HOLE:int = 0;

        private var _currentState:int = -1;
        private var _currentLoc:Vector3d = null;

        override public function dispose():void
        {
            if (_currentState == 0)
            {
                eventDispatcher.dispatchEvent(new RoomObjectFloorHoleEvent("ROFHO_REMOVE_HOLE", object));
            };

            super.dispose();
        }

        override public function getEventTypes():Array
        {
            var _local_1:Array = ["ROFHO_ADD_HOLE", "ROFHO_REMOVE_HOLE"];
            return (getAllEventTypes(super.getEventTypes(), _local_1));
        }

        override public function processUpdateMessage(_arg_1:RoomObjectUpdateMessage):void
        {
            var _local_4:RoomObjectDataUpdateMessage;
            var _local_3:int;
            var _local_2:IVector3d;
            super.processUpdateMessage(_arg_1);

            if (object != null)
            {
                _local_4 = (_arg_1 as RoomObjectDataUpdateMessage);

                if (_local_4 != null)
                {
                    _local_3 = object.getState(0);
                    handleStateUpdate(_local_3);
                };

                _local_2 = object.getLocation();

                if (_currentLoc == null)
                {
                    _currentLoc = new Vector3d();
                }

                else
                {
                    if (((!(_local_2.x == _currentLoc.x)) || (!(_local_2.y == _currentLoc.y))))
                    {
                        if (_currentState == 0)
                        {
                            if (eventDispatcher != null)
                            {
                                eventDispatcher.dispatchEvent(new RoomObjectFloorHoleEvent("ROFHO_ADD_HOLE", object));
                            };
                        };
                    };
                };

                _currentLoc.assign(_local_2);
            };
        }

        private function handleStateUpdate(_arg_1:int):void
        {
            if (_arg_1 != _currentState)
            {
                if (eventDispatcher != null)
                {
                    if (_arg_1 == 0)
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectFloorHoleEvent("ROFHO_ADD_HOLE", object));
                    }

                    else
                    {
                        if (_currentState == 0)
                        {
                            eventDispatcher.dispatchEvent(new RoomObjectFloorHoleEvent("ROFHO_REMOVE_HOLE", object));
                        };
                    };
                };

                _currentState = _arg_1;
            };
        }

        private function handleAutomaticStateUpdate():void
        {
            var _local_3:IRoomObjectModel;
            var _local_2:Number;
            var _local_4:int;
            var _local_1:IRoomObject = object;

            if (_local_1 != null)
            {
                _local_3 = _local_1.getModel();

                if (_local_3 != null)
                {
                    _local_2 = _local_3.getNumber("furniture_automatic_state_index");

                    if (!isNaN(_local_2))
                    {
                        _local_4 = _local_2;
                        _local_4 = (_local_4 % 2);
                        handleStateUpdate(_local_4);
                    };
                };
            };
        }

        override public function update(_arg_1:int):void
        {
            super.update(_arg_1);
            handleAutomaticStateUpdate();
        }

    }
}
