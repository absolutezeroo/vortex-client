package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;

    public class FurnitureOneWayDoorLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROFCAE_ENTER_ONEWAYDOOR"];
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
            var furnitureActionEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                furnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_ENTER_ONEWAYDOOR", object);
                eventDispatcher.dispatchEvent(furnitureActionEvent);
            };
        }

    }
}