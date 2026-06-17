package com.sulake.room.object.visualization.utils
{
    import __AS3__.vec.Vector;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAsset;
    import flash.display.BitmapData;

    public class GraphicAsset implements IGraphicAsset
    {

        private static const _assetPool:Vector.<GraphicAsset> = new Vector.<GraphicAsset>();

        private var _assetName:String;
        private var _libraryAssetName:String;
        private var _asset:BitmapDataAsset;
        private var _flipH:Boolean;
        private var _flipV:Boolean;
        private var _usesPalette:Boolean;
        private var _originalOffsetX:int;
        private var _originalOffsetY:int;
        private var _width:int;
        private var _height:int;
        private var _initialized:Boolean;

        public static function allocate(assetName:String, libraryAssetName:String, sourceAsset:IAsset, flipHorizontal:Boolean, flipVertical:Boolean, xOffset:int, yOffset:int, usesPalette:Boolean=false):GraphicAsset
        {
            var cachedAsset:GraphicAsset = ((_assetPool.length > 0) ? _assetPool.pop() : new GraphicAsset());
            cachedAsset._assetName = assetName;
            cachedAsset._libraryAssetName = libraryAssetName;

            var bitmapAsset:BitmapDataAsset = (sourceAsset as BitmapDataAsset);

            if (bitmapAsset != null)
            {
                cachedAsset._asset = bitmapAsset;
                cachedAsset._initialized = false;
            }

            else
            {
                cachedAsset._asset = null;
                cachedAsset._initialized = true;
            };

            cachedAsset._flipH = flipHorizontal;
            cachedAsset._flipV = flipVertical;
            cachedAsset._originalOffsetX = xOffset;
            cachedAsset._originalOffsetY = yOffset;
            cachedAsset._usesPalette = usesPalette;
            return (cachedAsset);
        }

        public function recycle():void
        {
            _asset = null;
            _assetPool.push(this);
        }

        private function initialize():void
        {
            var bitmap:BitmapData;

            if (((!(_initialized)) && (!(_asset == null))))
            {
                bitmap = (_asset.content as BitmapData);

                if (bitmap != null)
                {
                    _width = bitmap.width;
                    _height = bitmap.height;
                };

                _initialized = true;
            };
        }

        public function get flipV():Boolean
        {
            return (_flipV);
        }

        public function get flipH():Boolean
        {
            return (_flipH);
        }

        public function get width():int
        {
            initialize();
            return (_width);
        }

        public function get height():int
        {
            initialize();
            return (_height);
        }

        public function get assetName():String
        {
            return (_assetName);
        }

        public function get libraryAssetName():String
        {
            return (_libraryAssetName);
        }

        public function get asset():IAsset
        {
            return (_asset);
        }

        public function get usesPalette():Boolean
        {
            return (_usesPalette);
        }

        public function get offsetX():int
        {
            if (!_flipH)
            {
                return (_originalOffsetX);
            };

            return (-(width + _originalOffsetX));
        }

        public function get offsetY():int
        {
            if (!_flipV)
            {
                return (_originalOffsetY);
            };

            return (-(height + _originalOffsetY));
        }

        public function get originalOffsetX():int
        {
            return (_originalOffsetX);
        }

        public function get originalOffsetY():int
        {
            return (_originalOffsetY);
        }

    }
}
