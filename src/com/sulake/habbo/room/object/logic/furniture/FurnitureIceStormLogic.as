package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.LegacyStuffData;

    public class FurnitureIceStormLogic extends FurnitureMultiStateLogic
    {

        private var _nextState:int = 0;
        private var _nextStateExtra:Number = 0;
        private var _nextStateTimeStamp:int = 0;

        override public function processUpdateMessage(_arg_updateMessage:RoomObjectUpdateMessage):void
        {
            if (_arg_updateMessage == null)
            {
                return;
            };

            var dataUpdateMessage:RoomObjectDataUpdateMessage = (_arg_updateMessage as RoomObjectDataUpdateMessage);

            if (dataUpdateMessage != null)
            {
                handleDataUpdateMessage(dataUpdateMessage);
                return;
            };

            super.processUpdateMessage(_arg_updateMessage);
        }

        private function handleDataUpdateMessage(_arg_dataUpdateMessage:RoomObjectDataUpdateMessage):void
        {
            var legacyStuffData:LegacyStuffData;
            var state:int = int((_arg_dataUpdateMessage.state / 1000));
            var delay:int = (_arg_dataUpdateMessage.state % 1000);

            if (delay == 0)
            {
                _nextStateTimeStamp = 0;
                legacyStuffData = new LegacyStuffData();
                legacyStuffData.setString(String(state));
                _arg_dataUpdateMessage = new RoomObjectDataUpdateMessage(state, legacyStuffData, _arg_dataUpdateMessage.extra);
                super.processUpdateMessage(_arg_dataUpdateMessage);
            }

            else
            {
                _nextState = state;
                _nextStateExtra = _arg_dataUpdateMessage.extra;
                _nextStateTimeStamp = (lastUpdateTime + delay);
            };
        }

        override public function update(_arg_time:int):void
        {
            var legacyStuffData:LegacyStuffData;
            var dataUpdateMessage:RoomObjectDataUpdateMessage;

            if (((_nextStateTimeStamp > 0) && (_arg_time >= _nextStateTimeStamp)))
            {
                _nextStateTimeStamp = 0;
                legacyStuffData = new LegacyStuffData();
                legacyStuffData.setString(String(_nextState));
                dataUpdateMessage = new RoomObjectDataUpdateMessage(_nextState, legacyStuffData, _nextStateExtra);
                super.processUpdateMessage(dataUpdateMessage);
            };

            super.update(_arg_time);
        }

    }
}