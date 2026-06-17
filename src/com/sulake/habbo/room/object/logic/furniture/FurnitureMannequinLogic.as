package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurnitureMannequinLogic extends FurnitureLogic 
    {

        private static const KEY_GENDER:String = "GENDER";
        private static const KEY_FIGURE:String = "FIGURE";
        private static const KEY_OUTFIT_NAME:String = "OUTFIT_NAME";

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROWRE_MANNEQUIN"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function processUpdateMessage(_arg_updateMessage:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(_arg_updateMessage);

            var dataUpdateMessage:RoomObjectDataUpdateMessage = (_arg_updateMessage as RoomObjectDataUpdateMessage);

            if (((!(dataUpdateMessage == null)) && (!(dataUpdateMessage.data == null))))
            {
                dataUpdateMessage.data.writeRoomObjectModel(object.getModelController());
                setObjectVariables();
            };
        }

        private function setObjectVariables():void
        {
            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            };

            var mapStuffData:MapStuffData = new MapStuffData();
            mapStuffData.initializeFromRoomObjectModel(object.getModel());
            object.getModelController().setString("furniture_mannequin_gender", mapStuffData.getValue("GENDER"));
            object.getModelController().setString("furniture_mannequin_figure", mapStuffData.getValue("FIGURE"));
            object.getModelController().setString("furniture_mannequin_name", mapStuffData.getValue("OUTFIT_NAME"));
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
                widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_MANNEQUIN", object);
                eventDispatcher.dispatchEvent(widgetRequestEvent);
            };
        }

    }
}