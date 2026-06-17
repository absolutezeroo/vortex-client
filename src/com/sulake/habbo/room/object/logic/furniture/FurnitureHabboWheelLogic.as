package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;

    public class FurnitureHabboWheelLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROFCAE_USE_HABBOWHEEL"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
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
            var furnitureActionEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                furnitureActionEvent = new RoomObjectFurnitureActionEvent("ROFCAE_USE_HABBOWHEEL", object);

                if (furnitureActionEvent != null)
                {
                    eventDispatcher.dispatchEvent(furnitureActionEvent);
                };
            };
        }

    }
}