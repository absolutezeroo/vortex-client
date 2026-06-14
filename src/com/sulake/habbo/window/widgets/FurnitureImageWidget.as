package com.sulake.habbo.window.widgets
{
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import flash.display.BitmapData;
    import com.sulake.habbo.room._SafeStr_147;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class FurnitureImageWidget implements IFurnitureImageWidget, IGetImageListener
    {

        public static const TYPE:String = "furniture_image";
        private static const _SafeStr_4423:String = "furniture_image:furnitureType";
        private static const SCALE_KEY:String = "furniture_image:scale";
        private static const _SafeStr_4409:String = "furniture_image:direction";
        private static const _SafeStr_4406:Array = ["northeast", "east", "southeast", "south", "southwest", "west", "northwest", "north"];
        private static const SCALES:Array = [32, 64];
        private static const FURNITURE_TYPE_DEFAULT:PropertyStruct = new PropertyStruct("furniture_image:furnitureType", "table_plasto_square", "String", false);
        private static const SCALE_DEFAULT:PropertyStruct = new PropertyStruct("furniture_image:scale", 64, "int", false, SCALES);
        private static const DIRECTION_DEFAULT:PropertyStruct = new PropertyStruct("furniture_image:direction", _SafeStr_4406[2], "String", false, _SafeStr_4406);
        private static const ITEM_TYPE_FLOOR:int = 0;
        private static const ITEM_TYPE_WALL:int = 1;

        private var _disposed:Boolean;
        private var _widgetWindow:IWidgetWindow;
        private var _windowManager:HabboWindowManagerComponent;
        private var _root:IWindowContainer;
        private var _bitmap:IBitmapWrapperWindow;
        private var _region:IRegionWindow;
        private var _furnitureType:String = "table_plasto_square";
        private var _scale:int = int(SCALE_DEFAULT.value);
        private var _direction:int = _SafeStr_4406.indexOf(DIRECTION_DEFAULT.value);
        private var _imageCallbackIds:Map;
        private var _extra:String;
        private var _itemType:int = 0;
        private var _stuffData:IStuffData = null;

        public function FurnitureImageWidget(_arg_1:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            _widgetWindow = _arg_1;
            _windowManager = _arg_2;
            _imageCallbackIds = new Map();
            _root = (_windowManager.buildFromXML((_windowManager.assets.getAssetByName("furniture_image_xml").content as XML)) as IWindowContainer);
            _bitmap = (_root.findChildByName("bitmap") as IBitmapWrapperWindow);
            _region = (_root.findChildByName("region") as IRegionWindow);
            _region.addEventListener("WME_CLICK", onClick);
            refresh();
            _widgetWindow.rootWindow = _root;
            _root.width = _widgetWindow.width;
            _root.height = _widgetWindow.height;
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                if (_region != null)
                {
                    _region.removeEventListener("WME_CLICK", onClick);
                    _region.dispose();
                    _region = null;
                };

                _bitmap = null;

                if (_root != null)
                {
                    _root.dispose();
                    _root = null;
                };

                if (_widgetWindow != null)
                {
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
            return (EmptyIterator.INSTANCE);
        }

        public function get properties():Array
        {
            var _local_1:Array = [];

            if (_disposed)
            {
                return (_local_1);
            };

            _local_1.push(FURNITURE_TYPE_DEFAULT.withValue(_furnitureType));
            _local_1.push(SCALE_DEFAULT.withValue(_scale));
            _local_1.push(DIRECTION_DEFAULT.withValue(_SafeStr_4406[_direction]));
            return (_local_1);
        }

        public function set properties(_arg_1:Array):void
        {
            for each (var _local_2:PropertyStruct in _arg_1)
            {
                switch (_local_2.key)
                {
                    case "furniture_image:furnitureType":
                        furnitureType = String(_local_2.value);
                        break;
                    case "furniture_image:scale":
                        scale = int(_local_2.value);
                        break;
                    case "furniture_image:direction":
                        direction = _SafeStr_4406.indexOf(_local_2.value);
                };
            };
        }

        public function get furnitureType():String
        {
            return (_furnitureType);
        }

        public function set furnitureType(_arg_1:String):void
        {
            _furnitureType = _arg_1;
            refresh();
        }

        public function get scale():int
        {
            return (_scale);
        }

        public function set scale(_arg_1:int):void
        {
            _scale = _arg_1;
            refresh();
        }

        public function get direction():int
        {
            return (_direction);
        }

        public function set direction(_arg_1:int):void
        {
            _direction = _arg_1;
            refresh();
        }

        public function imageReady(_arg_1:int, _arg_2:BitmapData):void
        {
            var _local_3:String = _imageCallbackIds.getValue(_arg_1);

            if (_local_3 == _furnitureType)
            {
                refresh();
            };
        }

        public function imageFailed(_arg_1:int):void
        {
        }

        private function refresh():void
        {
            var _local_1:_SafeStr_147;
            var _local_2:String;
            var _local_5:int;
            var _local_4:int;
            var _local_3:String;
            _bitmap.bitmap = null;

            if (_windowManager.roomEngine != null)
            {
                _local_2 = "std";
                _local_5 = _windowManager.roomEngine.getFurnitureTypeId(_furnitureType);

                if (_itemType == 0)
                {
                    _local_1 = _windowManager.roomEngine.getFurnitureImage(_local_5, new Vector3d((_direction * 45), 0, 0), _scale, this, 0, _extra, -1, -1, _stuffData);
                }

                else
                {
                    _local_1 = _windowManager.roomEngine.getWallItemImage(_local_5, new Vector3d((_direction * 45), 0, 0), _scale, this, 0, ((_stuffData) ? _stuffData.getLegacyString() : ""));
                };

                if (_local_1 != null)
                {
                    _local_4 = _local_1.id;
                    _imageCallbackIds.remove(_local_4);

                    if (_local_4 > 0)
                    {
                        _imageCallbackIds.add(_local_4, _furnitureType);
                    };

                    _bitmap.bitmap = _local_1.data;
                    _bitmap.disposesBitmap = true;
                };
            };

            if (((_bitmap.bitmap == null) || (_bitmap.bitmap.width < 2)))
            {
                _local_3 = (("placeholder_furni" + ((_scale == 32) ? "_small" : "")) + "_png");
                _bitmap.bitmap = (_windowManager.assets.getAssetByName(_local_3).content as BitmapData);
                _bitmap.disposesBitmap = false;
            };

            _bitmap.invalidate();
            _widgetWindow.width = _bitmap.bitmap.width;
            _widgetWindow.height = _bitmap.bitmap.height;
        }

        private function onClick(_arg_1:WindowMouseEvent):void
        {
        }

    }
}