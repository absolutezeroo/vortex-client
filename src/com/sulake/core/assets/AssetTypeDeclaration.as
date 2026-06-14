package com.sulake.core.assets
{
    public class AssetTypeDeclaration 
    {

        private var _mimeType:String;
        private var _assetClass:Class;
        private var _loaderClass:Class;
        private var _fileTypes:Array;

        public function AssetTypeDeclaration(mimeType:String, assetClass:Class, loaderClass:Class=null, ... _args)
        {
            _mimeType = mimeType;
            _assetClass = assetClass;
            _loaderClass = loaderClass;

            if (_args == null)
            {
                _fileTypes = [];
            }

            else
            {
                _fileTypes = _args;
            };
        }

        public function get mimeType():String
        {
            return (_mimeType);
        }

        public function get assetClass():Class
        {
            return (_assetClass);
        }

        public function get loaderClass():Class
        {
            return (_loaderClass);
        }

        public function get fileTypes():Array
        {
            return (_fileTypes);
        }

    }
}