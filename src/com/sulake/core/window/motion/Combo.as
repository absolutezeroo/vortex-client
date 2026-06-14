package com.sulake.core.window.motion
{
    import __AS3__.vec.Vector;

    use namespace friend;

    public class Combo extends Motion 
    {

        private var _runningMotions:Vector.<Motion> = new Vector.<Motion>();
        private var _removedMotions:Vector.<Motion> = new Vector.<Motion>();

        public function Combo(... _args)
        {
            for each (var _local_2:Motion in _args)
            {
                _runningMotions.push(_local_2);
            };

            super(((_runningMotions.length > 0) ? _runningMotions[0].target : null));
        }

        override friend function start():void
        {
            super.friend::start();

            for each (var _local_1:Motion in _runningMotions)
            {
                _local_1.friend::start();
            };
        }

        override friend function tick(_arg_1:int):void
        {
            var _local_2:Motion;
            super.friend::tick(_arg_1);

            while ((_local_2 = _removedMotions.pop()) != null)
            {
                _runningMotions.splice(_removedMotions.indexOf(_local_2), 1);

                if (_local_2.running)
                {
                    _local_2.friend::stop();
                };
            };

            for each (_local_2 in _runningMotions)
            {
                if (_local_2.running)
                {
                    _local_2.friend::tick(_arg_1);
                };

                if (_local_2.complete)
                {
                    _removedMotions.push(_local_2);
                };
            };

            if (_runningMotions.length > 0)
            {
                for each (_local_2 in _runningMotions)
                {
                    _SafeStr_1138 = _local_2.target;

                    if (((_SafeStr_1138) && (!(_SafeStr_1138.disposed)))) break;
                };

                _SafeStr_1139 = false;
            }

            else
            {
                _SafeStr_1139 = true;
            };
        }

    }
}
