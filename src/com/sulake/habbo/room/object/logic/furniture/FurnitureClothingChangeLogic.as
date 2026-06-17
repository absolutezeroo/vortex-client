package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurnitureClothingChangeLogic extends FurnitureLogic 
    {

        override public function getEventTypes():Array
        {
            var _eventTypes:Array = ["ROWRE_CLOTHING_CHANGE"];
            return (getAllEventTypes(super.getEventTypes(), _eventTypes));
        }

        override public function initialize(_model:XML):void
        {
            super.initialize(_model);

            if (((object == null) || (object.getModel() == null)))
            {
                return;
            };

            var _clothingData:String = object.getModel().getString("furniture_data");
            updateClothingData(_clothingData);
        }

        override public function processUpdateMessage(_message:RoomObjectUpdateMessage):void
        {
            var _stuffData:IStuffData;
            super.processUpdateMessage(_message);

            var _dataUpdateMessage:RoomObjectDataUpdateMessage = (_message as RoomObjectDataUpdateMessage);

            if (_dataUpdateMessage != null)
            {
                _stuffData = _dataUpdateMessage.data;

                if (_stuffData != null)
                {
                    updateClothingData(_stuffData.getLegacyString());
                };
            };
        }

        private function updateClothingData(_clothingData:String):void
        {
            var _clothingParts:Array;

            if (((!(_clothingData == null)) && (_clothingData.length > 0)))
            {
                _clothingParts = _clothingData.split(",");

                if (_clothingParts.length > 0)
                {
                    object.getModelController().setString("furniture_clothing_boy", _clothingParts[0]);
                };

                if (_clothingParts.length > 1)
                {
                    object.getModelController().setString("furniture_clothing_girl", _clothingParts[1]);
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
                _widgetRequestEvent = new RoomObjectWidgetRequestEvent("ROWRE_CLOTHING_CHANGE", object);
                eventDispatcher.dispatchEvent(_widgetRequestEvent);
            };
        }

    }
}