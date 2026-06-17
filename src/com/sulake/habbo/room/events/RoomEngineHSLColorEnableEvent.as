package com.sulake.habbo.room.events
{
    public class RoomEngineHSLColorEnableEvent extends RoomEngineEvent 
    {

        public static const ROOM_BACKGROUND_COLOR:String = "ROHSLCEE_ROOM_BACKGROUND_COLOR";

        private var _enable:Boolean;
        private var _hue:int;
        private var _saturation:int;
        private var _lightness:int;

        public function RoomEngineHSLColorEnableEvent(type:String, roomId:int, enable:Boolean, hue:int, saturation:int, lightness:int, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, roomId, bubbles, cancelable);
            _enable = enable;
            _hue = hue;
            _saturation = saturation;
            _lightness = lightness;
        }

        public function get enable():Boolean
        {
            return (_enable);
        }

        public function get hue():int
        {
            return (_hue);
        }

        public function get saturation():int
        {
            return (_saturation);
        }

        public function get lightness():int
        {
            return (_lightness);
        }

    }
}