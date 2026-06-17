package onBoardingHc
{
    import flash.events.Event;
    import flash.display.Loader;

    public class ImageLoaderEvent extends Event
    {

        private var _loader:Loader;
        private var _url:String;

        public function ImageLoaderEvent(eventType:String, loader:Loader, url:String)
        {
            _loader = loader;
            _url = url;
            super(eventType, false, false);
        }

        public function get loader():Loader
        {
            return (_loader);
        }

        public function get url():String
        {
            return (_url);
        }

    }
}
