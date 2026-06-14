package com.sulake.habbo.ui.widget.playlisteditor
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components._SafeStr_101;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class MusicInventoryStatusView 
    {

        public static const BUY_MORE:String = "MISV_BUY_MORE";
        public static const PREVIEW_PLAYING:String = "MISV_PREVIEW_PLAYING";

        private var _container:IWindowContainer;
        private var _windows:Map = new Map();
        private var _widget:PlayListEditorWidget;
        private var _currentView:String;
        private var _songNameElement:ITextWindow;
        private var _songAuthorElement:ITextWindow;

        public function MusicInventoryStatusView(_arg_1:PlayListEditorWidget, _arg_2:IWindowContainer)
        {
            _container = _arg_2;
            _widget = _arg_1;
            createWindows();
            hide();
        }

        public function destroy():void
        {
            for each (var _local_1:IWindowContainer in _windows.getValues())
            {
                _local_1.destroy();
            };

            _windows = null;
        }

        public function show():void
        {
            _container.visible = true;
        }

        public function hide():void
        {
            _container.visible = false;
        }

        public function selectView(_arg_1:String):void
        {
            _container.removeChildAt(0);
            _container.addChildAt((_windows[_arg_1] as IWindowContainer), 0);
            _currentView = _arg_1;
        }

        public function set songName(_arg_1:String):void
        {
            if (_songNameElement == null)
            {
                return;
            };

            _songNameElement.text = _arg_1;
        }

        public function set authorName(_arg_1:String):void
        {
            if (_songAuthorElement == null)
            {
                return;
            };

            _songAuthorElement.text = _arg_1;
        }

        public function setPreviewPlayingBackgroundImage(_arg_1:BitmapData, _arg_2:Boolean=true):void
        {
            blitBackgroundImage("MISV_PREVIEW_PLAYING", "preview_play_background_image", _arg_1);

            if (((_arg_2) && (!(_arg_1 == null))))
            {
                _arg_1.dispose();
            };
        }

        public function setGetMoreMusicBackgroundImage(_arg_1:BitmapData, _arg_2:Boolean=true):void
        {
            blitBackgroundImage("MISV_BUY_MORE", "get_more_music_background_image", _arg_1);

            if (((_arg_2) && (!(_arg_1 == null))))
            {
                _arg_1.dispose();
            };
        }

        private function createWindows():void
        {
            var _local_3:IWindowContainer;
            var _local_2:XmlAsset;
            var _local_1:_SafeStr_101;
            var _local_4:_SafeStr_101;
            _local_2 = (_widget.assets.getAssetByName("playlisteditor_inventory_subwindow_play_preview") as XmlAsset);
            _local_3 = (_widget.windowManager.buildFromXML((_local_2.content as XML)) as IWindowContainer);

            if (_local_3 != null)
            {
                _windows.add("MISV_PREVIEW_PLAYING", _local_3);
                _songNameElement = (_local_3.getChildByName("preview_play_track_name") as ITextWindow);
                _songAuthorElement = (_local_3.getChildByName("preview_play_author_name") as ITextWindow);
                _local_1 = (_local_3.getChildByName("stop_preview_button") as _SafeStr_101);
                _local_1.addEventListener("WME_CLICK", onStopPreviewClicked);
                setPreviewPlayingBackgroundImage(_widget.getImageGalleryAssetBitmap("background_preview_playing"));
                assignAssetByNameToElement("jb_icon_disc", (_local_3.getChildByName("song_name_icon_bitmap") as IBitmapWrapperWindow));
                assignAssetByNameToElement("jb_icon_composer", (_local_3.getChildByName("author_name_icon_bitmap") as IBitmapWrapperWindow));
            };

            _local_2 = (_widget.assets.getAssetByName("playlisteditor_inventory_subwindow_get_more_music") as XmlAsset);
            _local_3 = (_widget.windowManager.buildFromXML((_local_2.content as XML)) as IWindowContainer);

            if (_local_3 != null)
            {
                _windows.add("MISV_BUY_MORE", _local_3);
                _local_4 = (_local_3.getChildByName("open_catalog_button") as _SafeStr_101);
                _local_4.addEventListener("WME_CLICK", onOpenCatalogButtonClicked);
                setGetMoreMusicBackgroundImage(_widget.getImageGalleryAssetBitmap("background_get_more_music"));
            };
        }

        private function blitBackgroundImage(_arg_1:String, _arg_2:String, _arg_3:BitmapData):void
        {
            var _local_5:BitmapData;
            var _local_6:IWindowContainer = (_windows[_arg_1] as IWindowContainer);

            if (_local_6 == null)
            {
                return;
            };

            var _local_4:IBitmapWrapperWindow = (_local_6.getChildByName(_arg_2) as IBitmapWrapperWindow);

            if (_local_4 == null)
            {
                return;
            };

            if (_arg_3 != null)
            {
                _local_5 = new BitmapData(_local_4.width, _local_4.height, false, 0xFFFFFFFF);
                _local_5.copyPixels(_arg_3, _arg_3.rect, new Point(0, 0));
                _local_4.bitmap = _local_5;
            };
        }

        private function assignAssetByNameToElement(_arg_1:String, _arg_2:IBitmapWrapperWindow):void
        {
            var _local_3:BitmapData;
            var _local_4:BitmapDataAsset = (_widget.assets.getAssetByName(_arg_1) as BitmapDataAsset);

            if (_local_4 != null)
            {
                if (((!(_arg_2 == null)) && (!(_local_4.content == null))))
                {
                    _local_3 = (_local_4.content as BitmapData);
                    _arg_2.bitmap = _local_3.clone();
                };
            };
        }

        private function onOpenCatalogButtonClicked(_arg_1:WindowMouseEvent):void
        {
            _widget.openSongDiskShopCataloguePage();
        }

        private function onStopPreviewClicked(_arg_1:WindowMouseEvent):void
        {
            _widget.stopUserSong();
        }

    }
}
