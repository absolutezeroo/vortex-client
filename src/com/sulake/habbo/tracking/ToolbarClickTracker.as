package com.sulake.habbo.tracking
{
    public class ToolbarClickTracker 
    {

        private var _tracking:HabboTracking;
        private var _eventCount:int = 0;

        public function ToolbarClickTracker(_arg_1:HabboTracking)
        {
            _tracking = _arg_1;
        }

        public function track(_arg_1:String):void
        {
            if (!_tracking.getBoolean("toolbar.tracking.enabled"))
            {
                return;
            };

            _eventCount++;

            if (_eventCount <= _tracking.getInteger("toolbar.tracking.max.events", 100))
            {
                _tracking.trackGoogle("toolbar", _arg_1);
            };
        }

    }
}
