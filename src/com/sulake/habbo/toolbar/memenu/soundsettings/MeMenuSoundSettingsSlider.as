package com.sulake.habbo.toolbar.memenu.soundsettings
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;

    public class MeMenuSoundSettingsSlider 
    {

        private var _settingsItem:*;
        private var _sliderContainer:IWindowContainer;
        private var _referenceWidth:int;
        private var _minValue:Number = 0;
        private var _maxValue:Number = 1;

        public function MeMenuSoundSettingsSlider(settingsItem:*, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, minValue:Number=0, maxValue:Number=1)
        {
            _settingsItem = settingsItem;
            _sliderContainer = _arg_2;
            _minValue = minValue;
            _maxValue = maxValue;
            displaySlider();
        }

        public function dispose():void
        {
            _settingsItem = null;
            _sliderContainer = null;
        }

        public function setValue(value:Number):void
        {
            if (_sliderContainer == null)
            {
                return;
            };

            var _local_2:IWindow = _sliderContainer.findChildByName("slider_button");

            if (_local_2 != null)
            {
                _local_2.x = getSliderPosition(value);
            };
        }

        private function getSliderPosition(_arg_1:Number):int
        {
            return (int((_referenceWidth * ((_arg_1 - _minValue) / (_maxValue - _minValue)))));
        }

        private function getValue(index:Number):Number
        {
            return (((index / _referenceWidth) * (_maxValue - _minValue)) + _minValue);
        }

        private function buttonProcedure(event:WindowEvent, window:IWindow):void
        {
            if (event.type != "WE_RELOCATED")
            {
                return;
            };

            _settingsItem.saveVolume(getValue(window.x), false);
        }

        private function displaySlider():void
        {
            var _local_2:IWindowContainer;
            var _local_1:IWindowContainer;

            if (_sliderContainer == null)
            {
                return;
            };

            _local_2 = (_sliderContainer.findChildByName("slider_movement_area") as IWindowContainer);

            if (_local_2 != null)
            {
                _local_1 = (_local_2.findChildByName("slider_button") as IWindowContainer);

                if (_local_1 != null)
                {
                    _local_1.procedure = buttonProcedure;
                    _referenceWidth = (_local_2.width - _local_1.width);
                };
            };
        }

    }
}
