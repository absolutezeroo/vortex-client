package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

    public class FurnitureFriendFurniLogic extends FurnitureMultiStateLogic 
    {

        private static const STATE_UNINITIALIZED:int = -1;
        private static const STATE_UNLOCKED:int = 0;
        private static const STATE_LOCKED:int = 1;

        private var _state:int = -1;

        protected function get engravingDialogType():int
        {
            return (0);
        }

        override public function get contextMenu():String
        {
            return ((_state == 0) ? "FRIEND_FURNITURE" : "DUMMY");
        }

        override public function getEventTypes():Array
        {
            return (getAllEventTypes(super.getEventTypes(), ["ROWRE_FRIEND_FURNITURE_ENGRAVING"]));
        }

        override public function initialize(_arg_xml:XML):void
        {
            super.initialize(_arg_xml);
            object.getModelController().setNumber("furniture_friendfurni_engraving_type", engravingDialogType);
        }

        override public function processUpdateMessage(_arg_updateMessage:RoomObjectUpdateMessage):void
        {
            var stringArrayStuffData:StringArrayStuffData;
            var dataUpdateMessage:RoomObjectDataUpdateMessage = (_arg_updateMessage as RoomObjectDataUpdateMessage);

            if (dataUpdateMessage != null)
            {
                stringArrayStuffData = (dataUpdateMessage.data as StringArrayStuffData);

                if (stringArrayStuffData != null)
                {
                    _state = stringArrayStuffData.state;
                }

                else
                {
                    _state = dataUpdateMessage.state;
                };
            };

            super.processUpdateMessage(_arg_updateMessage);
        }

        override public function useObject():void
        {
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                if (_state == 1)
                {
                    eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent("ROWRE_FRIEND_FURNITURE_ENGRAVING", object));
                }

                else
                {
                    super.useObject();
                };
            };
        }

    }
}
