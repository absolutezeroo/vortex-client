package com.sulake.habbo.room.events
{
    public class RoomEngineDimmerStateEvent extends RoomEngineEvent 
    {

        public static const _SafeStr_3155:String = "REDSE_ROOM_COLOR";

        private var _state:int;
        private var _presetId:int;
        private var _effectId:int;
        private var _color:uint;
        private var _brightness:int;

        public function RoomEngineDimmerStateEvent(roomId:int, state:int, presetId:int, effectId:int, color:uint, brightness:uint, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super("REDSE_ROOM_COLOR", roomId, bubbles, cancelable);
            _state = state;
            _presetId = presetId;
            _effectId = effectId;
            _color = color;
            _brightness = brightness;
        }

        public function get state():int
        {
            return (_state);
        }

        public function get presetId():int
        {
            return (_presetId);
        }

        public function get effectId():int
        {
            return (_effectId);
        }

        public function get color():uint
        {
            return (_color);
        }

        public function get brightness():uint
        {
            return (_brightness);
        }

    }
}
