package com.sulake.habbo.ui.widget.playlisteditor
{
    import com.sulake.core.window.components.IItemListWindow;
    import flash.geom.ColorTransform;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

    public class PlayListEditorItemListView 
    {

        private var _itemListWindow:IItemListWindow;
        private var _items:Array;
        private var _widget:PlayListEditorWidget;
        private var _selectedItem:PlayListEditorItem;
        private var _selectedItemIndex:int = -1;
        private var _previousItemPlaying:int = -1;

        public function PlayListEditorItemListView(_arg_1:PlayListEditorWidget, _arg_2:IItemListWindow)
        {
            _itemListWindow = _arg_2;
            _widget = _arg_1;
            _selectedItem = null;
        }

        public function get selectedItemIndex():int
        {
            return (_selectedItemIndex);
        }

        public function destroy():void
        {
            if (_itemListWindow == null)
            {
                return;
            };

            _itemListWindow.destroyListItems();
        }

        public function refresh(_arg_1:Array, _arg_2:int):void
        {
            var _local_3:String;
            var _local_7:String;
            var _local_5:ColorTransform;
            var _local_4:PlayListEditorItem;

            if (_itemListWindow == null)
            {
                return;
            };

            if (_arg_1 == null)
            {
                return;
            };

            _previousItemPlaying = -1;
            _items = [];
            _itemListWindow.destroyListItems();

            for each (var _local_6:ISongInfo in _arg_1)
            {
                _local_3 = _local_6.name;
                _local_7 = _local_6.creator;
                _local_5 = _widget.getDiskColorTransformFromSongData(_local_6.songData);
                _local_4 = new PlayListEditorItem(_widget, _local_3, _local_7, _local_5);
                _local_4.window.procedure = itemEventProc;
                _local_4.removeButton.procedure = itemEventProc;
                _itemListWindow.addListItem(_local_4.window);
                _items.push(_local_4);
            };

            setItemIndexPlaying(_arg_2);
        }

        public function setItemIndexPlaying(_arg_1:int):void
        {
            var _local_2:PlayListEditorItem;

            if (_items == null)
            {
                return;
            };

            if (_arg_1 < 0)
            {
                for each (var _local_3:PlayListEditorItem in _items)
                {
                    _local_3.setIconState("PLEI_ICON_STATE_NORMAL");
                };

                return;
            };

            if (_arg_1 >= _items.length)
            {
                return;
            };

            if (((_previousItemPlaying >= 0) && (_previousItemPlaying < _items.length)))
            {
                _local_2 = (_items[_previousItemPlaying] as PlayListEditorItem);
                _local_2.setIconState("PLEI_ICON_STATE_NORMAL");
            };

            _local_2 = (_items[_arg_1] as PlayListEditorItem);
            _local_2.setIconState("PLEI_ICON_STATE_PLAYING");
            _previousItemPlaying = _arg_1;
        }

        public function deselectAny():void
        {
            if (_selectedItem != null)
            {
                _selectedItem.deselect();
                _selectedItem = null;
                _selectedItemIndex = -1;
            };
        }

        private function itemEventProc(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_4:int;
            var _local_3:Boolean = (_arg_1.type == "WME_DOUBLE_CLICK");

            if (((_arg_1.type == "WME_CLICK") || (_local_3)))
            {
                if (((_arg_2.name == "button_remove_from_playlist") || (_local_3)))
                {
                    if (_selectedItem != null)
                    {
                        _selectedItem.deselect();
                    };

                    if (_selectedItemIndex > -1)
                    {
                        _widget.sendRemoveFromPlayListMessage(_selectedItemIndex);
                    };

                    _selectedItem = null;
                    _selectedItemIndex = -1;
                }

                else
                {
                    if (_selectedItem != null)
                    {
                        _selectedItem.deselect();
                    };

                    _local_4 = _itemListWindow.getListItemIndex(_arg_1.window);

                    if (_local_4 != -1)
                    {
                        _selectedItemIndex = _local_4;
                        _selectedItem = _items[_local_4];
                        _selectedItem.select();

                        if (_arg_2.name == "button_remove_from_playlist")
                        {
                            _widget.sendRemoveFromPlayListMessage(_local_4);
                        };

                        if (_widget.mainWindowHandler != null)
                        {
                            _widget.mainWindowHandler.musicInventoryView.deselectAny();
                        };
                    };
                };
            };
        }

    }
}
