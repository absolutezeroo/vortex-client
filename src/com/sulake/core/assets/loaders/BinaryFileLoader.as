package com.sulake.core.assets.loaders
{
    import flash.net.URLLoader;
    import flash.utils.Timer;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import com.sulake.core.utils.Resources;
    import flash.events.SecurityErrorEvent;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class BinaryFileLoader extends _SafeStr_16 implements IAssetLoader 
    {

        protected var _SafeStr_780:String;
        protected var _SafeStr_741:String;
        protected var _SafeStr_690:Object;
        protected var _SafeStr_779:URLLoader;
        private var _cacheKey:String = null;
        private var _cacheRevision:String = null;
        private var _fromCache:Boolean = false;
        private var _id:int;

        public function BinaryFileLoader(_arg_1:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:String=null, data:ByteArray=null, id:int=-1)
        {
            var _local_7:Timer = null;
            super();
            _SafeStr_780 = ((urlRequest == null) ? "" : urlRequest.url);
            _SafeStr_741 = _arg_1;
            _SafeStr_779 = new URLLoader();
            _SafeStr_779.dataFormat = "binary";
            _SafeStr_779.addEventListener("complete", loadEventHandler);
            _SafeStr_779.addEventListener("unload", loadEventHandler);
            _SafeStr_779.addEventListener("httpStatus", loadEventHandler);
            _SafeStr_779.addEventListener("progress", loadEventHandler);
            _SafeStr_779.addEventListener("ioError", loadEventHandler);
            _SafeStr_779.addEventListener("securityError", securityErrorEventHandler);
            _cacheKey = cacheKey;
            _cacheRevision = cacheRevision;
            _id = id;

            if (((!(data == null)) && (data.length > 0)))
            {
                _fromCache = true;
                _SafeStr_690 = data;
                _local_7 = new Timer(10, 1);
                _local_7.addEventListener("timer", timerEventHandler);
                _local_7.start();
                return;
            };

            if (urlRequest != null)
            {
                load(urlRequest);
            };
        }

        public function get url():String
        {
            return (_SafeStr_780);
        }

        public function get content():Object
        {
            return ((_SafeStr_690) ? _SafeStr_690 : ((_SafeStr_779) ? _SafeStr_779.data : null));
        }

        public function get bytes():ByteArray
        {
            var _local_1:ByteArray;

            if (_SafeStr_779)
            {
                if ((_SafeStr_779.data is ByteArray))
                {
                    return (_SafeStr_779.data);
                };

                if ((_SafeStr_779.data is String))
                {
                    _local_1 = new ByteArray();
                    _local_1.writeUTFBytes(_SafeStr_779.data);
                    return (_local_1);
                };
            };

            return (null);
        }

        public function get mimeType():String
        {
            return (_SafeStr_741);
        }

        public function get bytesLoaded():uint
        {
            return ((_SafeStr_779) ? _SafeStr_779.bytesLoaded : 0);
        }

        public function get bytesTotal():uint
        {
            return ((_SafeStr_779) ? _SafeStr_779.bytesTotal : 0);
        }

        public function get fromCache():Boolean
        {
            return (_fromCache);
        }

        public function get cacheKey():String
        {
            return (_cacheKey);
        }

        public function get cacheRevision():String
        {
            return (_cacheRevision);
        }

        public function get id():int
        {
            return (_id);
        }

        public function load(urlRequest:URLRequest):void
        {
            var _local_2:Timer;
            _SafeStr_780 = urlRequest.url;
            _SafeStr_690 = null;
            _SafeStr_777 = 0;
            _SafeStr_779.dataFormat = "binary";
            _SafeStr_690 = (Resources.get(urlRequest.url) as String);

            if (_SafeStr_690)
            {
                _local_2 = new Timer(10, 1);
                _local_2.addEventListener("timer", timerEventHandler);
                _local_2.start();
                return;
            };

            _SafeStr_779.load(urlRequest);
        }

        override protected function retry():Boolean
        {
            if (!_disposed)
            {
                if (++_SafeStr_777 <= _SafeStr_778)
                {
                    try
                    {
                        _SafeStr_779.close();
                    }

                    catch(e:Error)
                    {
                    };

                    _SafeStr_779.load(new URLRequest((((_SafeStr_780 + ((_SafeStr_780.indexOf("?") == -1) ? "?" : "&")) + "retry=") + _SafeStr_777)));
                    return (true);
                };
            };

            return (false);
        }

        override public function dispose():void
        {
            if (!_disposed)
            {
                super.dispose();
                _SafeStr_779.removeEventListener("complete", loadEventHandler);
                _SafeStr_779.removeEventListener("unload", loadEventHandler);
                _SafeStr_779.removeEventListener("httpStatus", loadEventHandler);
                _SafeStr_779.removeEventListener("progress", loadEventHandler);
                _SafeStr_779.removeEventListener("ioError", loadEventHandler);
                _SafeStr_779.removeEventListener("securityError", securityErrorEventHandler);
                try
                {
                    _SafeStr_779.close();
                }

                catch(e:Error)
                {
                };

                _SafeStr_779 = null;
                _SafeStr_741 = null;
                _SafeStr_690 = null;
                _SafeStr_780 = null;
            };
        }

        private function securityErrorEventHandler(event:SecurityErrorEvent):void
        {
            if (!_disposed)
            {
                loadEventHandler(event);
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
