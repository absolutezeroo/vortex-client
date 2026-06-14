package com.sulake.habbo.ui.widget.memenu.soundsettings
{
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

    public class MeMenuSoundSettingsSlider 
    {

        private var _settingsItem:MeMenuSoundSettingsItem;
        private var _sliderContainer:IWindowContainer;
        private var _sliderBase:BitmapData;
        private var _sliderButton:BitmapData;
        private var _referenceWidth:int;
        private var _minValue:Number = 0;
        private var _maxValue:Number = 1;

        public function MeMenuSoundSettingsSlider(_arg_1:MeMenuSoundSettingsItem, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, _arg_4:Number=0, _arg_5:Number=1)
        {
            _settingsItem = _arg_1;
            _sliderContainer = _arg_2;
            _minValue = _arg_4;
            _maxValue = _arg_5;
            storeAssets(_arg_3);
            displaySlider();
        }

        public function dispose():void
        {
            _settingsItem = null;
            _sliderContainer = null;
            _sliderBase = null;
            _sliderButton = null;
        }

        public function setValue(_arg_1:Number):void
        {
            if (_sliderContainer == null)
            {
                return;
            };

            var _local_2:IWindow = _sliderContainer.findChildByName("slider_button");

            if (_local_2 != null)
            {
                _local_2.x = getSliderPosition(_arg_1);
            };
        }

        private function getSliderPosition(_arg_1:Number):int
        {
            return (int((_referenceWidth * ((_arg_1 - _minValue) / (_maxValue - _minValue)))));
        }

        private function getValue(_arg_1:Number):Number
        {
            return (((_arg_1 / _referenceWidth) * (_maxValue - _minValue)) + _minValue);
        }

        private function buttonProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WE_RELOCATED")
            {
                return;
            };

            _settingsItem.saveVolume(getValue(_arg_2.x), false);
        }

        private function displaySlider():void
        {
            var _local_3:IWindowContainer;
            var _local_1:IWindowContainer;
            var _local_2:IBitmapWrapperWindow;

            if (_sliderContainer == null)
            {
                return;
            };

            _local_2 = (_sliderContainer.findChildByName("slider_base") as IBitmapWrapperWindow);

            if (((!(_local_2 == null)) && (!(_sliderBase == null))))
            {
                _local_2.bitmap = new BitmapData(_sliderBase.width, _sliderBase.height, true, 0xFFFFFF);
                _local_2.bitmap.copyPixels(_sliderBase, _sliderBase.rect, new Point(0, 0), null, null, true);
            };

            _local_3 = (_sliderContainer.findChildByName("slider_movement_area") as IWindowContainer);

            if (_local_3 != null)
            {
                _local_1 = (_local_3.findChildByName("slider_button") as IWindowContainer);

                if (_local_1 != null)
                {
                    _local_2 = (_local_1.findChildByName("slider_bitmap") as IBitmapWrapperWindow);

                    if (((!(_local_2 == null)) && (!(_sliderButton == null))))
                    {
                        _local_2.bitmap = new BitmapData(_sliderButton.width, _sliderButton.height, true, 0xFFFFFF);
                        _local_2.bitmap.copyPixels(_sliderButton, _sliderButton.rect, new Point(0, 0), null, null, true);
                        _local_1.procedure = buttonProcedure;
                        _referenceWidth = (_local_3.width - _local_2.width);
                    };
                };
            };
        }

        private function storeAssets(_arg_1:IAssetLibrary):void
        {
            var _local_2:BitmapDataAsset;

            if (_arg_1 == null)
            {
                return;
            };

            _local_2 = BitmapDataAsset(_arg_1.getAssetByName("memenu_settings_slider_base"));
            _sliderBase = BitmapData(_local_2.content);
            _local_2 = BitmapDataAsset(_arg_1.getAssetByName("memenu_settings_slider_button"));
            _sliderButton = BitmapData(_local_2.content);
        }

    }
}
