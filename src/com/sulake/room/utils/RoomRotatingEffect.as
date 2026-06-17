package com.sulake.room.utils
{
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import flash.events.TimerEvent;

    public class RoomRotatingEffect 
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
        private static var _duration:int = 5000;
        private static var _hideTimer:Timer;

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

            if (((_hideTimer == null) || (!(_hideTimer.running))))
            {
                _hideTimer = new Timer(_duration, 1);
                _hideTimer.addEventListener("timerComplete", turnVisualizationOff);
                _hideTimer.start();
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

        public static function turnVisualizationOff(_event:TimerEvent):void
        {
            _isVisible = false;
            if (_hideTimer != null)
            {
                _hideTimer.stop();
                _hideTimer.removeEventListener("timerComplete", turnVisualizationOff);
                _hideTimer = null;
            };
        }

        public static function isVisualizationOn():Boolean
        {
            return ((_isVisible) && (isRunning()));
        }

        private static function isRunning():Boolean
        {
            if (((_state == 1) || (_state == 2)))
            {
                return (true);
            };

            return (false);
        }

    }
}

