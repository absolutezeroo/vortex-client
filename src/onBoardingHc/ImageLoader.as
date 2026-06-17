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

        public function ImageLoader(loader:Loader, imageUrl:String)
        {
            _loader = loader;
            _url = imageUrl;

            var request:URLRequest = new URLRequest(imageUrl);
            loader.load(request);
            loader.contentLoaderInfo.addEventListener("complete", onLoadComplete);
            loader.contentLoaderInfo.addEventListener("error", onLoadError);
            loader.contentLoaderInfo.addEventListener("ioError", onLoadError);
            loader.contentLoaderInfo.addEventListener("securityError", onLoadError);
        }

        public static function CreateLoader(loader:Loader, imageUrl:String, completeHandler:Function):ImageLoader
        {
            var imageLoader:ImageLoader = new ImageLoader(loader, imageUrl);
            imageLoader.addEventListener("complete", completeHandler);
            return (imageLoader);
        }

        private function onLoadComplete(loadEvent:Event):void
        {
            Logger.log(("[ImageLoader] Loaded: " + _url));
            dispatchEvent(new ImageLoaderEvent("complete", _loader, _url));
        }

        private function onLoadError(errorEvent:ErrorEvent):void
        {
            Logger.log(("[ImageLoader] Failed: " + errorEvent.text));
        }

    }
}
