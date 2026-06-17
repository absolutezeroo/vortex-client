package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.IStuffData;

    public class RoomObjectDataUpdateMessage extends RoomObjectUpdateMessage 
    {

        private var _state:int;
        private var _data:IStuffData = null;
        private var _extra:Number = NaN;

        public function RoomObjectDataUpdateMessage(state:int, data:IStuffData, extra:Number=NaN)
        {
            super(null, null);
            _state = state;
            _data = data;
            _extra = extra;
        }

        public function get state():int
        {
            return (_state);
        }

        public function get data():IStuffData
        {
            return (_data);
        }

        public function get extra():Number
        {
            return (_extra);
        }

    }
}