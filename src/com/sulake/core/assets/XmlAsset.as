package com.sulake.core.assets
{
    import flash.utils.ByteArray;

    public class XmlAsset implements ILazyAsset 
    {

        private var _disposed:Boolean = false;
        private var _unknown:Object;
        private var _content:XML;
        private var _declaration:AssetTypeDeclaration;
        private var _url:String;

        public function XmlAsset(decl:AssetTypeDeclaration, url:String=null)
        {
            _declaration = decl;
            _url = url;
        }

        public function get url():String
        {
            return (_url);
        }

        public function get content():Object
        {
            if (!_content)
            {
                prepareLazyContent();
            };

            return (_content);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get declaration():AssetTypeDeclaration
        {
            return (_declaration);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _disposed = true;
                _content = null;
                _unknown = null;
                _declaration = null;
                _url = null;
            };
        }

        public function setUnknownContent(unknown:Object):void
        {
            _content = null;
            _unknown = unknown;
        }

        public function prepareLazyContent():void
        {
            var _local_1:ByteArray;

            if ((_unknown is Class))
            {
                var _local_1_cls:Class = _unknown as Class;
                _local_1 = new _local_1_cls() as ByteArray;
                _content = new XML(_local_1.readUTFBytes(_local_1.length));
                return;
            };

            if ((_unknown is ByteArray))
            {
                _local_1 = (_unknown as ByteArray);
                _content = new XML(_local_1.readUTFBytes(_local_1.length));
                return;
            };

            if ((_unknown is String))
            {
                _content = new XML((_unknown as String));
                return;
            };

            if ((_unknown is XML))
            {
                _content = (_unknown as XML);
                return;
            };

            if ((_unknown is XmlAsset))
            {
                _content = XmlAsset(_unknown)._content;
                return;
            };
        }

        public function setFromOtherAsset(asset:IAsset):void
        {
            if ((asset is XmlAsset))
            {
                _content = XmlAsset(asset)._content;
            }

            else
            {
                throw (Error("Provided asset is not of type XmlAsset!"));
            };
        }

        public function setParamsDesc(xml:XMLList):void
        {
        }

        public function toString():String
        {
            var _local_1:String = "XmlAsset";
            _local_1 = (_local_1 + (" _url:" + _url));
            _local_1 = (_local_1 + (" _content:" + _content));
            return (_local_1 + (" _unknown:" + _unknown));
        }

    }
}
