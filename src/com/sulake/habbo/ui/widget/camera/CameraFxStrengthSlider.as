package com.sulake.habbo.ui.widget.camera
{
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

    public class CameraFxStrengthSlider 
    {

        private var _view:CameraPhotoLab;
        private var _sliderContainer:IWindowContainer;
        private var _sliderBase:BitmapData;
        private var _sliderButton:BitmapData;
        private var _activeBaseArea:IBitmapWrapperWindow;
        private var _sliderBaseWidth:int;
        private var _referenceWidth:int;
        private var _referenceX:int = 0;

        public function CameraFxStrengthSlider(_arg_1:CameraPhotoLab, _arg_2:IWindowContainer, _arg_3:IAssetLibrary)
        {
            _view = _arg_1;
            _sliderContainer = _arg_2;
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

        public function disable():void
        {
            _sliderContainer.visible = false;
        }

        public function enable():void
        {
            _sliderContainer.visible = true;
        }

        public function getScale():int
        {
            return (_referenceWidth);
        }

        public function setValue(_arg_1:int):void
        {
            var _local_2:IWindow;

            if (_sliderContainer != null)
            {
                _local_2 = _sliderContainer.findChildByName("slider_button");

                if (_local_2 != null)
                {
                    _local_2.x = _arg_1;
                };
            };
        }

        private function buttonProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type == "WE_RELOCATED")
            {
                if (_activeBaseArea)
                {
                    _activeBaseArea.width = ((_arg_2.x / _referenceWidth) * _sliderBaseWidth);
                };
            }

            else
            {
                if (((_arg_1.type == "WME_UP") || (_arg_1.type == "WME_UP_OUTSIDE")))
                {
                    _view.setSelectedFxValue(_arg_2.x);
                };
            };
        }

        private function shaftProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:int;

            if (((_arg_1.type == "WME_DOWN") && (_arg_2.name == "shaft_click_area")))
            {
                _local_3 = (WindowMouseEvent(_arg_1).localX - _referenceX);
                setValue(_local_3);
                _view.setSelectedFxValue(_local_3);
            };
        }

        private function displaySlider():void
        {
            var _local_3:IWindowContainer;
            var _local_2:IBitmapWrapperWindow;

            if (_sliderContainer == null)
            {
                return;
            };

            var _local_1:IRegionWindow = (_sliderContainer.findChildByName("shaft_click_area") as IRegionWindow);

            if (_local_1)
            {
                _local_1.procedure = shaftProcedure;
            };

            _local_2 = (_sliderContainer.findChildByName("slider_base") as IBitmapWrapperWindow);

            if (((!(_local_2 == null)) && (!(_sliderBase == null))))
            {
                _sliderBaseWidth = _local_2.width;
                _local_2.bitmap = new BitmapData(_sliderBase.width, _sliderBase.height, true, 0xFFFFFF);
                _local_2.bitmap.copyPixels(_sliderBase, _sliderBase.rect, new Point(0, 0), null, null, true);
                _activeBaseArea = _local_2;
            };

            _local_3 = (_sliderContainer.findChildByName("slider_movement_area") as IWindowContainer);

            if (_local_3 != null)
            {
                _local_2 = (_local_3.findChildByName("slider_button") as IBitmapWrapperWindow);

                if (((!(_local_2 == null)) && (!(_sliderButton == null))))
                {
                    _local_2.bitmap = new BitmapData(_sliderButton.width, _sliderButton.height, true, 0xFFFFFF);
                    _local_2.bitmap.copyPixels(_sliderButton, _sliderButton.rect, new Point(0, 0), null, null, true);
                    _local_2.procedure = buttonProcedure;
                    _referenceWidth = (_local_3.width - _local_2.width);
                    _referenceX = ((_sliderBaseWidth - _referenceWidth) / 2);
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

            _local_2 = BitmapDataAsset(_arg_1.getAssetByName("camera_fx_slider_bottom_active"));
            _sliderBase = BitmapData(_local_2.content);
            _local_2 = BitmapDataAsset(_arg_1.getAssetByName("camera_fx_slider_button"));
            _sliderButton = BitmapData(_local_2.content);
        }

    }
}
