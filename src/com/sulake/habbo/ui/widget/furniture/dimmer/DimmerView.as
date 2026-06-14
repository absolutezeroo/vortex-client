package com.sulake.habbo.ui.widget.furniture.dimmer
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.geom.Point;
    import com.sulake.core.window.components._SafeStr_108;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.assets.XmlAsset;

    public class DimmerView 
    {

        private static const _SafeStr_4079:Number = 100;
        private static const _SafeStr_4080:Number = 100;

        private var _window:IWindowContainer;
        private var _tabContext:ITabContextWindow;
        private var _windowXML:XML;
        private var _widget:DimmerFurniWidget;
        private var _colorGrid:DimmerViewColorGrid;
        private var _alphaSlider:DimmerViewAlphaSlider;
        private var _selectedBrightness:int;
        private var _selectedColorIndex:int;
        private var _selectedType:int;

        public function DimmerView(_arg_1:DimmerFurniWidget)
        {
            _widget = _arg_1;
        }

        public function get selectedBrightness():int
        {
            return (_selectedBrightness);
        }

        public function get selectedColorIndex():int
        {
            return (_selectedColorIndex);
        }

        public function get selectedType():int
        {
            return (_selectedType);
        }

        public function dispose():void
        {
            hideInterface();
            _widget = null;
        }

        public function showInterface():void
        {
            if (_window == null)
            {
                createWindow();
            };

            selectPreset(_widget.selectedPresetIndex);
            update();
        }

        public function update():void
        {
            var _local_2:String;

            if (((_window == null) || (_widget == null)))
            {
                return;
            };

            var _local_1:Boolean = (_widget.dimmerState == 1);
            var _local_3:IWindow = _window.findChildByName("on_off_button");

            if (_local_3 != null)
            {
                _local_2 = ((_local_1) ? "${widget.dimmer.button.off}" : "${widget.dimmer.button.on}");
                _local_3.caption = _local_2;
            };

            _local_3 = _window.findChildByName("tabbedview");

            if (_local_3 != null)
            {
                _local_3.visible = _local_1;
            };

            _local_3 = _window.findChildByName("apply_button");

            if (_local_3 != null)
            {
                ((_local_1) ? _local_3.enable() : _local_3.disable());
            };

            _local_3 = _window.findChildByName("off_border");

            if (_local_3)
            {
                _local_3.visible = (!(_local_1));
            };
        }

        public function hideInterface():void
        {
            if (_widget != null)
            {
                _widget.removePreview();
            };

            if (_colorGrid != null)
            {
                _colorGrid.dispose();
                _colorGrid = null;
            };

            if (_alphaSlider != null)
            {
                _alphaSlider.dispose();
                _alphaSlider = null;
            };

            _tabContext = null;

            if (_window != null)
            {
                _window.dispose();
                _window = null;
            };
        }

        private function createWindow():void
        {
            var _local_4:IWindow;
            var _local_5:IWindow;
            var _local_6:int;
            var _local_1:ITabButtonWindow;
            var _local_3:BitmapData;

            if ((((_widget == null) || (_widget.windowManager == null)) || (windowXML == null)))
            {
                return;
            };

            _window = (_widget.windowManager.createWindow("dimmerui_container", "", 4, 0, (0x020000 | 0x01), new Rectangle(100, 100, 2, 2), null, 0) as IWindowContainer);
            _window.buildFromXML(windowXML);
            _local_4 = _window.findChildByTag("close");

            if (_local_4 != null)
            {
                _local_4.procedure = onWindowClose;
            };

            _local_4 = _window.findChildByName("color_grid_container");

            if (_local_4 != null)
            {
                _local_5 = (_local_4 as IWindowContainer).findChildByName("color_grid");

                if (_local_5 != null)
                {
                    _colorGrid = new DimmerViewColorGrid(this, (_local_5 as IItemGridWindow), _widget.windowManager, _widget.assets);
                };
            };

            _local_4 = _window.findChildByName("brightness_container");

            if (_local_4 != null)
            {
                _alphaSlider = new DimmerViewAlphaSlider(this, (_local_4 as IWindowContainer), _widget.assets);
            };

            _tabContext = ITabContextWindow(_window.findChildByName("tab_context"));
            selectTab(_widget.selectedPresetIndex);
            _local_6 = 0;

            while (_local_6 < _tabContext.numTabItems)
            {
                _local_1 = _tabContext.getTabItemAt(_local_6);
                _local_1.setParamFlag(1, true);
                _local_1.procedure = onTabClick;
                _local_6++;
            };

            _local_4 = _window.findChildByName("type_checkbox");

            if (_local_4 != null)
            {
                _local_4.addEventListener("WME_CLICK", onMouseEvent);
            };

            _local_4 = _window.findChildByName("apply_button");

            if (_local_4 != null)
            {
                _local_4.addEventListener("WME_CLICK", onMouseEvent);
            };

            _local_4 = _window.findChildByName("on_off_button");

            if (_local_4 != null)
            {
                _local_4.addEventListener("WME_CLICK", onMouseEvent);
            };

            var _local_2:IBitmapWrapperWindow = (_window.findChildByName("off_image") as IBitmapWrapperWindow);
            var _local_7:BitmapDataAsset = (_widget.assets.getAssetByName("dimmer_info") as BitmapDataAsset);

            if (((!(_local_2 == null)) && (!(_local_7 == null))))
            {
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height);
                _local_3 = (_local_7.content as BitmapData);

                if (_local_3 != null)
                {
                    _local_2.bitmap.copyPixels(_local_3, _local_3.rect, new Point(0, 0));
                };
            };
        }

        private function onMouseEvent(_arg_1:WindowMouseEvent):void
        {
            var _local_3:_SafeStr_108;
            var _local_2:IWindow = (_arg_1.target as IWindow);
            var _local_4:String = _local_2.name;
            switch (_local_4)
            {
                case "type_checkbox":
                    _local_3 = (_arg_1.target as _SafeStr_108);

                    if (_local_3 == null)
                    {
                        return;
                    };

                    if (_local_3.isSelected)
                    {
                        selectedType = 2;
                    }

                    else
                    {
                        selectedType = 1;
                    };

                    _widget.previewCurrentSetting();
                    return;
                case "apply_button":
                    _widget.storeCurrentSetting(true);
                    return;
                case "cancel":
                case "close":
                    hideInterface();
                    return;
                case "on_off_button":
                    _widget.changeRoomDimmerState();
                    return;
            };
        }

        private function onTabClick(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WE_SELECTED")
            {
                return;
            };

            _widget.storeCurrentSetting(false);

            var _local_3:int = _arg_2.id;
            selectPreset(_local_3);
        }

        private function onWindowClose(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            hideInterface();
        }

        private function selectPreset(_arg_1:int):void
        {
            if (((((_widget == null) || (_widget.presets == null)) || (_arg_1 < 0)) || (_arg_1 >= _widget.presets.length)))
            {
                return;
            };

            _widget.selectedPresetIndex = _arg_1;

            var _local_2:DimmerFurniWidgetPresetItem = _widget.presets[_arg_1];

            if (_local_2 == null)
            {
                return;
            };

            selectTab(_arg_1);
            _selectedBrightness = _local_2.light;

            if (_alphaSlider != null)
            {
                _alphaSlider.setValue(_selectedBrightness);
            };

            _selectedColorIndex = colors.indexOf(_local_2.color);

            if (_colorGrid != null)
            {
                _colorGrid.setSelectedColorIndex(_selectedColorIndex);
            };

            selectedType = _local_2.type;
            _widget.previewCurrentSetting();
        }

        private function selectTab(_arg_1:int):void
        {
            if (_tabContext == null)
            {
                return;
            };

            var _local_2:IWindow = _tabContext.getTabItemAt(_arg_1);

            if (_local_2 != null)
            {
                _tabContext.selector.setSelected((_local_2 as ISelectableWindow));
            };
        }

        private function getSelectedTabIndex():int
        {
            if (_tabContext == null)
            {
                return (-1);
            };

            var _local_1:ISelectableWindow = _tabContext.selector.getSelected();
            return (_tabContext.selector.getSelectableIndex(_local_1));
        }

        private function get windowXML():XML
        {
            if (_windowXML != null)
            {
                return (_windowXML);
            };

            if ((((_widget == null) || (_widget.assets == null)) || (_widget.assets.getAssetByName("dimmer_ui") == null)))
            {
                return (null);
            };

            var _local_1:XmlAsset = XmlAsset(_widget.assets.getAssetByName("dimmer_ui"));
            _windowXML = XML(_local_1.content);
            return (_windowXML);
        }

        public function get colors():Array
        {
            if (_widget == null)
            {
                return (null);
            };

            return (_widget.colors);
        }

        public function set selectedType(_arg_1:int):void
        {
            if (((!(_arg_1 == 1)) && (!(_arg_1 == 2))))
            {
                return;
            };

            _selectedType = _arg_1;

            var _local_2:_SafeStr_108 = (_window.findChildByName("type_checkbox") as _SafeStr_108);

            if (_local_2 != null)
            {
                if (_arg_1 == 2)
                {
                    _local_2.select();
                }

                else
                {
                    _local_2.unselect();
                };
            };

            if (_alphaSlider != null)
            {
                _alphaSlider.min = _widget.minLights[(_arg_1 - 1)];
            };
        }

        public function set selectedColorIndex(_arg_1:int):void
        {
            _selectedColorIndex = _arg_1;

            if (_colorGrid != null)
            {
                _colorGrid.setSelectedColorIndex(_arg_1);
            };

            _widget.previewCurrentSetting();
        }

        public function set selectedBrightness(_arg_1:int):void
        {
            _selectedBrightness = _arg_1;

            if (_alphaSlider != null)
            {
                _alphaSlider.setValue(_arg_1);
            };

            _widget.previewCurrentSetting();
        }

    }
}
