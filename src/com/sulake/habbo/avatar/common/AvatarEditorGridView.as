package com.sulake.habbo.avatar.common
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IScrollableGridWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

    public class AvatarEditorGridView implements IAvatarEditorGridView 
    {

        public static const REMOVE_ITEM:String = "REMOVE_ITEM";
        public static const GET_MORE:String = "GET_MORE";

        private const MAX_COLOR_LAYERS:int = 2;

        private var _view:IWindowContainer;
        private var _model:IAvatarEditorCategoryModel;
        private var _partGrid:IItemGridWindow;
        private var _paletteGrids:Array;
        private var _categoryId:String;
        private var _notification:IWindow;
        private var _title:IWindow;

        public function AvatarEditorGridView(_arg_1:IWindowContainer)
        {
            _view = _arg_1;
            _partGrid = (_view.findChildByName("thumbs") as IItemGridWindow);
            _paletteGrids = [];
            _paletteGrids.push((_view.findChildByName("palette0") as IItemGridWindow));
            _paletteGrids.push((_view.findChildByName("palette1") as IItemGridWindow));
            _notification = _view.findChildByName("content_notification");
            _title = _view.findChildByName("content_title");
            _notification.visible = false;
            _title.visible = false;
        }

        public function dispose():void
        {
            if (_partGrid)
            {
                _partGrid.dispose();
                _partGrid = null;
            };

            if (_paletteGrids)
            {
                for each (var _local_1:IItemGridWindow in _paletteGrids)
                {
                    if (_local_1 != null)
                    {
                        _local_1.dispose();
                        _local_1 = null;
                    };
                };

                _paletteGrids = null;
            };

            _model = null;

            if (_view)
            {
                _view.dispose();
                _view = null;
            };
        }

        public function get window():IWindowContainer
        {
            if (_view == null)
            {
                return (null);
            };

            if (_view.disposed)
            {
                return (null);
            };

            return (_view);
        }

        public function initFromList(_arg_1:IAvatarEditorCategoryModel, _arg_2:String):void
        {
            var _local_3:int;
            var _local_6:Array;
            var _local_4:CategoryData = _arg_1.getCategoryData(_arg_2);

            if (!_local_4)
            {
                return;
            };

            _view.visible = true;
            _model = _arg_1;
            _categoryId = _arg_2;
            _partGrid.removeGridItems();

            if (_local_4.parts.length == 0)
            {
                _title.visible = true;
                _notification.visible = true;
            }

            else
            {
                _title.visible = false;
                _notification.visible = false;

                for each (var _local_8:IItemGridWindow in _paletteGrids)
                {
                    _local_8.removeGridItems();
                };

                for each (var _local_5:AvatarEditorGridPartItem in _local_4.parts)
                {
                    if (_local_5)
                    {
                        _partGrid.addGridItem(_local_5.view);
                        _local_5.view.addEventListener("WME_CLICK", onGridItemClicked);

                        if (_local_5.isSelected)
                        {
                            showPalettes(_local_5.colorLayerCount);
                        };
                    };
                };

                _local_3 = 0;

                while (_local_3 < 2)
                {
                    _local_6 = _local_4.getPalette(_local_3);
                    _local_8 = (_paletteGrids[_local_3] as IItemGridWindow);

                    if (!((!(_local_6)) || (!(_local_8))))
                    {
                        for each (var _local_7:AvatarEditorGridColorItem in _local_6)
                        {
                            _local_8.addGridItem(_local_7.view);
                            _local_7.view.procedure = paletteEventProc;
                        };
                    };

                    _local_3++;
                };
            };
        }

        public function showPalettes(_arg_1:int):void
        {
            var _local_4:IScrollableGridWindow = (_view.findChildByName("palette0") as IScrollableGridWindow);
            var _local_3:IScrollableGridWindow = (_view.findChildByName("palette1") as IScrollableGridWindow);
            var _local_5:int = _partGrid.width;
            var _local_2:int = int(((_partGrid.width - 10) / 2));

            if (_arg_1 <= 1)
            {
                _local_4.width = _local_5;
                _local_4.visible = true;
                _local_3.visible = false;
            }

            else
            {
                _local_4.width = _local_2;
                _local_3.width = _local_2;
                _local_3.x = (_local_4.right + 10);
                _local_4.visible = true;
                _local_3.visible = true;
            };
        }

        public function updatePart(_arg_1:int, _arg_2:IWindowContainer):void
        {
            var _local_3:IWindow = _partGrid.getGridItemAt(_arg_1);

            if (!_local_3)
            {
                return;
            };

            _local_3 = _arg_2;
        }

        private function onGridItemClicked(_arg_1:WindowMouseEvent):void
        {
            var _local_2:int;
            switch (_arg_1.target.name)
            {
                case "REMOVE_ITEM":
                    _local_2 = _partGrid.getGridItemIndex(_arg_1.window);
                    _model.selectPart(_categoryId, _local_2);
                    return;
                case "GET_MORE":
                    _model.controller.manager.catalog.openCatalogPage(_model.controller.manager.getProperty("catalog.clothes.page"));
                    return;
                default:
                    _local_2 = _partGrid.getGridItemIndex(_arg_1.window);
                    _model.selectPart(_categoryId, _local_2);
                    return;
            };
        }

        private function paletteEventProc(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_5:int;
            var _local_4:IItemGridWindow;
            var _local_7:int;
            var _local_3:IWindow;
            var _local_6:int;

            if (_arg_1.type == "WME_CLICK")
            {
                _local_3 = _arg_1.window;
                _local_6 = 0;

                while (_local_6 < 2)
                {
                    if (_paletteGrids.length > _local_6)
                    {
                        _local_4 = (_paletteGrids[_local_6] as IItemGridWindow);
                        _local_7 = _local_4.getGridItemIndex(_local_3);

                        if (_local_7 > -1)
                        {
                            _model.selectColor(_categoryId, _local_7, _local_6);
                            return;
                        };
                    };

                    _local_6++;
                };
            };
        }

    }
}
