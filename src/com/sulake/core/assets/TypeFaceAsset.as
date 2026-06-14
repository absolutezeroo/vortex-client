package com.sulake.core.assets
{
    import flash.text.Font;
    import com.sulake.core.utils.FontEnum;

    public class TypeFaceAsset implements IAsset 
    {

        protected var _SafeStr_802:AssetTypeDeclaration;
        protected var _content:Font;
        protected var _disposed:Boolean = false;

        public function TypeFaceAsset(_arg_1:AssetTypeDeclaration, _arg_2:String=null)
        {
            _SafeStr_802 = _arg_1;
        }

        public function get url():String
        {
            return (null);
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
            return (_SafeStr_802);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _SafeStr_802 = null;
                _content = null;
                _disposed = true;
            };
        }

        public function setUnknownContent(unknown:Object):void
        {
            try
            {
                if ((unknown is Class))
                {
                    _content = Font(FontEnum.registerFont((unknown as Class)));
                };
            }

            catch(e:Error)
            {
                throw (new Error(("Failed to register font from resource: " + unknown)));
            };
        }

        public function setFromOtherAsset(asset:IAsset):void
        {
            if ((asset is TypeFaceAsset))
            {
                _content = TypeFaceAsset(asset)._content;
            }

            else
            {
                throw (new Error("Provided asset should be of type FontAsset!"));
            };
        }

        public function setParamsDesc(xml:XMLList):void
        {
        }

    }
}
