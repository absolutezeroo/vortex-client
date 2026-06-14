package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.utils.IIterator;

    public class RoomUserCountWidget implements IRoomUserCountWidget 
    {

        public static const TYPE:String = "room_user_count";

        private var _widgetWindow:IWidgetWindow;
        private var _windowManager:HabboWindowManagerComponent;
        private var _root:IWindowContainer;

        public function RoomUserCountWidget(_arg_1:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            _widgetWindow = _arg_1;
            _windowManager = _arg_2;
            _root = (_windowManager.buildFromXML((_windowManager.assets.getAssetByName("room_user_count_xml").content as XML)) as IWindowContainer);
            _widgetWindow.rootWindow = _root;
            _root.width = _widgetWindow.width;
            _root.height = _widgetWindow.height;
        }

        public function set userCount(_arg_1:int):void
        {
        }

        public function get properties():Array
        {
            return (null);
        }

        public function set properties(_arg_1:Array):void
        {
        }

        public function dispose():void
        {
        }

        public function get disposed():Boolean
        {
            return (false);
        }

        public function get iterator():IIterator
        {
            return (null);
        }

    }
}
