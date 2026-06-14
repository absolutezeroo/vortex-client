package com.sulake.core.window.events
{
    import com.sulake.core.window.IWindow;

    public class WindowTouchEvent extends WindowEvent 
    {

        public static const WINDOW_EVENT_TOUCH_BEGIN:String = "WTE_BEGIN";
        public static const _SafeStr_1097:String = "WTE_END";
        public static const WINDOW_EVENT_TOUCH_MOVE:String = "WTE_MOVE";
        public static const _SafeStr_1098:String = "WTE_OUT";
        public static const WINDOW_EVENT_TOUCH_OVER:String = "WTE_OVER";
        public static const _SafeStr_1099:String = "WTE_ROLL_OUT";
        public static const WINDOW_EVENT_TOUCH_ROLL_OVER:String = "WTE_ROLL_OVER";
        public static const _SafeStr_1100:String = "WTE_TAP";
        private static const _SafeStr_1036:Array = [];

        public var localX:Number;
        public var localY:Number;
        public var stageX:Number;
        public var stageY:Number;
        public var altKey:Boolean;
        public var ctrlKey:Boolean;
        public var shiftKey:Boolean;
        public var pressure:Number;
        public var sizeX:Number;
        public var sizeY:Number;

        public static function allocate(type:String, window:IWindow, related:IWindow, localX:Number, localY:Number, sizeX:Number, sizeY:Number, stageX:Number, stageY:Number, pressure:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):WindowTouchEvent
        {
            var _local_14:WindowTouchEvent = ((_SafeStr_1036.length > 0) ? _SafeStr_1036.pop() : new WindowTouchEvent());
            _local_14._SafeStr_741 = type;
            _local_14._window = window;
            _local_14._SafeStr_1084 = related;
            _local_14._SafeStr_1037 = false;
            _local_14._SafeStr_1038 = _SafeStr_1036;
            _local_14.sizeX = sizeX;
            _local_14.sizeY = sizeY;
            _local_14.localX = localX;
            _local_14.localY = localY;
            _local_14.stageX = stageX;
            _local_14.stageY = stageY;
            _local_14.pressure = pressure;
            _local_14.altKey = altKey;
            _local_14.ctrlKey = ctrlKey;
            _local_14.shiftKey = shiftKey;
            return (_local_14);
        }

        override public function clone():WindowEvent
        {
            return (allocate(_SafeStr_741, window, related, localX, localY, sizeX, sizeY, stageX, stageY, pressure, altKey, ctrlKey, shiftKey));
        }

        override public function toString():String
        {
            return (((((((((("WindowTouchEvent { type: " + _SafeStr_741) + " cancelable: ") + _SafeStr_1085) + " window: ") + _window) + " localX: ") + localX) + " localY: ") + localY) + " }");
        }

    }
}
