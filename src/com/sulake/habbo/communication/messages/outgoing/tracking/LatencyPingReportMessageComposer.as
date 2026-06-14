package com.sulake.habbo.communication.messages.outgoing.tracking
{
    import com.sulake.core.communication.messages.IMessageComposer;

        public class LatencyPingReportMessageComposer implements IMessageComposer 
    {

        private var _averagePing:int;
        private var _clearedAveragePing:int;
        private var _pingCount:int;

        public function LatencyPingReportMessageComposer(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            _averagePing = _arg_1;
            _clearedAveragePing = _arg_2;
            _pingCount = _arg_3;
        }

        public function getMessageArray():Array
        {
            return ([_averagePing, _clearedAveragePing, _pingCount]);
        }

        public function dispose():void
        {
        }

    }
}
