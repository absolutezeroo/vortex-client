package com.sulake.habbo.room
{
    public class RoomContentLoaderURL implements IRoomContentLoaderURL 
    {

        private static const FILE_TYPE_PNG:String = "png";
        private static const FILE_TYPE_JPG:String = "png";
        private static const CACHE_KEY_FURNI_PREFIX:String = "furni/";
        private static const CACHE_KEY_ICON_PREFIX:String = "icon/";

        private var _url:String;
        private var _cacheKey:String;
        private var _cacheRevision:String;
        private var _assetName:String;
        private var _fileType:String;

        public function RoomContentLoaderURL(url:String, cacheKeyName:String=null, cacheRevision:String=null, isIcon:Boolean=false, assetName:String=null)
        {
            _url = url;

            var cacheKeyPrefix:String = ((isIcon) ? "icon/" : "furni/");
            _cacheKey = ((cacheKeyName) ? (cacheKeyPrefix + cacheKeyName) : null);
            _cacheRevision = cacheRevision;
            _assetName = assetName;

            var lowerCaseUrl:String = url.toLowerCase();

            if (lowerCaseUrl.indexOf(".png") > -1)
            {
                _fileType = "png";
            }

            else
            {
                if (lowerCaseUrl.indexOf(".jpg") > -1)
                {
                    _fileType = "png";
                }

                else
                {
                    if (lowerCaseUrl.indexOf(".jpeg") > -1)
                    {
                        _fileType = "png";
                    };
                };
            };
        }

        public function get url():String
        {
            return (_url);
        }

        public function get cacheKey():String
        {
            return (_cacheKey);
        }

        public function get cacheRevision():String
        {
            return (_cacheRevision);
        }

        public function get assetName():String
        {
            return (_assetName);
        }

        public function get fileType():String
        {
            return (_fileType);
        }

    }
}