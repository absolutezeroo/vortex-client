package com.sulake.habbo.toolbar.memenu.soundsettings
{
    import com.sulake.habbo.toolbar.memenu.MeMenuSettingsMenuView;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.toolbar.ToolbarView;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.toolbar.memenu.MeMenuController;

    public class MeMenuSoundSettingsView 
    {

        private var _widget:MeMenuSettingsMenuView;
        private var _window:IWindowContainer;
        private var _uiSoundsSettings:MeMenuSoundSettingsItem;
        private var _furniSoundsSettings:MeMenuSoundSettingsItem;
        private var _traxSoundsSettings:MeMenuSoundSettingsItem;
        private var _soundsOffIconColor:BitmapData;
        private var _soundsOffIconWhite:BitmapData;
        private var _soundsOnIconColor:BitmapData;
        private var _soundsOnIconWhite:BitmapData;
        private var _genericVolume:Number = 1;
        private var _furniVolume:Number = 1;
        private var _traxVolume:Number = 1;
        private var _toolbarView:ToolbarView;

        public function init(_arg_1:MeMenuSettingsMenuView, _arg_2:ToolbarView):void
        {
            _toolbarView = _arg_2;
            _widget = _arg_1;
            createWindow();
        }

        public function dispose():void
        {
            saveVolume(_genericVolume, _furniVolume, _traxVolume);
            _widget = null;

            if (_window != null)
            {
                _window.dispose();
            };

            _window = null;

            if (_uiSoundsSettings != null)
            {
                _uiSoundsSettings.dispose();
            };

            _uiSoundsSettings = null;

            if (_furniSoundsSettings != null)
            {
                _furniSoundsSettings.dispose();
            };

            _furniSoundsSettings = null;

            if (_traxSoundsSettings != null)
            {
                _traxSoundsSettings.dispose();
            };

            _traxSoundsSettings = null;

            if (_soundsOffIconColor)
            {
                _soundsOffIconColor.dispose();
                _soundsOffIconColor = null;
            };

            if (_soundsOffIconWhite)
            {
                _soundsOffIconWhite.dispose();
                _soundsOffIconWhite = null;
            };

            if (_soundsOnIconColor)
            {
                _soundsOnIconColor.dispose();
                _soundsOnIconColor = null;
            };

            if (_soundsOnIconWhite)
            {
                _soundsOnIconWhite.dispose();
                _soundsOnIconWhite = null;
            };
        }

        public function get window():IWindowContainer
        {
            return (_window);
        }

        public function updateSettings():void
        {
            _genericVolume = _widget.widget.toolbar.soundManager.genericVolume;
            _furniVolume = _widget.widget.toolbar.soundManager.furniVolume;
            _traxVolume = _widget.widget.toolbar.soundManager.traxVolume;

            if (_uiSoundsSettings != null)
            {
                _uiSoundsSettings.setValue(_genericVolume);
            };

            if (_furniSoundsSettings != null)
            {
                _furniSoundsSettings.setValue(_furniVolume);
            };

            if (_traxSoundsSettings != null)
            {
                _traxSoundsSettings.setValue(_traxVolume);
            };
        }

        private function createWindow():void
        {
            var _local_1:IWindow;
            var _local_3:int;
            var _local_2:XmlAsset = (_widget.widget.toolbar.assets.getAssetByName("me_menu_sound_settings_xml") as XmlAsset);
            _window = (_widget.widget.toolbar.windowManager.buildFromXML((_local_2.content as XML)) as IWindowContainer);
            _window.x = (_toolbarView.window.width + 10);
            _window.y = (_toolbarView.window.bottom - _window.height);
            _local_3 = 0;

            while (_local_3 < _window.numChildren)
            {
                _local_1 = _window.getChildAt(_local_3);
                _local_1.addEventListener("WME_CLICK", onButtonClicked);
                _local_3++;
            };

            _uiSoundsSettings = new MeMenuSoundSettingsItem(this, 0, uiVolumeContainer);
            _furniSoundsSettings = new MeMenuSoundSettingsItem(this, 1, furniVolumeContainer);
            _traxSoundsSettings = new MeMenuSoundSettingsItem(this, 2, traxVolumeContainer);
            updateSettings();
        }

        private function onButtonClicked(_arg_1:WindowMouseEvent):void
        {
            var _local_2:IWindow = (_arg_1.target as IWindow);
            var _local_3:String = _local_2.name;
            Logger.log(_local_3);
            switch (_local_3)
            {
                case "back_btn":
                    _widget.window.visible = true;
                    dispose();
                    return;
                default:
                    Logger.log(("Me Menu Settings View: unknown button: " + _local_3));
                    return;
            };
        }

        public function saveVolume(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Boolean=true):void
        {
            var _local_6:Number = ((_arg_2 != -1) ? _arg_2 : _furniVolume);
            var _local_5:Number = ((_arg_1 != -1) ? _arg_1 : _genericVolume);
            var _local_7:Number = ((_arg_3 != -1) ? _arg_3 : _traxVolume);

            if (_arg_4)
            {
                if (_widget == null)
                {
                    return;
                };

                _widget.widget.toolbar.soundManager.furniVolume = _local_6;
                _widget.widget.toolbar.soundManager.genericVolume = _local_5;
                _widget.widget.toolbar.soundManager.traxVolume = _local_7;
            }

            else
            {
                _widget.widget.toolbar.soundManager.previewVolume(_local_5, _local_6, _local_7);
            };
        }

        public function updateUnseenItemCount(_arg_1:String, _arg_2:int):void
        {
        }

        public function get uiVolumeContainer():IWindowContainer
        {
            return (_window.findChildByName("ui_volume_container") as IWindowContainer);
        }

        public function get furniVolumeContainer():IWindowContainer
        {
            return (_window.findChildByName("furni_volume_container") as IWindowContainer);
        }

        public function get traxVolumeContainer():IWindowContainer
        {
            return (_window.findChildByName("trax_volume_container") as IWindowContainer);
        }

        public function get widget():MeMenuController
        {
            return (_widget.widget);
        }

        public function get soundsOffIconColor():BitmapData
        {
            return (_soundsOffIconColor);
        }

        public function get soundsOffIconWhite():BitmapData
        {
            return (_soundsOffIconWhite);
        }

        public function get soundsOnIconColor():BitmapData
        {
            return (_soundsOnIconColor);
        }

        public function get soundsOnIconWhite():BitmapData
        {
            return (_soundsOnIconWhite);
        }

    }
}
