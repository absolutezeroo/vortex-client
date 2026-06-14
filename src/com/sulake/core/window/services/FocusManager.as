package com.sulake.core.window.services
{
    import flash.display.Stage;
    import __AS3__.vec.Vector;
    import com.sulake.core.window.components.IFocusWindow;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import com.sulake.core.window.utils.*;

    public class FocusManager implements IFocusManagerService 
    {

        private var _disposed:Boolean = false;
        private var _stage:Stage;
        private var _array:Vector.<IFocusWindow> = new Vector.<IFocusWindow>();

        public function FocusManager(_arg_1:DisplayObject)
        {
            _stage = _arg_1.stage;
            _stage.addEventListener("activate", onActivateEvent);
            _stage.addEventListener("focusOut", onFocusEvent);
            _stage.addEventListener("keyFocusChange", onFocusEvent);
            _stage.addEventListener("mouseFocusChange", onFocusEvent);
            super();
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _stage.removeEventListener("activate", onActivateEvent);
                _stage.removeEventListener("focusOut", onFocusEvent);
                _stage.removeEventListener("keyFocusChange", onFocusEvent);
                _stage.removeEventListener("mouseFocusChange", onFocusEvent);
                _stage = null;
                _disposed = true;
                _array = null;
            };
        }

        public function registerFocusWindow(_arg_1:IFocusWindow):void
        {
            if (_arg_1 != null)
            {
                if (_array.indexOf(_arg_1) == -1)
                {
                    _array.push(_arg_1);

                    if (_stage.focus == null)
                    {
                        _arg_1.focus();
                    };
                };
            };
        }

        public function removeFocusWindow(_arg_1:IFocusWindow):void
        {
            var _local_2:int;

            if (_arg_1 != null)
            {
                _local_2 = _array.indexOf(_arg_1);

                if (_local_2 > -1)
                {
                    _array.splice(_local_2, 1);
                };
            };

            if (_stage.focus == null)
            {
                resolveNextFocusTarget();
            };
        }

        private function resolveNextFocusTarget():IFocusWindow
        {
            var _local_1:IFocusWindow;
            var _local_2:uint = _array.length;

            while (_local_2-- != 0)
            {
                _local_1 = (_array[_local_2] as IFocusWindow);

                if (_local_1.disposed)
                {
                    _array.splice(_local_2, 1);
                }

                else
                {
                    _local_1.focus();
                    break;
                };
            };

            return (_local_1);
        }

        private function onActivateEvent(_arg_1:Event):void
        {
            if (_stage.focus == null)
            {
                resolveNextFocusTarget();
            };
        }

        private function onFocusEvent(_arg_1:FocusEvent):void
        {
            if (_stage.focus == null)
            {
                resolveNextFocusTarget();
            };
        }

    }
}
