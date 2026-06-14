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

        override public function processUpdateMessage(_arg_1:RoomObjectUpdateMessage):void
        {
            if (_arg_1 == null)
            {
                return;
            };

            var _local_2:RoomObjectDataUpdateMessage = (_arg_1 as RoomObjectDataUpdateMessage);

            if (_local_2 != null)
            {
                handleDataUpdateMessage(_local_2);
                return;
            };

            super.processUpdateMessage(_arg_1);
        }

        private function handleDataUpdateMessage(_arg_1:RoomObjectDataUpdateMessage):void
        {
            var _local_3:LegacyStuffData;
            var _local_4:int = int((_arg_1.state / 1000));
            var _local_2:int = (_arg_1.state % 1000);

            if (_local_2 == 0)
            {
                _nextStateTimeStamp = 0;
                _local_3 = new LegacyStuffData();
                _local_3.setString(String(_local_4));
                _arg_1 = new RoomObjectDataUpdateMessage(_local_4, _local_3, _arg_1.extra);
                super.processUpdateMessage(_arg_1);
            }

            else
            {
                _nextState = _local_4;
                _nextStateExtra = _arg_1.extra;
                _nextStateTimeStamp = (lastUpdateTime + _local_2);
            };
        }

        override public function update(_arg_1:int):void
        {
            var _local_2:LegacyStuffData;
            var _local_3:RoomObjectDataUpdateMessage;

            if (((_nextStateTimeStamp > 0) && (_arg_1 >= _nextStateTimeStamp)))
            {
                _nextStateTimeStamp = 0;
                _local_2 = new LegacyStuffData();
                _local_2.setString(String(_nextState));
                _local_3 = new RoomObjectDataUpdateMessage(_nextState, _local_2, _nextStateExtra);
                super.processUpdateMessage(_local_3);
            };

            super.update(_arg_1);
        }

    }
}