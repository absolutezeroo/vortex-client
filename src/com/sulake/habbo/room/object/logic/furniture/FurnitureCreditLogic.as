package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurnitureCreditLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var _eventTypes:Array = ["ROWRE__CREDITFURNI"];
            return (getAllEventTypes(super.getEventTypes(), _eventTypes));
        }

        override public function dispose():void
        {
            super.dispose();
        }

        override public function initialize(_model:XML):void
        {
            var _modelController:IRoomObjectModelController;
            super.initialize(_model);

            if (_model == null)
            {
                return;
            };

            var _credits:XMLList = _model.credits;

            if (_credits.length() == 0)
            {
                return;
            };

            var _creditValue:Number = Number(_credits[0].@value);

            if (object != null)
            {
                _modelController = object.getModelController();

                if (_modelController != null)
                {
                    _modelController.setNumber("furniture_credit_value", _creditValue);
                };
            };
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
                _widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE__CREDITFURNI", object);
                eventDispatcher.dispatchEvent(_widgetRequestEvent);
            };

            super.useObject();
        }

    }
}