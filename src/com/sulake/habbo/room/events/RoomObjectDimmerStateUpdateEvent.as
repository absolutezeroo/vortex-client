package com.sulake.habbo.room.events
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectDimmerStateUpdateEvent extends RoomObjectEvent 
    {

        public static const _SafeStr_3155:String = "RODSUE_DIMMER_STATE";

        private var _state:int;
        private var _presetId:int;
        private var _effectId:int;
        private var _color:uint;
        private var _brightness:int;

        public function RoomObjectDimmerStateUpdateEvent(roomObject:IRoomObject, state:int, presetId:int, effectId:int, color:uint, brightness:int, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super("RODSUE_DIMMER_STATE", roomObject, bubbles, cancelable);
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
