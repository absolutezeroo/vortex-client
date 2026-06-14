package com.sulake.core.window.events
{
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import com.sulake.core.window.IWindow;

    public class WindowKeyboardEvent extends WindowEvent 
    {

        public static const _SafeStr_1087:String = "WKE_KEY_UP";
        public static const _SafeStr_1088:String = "WKE_KEY_DOWN";
        private static const _SafeStr_1036:Array = [];

        private var _event:KeyboardEvent;

        public static function allocate(type:String, event:Event, window:IWindow, related:IWindow, cancelable:Boolean=false):WindowKeyboardEvent
        {
            var _local_6:WindowKeyboardEvent = ((_SafeStr_1036.length > 0) ? _SafeStr_1036.pop() : new WindowKeyboardEvent());
            _local_6._SafeStr_741 = type;
            _local_6._event = (event as KeyboardEvent);
            _local_6._window = window;
            _local_6._SafeStr_1084 = related;
            _local_6._SafeStr_1037 = false;
            _local_6._SafeStr_1085 = cancelable;
            _local_6._SafeStr_1038 = _SafeStr_1036;
            return (_local_6);
        }

        public function get charCode():uint
        {
            return (_event.charCode);
        }

        public function get keyCode():uint
        {
            return (_event.keyCode);
        }

        public function get keyLocation():uint
        {
            return (_event.keyLocation);
        }

        public function get altKey():Boolean
        {
            return (_event.altKey);
        }

        public function get shiftKey():Boolean
        {
            return (_event.shiftKey);
        }

        public function get ctrlKey():Boolean
        {
            return (_event.ctrlKey);
        }

        override public function clone():WindowEvent
        {
            return (allocate(_SafeStr_741, _event, window, related, cancelable));
        }

        override public function toString():String
        {
            return (((((((("WindowKeyboardEvent { type: " + _SafeStr_741) + " cancelable: ") + _SafeStr_1085) + " window: ") + _window) + " charCode: ") + charCode) + " }");
        }

    }
}
