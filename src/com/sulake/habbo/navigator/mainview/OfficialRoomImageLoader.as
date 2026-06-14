package com.sulake.habbo.navigator.mainview
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.display.BitmapData;

    public class OfficialRoomImageLoader implements IDisposable 
    {

        private var _navigator:IHabboTransitionalNavigator;
        private var _picRef:String;
        private var _url:String;
        private var _bitmapWrapper:IBitmapWrapperWindow;
        private var _disposed:Boolean;

        public function OfficialRoomImageLoader(_arg_1:IHabboTransitionalNavigator, _arg_2:String, _arg_3:IBitmapWrapperWindow)
        {
            _navigator = _arg_1;
            _picRef = _arg_2;
            _bitmapWrapper = _arg_3;

            var _local_4:String = _navigator.getProperty("image.library.url");
            _url = (_local_4 + _picRef);
            Logger.log(("[OFFICIAL ROOM ICON IMAGE DOWNLOADER] : " + _url));
        }

        public function startLoad():void
        {
            var _local_1:URLRequest;
            var _local_2:AssetLoaderStruct;

            if (_navigator.assets.hasAsset(_picRef))
            {
                setImage();
            }

            else
            {
                _local_1 = new URLRequest(_url);
                _local_2 = _navigator.assets.loadAssetFromFile(_picRef, _local_1, "image/gif");
                _local_2.addEventListener("AssetLoaderEventComplete", onImageReady);
                _local_2.addEventListener("AssetLoaderEventError", onLoadError);
            };
        }

        private function onImageReady(_arg_1:AssetLoaderEvent):void
        {
            if (_disposed)
            {
                return;
            };

            var _local_2:AssetLoaderStruct = (_arg_1.target as AssetLoaderStruct);

            if (_local_2 == null)
            {
                Logger.log((("Loading pic from url: " + _url) + " failed. loaderStruct == null"));
                return;
            };

            setImage();
        }

        private function setImage():void
        {
            var _local_1:BitmapData;

            if (((((_navigator) && (!(_navigator.disposed))) && (_bitmapWrapper)) && (!(_bitmapWrapper.disposed))))
            {
                _local_1 = _navigator.getButtonImage(_picRef, "");

                if (_local_1)
                {
                    _bitmapWrapper.disposesBitmap = false;
                    _bitmapWrapper.bitmap = _local_1;
                    _bitmapWrapper.width = _local_1.width;
                    _bitmapWrapper.height = _local_1.height;
                    _bitmapWrapper.visible = true;
                }

                else
                {
                    Logger.log(("OfficialRoomImageLoader - Image not found: " + _picRef));
                };
            };

            dispose();
        }

        private function onLoadError(_arg_1:AssetLoaderEvent):void
        {
            Logger.log(((("Error loading image: " + _url) + ", ") + _arg_1));
            dispose();
        }

        public function dispose():void
        {
            if (_disposed)
            {
                return;
            };

            _disposed = true;
            _bitmapWrapper = null;
            _navigator = null;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

    }
}
