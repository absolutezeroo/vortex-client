package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import com.sulake.habbo.room.object.visualization.room.utils.Randomizer;

    public class PlaneMaterialCell 
    {

        private var _cachedBitmapData:BitmapData = null;
        private var _texture:PlaneTexture;
        private var _extraItemOffsets:Array = [];
        private var _extraItemAssets:Array = [];
        private var _extraItemCount:int = 0;

        public function PlaneMaterialCell(_arg_1:PlaneTexture, _arg_2:Array=null, _arg_3:Array=null, _arg_4:int=0)
        {
            var _local_6:int;
            var _local_7:IGraphicAsset = null;
            var _local_5:Point = null;
            super();
            _texture = _arg_1;

            if ((((!(_arg_2 == null)) && (_arg_2.length > 0)) && (_arg_4 > 0)))
            {
                _local_6 = 0;
                _local_6 = 0;

                while (_local_6 < _arg_2.length)
                {
                    _local_7 = (_arg_2[_local_6] as IGraphicAsset);

                    if (_local_7 != null)
                    {
                        _extraItemAssets.push(_local_7);
                    };

                    _local_6++;
                };

                if (_extraItemAssets.length > 0)
                {
                    if (_arg_3 != null)
                    {
                        _local_6 = 0;

                        while (_local_6 < _arg_3.length)
                        {
                            _local_5 = (_arg_3[_local_6] as Point);

                            if (_local_5 != null)
                            {
                                _extraItemOffsets.push(new Point(_local_5.x, _local_5.y));
                            };

                            _local_6++;
                        };
                    };

                    _extraItemCount = _arg_4;
                };
            };
        }

        public function get isStatic():Boolean
        {
            return (_extraItemCount == 0);
        }

        public function dispose():void
        {
            if (_texture != null)
            {
                _texture.dispose();
                _texture = null;
            };

            if (_cachedBitmapData != null)
            {
                _cachedBitmapData.dispose();
                _cachedBitmapData = null;
            };

            _extraItemAssets = null;
            _extraItemOffsets = null;
        }

        public function clearCache():void
        {
            if (_cachedBitmapData != null)
            {
                _cachedBitmapData.dispose();
                _cachedBitmapData = null;
            };
        }

        public function getHeight(_arg_1:IVector3d):int
        {
            var _local_2:BitmapData;

            if (_texture != null)
            {
                _local_2 = _texture.getBitmap(_arg_1);

                if (_local_2 != null)
                {
                    return (_local_2.height);
                };
            };

            return (0);
        }

        public function render(normal:IVector3d, textureOffsetX:int, textureOffsetY:int):BitmapData
        {
            var _local_16:BitmapData;
            var _local_4:BitmapData;
            var _local_20:int;
            var _local_5:int;
            var _local_7:Array;
            var _local_11:int;
            var _local_8:Point;
            var _local_6:IGraphicAsset;
            var _local_13:BitmapDataAsset;
            var _local_14:BitmapData;
            var _local_10:Point;
            var _local_9:Matrix;
            var _local_18:Number;
            var _local_19:Number;
            var _local_17:Number;
            var _local_15:Number;
            var _local_12:int;

            if (_texture != null)
            {
                _local_16 = _texture.getBitmap(normal);
                try
                {
                    if (((!(_local_16 == null)) && ((!(textureOffsetX == 0)) || (!(textureOffsetY == 0)))))
                    {
                        _local_4 = new BitmapData((_local_16.width * 2), (_local_16.height * 2), _local_16.transparent);
                        _local_4.copyPixels(_local_16, _local_16.rect, new Point());
                        _local_4.copyPixels(_local_16, _local_16.rect, new Point(_local_16.width, 0));
                        _local_4.copyPixels(_local_16, _local_16.rect, new Point(0, _local_16.height));
                        _local_4.copyPixels(_local_16, _local_16.rect, new Point(_local_16.width, _local_16.height));
                        _local_16 = new BitmapData(_local_16.width, _local_16.height, _local_16.transparent);

                        while (textureOffsetX < 0)
                        {
                            textureOffsetX = (textureOffsetX + _local_16.width);
                        };

                        while (textureOffsetY < 0)
                        {
                            textureOffsetY = (textureOffsetY + _local_16.height);
                        };

                        _local_16.copyPixels(_local_4, new Rectangle((textureOffsetX % _local_16.width), (textureOffsetY % _local_16.height), _local_16.width, _local_16.height), new Point());
                    };
                }

                catch(e:Error)
                {
                    return (null);
                };

                if (_local_16 != null)
                {
                    if (!isStatic)
                    {
                        if (_cachedBitmapData != null)
                        {
                            if (((!(_cachedBitmapData.width == _local_16.width)) || (!(_cachedBitmapData.height == _local_16.height))))
                            {
                                _cachedBitmapData.dispose();
                                _cachedBitmapData = null;
                            }

                            else
                            {
                                _cachedBitmapData.copyPixels(_local_16, _local_16.rect, new Point(0, 0));
                            };
                        };

                        if (_cachedBitmapData == null)
                        {
                            _cachedBitmapData = _local_16.clone();
                        };

                        _local_20 = Math.min(_extraItemCount, _extraItemOffsets.length);
                        _local_5 = Math.max(_extraItemCount, _extraItemOffsets.length);
                        _local_7 = Randomizer.getArray(_extraItemCount, _local_5);
                        _local_11 = 0;

                        while (_local_11 < _local_20)
                        {
                            _local_8 = (_extraItemOffsets[_local_7[_local_11]] as Point);
                            _local_6 = (_extraItemAssets[(_local_11 % _extraItemAssets.length)] as IGraphicAsset);

                            if (((!(_local_8 == null)) && (!(_local_6 == null))))
                            {
                                _local_13 = (_local_6.asset as BitmapDataAsset);

                                if (_local_13 != null)
                                {
                                    _local_14 = (_local_13.content as BitmapData);

                                    if (_local_14 != null)
                                    {
                                        _local_10 = new Point((_local_8.x + _local_6.offsetX), (_local_8.y + _local_6.offsetY));
                                        _local_9 = new Matrix();
                                        _local_18 = 1;
                                        _local_19 = 1;
                                        _local_17 = 0;
                                        _local_15 = 0;

                                        if (_local_6.flipH)
                                        {
                                            _local_18 = -1;
                                            _local_17 = _local_14.width;
                                        };

                                        if (_local_6.flipV)
                                        {
                                            _local_19 = -1;
                                            _local_15 = _local_14.height;
                                        };

                                        _local_12 = (_local_10.x + _local_17);
                                        _local_12 = ((_local_12 >> 1) << 1);
                                        _local_9.scale(_local_18, _local_19);
                                        _local_9.translate(_local_12, (_local_10.y + _local_15));
                                        _cachedBitmapData.draw(_local_14, _local_9);
                                    };
                                };
                            };

                            _local_11++;
                        };

                        return (_cachedBitmapData);
                    };

                    return (_local_16);
                };
            };

            return (null);
        }

        public function getAssetName(_arg_1:IVector3d):String
        {
            return ((_texture == null) ? null : _texture.getAssetName(_arg_1));
        }

    }
}
