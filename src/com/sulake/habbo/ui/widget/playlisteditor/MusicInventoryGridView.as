package com.sulake.habbo.ui.widget.playlisteditor
{
    import com.sulake.habbo.sound.IHabboMusicController;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.sound.ISongInfo;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;

    public class MusicInventoryGridView 
    {

        private var _musicController:IHabboMusicController;
        private var _itemGridWindow:IItemGridWindow;
        private var _items:Map = new Map();
        private var _widget:PlayListEditorWidget;
        private var _selectedItem:MusicInventoryGridItem;

        public function MusicInventoryGridView(_arg_1:PlayListEditorWidget, _arg_2:IItemGridWindow, _arg_3:IHabboMusicController)
        {
            _musicController = _arg_3;
            _itemGridWindow = _arg_2;
            _widget = _arg_1;
            _selectedItem = null;
            _musicController.events.addEventListener("SIR_TRAX_SONG_INFO_RECEIVED", onSongInfoReceivedEvent);
        }

        public function get itemCount():int
        {
            return (_items.length);
        }

        public function destroy():void
        {
            if (_itemGridWindow != null)
            {
                _itemGridWindow.destroyGridItems();
                _itemGridWindow = null;
            };

            if (_musicController != null)
            {
                if (_musicController.events != null)
                {
                    _musicController.events.removeEventListener("SIR_TRAX_SONG_INFO_RECEIVED", onSongInfoReceivedEvent);
                };

                _musicController = null;
            };

            if (_items)
            {
                _items.reset();
                _items = null;
            };

            _selectedItem = null;
            _widget = null;
        }

        public function refresh():void
        {
            var _local_4:int;
            var _local_9:int;
            var _local_11:int;
            var _local_12:ISongInfo;
            var _local_1:String;
            var _local_13:ColorTransform;
            var _local_3:MusicInventoryGridItem;
            var _local_7:MusicInventoryGridItem;

            if (_itemGridWindow == null)
            {
                return;
            };

            _itemGridWindow.removeGridItems();

            var _local_8:Map = _items;
            var _local_2:Map = new Map();
            var _local_5:Array = _local_8.getKeys();
            _items = new Map();

            var _local_6:int = _musicController.getSongDiskInventorySize();
            _local_4 = 0;

            while (_local_4 < _local_6)
            {
                _local_9 = _musicController.getSongDiskInventoryDiskId(_local_4);
                _local_11 = _musicController.getSongDiskInventorySongId(_local_4);
                _local_12 = _musicController.getSongInfo(_local_11);
                _local_1 = null;
                _local_13 = null;

                if (_local_12 != null)
                {
                    _local_1 = _local_12.name;
                    _local_13 = _widget.getDiskColorTransformFromSongData(_local_12.songData);
                };

                if (_local_5.indexOf(_local_9) == -1)
                {
                    _local_3 = new MusicInventoryGridItem(_widget, _local_9, _local_11, _local_1, _local_13);
                }

                else
                {
                    _local_3 = _local_8[_local_9];
                    _local_5.splice(_local_5.indexOf(_local_9), 1);
                };

                _local_3.window.procedure = gridItemEventProc;
                _local_3.toPlayListButton.procedure = gridItemEventProc;
                _itemGridWindow.addGridItem(_local_3.window);
                _items.add(_local_9, _local_3);
                _local_4++;
            };

            for each (var _local_10:int in _local_5)
            {
                _local_7 = _local_8[_local_10];
                _local_7.destroy();
                _local_8.remove(_local_10);
            };
        }

        public function setPreviewIconToPause():void
        {
            if (_selectedItem != null)
            {
                _selectedItem.playButtonState = 1;
            };
        }

        public function setPreviewIconToPlay():void
        {
            if (_selectedItem != null)
            {
                _selectedItem.playButtonState = 0;
            };
        }

        public function deselectAny():void
        {
            if (_selectedItem != null)
            {
                _selectedItem.deselect();
                _selectedItem = null;
            };
        }

        private function gridItemEventProc(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_4:int;
            var _local_5:MusicInventoryGridItem;
            var _local_3:Boolean = (_arg_1.type == "WME_DOUBLE_CLICK");

            if (((_arg_1.type == "WME_CLICK") || (_local_3)))
            {
                if (((_arg_2.name == "button_to_playlist") || (_local_3)))
                {
                    if (_selectedItem != null)
                    {
                        _selectedItem.deselect();
                        stopPreview();
                        _widget.sendAddToPlayListMessage(_selectedItem.diskId);
                        _selectedItem = null;
                    };
                }

                else
                {
                    if (_arg_2.name == "button_play_pause")
                    {
                        if (_selectedItem.playButtonState == 0)
                        {
                            _selectedItem.playButtonState = 2;
                            _widget.playUserSong(_selectedItem.songId);
                        }

                        else
                        {
                            stopPreview();
                        };
                    }

                    else
                    {
                        _local_4 = _itemGridWindow.getGridItemIndex(_arg_1.window);

                        if (_local_4 != -1)
                        {
                            _local_5 = _items.getWithIndex(_local_4);

                            if (_local_5 != _selectedItem)
                            {
                                if (_selectedItem != null)
                                {
                                    _selectedItem.deselect();
                                };

                                _selectedItem = _local_5;
                                _selectedItem.select();
                                stopPreview();
                            };

                            if (_widget.mainWindowHandler != null)
                            {
                                _widget.mainWindowHandler.playListEditorView.deselectAny();
                            };
                        };
                    };
                };
            };
        }

        private function stopPreview():void
        {
            _widget.stopUserSong();
            setPreviewIconToPlay();
        }

        private function onSongInfoReceivedEvent(_arg_1:SongInfoReceivedEvent):void
        {
            var _local_4:ISongInfo;
            var _local_2:String;
            var _local_5:ColorTransform;
            var _local_3:MusicInventoryGridItem;

            if (_musicController != null)
            {
                _local_4 = _musicController.getSongInfo(_arg_1.id);

                if (_local_4 != null)
                {
                    _local_2 = _local_4.name;
                    _local_5 = _widget.getDiskColorTransformFromSongData(_local_4.songData);
                    _local_3 = _items[_arg_1.id];

                    if (_local_3 != null)
                    {
                        _local_3.update(_arg_1.id, _local_2, _local_5);
                    };
                };
            };
        }

    }
}
