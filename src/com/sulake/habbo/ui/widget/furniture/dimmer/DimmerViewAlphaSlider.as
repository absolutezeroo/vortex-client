package com.sulake.habbo.ui.widget.furniture.dimmer
{
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

    public class DimmerViewAlphaSlider 
    {

        private var _view:DimmerView;
        private var _sliderContainer:IWindowContainer;
        private var _sliderBase:BitmapData;
        private var _sliderButton:BitmapData;
        private var _referenceWidth:int;
        private var _referenceX:int;
        private var _minValue:int = 0;
        private var _maxValue:int = 0xFF;

        public function DimmerViewAlphaSlider(_arg_1:DimmerView, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, _arg_4:int=0, _arg_5:int=0xFF)
        {
            _view = _arg_1;
            _sliderContainer = _arg_2;
            _minValue = _arg_4;
            _maxValue = _arg_5;
            storeAssets(_arg_3);
            displaySlider();
        }

        public function dispose():void
        {
            _view = null;
            _sliderContainer = null;
            _sliderBase = null;
            _sliderButton = null;
        }

        public function setValue(_arg_1:int):void
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

        public function set min(_arg_1:Number):void
        {
            _minValue = _arg_1;
            setValue(_view.selectedBrightness);
        }

        public function set max(_arg_1:Number):void
        {
            _maxValue = _arg_1;
            setValue(_view.selectedBrightness);
        }

        private function getSliderPosition(_arg_1:int):int
        {
            return (int((_referenceWidth * ((_arg_1 - _minValue) / (_maxValue - _minValue)))));
        }

        private function getValue(_arg_1:Number):int
        {
            return (int(((_arg_1 / _referenceWidth) * (_maxValue - _minValue))) + _minValue);
        }

        private function buttonProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (((!(_arg_1.type == "WME_UP")) && (!(_arg_1.type == "WME_UP_OUTSIDE"))))
            {
                return;
            };

            _view.selectedBrightness = getValue(_arg_2.x);
        }

        private function displaySlider():void
        {
            var _local_2:IWindowContainer;
            var _local_1:IBitmapWrapperWindow;

            if (_sliderContainer == null)
            {
                return;
            };

            _local_1 = (_sliderContainer.findChildByName("slider_base") as IBitmapWrapperWindow);

            if (((!(_local_1 == null)) && (!(_sliderBase == null))))
            {
                _local_1.bitmap = new BitmapData(_sliderBase.width, _sliderBase.height, true, 0xFFFFFF);
                _local_1.bitmap.copyPixels(_sliderBase, _sliderBase.rect, new Point(0, 0), null, null, true);
            };

            _local_2 = (_sliderContainer.findChildByName("slider_movement_area") as IWindowContainer);

            if (_local_2 != null)
            {
                _local_1 = (_local_2.findChildByName("slider_button") as IBitmapWrapperWindow);

                if (((!(_local_1 == null)) && (!(_sliderButton == null))))
                {
                    _local_1.bitmap = new BitmapData(_sliderButton.width, _sliderButton.height, true, 0xFFFFFF);
                    _local_1.bitmap.copyPixels(_sliderButton, _sliderButton.rect, new Point(0, 0), null, null, true);
                    _local_1.procedure = buttonProcedure;
                    _referenceWidth = (_local_2.width - _local_1.width);
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

            _local_2 = BitmapDataAsset(_arg_1.getAssetByName("dimmer_slider_base"));
            _sliderBase = BitmapData(_local_2.content);
            _local_2 = BitmapDataAsset(_arg_1.getAssetByName("dimmer_slider_button"));
            _sliderButton = BitmapData(_local_2.content);
        }

    }
}
