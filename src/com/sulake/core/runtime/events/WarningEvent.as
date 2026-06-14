package com.sulake.core.runtime.events
{
    import flash.events.Event;

    public class WarningEvent extends Event 
    {

        protected var _SafeStr_835:String;

        public function WarningEvent(type:String, message:String)
        {
            _SafeStr_835 = ((message == null) ? "undefined" : message);
            super(type);
        }

        public function get message():String
        {
            return (_SafeStr_835);
        }

    }
}
