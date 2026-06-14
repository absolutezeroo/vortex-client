package com.sulake.habbo.tracking
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import flash.utils.getTimer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.LatencyPingRequestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.LatencyPingReportMessageComposer;
    import com.sulake.habbo.communication.messages.parser.tracking.LatencyPingResponseMessageParser;
    import com.sulake.habbo.communication.messages.parser.tracking.LatencyPingResponseMessageEvent;

    public class LatencyTracker implements IDisposable 
    {

        private var _state:Boolean = false;
        private var _testId:int = 0;
        private var _testInterval:int = 0;
        private var _reportIndex:int = 0;
        private var _reportDelta:int = 0;
        private var _lastTestTime:int = 0;
        private var _lastReportedLatency:int = 0;
        private var _latencyValues:Array;
        private var _timeStampMap:Map;
        private var _habboTracking:HabboTracking;

        public function LatencyTracker(_arg_1:HabboTracking)
        {
            _habboTracking = _arg_1;
        }

        public function dispose():void
        {
            if (disposed)
            {
                return;
            };

            _state = false;

            if (_timeStampMap != null)
            {
                _timeStampMap.dispose();
                _timeStampMap = null;
            };

            _latencyValues = null;
            _habboTracking = null;
        }

        public function init():void
        {
            _testInterval = _habboTracking.getInteger("latencytest.interval", 20000);
            _reportIndex = _habboTracking.getInteger("latencytest.report.index", 100);
            _reportDelta = _habboTracking.getInteger("latencytest.report.delta", 3);

            if (_testInterval < 1)
            {
                return;
            };

            _timeStampMap = new Map();
            _latencyValues = [];
            _state = true;
        }

        public function update(_arg_1:uint, _arg_2:int):void
        {
            if (!_state)
            {
                return;
            };

            if ((_arg_2 - _lastTestTime) > _testInterval)
            {
                testLatency();
            };
        }

        private function testLatency():void
        {
            _lastTestTime = getTimer();
            _timeStampMap.add(_testId, _lastTestTime);
            _habboTracking.send(new LatencyPingRequestMessageComposer(_testId));
            _testId++;
        }

        public function onPingResponse(_arg_1:LatencyPingResponseMessageEvent):void
        {
            var _local_7:int;
            var _local_2:int;
            var _local_10:int;
            var _local_8:int;
            var _local_5:int;
            var _local_3:int;
            var _local_11:LatencyPingReportMessageComposer;

            if (((_timeStampMap == null) || (_latencyValues == null)))
            {
                return;
            };

            var _local_4:LatencyPingResponseMessageParser = _arg_1.getParser();
            var _local_9:int = _timeStampMap.getValue(_local_4.requestId);
            _timeStampMap.remove(_local_4.requestId);

            var _local_6:int = (getTimer() - _local_9);
            _latencyValues.push(_local_6);

            if (((_latencyValues.length == _reportIndex) && (_reportIndex > 0)))
            {
                _local_7 = 0;
                _local_2 = 0;
                _local_10 = 0;
                _local_8 = 0;

                while (_local_8 < _latencyValues.length)
                {
                    _local_7 = (_local_7 + _latencyValues[_local_8]);
                    _local_8++;
                };

                _local_5 = int((_local_7 / _latencyValues.length));
                _local_8 = 0;

                while (_local_8 < _latencyValues.length)
                {
                    if (_latencyValues[_local_8] < (_local_5 * 2))
                    {
                        _local_2 = (_local_2 + _latencyValues[_local_8]);
                        _local_10++;
                    };

                    _local_8++;
                };

                if (_local_10 == 0)
                {
                    _latencyValues = [];
                    return;
                };

                _local_3 = int((_local_2 / _local_10));

                if (((Math.abs((_local_5 - _lastReportedLatency)) > _reportDelta) || (_lastReportedLatency == 0)))
                {
                    _lastReportedLatency = _local_5;
                    _local_11 = new LatencyPingReportMessageComposer(_local_5, _local_3, _latencyValues.length);
                    _habboTracking.send(_local_11);
                };

                _latencyValues = [];
            };
        }

        public function get disposed():Boolean
        {
            return (_habboTracking == null);
        }

    }
}
