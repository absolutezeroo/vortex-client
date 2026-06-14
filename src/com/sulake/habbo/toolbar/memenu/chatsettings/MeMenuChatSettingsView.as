package com.sulake.habbo.toolbar.memenu.chatsettings
{
    import com.sulake.habbo.toolbar.memenu.MeMenuSettingsMenuView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.ToolbarView;
    import com.sulake.core.window.components._SafeStr_108;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class MeMenuChatSettingsView 
    {

        private var _widget:MeMenuSettingsMenuView;
        private var _window:IWindowContainer;
        private var _toolbarView:ToolbarView;

        public function init(_arg_1:MeMenuSettingsMenuView, _arg_2:ToolbarView):void
        {
            _widget = _arg_1;
            _toolbarView = _arg_2;
            createWindow();
        }

        public function dispose():void
        {
            if (_window == null)
            {
                return;
            };

            var _local_1:_SafeStr_108 = (_window.findChildByName("prefer_old_chat_checkbox") as _SafeStr_108);
            _widget.window.visible = true;
            _widget.widget.toolbar.freeFlowChat.isDisabledInPreferences = ((!(_local_1 == null)) && (_local_1.isSelected));
            _window.dispose();
            _window = null;
            _widget = null;
        }

        private function createWindow():void
        {
            var _local_3:int;
            var _local_1:IWindow;
            var _local_2:XmlAsset = (_widget.widget.toolbar.assets.getAssetByName("me_menu_chat_settings_xml") as XmlAsset);
            _window = (_widget.widget.toolbar.windowManager.buildFromXML((_local_2.content as XML)) as IWindowContainer);
            _window.x = (_toolbarView.window.width + 10);
            _window.y = (_toolbarView.window.bottom - _window.height);
            _widget.window.visible = false;
            _local_3 = 0;
            _local_1 = null;

            while (_local_3 < _window.numChildren)
            {
                _local_1 = _window.getChildAt(_local_3);
                _local_1.addEventListener("WME_CLICK", onButtonClicked);
                _local_3++;
            };

            _SafeStr_108(_window.findChildByName("prefer_old_chat_checkbox")).isSelected = _widget.widget.toolbar.freeFlowChat.isDisabledInPreferences;
        }

        private function onButtonClicked(_arg_1:WindowMouseEvent):void
        {
            var _local_2:IWindow = (_arg_1.target as IWindow);
            var _local_3:String = _local_2.name;
            switch (_local_3)
            {
                case "back_btn":
                    dispose();
                    return;
                case "prefer_old_chat_checkbox":
                    _widget.widget.toolbar.freeFlowChat.isDisabledInPreferences = _SafeStr_108(_window.findChildByName("prefer_old_chat_checkbox")).isSelected;

                    if (!_widget.widget.toolbar.freeFlowChat.isDisabledInPreferences)
                    {
                        if (_widget.widget.toolbar.roomUI.chatContainer != null)
                        {
                            _widget.widget.toolbar.roomUI.chatContainer.setDisplayObject(_widget.widget.toolbar.freeFlowChat.displayObject);
                        };
                    }

                    else
                    {
                        _widget.widget.toolbar.freeFlowChat.clear();
                    };

                    return;
            };
        }

        public function get window():IWindowContainer
        {
            return (_window);
        }

    }
}
