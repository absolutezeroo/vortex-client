package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurniturePlaceholderLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROWRE_PLACEHOLDER"];
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

        override public function useObject():void
        {
            var widgetRequestEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_PLACEHOLDER", object);
                eventDispatcher.dispatchEvent(widgetRequestEvent);
            };
        }

    }
}