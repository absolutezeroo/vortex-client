package com.sulake.core.runtime.events
{
    public class ErrorEvent extends WarningEvent 
    {

        protected var _SafeStr_826:int;
        protected var _SafeStr_827:Boolean;
        protected var _SafeStr_828:Error;

        public function ErrorEvent(type:String, message:String, critical:Boolean, category:int, error:Error=null)
        {
            _SafeStr_827 = critical;
            _SafeStr_826 = category;
            _SafeStr_828 = error;
            super(type, message);
        }

        public function get category():int
        {
            return (_SafeStr_826);
        }

        public function get critical():Boolean
        {
            return (_SafeStr_827);
        }

        public function get error():Error
        {
            return (_SafeStr_828);
        }

    }
}
