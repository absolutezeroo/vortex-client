package com.sulake.core.utils.debug
{
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.Dictionary;

    public class GarbageMonitor implements IDisposable 
    {

        private var _disposed:Boolean = false;
        private var _dict:Dictionary;

        public function GarbageMonitor()
        {
            _dict = new Dictionary(true);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                for each (var _local_1:Object in _dict)
                {
                    delete _dict[_local_1];
                };

                _dict = null;
                _disposed = true;
            };
        }

        public function insert(_arg_1:Object, _arg_2:String=null):void
        {
            _dict[_arg_1] = ((_arg_2 == null) ? _arg_1.toString() : _arg_2);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get list():Array
        {
            var _local_1:Array = [];

            for each (var _local_2:Object in _dict)
            {
                _local_1.push(_local_2);
            };

            return (_local_1);
        }

    }
}
