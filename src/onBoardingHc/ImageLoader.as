package onBoardingHc
{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.ErrorEvent;

    public class ImageLoader extends EventDispatcher
    {

        private var _loader:Loader;
        private var _url:String;

        public function ImageLoader(_arg_1:Loader, _arg_2:String)
        {
            _loader = _arg_1;
            _url = _arg_2;

            var _local_3:URLRequest = new URLRequest(_arg_2);
            _arg_1.load(_local_3);
            _arg_1.contentLoaderInfo.addEventListener("complete", onLoadComplete);
            _arg_1.contentLoaderInfo.addEventListener("error", onLoadError);
            _arg_1.contentLoaderInfo.addEventListener("ioError", onLoadError);
            _arg_1.contentLoaderInfo.addEventListener("securityError", onLoadError);
        }

        public static function CreateLoader(_arg_1:Loader, _arg_2:String, _arg_3:Function):ImageLoader
        {
            var _local_4:ImageLoader = new ImageLoader(_arg_1, _arg_2);
            _local_4.addEventListener("complete", _arg_3);
            return (_local_4);
        }

        private function onLoadComplete(_arg_1:Event):void
        {
            Logger.log(("[ImageLoader] Loaded: " + _url));
            dispatchEvent(new ImageLoaderEvent("complete", _loader, _url));
        }

        private function onLoadError(_arg_1:ErrorEvent):void
        {
            Logger.log(("[ImageLoader] Failed: " + _arg_1.text));
        }

    }
}
