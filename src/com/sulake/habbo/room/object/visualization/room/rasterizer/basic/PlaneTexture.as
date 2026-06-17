package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;

    public class PlaneTexture 
    {

        public static const _SafeStr_3425:Number = -1;
        public static const MAX_NORMAL_COORDINATE_VALUE:Number = 1;

        private var _bitmaps:Array = [];

        public function dispose():void
        {
            var index:int;
            var planeTextureBitmap:PlaneTextureBitmap;

            if (_bitmaps != null)
            {
                index = 0;

                while (index < _bitmaps.length)
                {
                    planeTextureBitmap = (_bitmaps[index] as PlaneTextureBitmap);

                    if (planeTextureBitmap != null)
                    {
                        planeTextureBitmap.dispose();
                    };

                    index++;
                };

                _bitmaps = null;
            };
        }

        public function addBitmap(bitmapData:BitmapData, normalMinX:Number=-1, normalMaxX:Number=1, normalMinY:Number=-1, normalMaxY:Number=1, assetName:String=null):void
        {
            var planeTextureBitmap:PlaneTextureBitmap = new PlaneTextureBitmap(bitmapData, normalMinX, normalMaxX, normalMinY, normalMaxY, assetName);
            _bitmaps.push(planeTextureBitmap);
        }

        public function getBitmap(normal:IVector3d):BitmapData
        {
            var planeTextureBitmap:PlaneTextureBitmap = getPlaneTextureBitmap(normal);
            return ((planeTextureBitmap == null) ? null : planeTextureBitmap.bitmap);
        }

        public function getPlaneTextureBitmap(normal:IVector3d):PlaneTextureBitmap
        {
            var index:int;
            var planeTextureBitmap:PlaneTextureBitmap;

            if (normal == null)
            {
                return (null);
            };

            index = 0;

            while (index < _bitmaps.length)
            {
                planeTextureBitmap = (_bitmaps[index] as PlaneTextureBitmap);

                if (planeTextureBitmap != null)
                {
                    if (((((normal.x >= planeTextureBitmap.normalMinX) && (normal.x <= planeTextureBitmap.normalMaxX)) && (normal.y >= planeTextureBitmap.normalMinY)) && (normal.y <= planeTextureBitmap.normalMaxY)))
                    {
                        return (planeTextureBitmap);
                    };
                };

                index++;
            };

            return (null);
        }

        public function getAssetName(normal:IVector3d):String
        {
            var planeTextureBitmap:PlaneTextureBitmap = getPlaneTextureBitmap(normal);
            return ((planeTextureBitmap == null) ? null : planeTextureBitmap.assetName);
        }

    }
}
