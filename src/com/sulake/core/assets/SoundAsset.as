package com.sulake.core.assets
{
    import flash.media.Sound;
    import flash.utils.ByteArray;

    public class SoundAsset implements IAsset 
    {

        private var _disposed:Boolean = false;
        private var _content:Sound = null;
        private var _declaration:AssetTypeDeclaration;
        private var _url:String;

        public function SoundAsset(_arg_1:AssetTypeDeclaration, _arg_2:String=null)
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
            return (_content as Object);
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
            if ((unknown is Sound))
            {
                if (_content)
                {
                    _content.close();
                };

                _content = (unknown as Sound);
                return;
            };

            if ((unknown is ByteArray))
            {
            };

            if ((unknown is Class))
            {
                if (_content)
                {
                    _content.close();
                };

                var _content_cls:Class = unknown as Class;
                _content = new _content_cls() as Sound;
                return;
            };

            if ((unknown is SoundAsset))
            {
                if (_content)
                {
                    _content.close();
                };

                _content = SoundAsset(unknown)._content;
                return;
            };
        }

        public function setFromOtherAsset(asset:IAsset):void
        {
            if ((asset is SoundAsset))
            {
                _content = SoundAsset(asset)._content;
            };
        }

        public function setParamsDesc(xml:XMLList):void
        {
        }

    }
}