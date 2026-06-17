package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.events.RoomObjectStateChangeEvent;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;

    public class FurnitureJukeboxLogic extends FurnitureMultiStateLogic 
    {

        private var _disposeEventsAllowed:Boolean;
        private var _isInitialized:Boolean = false;
        private var _currentState:int = -1;

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROFCAE_JUKEBOX_START", "ROFCAE_JUKEBOX_MACHINE_STOP", "ROFCAE_JUKEBOX_DISPOSE", "ROFCAE_JUKEBOX_INIT", "ROWRE_JUKEBOX_PLAYLIST_EDITOR"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function dispose():void
        {
            requestDispose();
            super.dispose();
        }

        override public function processUpdateMessage(_arg_updateMessage:RoomObjectUpdateMessage):void
        {
            var dataUpdateMessage:RoomObjectDataUpdateMessage;
            var modelController:IRoomObjectModelController;
            var state:int;
            super.processUpdateMessage(_arg_updateMessage);

            if (object == null)
            {
                return;
            };

            if (object.getModelController().getNumber("furniture_real_room_object") == 1)
            {
                if (!_isInitialized)
                {
                    requestInit();
                };

                object.getModelController().setString("RWEIEP_INFOSTAND_EXTRA_PARAM", "RWEIEP_JUKEBOX");
                dataUpdateMessage = (_arg_updateMessage as RoomObjectDataUpdateMessage);

                if (dataUpdateMessage == null)
                {
                    return;
                };

                modelController = object.getModelController();

                if (modelController == null)
                {
                    return;
                };

                state = object.getState(0);

                if (state != _currentState)
                {
                    _currentState = state;

                    if (state == 1)
                    {
                        requestPlayList();
                    }

                    else
                    {
                        if (state == 0)
                        {
                            requestStopPlaying();
                        };
                    };
                };
            };
        }

        override public function mouseEvent(_arg_mouseEvent:RoomSpriteMouseEvent, _arg_geometry:IRoomGeometry):void
        {
            if (((_arg_mouseEvent == null) || (_arg_geometry == null)))
            {
                return;
            };

            if (object == null)
            {
                return;
            };

            switch (_arg_mouseEvent.type)
            {
                case "doubleClick":
                    useObject();
                    return;
                default:
                    super.mouseEvent(_arg_mouseEvent, _arg_geometry);
                    return;
            };
        }

        override public function useObject():void
        {
            var widgetRequestEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_JUKEBOX_PLAYLIST_EDITOR", object);
                eventDispatcher.dispatchEvent(widgetRequestEvent);
                eventDispatcher.dispatchEvent(new RoomObjectStateChangeEvent("ROSCE_STATE_CHANGE", object, -1));
            };
        }

        private function requestInit():void
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            _disposeEventsAllowed = true;

            var furnitureActionEvent:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_JUKEBOX_INIT", object);
            eventDispatcher.dispatchEvent(furnitureActionEvent);
            _isInitialized = true;
        }

        private function requestPlayList():void
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            _disposeEventsAllowed = true;

            var furnitureActionEvent:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_JUKEBOX_START", object);
            eventDispatcher.dispatchEvent(furnitureActionEvent);
        }

        private function requestStopPlaying():void
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            var furnitureActionEvent:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_JUKEBOX_MACHINE_STOP", object);
            eventDispatcher.dispatchEvent(furnitureActionEvent);
        }

        private function requestDispose():void
        {
            if (!_disposeEventsAllowed)
            {
                return;
            };

            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            };

            var furnitureActionEvent:RoomObjectFurnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_JUKEBOX_DISPOSE", object);
            eventDispatcher.dispatchEvent(furnitureActionEvent);
        }

    }
}
