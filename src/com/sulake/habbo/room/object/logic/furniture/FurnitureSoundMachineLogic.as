package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;

    public class FurnitureSoundMachineLogic extends FurnitureMultiStateLogic 
    {

        private var _disposeEventsAllowed:Boolean;
        private var _isInitialized:Boolean = false;
        private var _currentState:int = -1;

        override public function getEventTypes():Array
        {
            var _local_1:Array = ["ROFCAE_SOUND_MACHINE_START", "ROFCAE_SOUND_MACHINE_STOP", "ROFCAE_SOUND_MACHINE_DISPOSE", "ROFCAE_SOUND_MACHINE_INIT"];
            return (getAllEventTypes(super.getEventTypes(), _local_1));
        }

        override public function dispose():void
        {
            requestDispose();
            super.dispose();
        }

        override public function processUpdateMessage(_arg_1:RoomObjectUpdateMessage):void
        {
            var _local_3:RoomObjectDataUpdateMessage;
            var _local_2:int;
            super.processUpdateMessage(_arg_1);

            if (object == null)
            {
                return;
            };

            if (object.getModelController().getNumber("furniture_real_room_object") == 1)
            {
                if (!_isInitialized)
                {
                    requestInitialize();
                };

                _local_3 = (_arg_1 as RoomObjectDataUpdateMessage);

                if (_local_3 == null)
                {
                    return;
                };

                _local_2 = object.getState(0);

                if (_local_2 != _currentState)
                {
                    _currentState = _local_2;

                    if (_local_2 == 1)
                    {
                        requestPlayList();
                    }

                    else
                    {
                        if (_local_2 == 0)
                        {
                            requestStopPlaying();
                        };
                    };
                };
            };
        }

        private function requestInitialize():void
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            _disposeEventsAllowed = true;

            var _local_1:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_SOUND_MACHINE_INIT", object);
            eventDispatcher.dispatchEvent(_local_1);
            _isInitialized = true;
        }

        private function requestPlayList():void
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            _disposeEventsAllowed = true;

            var _local_1:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_SOUND_MACHINE_START", object);
            eventDispatcher.dispatchEvent(_local_1);
        }

        private function requestStopPlaying():void
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            var _local_1:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_SOUND_MACHINE_STOP", object);
            eventDispatcher.dispatchEvent(_local_1);
        }

        private function requestDispose():void
        {
            if (!_disposeEventsAllowed)
            {
                return;
            };

            var _local_1:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_SOUND_MACHINE_DISPOSE", object);
            eventDispatcher.dispatchEvent(_local_1);
        }

    }
}
