package com.sulake.core.assets.loaders
{
    import flash.media.Sound;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;

    public class SoundFileLoader extends _SafeStr_16 implements IAssetLoader 
    {

        protected var _SafeStr_780:String;
        protected var _SafeStr_741:String;
        protected var _SafeStr_784:Sound;
        private var _cacheKey:String;
        private var _cacheRevision:String;
        private var _fromCache:Boolean = false;
        private var _id:int;

        public function SoundFileLoader(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:String=null, buffer:ByteArray=null, id:int=-1)
        {
            _SafeStr_780 = ((urlRequest == null) ? "" : urlRequest.url);
            _SafeStr_741 = type;
            _SafeStr_784 = new Sound(null, null);
            _SafeStr_784.addEventListener("id3", loadEventHandler);
            _SafeStr_784.addEventListener("open", loadEventHandler);
            _SafeStr_784.addEventListener("complete", loadEventHandler);
            _SafeStr_784.addEventListener("ioError", loadEventHandler);
            _SafeStr_784.addEventListener("progress", loadEventHandler);
            _cacheKey = cacheKey;
            _cacheRevision = cacheRevision;
            _id = id;

            if (((!(buffer == null)) && (buffer.length > 0)))
            {
                _fromCache = true;
                _SafeStr_784.loadPCMFromByteArray(buffer, buffer.length);
            }

            else
            {
                if (urlRequest != null)
                {
                    this.load(urlRequest);
                };
            };
        }

        public function get url():String
        {
            return (_SafeStr_780);
        }

        public function get content():Object
        {
            return (_SafeStr_784);
        }

        public function get bytes():ByteArray
        {
            var _local_1:ByteArray = new ByteArray();
            _SafeStr_784.extract(_local_1, _SafeStr_784.length);
            return (_local_1);
        }

        public function get mimeType():String
        {
            return (_SafeStr_741);
        }

        public function get bytesLoaded():uint
        {
            return ((_SafeStr_784) ? _SafeStr_784.bytesLoaded : 0);
        }

        public function get bytesTotal():uint
        {
            return ((_SafeStr_784) ? _SafeStr_784.bytesTotal : 0);
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

        override public function dispose():void
        {
            if (!disposed)
            {
                _SafeStr_784.removeEventListener("id3", loadEventHandler);
                _SafeStr_784.removeEventListener("open", loadEventHandler);
                _SafeStr_784.removeEventListener("complete", loadEventHandler);
                _SafeStr_784.removeEventListener("ioError", loadEventHandler);
                _SafeStr_784.removeEventListener("progress", loadEventHandler);
                _SafeStr_784 = null;
                _SafeStr_741 = null;
                _SafeStr_780 = null;
                super.dispose();
            };
        }

        public function load(urlRequest:URLRequest):void
        {
            _SafeStr_780 = urlRequest.url;
            _SafeStr_784.load(urlRequest, null);
        }

    }
}
