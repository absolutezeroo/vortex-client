package com.sulake.habbo.tracking
{
    public class FramerateTracker 
    {

        private var _lastReport:int;
        private var _updateCounter:int;
        private var _averageUpdateInterval:Number;
        private var _eventCounter:int;
        private var _habboTracking:HabboTracking;

        public function FramerateTracker(_arg_1:HabboTracking)
        {
            _habboTracking = _arg_1;
        }

        public function get frameRate():int
        {
            return (Math.round((1000 / _averageUpdateInterval)));
        }

        public function trackUpdate(_arg_1:uint, _arg_2:int):void
        {
            var _local_3:Number;
            _updateCounter++;

            if (_updateCounter == 1)
            {
                _averageUpdateInterval = _arg_1;
                _lastReport = _arg_2;
            }

            else
            {
                _local_3 = _updateCounter;
                _averageUpdateInterval = (((_averageUpdateInterval * (_local_3 - 1)) / _local_3) + (_arg_1 / _local_3));
            };

            if ((_arg_2 - _lastReport) >= (_habboTracking.getInteger("tracking.framerate.reportInterval.seconds", 300) * 1000))
            {
                _updateCounter = 0;

                if (_eventCounter < _habboTracking.getInteger("tracking.framerate.maximumEvents", 5))
                {
                    _habboTracking.trackGoogle("performance", "averageFramerate", frameRate);
                    _eventCounter++;
                    _lastReport = _arg_2;
                };
            };
        }

    }
}
