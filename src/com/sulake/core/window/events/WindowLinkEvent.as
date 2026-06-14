package com.sulake.core.window.events
{
    import com.sulake.core.window.IWindow;

    public class WindowLinkEvent extends WindowEvent 
    {

        public static const _SafeStr_1090:String = "WE_LINK";
        private static const _SafeStr_1036:Array = [];

        private var _link:String;

        public function WindowLinkEvent()
        {
            _SafeStr_741 = "WE_LINK";
        }

        public static function allocate(link:String, window:IWindow, related:IWindow):WindowEvent
        {
            var _local_4:WindowLinkEvent = ((_SafeStr_1036.length > 0) ? _SafeStr_1036.pop() : new WindowLinkEvent());
            _local_4._link = link;
            _local_4._window = window;
            _local_4._SafeStr_1084 = related;
            _local_4._SafeStr_1037 = false;
            _local_4._SafeStr_1038 = _SafeStr_1036;
            return (_local_4);
        }

        public function get link():String
        {
            return (_link);
        }

        override public function clone():WindowEvent
        {
            return (allocate(_link, window, related));
        }

        override public function toString():String
        {
            return (((((((("WindowLinkEvent { type: " + _SafeStr_741) + " link: ") + link) + " cancelable: ") + _SafeStr_1085) + " window: ") + _window) + " }");
        }

    }
}
