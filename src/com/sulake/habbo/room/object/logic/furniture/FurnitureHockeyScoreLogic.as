package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectStateChangeEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

    public class FurnitureHockeyScoreLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var eventTypes:Array = ["ROSCE_STATE_CHANGE"];
            return (getAllEventTypes(super.getEventTypes(), eventTypes));
        }

        override public function mouseEvent(_arg_mouseEvent:RoomSpriteMouseEvent, _arg_geometry:IRoomGeometry):void
        {
            var stateChangeEvent:RoomObjectEvent;

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
                    switch (_arg_mouseEvent.spriteTag)
                    {
                        case "off":
                            stateChangeEvent = new RoomObjectStateChangeEvent("ROSCE_STATE_CHANGE", object, 3);
                    };

                    break;
                case "click":
                    switch (_arg_mouseEvent.spriteTag)
                    {
                        case "inc":
                            stateChangeEvent = new RoomObjectStateChangeEvent("ROSCE_STATE_CHANGE", object, 2);
                            break;
                        case "dec":
                            stateChangeEvent = new RoomObjectStateChangeEvent("ROSCE_STATE_CHANGE", object, 1);
                    };
            };

            if (((!(eventDispatcher == null)) && (!(stateChangeEvent == null))))
            {
                eventDispatcher.dispatchEvent(stateChangeEvent);
            }

            else
            {
                super.mouseEvent(_arg_mouseEvent, _arg_geometry);
            };
        }

        override public function useObject():void
        {
            var stateChangeEvent:RoomObjectEvent;

            if (object != null)
            {
                stateChangeEvent = new RoomObjectStateChangeEvent("ROSCE_STATE_CHANGE", object, 3);

                if (eventDispatcher != null)
                {
                    eventDispatcher.dispatchEvent(stateChangeEvent);
                };
            };
        }

    }
}