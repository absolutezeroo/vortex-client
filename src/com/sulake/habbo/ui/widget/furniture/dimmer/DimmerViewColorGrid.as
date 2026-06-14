package com.sulake.habbo.ui.widget.furniture.dimmer
{
    import com.sulake.core.window.components.IItemGridWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.assets.BitmapDataAsset;

    public class DimmerViewColorGrid 
    {

        private var _gridWindow:IItemGridWindow;
        private var _view:DimmerView;
        private var _colorCellXML:XML;
        private var _colorCellFrame:BitmapData;
        private var _colorCellButton:BitmapData;
        private var _colorCellSelected:BitmapData;
        private var _selectedGridItem:IWindowContainer;

        public function DimmerViewColorGrid(_arg_1:DimmerView, _arg_2:IItemGridWindow, _arg_3:IHabboWindowManager, _arg_4:IAssetLibrary)
        {
            _view = _arg_1;
            _gridWindow = _arg_2;
            storeAssets(_arg_4);
            populate(_arg_3);
        }

        public function dispose():void
        {
            _view = null;
            _gridWindow = null;
            _colorCellXML = null;
            _colorCellFrame = null;
            _colorCellButton = null;
            _colorCellSelected = null;
        }

        public function setSelectedColorIndex(_arg_1:int):void
        {
            if (_gridWindow == null)
            {
                return;
            };

            if (((_arg_1 < 0) || (_arg_1 >= _gridWindow.numGridItems)))
            {
                return;
            };

            select((_gridWindow.getGridItemAt(_arg_1) as IWindowContainer));
        }

        private function populate(_arg_1:IHabboWindowManager):void
        {
            if (((_view == null) || (_gridWindow == null)))
            {
                return;
            };

            populateColourGrid(_arg_1);
        }

        private function select(_arg_1:IWindowContainer):void
        {
            var _local_2:IWindow;

            if (_selectedGridItem != null)
            {
                _local_2 = _selectedGridItem.getChildByName("chosen");

                if (_local_2 != null)
                {
                    _local_2.visible = false;
                };
            };

            _selectedGridItem = _arg_1;
            _local_2 = _selectedGridItem.getChildByName("chosen");

            if (_local_2 != null)
            {
                _local_2.visible = true;
            };
        }

        private function populateColourGrid(_arg_1:IHabboWindowManager):void
        {
            var _local_4:IWindowContainer;
            var _local_8:IBitmapWrapperWindow;
            var _local_14:IBitmapWrapperWindow;
            var _local_11:uint;
            var _local_3:uint;
            var _local_2:uint;
            var _local_7:Number;
            var _local_12:Number;
            var _local_5:Number;
            var _local_13:ColorTransform;
            var _local_6:BitmapData = null;
            var _local_9:IBitmapWrapperWindow;
            _gridWindow.destroyGridItems();
            _selectedGridItem = null;

            for each (var _local_10:uint in colors)
            {
                _local_4 = (_arg_1.buildFromXML(_colorCellXML) as IWindowContainer);
                _local_4.addEventListener("WME_CLICK", onClick);
                _local_4.background = true;
                _local_4.color = 0xFFFFFFFF;
                _local_4.width = _colorCellFrame.width;
                _local_4.height = _colorCellFrame.height;
                _gridWindow.addGridItem(_local_4);
                _local_8 = (_local_4.findChildByTag("BG_BORDER") as IBitmapWrapperWindow);

                if (_local_8 != null)
                {
                    _local_8.bitmap = new BitmapData(_colorCellFrame.width, _colorCellFrame.height, true, 0);
                    _local_8.bitmap.copyPixels(_colorCellFrame, _colorCellFrame.rect, new Point(0, 0));
                };

                _local_14 = (_local_4.findChildByTag("COLOR_IMAGE") as IBitmapWrapperWindow);

                if (_local_14 != null)
                {
                    _local_14.bitmap = new BitmapData(_colorCellButton.width, _colorCellButton.height, true, 0);
                    _local_11 = ((_local_10 >> 16) & 0xFF);
                    _local_3 = ((_local_10 >> 8) & 0xFF);
                    _local_2 = ((_local_10 >> 0) & 0xFF);
                    _local_7 = ((_local_11 / 0xFF) * 1);
                    _local_12 = ((_local_3 / 0xFF) * 1);
                    _local_5 = ((_local_2 / 0xFF) * 1);
                    _local_13 = new ColorTransform(_local_7, _local_12, _local_5);
                    _local_6 = _colorCellButton.clone();
                    _local_6.colorTransform(_local_6.rect, _local_13);
                    _local_14.bitmap.copyPixels(_local_6, _local_6.rect, new Point(0, 0));
                };

                _local_9 = (_local_4.findChildByTag("COLOR_CHOSEN") as IBitmapWrapperWindow);

                if (_local_9 != null)
                {
                    _local_9.bitmap = new BitmapData(_colorCellSelected.width, _colorCellSelected.height, true, 0xFFFFFF);
                    _local_9.bitmap.copyPixels(_colorCellSelected, _colorCellSelected.rect, new Point(0, 0), null, null, true);
                    _local_9.visible = false;
                };
            };
        }

        private function onClick(_arg_1:WindowMouseEvent):void
        {
            var _local_2:int = _gridWindow.getGridItemIndex((_arg_1.target as IWindow));
            setSelectedColorIndex(_local_2);
            _view.selectedColorIndex = _local_2;
        }

        private function storeAssets(_arg_1:IAssetLibrary):void
        {
            var _local_2:XmlAsset;
            var _local_3:BitmapDataAsset;

            if (_arg_1 == null)
            {
                return;
            };

            _local_2 = XmlAsset(_arg_1.getAssetByName("dimmer_color_chooser_cell"));
            _colorCellXML = XML(_local_2.content);
            _local_3 = BitmapDataAsset(_arg_1.getAssetByName("dimmer_color_frame"));
            _colorCellFrame = BitmapData(_local_3.content);
            _local_3 = BitmapDataAsset(_arg_1.getAssetByName("dimmer_color_button"));
            _colorCellButton = BitmapData(_local_3.content);
            _local_3 = BitmapDataAsset(_arg_1.getAssetByName("dimmer_color_selected"));
            _colorCellSelected = BitmapData(_local_3.content);
        }

        private function get colors():Array
        {
            if (_view == null)
            {
                return ([]);
            };

            return (_view.colors);
        }

    }
}
