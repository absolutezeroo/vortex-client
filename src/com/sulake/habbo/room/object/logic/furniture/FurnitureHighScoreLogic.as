package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

    public class FurnitureHighScoreLogic extends FurnitureLogic 
    {

        private static const SHOW_WIDGET_IN_STATE:int = 1;

        private var _state:int = -1;

        override public function getEventTypes():Array
        {
            return (["ROWRE_HIGH_SCORE_DISPLAY", "ROWRE_HIDE_HIGH_SCORE_DISPLAY"]);
        }

        override public function tearDown():void
        {
            if (object.getModelController().getNumber("furniture_real_room_object") == 1)
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_HIDE_HIGH_SCORE_DISPLAY", object));
            };

            super.tearDown();
        }

        override public function processUpdateMessage(_arg_updateMessage:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(_arg_updateMessage);

            if (object.getModelController().getNumber("furniture_real_room_object") != 1)
            {
                return;
            };

            var dataUpdateMessage:RoomObjectDataUpdateMessage = (_arg_updateMessage as RoomObjectDataUpdateMessage);

            if (dataUpdateMessage != null)
            {
                if (dataUpdateMessage.state == 1)
                {
                    eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_HIGH_SCORE_DISPLAY", object));
                }

                else
                {
                    eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_HIDE_HIGH_SCORE_DISPLAY", object));
                };

                _state = dataUpdateMessage.state;
                return;
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

    }
}
