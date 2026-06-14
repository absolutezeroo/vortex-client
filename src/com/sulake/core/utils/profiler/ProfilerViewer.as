package com.sulake.core.utils.profiler
{
    import flash.text.TextField;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IProfiler;
    import flash.text.TextFormat;

    public class ProfilerViewer extends TextField implements IDisposable
    {

        protected var _disposed:Boolean = false;
        private var _profiler:IProfiler;

        public function ProfilerViewer(_arg_1:IProfiler)
        {
            var _local_2:TextFormat = new TextFormat("Courier New", 8);
            defaultTextFormat = _local_2;
            setTextFormat(_local_2);
            textColor = 0xFFFFFF;
            width = 10;
            height = 10;
            autoSize = "left";
            mouseEnabled = false;
            selectable = false;
            super();

            if (_arg_1)
            {
                _profiler = _arg_1;
                _profiler.addStopEventListener(refresh);
            };
        }

        private static function padAlign(_arg_1:String, _arg_2:int, _arg_3:String=" ", _arg_4:Boolean=false):String
        {
            var _local_6:int;
            var _local_5:int = (_arg_2 - _arg_1.length);

            if (_local_5 <= 0)
            {
                return (_arg_1.substring(0, _arg_2));
            };

            var _local_7:String = "";
            _local_6 = 0;

            while (_local_6 < _local_5)
            {
                _local_7 = (_local_7 + _arg_3);
                _local_6++;
            };

            return ((_arg_4) ? (_local_7 + _arg_1) : (_arg_1 + _local_7));
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function set profiler(_arg_1:IProfiler):void
        {
            if (((!(_profiler)) && (_arg_1)))
            {
                _profiler = _arg_1;
                _profiler.addStopEventListener(refresh);
            };
        }

        public function get profiler():IProfiler
        {
            return (_profiler);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                if (parent != null)
                {
                    parent.removeChild(this);
                };

                if (_profiler)
                {
                    _profiler.removeStopEventListener(refresh);
                    _profiler = null;
                };

                _disposed = true;
            };
        }

        public function refresh():void
        {
            text = (((((((((((((((((((padAlign("task", 30) + "|") + padAlign("#rounds", 10, " ", true)) + "|") + padAlign("latest ms", 10, " ", true)) + "|") + padAlign("average ms", 10, " ", true)) + "|") + padAlign("total ms", 10, " ", true)) + "|\r") + padAlign("", 30, "-")) + "|") + padAlign("", 10, "-")) + "|") + padAlign("", 10, "-")) + "|") + padAlign("", 10, "-")) + "|") + padAlign("", 10, "-")) + "|\r");

            var _local_1:Array = _profiler.getProfilerAgentsInArray();

            while (_local_1.length > 0)
            {
                recursiveUpdate(_local_1.pop(), 0);
            };

            if (parent)
            {
                parent.swapChildren(this, parent.getChildAt((parent.numChildren - 1)));
            };
        }

        private function recursiveUpdate(task:ProfilerAgentTask, taskNumber:uint):void
        {
            var _local_3:uint;
            text = (text + (((((((((padAlign(task.name, 30) + "|") + padAlign(String(task.rounds), 10)) + "|") + padAlign(String(task.latest), 10)) + "|") + padAlign(String(task.average), 10)) + "|") + padAlign(String(task.total), 10)) + "|\r"));
            _local_3 = 0;

            while (_local_3 < task.numSubTasks)
            {
                recursiveUpdate(task.getSubTaskAt(_local_3), (taskNumber + 1));
                _local_3++;
            };
        }

    }
}
