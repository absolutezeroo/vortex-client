package com.sulake.core.assets
{
    import flash.utils.ByteArray;

    public class TextAsset implements IAsset 
    {

        private var _disposed:Boolean = false;
        private var _content:String = "";
        private var _declaration:AssetTypeDeclaration;
        private var _url:String;

        public function TextAsset(_arg_1:AssetTypeDeclaration, _arg_2:String=null)
        {
            _declaration = _arg_1;
            _url = _arg_2;
        }

        public function get url():String
        {
            return (_url);
        }

        public function get content():Object
        {
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
                _declaration = null;
                _url = null;
            };
        }

        public function setUnknownContent(unknown:Object):void
        {
            var _local_2:ByteArray;

            if ((unknown is String))
            {
                _content = (unknown as String);
                return;
            };

            if ((unknown is Class))
            {
                var _local_2_cls:Class = unknown as Class;
                _local_2 = new _local_2_cls() as ByteArray;
                _content = _local_2.readUTFBytes(_local_2.length);
                return;
            };

            if ((unknown is ByteArray))
            {
                _local_2 = (unknown as ByteArray);
                _content = _local_2.readUTFBytes(_local_2.length);
                return;
            };

            if ((unknown is TextAsset))
            {
                _content = TextAsset(unknown)._content;
                return;
            };

            _content = ((unknown) ? unknown.toString() : "");
        }

        public function setFromOtherAsset(asset:IAsset):void
        {
            if ((asset is TextAsset))
            {
                _content = TextAsset(asset)._content;
            }

            else
            {
                throw (Error("Provided asset is not of type TextAsset!"));
            };
        }

        public function setParamsDesc(xml:XMLList):void
        {
        }

    }
}