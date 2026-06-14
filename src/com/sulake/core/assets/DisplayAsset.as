package com.sulake.core.assets
{
    import flash.display.DisplayObject;

    public class DisplayAsset implements IAsset 
    {

        protected var _SafeStr_780:String;
        protected var _content:DisplayObject;
        protected var _disposed:Boolean = false;
        protected var _declaration:AssetTypeDeclaration;

        public function DisplayAsset(decl:AssetTypeDeclaration, url:String=null)
        {
            _declaration = decl;
            _SafeStr_780 = url;
        }

        public function get url():String
        {
            return (_SafeStr_780);
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
                if (_content.loaderInfo != null)
                {
                    if (_content.loaderInfo.loader != null)
                    {
                        _content.loaderInfo.loader.unload();
                    };
                };

                _content = null;
                _declaration = null;
                _disposed = true;
                _SafeStr_780 = null;
            };
        }

        public function setUnknownContent(unknown:Object):void
        {
            if ((unknown is DisplayObject))
            {
                _content = (unknown as DisplayObject);

                if (_content != null)
                {
                    return;
                };

                throw (new Error("Failed to convert DisplayObject to DisplayAsset!"));
            };

            if ((unknown is DisplayAsset))
            {
                _content = DisplayAsset(unknown)._content;
                _declaration = DisplayAsset(unknown)._declaration;

                if (_content == null)
                {
                    throw (new Error("Failed to read content from DisplayAsset!"));
                };
            };
        }

        public function setFromOtherAsset(asset:IAsset):void
        {
            if ((asset is DisplayAsset))
            {
                _content = DisplayAsset(asset)._content;
                _declaration = DisplayAsset(asset)._declaration;
            }

            else
            {
                throw (new Error("Provided asset should be of type DisplayAsset!"));
            };
        }

        public function setParamsDesc(xml:XMLList):void
        {
        }

    }
}
