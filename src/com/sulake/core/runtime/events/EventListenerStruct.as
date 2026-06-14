package com.sulake.core.runtime.events
{
    import flash.utils.Dictionary;

    public class EventListenerStruct 
    {

        private var _dictionary:Dictionary;
        public var useCapture:Boolean;
        public var priority:int;
        public var useWeakReference:Boolean;

        public function EventListenerStruct(callback:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false)
        {
            _dictionary = new Dictionary(useWeakReference);
            this.callback = callback;
            this.useCapture = useCapture;
            this.priority = priority;
            this.useWeakReference = useWeakReference;
        }

        public function set callback(callback:Function):void
        {
            for (var _local_2:Object in _dictionary)
            {
                delete _dictionary[_local_2];
            };

            _dictionary[callback] = null;
        }

        public function get callback():Function
        {
            for (var _local_1:Object in _dictionary)
            {
                return (_local_1 as Function);
            };

            return (null);
        }

    }
}
