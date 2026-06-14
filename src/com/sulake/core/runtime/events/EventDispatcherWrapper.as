package com.sulake.core.runtime.events
{
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.IDisposable;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import com.sulake.core.Core;
    import flash.utils.getQualifiedClassName;
    import flash.events.Event;

        public class EventDispatcherWrapper implements IEventDispatcher, IDisposable 
    {

        private static const _SafeStr_829:uint = 0;
        private static const _SafeStr_830:uint = 1;
        private static const _SafeStr_831:uint = 2;

        protected var _disposed:Boolean = false;
        private var _eventDispatcher:EventDispatcher;
        private var _eventListenerTable:Dictionary = new Dictionary();
        private var _result:uint;
        private var _error:Error;

        public function EventDispatcherWrapper(parent:IEventDispatcher=null)
        {
            _eventDispatcher = new EventDispatcher(((parent) ? parent : this));
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get error():Error
        {
            return (_error);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            var _local_8:Array = _eventListenerTable[_arg_1];
            var _local_6:EventListenerStruct = new EventListenerStruct(_arg_2, _arg_3, _arg_4, _arg_5);

            if (!_local_8)
            {
                _local_8 = [_local_6];
                _eventListenerTable[_arg_1] = _local_8;
                _eventDispatcher.addEventListener(_arg_1, eventProcessor);
            }

            else
            {
                for each (var _local_7:EventListenerStruct in _local_8)
                {
                    if (((_local_7.callback == _arg_2) && (_local_7.useCapture == _arg_3)))
                    {
                        return;
                    };

                    if (_arg_4 > _local_7.priority)
                    {
                        _local_8.splice(_local_8.indexOf(_local_7), 0, _local_6);
                        return;
                    };
                };

                _local_8.push(_local_6);
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            var _local_5:Array;
            var _local_6:uint;

            if (!_disposed)
            {
                _local_5 = _eventListenerTable[_arg_1];

                if (_local_5)
                {
                    _local_6 = 0;

                    for each (var _local_4:EventListenerStruct in _local_5)
                    {
                        if (((_local_4.callback == _arg_2) && (_local_4.useCapture == _arg_3)))
                        {
                            _local_5.splice(_local_6, 1);
                            _local_4.callback = null;

                            if (_local_5.length == 0)
                            {
                                delete _eventListenerTable[_arg_1];
                                _eventDispatcher.removeEventListener(_arg_1, eventProcessor);
                            };

                            return;
                        };

                        _local_6++;
                    };
                };
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            if (!_disposed)
            {
                _result = 0;
                _eventDispatcher.dispatchEvent(_arg_1);

                if (_result == 2)
                {
                    if (_error != null)
                    {
                        Core.crash(((("Error caught when handling " + getQualifiedClassName(_arg_1)) + ": ") + _error.message), _error.errorID, _error);
                    }

                    else
                    {
                        Core.crash((("Error caught when handling " + getQualifiedClassName(_arg_1)) + ". No error data available!"), 0, _error);
                    };
                };

                return (_result == 0);
            };

            return (false);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return ((_disposed) ? false : (!(_eventListenerTable[_arg_1] == null)));
        }

        public function callEventListeners(_arg_1:String):void
        {
            var _local_3:Array = _eventListenerTable[_arg_1];

            if (_local_3)
            {
                for each (var _local_2:EventListenerStruct in _local_3)
                {
                    _local_2.callback(null);
                };
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return ((_disposed) ? false : (!(_eventListenerTable[_arg_1] == null)));
        }

        private function eventProcessor(event:Event):void
        {
            var _local_4:Function;
            var _local_5:Array;
            var _local_3:Array = _eventListenerTable[event.type];

            if (_local_3)
            {
                _local_5 = [];

                for each (var _local_2:EventListenerStruct in _local_3)
                {
                    _local_5.push(_local_2.callback);
                };

                while (_local_5.length > 0)
                {
                    try
                    {
                        _local_4 = _local_5.shift();
                        (_local_4(event));
                    }

                    catch(e:Error)
                    {
                        Logger.log(e.getStackTrace());
                        _result = 2;
                        _error = e;
                        return;
                    };
                };
            };

            _result = ((event.isDefaultPrevented()) ? 1 : 0);
        }

        public function dispose():void
        {
            var _local_2:Array;

            if (!_disposed)
            {
                for (var _local_3:String in _eventListenerTable)
                {
                    _local_2 = (_eventListenerTable[_local_3] as Array);

                    for each (var _local_1:EventListenerStruct in _local_2)
                    {
                        _local_1.callback = null;
                    };

                    delete _eventListenerTable[_local_3];
                    _eventDispatcher.removeEventListener(_local_3, eventProcessor);
                };

                _eventListenerTable = null;
                _eventDispatcher = null;
                _disposed = true;
            };
        }

    }
}
