package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurniturePetProductLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var eventTypes:Array = [];
            eventTypes.push("ROWRE_PET_PRODUCT_MENU");
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
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
                case "doubleClick":
                    useObject();
                    return;
                default:
                    super.mouseEvent(mouseEvent, geometry);
                    return;
            };
        }

        override public function processUpdateMessage(updateMessage:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(updateMessage);

            if (object == null)
            {
                return;
            };

            if (object.getModelController().getNumber("furniture_real_room_object") == 1)
            {
                object.getModelController().setString("RWEIEP_INFOSTAND_EXTRA_PARAM", "RWEIEP_USABLE_PRODUCT");
            };
        }

        override public function useObject():void
        {
            var widgetRequestEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_PET_PRODUCT_MENU", object);
                eventDispatcher.dispatchEvent(widgetRequestEvent);
            };
        }

    }
}