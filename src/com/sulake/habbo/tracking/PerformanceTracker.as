package com.sulake.habbo.tracking
{
    import com.sulake.core.utils.debug.GarbageMonitor;
    import flash.system.Capabilities;
    import flash.external.ExternalInterface;
    import flash.utils.getTimer;
    import flash.system.System;
    import com.sulake.habbo.communication.messages.outgoing.tracking.PerformanceLogMessageComposer;

    public class PerformanceTracker
    {

        private var _counter:int = 0;
        private var _averageUpdateInterval:Number = 0;
        private var _userAgent:String = "";
        private var _flashVersion:String = "";
        private var _operatingSystem:String = "";
        private var _cpuArchitecture:String = "";
        private var _isDebugger:Boolean = false;
        private var _garbageMonitor:GarbageMonitor = null;
        private var _gcCount:int = 0;
        private var _slowUpdateCount:int = 0;
        private var _lastReport:int = 0;
        private var _reportCount:int = 0;
        private var _lastAverage:Number = 0;
        private var _habboTracking:HabboTracking;

        public function PerformanceTracker(_arg_1:HabboTracking)
        {
            _habboTracking = _arg_1;
            _flashVersion = Capabilities.version;
            _operatingSystem = Capabilities.os;
            _isDebugger = Capabilities.isDebugger;
            try
            {
                _userAgent = ((ExternalInterface.available) ? ExternalInterface.call("window.navigator.userAgent.toString") : "unknown");
            }

            catch(e:Error)
            {
            };

            if (_userAgent == null)
            {
                _userAgent = "unknown";
            };

            _garbageMonitor = new GarbageMonitor();
            updateGarbageMonitor();
            _lastReport = getTimer();
        }

        private static function differenceInPercents(_arg_1:Number, _arg_2:Number):Number
        {
            if (_arg_1 == _arg_2)
            {
                return (0);
            };

            var _local_4:Number = _arg_1;
            var _local_3:Number = _arg_2;

            if (_arg_2 > _arg_1)
            {
                _local_4 = _arg_2;
                _local_3 = _arg_1;
            };

            return (100 * (1 - (_local_3 / _local_4)));
        }

        public function get flashVersion():String
        {
            return (_flashVersion);
        }

        public function get averageUpdateInterval():int
        {
            return (_averageUpdateInterval);
        }

        private function updateGarbageMonitor():Object
        {
            var _local_2:Object;
            var _local_1:Array = _garbageMonitor.list;

            if (((_local_1 == null) || (_local_1.length == 0)))
            {
                _local_2 = new GarbageTester("tester");
                _garbageMonitor.insert(_local_2, "tester");
                return (_local_2);
            };

            return (null);
        }

        public function update(_arg_1:uint, _arg_2:int):void
        {
            var _local_7:Object;
            var _local_3:Number;
            var _local_4:uint;
            var _local_6:Boolean;
            var _local_5:Number;

            if (isGarbageMonitored)
            {
                _local_7 = updateGarbageMonitor();

                if (_local_7 != null)
                {
                    _gcCount++;
                    Logger.log("Garbage collection");
                };
            };

            var _local_8:Boolean;

            if (_arg_1 > slowUpdateLimit)
            {
                _slowUpdateCount++;
                _local_8 = true;
            }

            else
            {
                _counter++;

                if (_counter <= 1)
                {
                    _averageUpdateInterval = _arg_1;
                }

                else
                {
                    _local_3 = _counter;
                    _averageUpdateInterval = (((_averageUpdateInterval * (_local_3 - 1)) / _local_3) + (_arg_1 / _local_3));
                };
            };

            if ((((_arg_2 - _lastReport) > (reportInterval * 1000)) && (_reportCount < reportLimit)))
            {
                _local_4 = System.totalMemory;
                Logger.log((((("*** Performance tracker: average frame rate " + (1000 / _averageUpdateInterval)) + "/s, system memory usage : ") + _local_4) + " bytes"));
                _local_6 = true;

                if (((useDistribution) && (_reportCount > 0)))
                {
                    _local_5 = differenceInPercents(_lastAverage, _averageUpdateInterval);

                    if (_local_5 < meanDevianceLimit)
                    {
                        _local_6 = false;
                    };
                };

                _lastReport = _arg_2;

                if (((_local_6) || (_local_8)))
                {
                    _lastAverage = _averageUpdateInterval;
                    sendReport(_arg_2);
                    _reportCount++;
                };
            };
        }

        private function sendReport(_arg_1:int):void
        {
            var _local_4:int = int((_arg_1 / 1000));
            var _local_3:int = -1;
            var _local_2:int = int((System.totalMemory / 0x0400));
            _habboTracking.send(new PerformanceLogMessageComposer(_local_4, _userAgent, _flashVersion, _operatingSystem, _cpuArchitecture, _isDebugger, _local_2, _local_3, _gcCount, _averageUpdateInterval, _slowUpdateCount));
            _gcCount = 0;
            _averageUpdateInterval = 0;
            _counter = 0;
            _slowUpdateCount = 0;
        }

        private function get isGarbageMonitored():Boolean
        {
            return (_habboTracking.getBoolean("monitor.garbage.collection"));
        }

        private function get slowUpdateLimit():int
        {
            return (_habboTracking.getInteger("performancetest.slowupdatelimit", 1000));
        }

        private function get reportInterval():int
        {
            return (_habboTracking.getInteger("performancetest.interval", 60));
        }

        private function get reportLimit():int
        {
            return (_habboTracking.getInteger("performancetest.reportlimit", 10));
        }

        private function get meanDevianceLimit():Number
        {
            return ((_habboTracking.propertyExists("performancetest.distribution.deviancelimit.percent")) ? Number(_habboTracking.getProperty("performancetest.distribution.deviancelimit.percent")) : 10);
        }

        private function get useDistribution():Boolean
        {
            return (_habboTracking.getBoolean("performancetest.distribution.enabled"));
        }

    }
}