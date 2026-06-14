package com.sulake.habbo.ui.widget.doorbell
{
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class DoorbellView 
    {

        private var _doorbell:DoorbellWidget;
        private var _mainWindow:IFrameWindow;
        private var _list:IItemListWindow;

        public function DoorbellView(_arg_1:DoorbellWidget)
        {
            _doorbell = _arg_1;
        }

        public function dispose():void
        {
            _list = null;
            _doorbell = null;

            if (_mainWindow)
            {
                _mainWindow.dispose();
                _mainWindow = null;
            };
        }

        public function update():void
        {
            var _local_1:int;

            if (_doorbell.users.length == 0)
            {
                hide();
                return;
            };

            if (_mainWindow == null)
            {
                createMainWindow();
            };

            _mainWindow.visible = true;

            if (_list != null)
            {
                _list.destroyListItems();
                _local_1 = 0;

                while (_local_1 < _doorbell.users.length)
                {
                    _list.addListItem(createListItem((_doorbell.users[_local_1] as String), _local_1));
                    _local_1++;
                };
            };
        }

        public function get mainWindow():IWindow
        {
            return (_mainWindow);
        }

        private function createListItem(_arg_1:String, _arg_2:int):IWindow
        {
            var _local_5:IWindow;
            var _local_4:XmlAsset = (_doorbell.assets.getAssetByName("doorbell_list_entry") as XmlAsset);
            var _local_3:IWindowContainer = (_doorbell.windowManager.buildFromXML((_local_4.content as XML)) as IWindowContainer);

            if (_local_3 == null)
            {
                throw (new Error("Failed to construct window from XML!"));
            };

            var _local_6:ITextWindow = (_local_3.findChildByName("user_name") as ITextWindow);

            if (_local_6 != null)
            {
                _local_6.caption = _arg_1;
            };

            _local_3.name = _arg_1;

            if ((_arg_2 % 2) == 0)
            {
                _local_3.color = 0xFFFFFFFF;
            };

            _local_5 = _local_3.findChildByName("accept");

            if (_local_5 != null)
            {
                _local_5.addEventListener("WME_CLICK", onButtonClicked);
            };

            _local_5 = _local_3.findChildByName("deny");

            if (_local_5 != null)
            {
                _local_5.addEventListener("WME_CLICK", onButtonClicked);
            };

            return (_local_3);
        }

        private function hide():void
        {
            if (_mainWindow)
            {
                _mainWindow.dispose();
                _mainWindow = null;
            };
        }

        private function createMainWindow():void
        {
            if (_mainWindow != null)
            {
                return;
            };

            var _local_2:XmlAsset = (_doorbell.assets.getAssetByName("doorbell") as XmlAsset);
            _mainWindow = (_doorbell.windowManager.buildFromXML((_local_2.content as XML)) as IFrameWindow);

            if (_mainWindow == null)
            {
                throw (new Error("Failed to construct window from XML!"));
            };

            _list = (_mainWindow.findChildByName("user_list") as IItemListWindow);
            _mainWindow.visible = false;

            var _local_1:IWindow = _mainWindow.findChildByTag("close");

            if (_local_1 != null)
            {
                _local_1.addEventListener("WME_CLICK", onClose);
            };
        }

        private function onClose(_arg_1:WindowMouseEvent):void
        {
            _doorbell.denyAll();
        }

        private function onButtonClicked(_arg_1:WindowMouseEvent):void
        {
            var _local_2:String = _arg_1.window.parent.name;
            switch (_arg_1.window.name)
            {
                case "accept":
                    _doorbell.accept(_local_2);
                    return;
                case "deny":
                    _doorbell.deny(_local_2);
                    return;
            };
        }

    }
}
