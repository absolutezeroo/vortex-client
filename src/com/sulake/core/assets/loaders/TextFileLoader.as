package com.sulake.core.assets.loaders
{
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import com.probertson.utils._SafeStr_40;
    import flash.errors.IllegalOperationError;

    public class TextFileLoader extends BinaryFileLoader implements IAssetLoader 
    {

        public function TextFileLoader(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:String=null, buffer:ByteArray=null, id:int=-1)
        {
            super(type, urlRequest, cacheKey, cacheRevision, buffer, id);
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

        override protected function loadEventHandler(event:Event):void
        {
            if (event.type == "complete")
            {
                unCompress();
            };

            super.loadEventHandler(event);
        }

        private function unCompress():void
        {
            var _local_2:ByteArray;
            var _local_3:_SafeStr_40;
            var _local_1:String = "";

            if ((_SafeStr_779.data is ByteArray))
            {
                _local_2 = (_SafeStr_779.data as ByteArray);

                if (_local_2.length == 0)
                {
                    _local_1 = "";
                }

                else
                {
                    try
                    {
                        _local_3 = new _SafeStr_40();
                        _local_1 = _local_3.uncompressToByteArray(_local_2).toString();
                    }

                    catch(error:IllegalOperationError)
                    {
                        _local_2.position = 0;
                        _local_1 = _local_2.readUTFBytes(_local_2.length);
                    };
                };

                _local_2.position = 0;
            }

            else
            {
                _local_1 = (_SafeStr_779.data as String);
            };

            _SafeStr_779.data = _local_1;
        }

    }
}
