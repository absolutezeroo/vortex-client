package com.sulake.room.utils
{
    import flash.utils.getTimer;

    public class RoomEnterEffect 
    {

        public static const STATE_NOT_INITIALIZED:int = 0;
        public static const STATE_START_DELAY:int = 1;
        public static const STATE_RUNNING:int = 2;
        public static const STATE_OVER:int = 3;

        private static var _state:int = 0;
        private static var _isVisible:Boolean = false;
        private static var _delta:Number;
        private static var _startTime:int = 0;
        private static var _startDelay:int = 20000;
        private static var _duration:int = 2000;

        public static function init(startDelay:int, duration:int):void
        {
            _delta = 0;
            _startDelay = startDelay;
            _duration = duration;
            _startTime = getTimer();
            _state = 1;
        }

        public static function turnVisualizationOn():void
        {
            if (((_state == 0) || (_state == 3)))
            {
                return;
            };

            var elapsed:int = (getTimer() - _startTime);

            if (elapsed > (_startDelay + _duration))
            {
                _state = 3;
                return;
            };

            _isVisible = true;

            if (elapsed < _startDelay)
            {
                _state = 1;
                return;
            };

            _state = 2;
            _delta = ((elapsed - _startDelay) / _duration);
        }

        public static function turnVisualizationOff():void
        {
            _isVisible = false;
        }

        public static function isVisualizationOn():Boolean
        {
            return ((_isVisible) && (isRunning()));
        }

        public static function isRunning():Boolean
        {
            if (((_state == 1) || (_state == 2)))
            {
                return (true);
            };

            return (false);
        }

        public static function getDelta(min:Number=0, max:Number=1):Number
        {
            return (Math.min(Math.max(_delta, min), max));
        }

        public static function get totalRunningTime():int
        {
            return (_startDelay + _duration);
        }

    }
}

