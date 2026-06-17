package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurnitureEcotronBoxLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var _eventTypes:Array = ["ROWRE_ECOTRONBOX"];
            return (getAllEventTypes(super.getEventTypes(), _eventTypes));
        }

        override public function mouseEvent(_mouseEvent:RoomSpriteMouseEvent, _geometry:IRoomGeometry):void
        {
            if (((_mouseEvent == null) || (_geometry == null)))
            {
                return;
            };

            if (object == null)
            {
                return;
            };

            switch (_mouseEvent.type)
            {
                case "doubleClick":
                    useObject();
                    return;
                default:
                    super.mouseEvent(_mouseEvent, _geometry);
                    return;
            };
        }

        override public function useObject():void
        {
            var _widgetRequestEvent:RoomObjectEvent;

            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                _widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_ECOTRONBOX", object);
                eventDispatcher.dispatchEvent(_widgetRequestEvent);
            };
        }

    }
}