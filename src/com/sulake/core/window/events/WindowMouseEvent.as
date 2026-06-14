package com.sulake.core.window.events
{
    import com.sulake.core.window.IWindow;

    public class WindowMouseEvent extends WindowEvent 
    {

        public static const CLICK:String = "WME_CLICK";
        public static const DOUBLE_CLICK:String = "WME_DOUBLE_CLICK";
        public static const DOWN:String = "WME_DOWN";
        public static const MIDDLE_CLICK:String = "WME_MIDDLE_CLICK";
        public static const _SafeStr_1091:String = "WME_MIDDLE_DOWN";
        public static const _SafeStr_1092:String = "WME_MIDDLE_UP";
        public static const MOVE:String = "WME_MOVE";
        public static const _SafeStr_1093:String = "WME_OUT";
        public static const OVER:String = "WME_OVER";
        public static const _SafeStr_1032:String = "WME_UP";
        public static const UP_OUTSIDE:String = "WME_UP_OUTSIDE";
        public static const _SafeStr_1094:String = "WME_WHEEL";
        public static const RIGHT_CLICK:String = "WME_RIGHT_CLICK";
        public static const _SafeStr_1095:String = "WME_RIGHT_DOWN";
        public static const _SafeStr_1096:String = "WME_RIGHT_UP";
        public static const ROLL_OUT:String = "WME_ROLL_OUT";
        public static const ROLL_OVER:String = "WME_ROLL_OVER";
        public static const HOVERING:String = "WME_HOVERING";
        private static const _SafeStr_1036:Array = [];

        public var delta:int;
        public var localX:Number;
        public var localY:Number;
        public var stageX:Number;
        public var stageY:Number;
        public var altKey:Boolean;
        public var ctrlKey:Boolean;
        public var shiftKey:Boolean;
        public var buttonDown:Boolean;

        public static function allocate(type:String, window:IWindow, related:IWindow, localX:Number, localY:Number, stageX:Number, stageY:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean, buttonDown:Boolean, delta:int):WindowMouseEvent
        {
            var _local_13:WindowMouseEvent = ((_SafeStr_1036.length > 0) ? _SafeStr_1036.pop() : new WindowMouseEvent());
            _local_13._SafeStr_741 = type;
            _local_13._window = window;
            _local_13._SafeStr_1084 = related;
            _local_13._SafeStr_1037 = false;
            _local_13._SafeStr_1038 = _SafeStr_1036;
            _local_13.localX = localX;
            _local_13.localY = localY;
            _local_13.stageX = stageX;
            _local_13.stageY = stageY;
            _local_13.altKey = altKey;
            _local_13.ctrlKey = ctrlKey;
            _local_13.shiftKey = shiftKey;
            _local_13.buttonDown = buttonDown;
            _local_13.delta = delta;
            return (_local_13);
        }

        override public function clone():WindowEvent
        {
            return (allocate(_SafeStr_741, window, related, localX, localY, stageX, stageY, altKey, ctrlKey, shiftKey, buttonDown, delta));
        }

        override public function toString():String
        {
            return (((((((((("WindowMouseEvent { type: " + _SafeStr_741) + " cancelable: ") + _SafeStr_1085) + " window: ") + _window) + " localX: ") + localX) + " localY: ") + localY) + " }");
        }

    }
}
