package com.sulake.core.assets.loaders
{
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class ZipFileLoader extends _SafeStr_16 implements IAssetLoader 
    {

        protected var _SafeStr_780:String;
        protected var _SafeStr_741:String;
        protected var _SafeStr_785:URLStream;
        protected var _SafeStr_690:ByteArray;
        private var _cacheKey:String;
        private var _cacheRevision:String;
        private var _fromCache:Boolean = false;
        private var _id:int;

        public function ZipFileLoader(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:String=null, buffer:ByteArray=null, id:int=-1)
        {
            var _local_7:Timer = null;
            super();
            _SafeStr_780 = ((urlRequest == null) ? "" : urlRequest.url);
            _SafeStr_741 = type;
            _SafeStr_785 = new URLStream();
            _SafeStr_785.addEventListener("complete", loadEventHandler);
            _SafeStr_785.addEventListener("httpStatus", loadEventHandler);
            _SafeStr_785.addEventListener("ioError", loadEventHandler);
            _SafeStr_785.addEventListener("open", loadEventHandler);
            _SafeStr_785.addEventListener("progress", loadEventHandler);
            _SafeStr_785.addEventListener("securityError", loadEventHandler);
            _cacheKey = cacheKey;
            _cacheRevision = cacheRevision;
            _id = id;

            if (((!(buffer == null)) && (buffer.length > 0)))
            {
                _fromCache = true;
                _SafeStr_690 = buffer;
                _local_7 = new Timer(10, 1);
                _local_7.addEventListener("timer", timerEventHandler);
                _local_7.start();
                return;
            };

            if (urlRequest != null)
            {
                this.load(urlRequest);
            };
        }

        public function get url():String
        {
            return (_SafeStr_780);
        }

        public function get content():Object
        {
            return ((_SafeStr_690) ? _SafeStr_690 : _SafeStr_785);
        }

        public function get bytes():ByteArray
        {
            if (_SafeStr_690)
            {
                return (_SafeStr_690);
            };

            var _local_1:ByteArray = new ByteArray();
            _SafeStr_785.readBytes(_local_1);
            return (_local_1);
        }

        public function get mimeType():String
        {
            return (_SafeStr_741);
        }

        public function get bytesLoaded():uint
        {
            return (_SafeStr_785.bytesAvailable);
        }

        public function get bytesTotal():uint
        {
            return (_SafeStr_785.bytesAvailable);
        }

        public function get cacheKey():String
        {
            return (_cacheKey);
        }

        public function get cacheRevision():String
        {
            return (_cacheRevision);
        }

        public function get fromCache():Boolean
        {
            return (_fromCache);
        }

        public function get id():int
        {
            return (_id);
        }

        public function load(urlRequest:URLRequest):void
        {
            _SafeStr_780 = urlRequest.url;
            _SafeStr_785.load(urlRequest);
        }

        override public function dispose():void
        {
            if (!_disposed)
            {
                super.dispose();
                _SafeStr_785.removeEventListener("complete", loadEventHandler);
                _SafeStr_785.removeEventListener("httpStatus", loadEventHandler);
                _SafeStr_785.removeEventListener("ioError", loadEventHandler);
                _SafeStr_785.removeEventListener("open", loadEventHandler);
                _SafeStr_785.removeEventListener("progress", loadEventHandler);
                _SafeStr_785.removeEventListener("securityError", loadEventHandler);
                _SafeStr_785.close();
                _SafeStr_785 = null;
                _SafeStr_741 = null;
                _SafeStr_780 = null;
            };
        }

        private function timerEventHandler(event:TimerEvent):void
        {
            var _local_2:Timer = (event.target as Timer);

            if (_local_2)
            {
                _local_2.stop();
                _local_2.removeEventListener("timer", timerEventHandler);
            };

            if (!_disposed)
            {
                loadEventHandler(new Event("complete"));
            };
        }

    }
}
