package com.sulake.core.window.motion
{
    import flash.utils.getTimer;

    use namespace friend;

    public class Wait extends Motion 
    {

        private var _startTimeMs:int;
        private var _waitTimeMs:int;

        public function Wait(_arg_1:int)
        {
            super(null);
            _waitTimeMs = _arg_1;
        }

        override public function get running():Boolean
        {
            return (_SafeStr_801);
        }

        override friend function start():void
        {
            super.friend::start();
            _SafeStr_1139 = false;
            _startTimeMs = getTimer();
        }

        override friend function tick(_arg_1:int):void
        {
            _SafeStr_1139 = ((_arg_1 - _startTimeMs) >= _waitTimeMs);

            if (_SafeStr_1139)
            {
                friend::stop();
            };

            super.friend::tick(_arg_1);
        }

    }
}
