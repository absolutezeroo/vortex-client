package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectModelDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.object.IRoomObjectModelController;

    public class FurniturePresentLogic extends FurnitureLogic 
    {

        private static const MESSAGE:String = "MESSAGE";
        private static const PRODUCT_CODE:String = "PRODUCT_CODE";
        private static const EXTRA_PARAM:String = "EXTRA_PARAM";
        private static const PURCHASER_NAME:String = "PURCHASER_NAME";
        private static const PURCHASER_FIGURE:String = "PURCHASER_FIGURE";

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROWRE_PRESENT"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function processUpdateMessage(updateMessage:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(updateMessage);

            var dataUpdateMessage:RoomObjectDataUpdateMessage = (updateMessage as RoomObjectDataUpdateMessage);

            if (((!(dataUpdateMessage == null)) && (!(dataUpdateMessage.data == null))))
            {
                dataUpdateMessage.data.writeRoomObjectModel(object.getModelController());
                setObjectVariables();
            };

            var modelDataUpdateMessage:RoomObjectModelDataUpdateMessage = (updateMessage as RoomObjectModelDataUpdateMessage);

            if (modelDataUpdateMessage != null)
            {
                if (modelDataUpdateMessage.numberKey == "furniture_disable_picking_animation")
                {
                    object.getModelController().setNumber("furniture_disable_picking_animation", modelDataUpdateMessage.numberValue);
                };
            };
        }

        private function setObjectVariables():void
        {
            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            };

            var stuffData:MapStuffData = new MapStuffData();
            stuffData.initializeFromRoomObjectModel(object.getModel());

            var message:String = stuffData.getValue("MESSAGE");
            var legacyFurnitureData:String = object.getModel().getString("furniture_data");

            if (((message == null) && (!(legacyFurnitureData == null))))
            {
                object.getModelController().setString("furniture_data", legacyFurnitureData.substr(1));
            }

            else
            {
                object.getModelController().setString("furniture_data", stuffData.getValue("MESSAGE"));
            };

            setObjectVariable("furniture_type_id", stuffData.getValue("PRODUCT_CODE"));
            setObjectVariable("furniture_purchaser_name", stuffData.getValue("PURCHASER_NAME"));
            setObjectVariable("furniture_purchaser_figure", stuffData.getValue("PURCHASER_FIGURE"));
        }

        private function setObjectVariable(key:String, value:String):void
        {
            if (value != null)
            {
                object.getModelController().setString(key, value);
            };
        }

        override public function mouseEvent(mouseEvent:RoomSpriteMouseEvent, geometry:IRoomGeometry):void
        {
            if (((mouseEvent == null) || (geometry == null)))
            {
                return;
            };

            if (object == null)
            {
                return;
            };

            switch (mouseEvent.type)
            {
                case "rollOver":
                    eventDispatcher.dispatchEvent(new RoomObjectFurnitureActionEvent("ROFCAE_MOUSE_BUTTON", object));
                    super.mouseEvent(mouseEvent, geometry);
                    return;
                case "rollOut":
                    eventDispatcher.dispatchEvent(new RoomObjectFurnitureActionEvent("ROFCAE_MOUSE_ARROW", object));
                    super.mouseEvent(mouseEvent, geometry);
                    return;
                case "doubleClick":
                    useObject();
                    return;
                default:
                    super.mouseEvent(mouseEvent, geometry);
                    return;
            };
        }

        override public function useObject():void
        {
            var widgetRequestEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_PRESENT", object);
                eventDispatcher.dispatchEvent(widgetRequestEvent);
            };
        }

        override public function initialize(data:XML):void
        {
            var modelController:IRoomObjectModelController;
            super.initialize(data);

            if (data == null)
            {
                return;
            };

            var particleSystemNodes:XMLList = data.particlesystems;

            if (((particleSystemNodes == null) || (particleSystemNodes.length() == 0)))
            {
                return;
            };

            if (object != null)
            {
                modelController = object.getModelController();

                if (modelController != null)
                {
                    modelController.setString("furniture_fireworks_data", particleSystemNodes);
                };
            };
        }

    }
}