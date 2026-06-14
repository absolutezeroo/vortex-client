package com.sulake.core.utils.profiler
{
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.getTimer;

    public class ProfilerAgentTask implements IDisposable 
    {

        private var _name:String;
        private var _rounds:uint;
        private var _total:int;
        private var _latest:int;
        private var _average:Number;
        private var _caption:String;
        private var _running:Boolean;
        private var _disposed:Boolean = false;
        private var _children:Array;
        private var _startTime:uint;
        private var _paused:Boolean = false;

        public function ProfilerAgentTask(name:String, caption:String="")
        {
            _name = name;
            _rounds = 0;
            _average = 0;
            _running = false;
            _children = [];
            _caption = caption;
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _disposed = true;
            };
        }

        public function start():void
        {
            if (!_running)
            {
                _startTime = getTimer();
                _running = true;
            };
        }

        public function stop():void
        {
            if (_running)
            {
                _latest = (getTimer() - _startTime);
                _rounds++;
                _total = (_total + _latest);
                _average = (_total / _rounds);
                _running = false;
            };
        }

        public function get name():String
        {
            return (_name);
        }

        public function get rounds():uint
        {
            return (_rounds);
        }

        public function get total():int
        {
            return (_total);
        }

        public function get latest():int
        {
            return (_latest);
        }

        public function get average():Number
        {
            return (_average);
        }

        public function get caption():String
        {
            return (_caption);
        }

        public function set caption(caption:String):void
        {
            _caption = caption;
        }

        public function get running():Boolean
        {
            return (_running);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get paused():Boolean
        {
            return (_paused);
        }

        public function set paused(paused:Boolean):void
        {
            _paused = paused;
        }

        public function get numSubTasks():uint
        {
            return (_children.length);
        }

        public function addSubTask(subTask:ProfilerAgentTask):void
        {
            if (getSubTaskByName(subTask.name) != null)
            {
                throw (new Error((('Component profiler task with name "' + subTask.name) + '" already exists!')));
            };

            _children.push(subTask);
        }

        public function removeSubTask(_arg_1:ProfilerAgentTask):ProfilerAgentTask
        {
            var _local_2:int = _children.indexOf(_arg_1);

            if (_local_2 > -1)
            {
                _children.splice(_local_2, 1);
            };

            return (_arg_1);
        }

        public function getSubTaskAt(_arg_1:uint):ProfilerAgentTask
        {
            return (_children[_arg_1] as ProfilerAgentTask);
        }

        public function getSubTaskByName(name:String):ProfilerAgentTask
        {
            var _local_2:ProfilerAgentTask;
            var _local_3:uint = _children.length;
            var _local_4:uint;

            while (_local_4 < _local_3)
            {
                _local_2 = (_children[_local_4++] as ProfilerAgentTask);

                if (_local_2.name == name)
                {
                    return (_local_2);
                };
            };

            return (null);
        }

    }
}