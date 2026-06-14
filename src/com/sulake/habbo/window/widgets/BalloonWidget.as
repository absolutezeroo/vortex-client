package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.window.enum._SafeStr_220;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Rectangle;
    import com.sulake.habbo.utils._SafeStr_25;

    public class BalloonWidget implements IBalloonWidget
    {

        public static const TYPE:String = "balloon";
        private static const ARROW_PIVOT_KEY:String = "balloon:arrow_pivot";
        private static const ARROW_DISPLACEMENT_KEY:String = "balloon:arrow_displacement";
        private static const ARROW_PIVOT_DEFAULT:PropertyStruct = new PropertyStruct("balloon:arrow_pivot", "up, center", "String", false, _SafeStr_220.ALL);
        private static const ARROW_DISPLACEMENT_DEFAULT:PropertyStruct = new PropertyStruct("balloon:arrow_displacement", 0, "int");
        private static const ARROW_ASSET_PREFIX:String = "illumina_light_balloon_arrow_";
        private static const ARROW_FREE_PADDING:int = 6;
        private static const ARROW_LENGTH:int = 6;
        private static const ARROW_WIDTH:int = 9;

        private var _disposed:Boolean;
        private var _widgetWindow:IWidgetWindow;
        private var _windowManager:HabboWindowManagerComponent;
        private var _settingProperties:Boolean = false;
        private var _resizingWidget:Boolean = false;
        private var _root:IWindowContainer;
        private var _contents:IWindowContainer;
        private var _arrowHead:IStaticBitmapWrapperWindow;
        private var _arrowPivot:String = String(ARROW_PIVOT_DEFAULT.value);
        private var _arrowDisplacement:int = int(ARROW_DISPLACEMENT_DEFAULT.value);

        public function BalloonWidget(_arg_1:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            _widgetWindow = _arg_1;
            _windowManager = _arg_2;
            _root = (_windowManager.buildFromXML((_windowManager.assets.getAssetByName("balloon_xml").content as XML)) as IWindowContainer);
            _arrowHead = (_root.findChildByName("bitmap") as IStaticBitmapWrapperWindow);
            _contents = (_root.findChildByName("border") as IWindowContainer);
            syncFlags();
            _widgetWindow.addEventListener("WE_RESIZE", onChange);
            _widgetWindow.addEventListener("WE_RESIZED", onChange);
            _contents.addEventListener("WE_RESIZE", onChange);
            _contents.addEventListener("WE_RESIZED", onChange);
            _widgetWindow.rootWindow = _root;
            _root.width = _widgetWindow.width;
            _root.height = _widgetWindow.height;
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                if (_contents != null)
                {
                    _contents.removeEventListener("WE_RESIZE", onChange);
                    _contents.removeEventListener("WE_RESIZED", onChange);
                    _contents = null;
                };

                _arrowHead = null;

                if (_root != null)
                {
                    _root.dispose();
                    _root = null;
                };

                if (_widgetWindow != null)
                {
                    _widgetWindow.removeEventListener("WE_RESIZE", onChange);
                    _widgetWindow.removeEventListener("WE_RESIZED", onChange);
                    _widgetWindow.rootWindow = null;
                    _widgetWindow = null;
                };

                _windowManager = null;
                _disposed = true;
            };
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get iterator():IIterator
        {
            return ((_contents == null) ? EmptyIterator.INSTANCE : _contents.iterator);
        }

        public function get properties():Array
        {
            var _local_1:Array = [];

            if (_disposed)
            {
                return (_local_1);
            };

            _local_1.push(ARROW_PIVOT_DEFAULT.withValue(_arrowPivot));
            _local_1.push(ARROW_DISPLACEMENT_DEFAULT.withValue(_arrowDisplacement));
            return (_local_1);
        }

        public function set properties(_arg_1:Array):void
        {
            _settingProperties = true;

            for each (var _local_2:PropertyStruct in _arg_1)
            {
                switch (_local_2.key)
                {
                    case "balloon:arrow_pivot":
                        arrowPivot = String(_local_2.value);
                        break;
                    case "balloon:arrow_displacement":
                        arrowDisplacement = int(_local_2.value);
                };
            };

            _settingProperties = false;
            refresh();
        }

        public function get arrowPivot():String
        {
            return (_arrowPivot);
        }

        public function set arrowPivot(_arg_1:String):void
        {
            _arrowPivot = _arg_1;
            clearFlags();
            refresh();
            syncFlags();
            refresh();
        }

        public function get arrowDisplacement():int
        {
            return (_arrowDisplacement);
        }

        public function set arrowDisplacement(_arg_1:int):void
        {
            _arrowDisplacement = _arg_1;
            refresh();
        }

        private function onChange(_arg_1:WindowEvent):void
        {
            refresh();
        }

        private function syncFlags():void
        {
            if (_contents != null)
            {
                _contents.setParamFlag(0x20000, _widgetWindow.getParamFlag(0x20000));
                _contents.setParamFlag(147456, _widgetWindow.getParamFlag(147456));
            };
        }

        private function clearFlags():void
        {
            if (_contents != null)
            {
                _contents.setParamFlag(0x20000, false);
                _contents.setParamFlag(147456, false);
            };
        }

        private function refresh():void
        {
            var _local_1:int;
            var _local_3:int;
            var _local_2:int;

            if (((((_settingProperties) || (_resizingWidget)) || (_disposed)) || (_contents == null)))
            {
                return;
            };

            var _local_4:String = _SafeStr_220.directionFromPivot(_arrowPivot);
            switch (_local_4)
            {
                case "up":
                case "down":
                    _local_1 = _contents.width;
                    _local_3 = ((_contents.height + 6) - 1);
                    break;
                case "left":
                case "right":
                    _local_1 = ((_contents.width + 6) - 1);
                    _local_3 = _contents.height;
            };

            _resizingWidget = true;

            if (_widgetWindow.testParamFlag(147456))
            {
                _root.width = _local_1;
                _root.height = _local_3;
            }

            else
            {
                if (_widgetWindow.testParamFlag(0x20000))
                {
                    _root.width = Math.max(_widgetWindow.width, _local_1);
                    _root.height = Math.max(_widgetWindow.height, _local_3);
                }

                else
                {
                    _root.width = _widgetWindow.width;
                    _root.height = _widgetWindow.height;
                };
            };

            _widgetWindow.width = _root.width;
            _widgetWindow.height = _root.height;
            _resizingWidget = false;
            _arrowHead.assetUri = ("illumina_light_balloon_arrow_" + _local_4);
            switch (_local_4)
            {
                case "up":
                case "down":
                    switch (_SafeStr_220.positionFromPivot(_arrowPivot))
                    {
                        case "minimum":
                            _local_2 = 6;
                            break;
                        case "middle":
                            _local_2 = int(((_root.width - 9) / 2));
                            break;
                        case "maximum":
                            _local_2 = ((_root.width - 6) - 9);
                    };

                    _resizingWidget = true;
                    _contents.rectangle = new Rectangle(0, ((_local_4 == "up") ? (6 - 1) : 0), _root.width, ((_root.height + 1) - 6));
                    _resizingWidget = false;
                    _arrowHead.rectangle = new Rectangle(_SafeStr_25.clamp((_local_2 + _arrowDisplacement), 6, (_root.width - 6)), ((_local_4 == "up") ? 0 : (_contents.bottom - 1)), 9, 6);
                    return;
                case "left":
                case "right":
                    switch (_SafeStr_220.positionFromPivot(_arrowPivot))
                    {
                        case "minimum":
                            _local_2 = 6;
                            break;
                        case "middle":
                            _local_2 = int(((_root.height - 9) / 2));
                            break;
                        case "maximum":
                            _local_2 = ((_root.height - 6) - 9);
                    };

                    _resizingWidget = true;
                    _contents.rectangle = new Rectangle(((_local_4 == "left") ? (6 - 1) : 0), 0, ((_root.width + 1) - 6), _root.height);
                    _resizingWidget = false;
                    _arrowHead.rectangle = new Rectangle(((_local_4 == "left") ? 0 : (_contents.right - 1)), _SafeStr_25.clamp((_local_2 + _arrowDisplacement), 6, (_root.height - 6)), 6, 9);
                    return;
            };
        }

    }
}