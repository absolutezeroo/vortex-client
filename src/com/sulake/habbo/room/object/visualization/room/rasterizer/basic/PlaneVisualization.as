package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.animated.PlaneVisualizationAnimationLayer;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

    public class PlaneVisualization 
    {

        private var _layers:Array = [];
        private var _geometry:IRoomGeometry = null;
        private var _cachedBitmapData:BitmapData;
        private var _cachedBitmapNormal:Vector3d = null;
        private var _isCached:Boolean = false;
        private var _hasAnimationLayers:Boolean = false;

        public function PlaneVisualization(_arg_1:Number, _arg_2:int, _arg_3:IRoomGeometry)
        {
            var _local_4:int;
            super();

            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            };

            _local_4 = 0;

            while (_local_4 < _arg_2)
            {
                _layers.push(null);
                _local_4++;
            };

            _geometry = _arg_3;
            _cachedBitmapNormal = new Vector3d();
        }

        public function get geometry():IRoomGeometry
        {
            return (_geometry);
        }

        public function get hasAnimationLayers():Boolean
        {
            return (_hasAnimationLayers);
        }

        public function dispose():void
        {
            var _local_1:int;
            var _local_2:IDisposable;

            if (_layers != null)
            {
                _local_1 = 0;

                while (_local_1 < _layers.length)
                {
                    _local_2 = (_layers[_local_1] as IDisposable);

                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    };

                    _local_1++;
                };

                _layers = null;
            };

            _geometry = null;

            if (_cachedBitmapData != null)
            {
                _cachedBitmapData.dispose();
            };

            if (_cachedBitmapNormal != null)
            {
                _cachedBitmapNormal = null;
            };
        }

        public function clearCache():void
        {
            var _local_2:int;
            var _local_3:PlaneVisualizationLayer;
            var _local_1:PlaneVisualizationAnimationLayer;

            if (!_isCached)
            {
                return;
            };

            if (_cachedBitmapData != null)
            {
                _cachedBitmapData.dispose();
                _cachedBitmapData = null;
            };

            if (_cachedBitmapNormal != null)
            {
                _cachedBitmapNormal.assign(new Vector3d());
            };

            if (_layers != null)
            {
                _local_2 = 0;

                while (_local_2 < _layers.length)
                {
                    _local_3 = (_layers[_local_2] as PlaneVisualizationLayer);
                    _local_1 = (_layers[_local_2] as PlaneVisualizationAnimationLayer);

                    if (_local_3 != null)
                    {
                        _local_3.clearCache();
                    }

                    else
                    {
                        if (_local_1 != null)
                        {
                            _local_1.clearCache();
                        };
                    };

                    _local_2++;
                };
            };

            _isCached = false;
        }

        public function setLayer(_arg_1:int, _arg_2:PlaneMaterial, _arg_3:uint, _arg_4:int, _arg_5:int=0):Boolean
        {
            if (((_arg_1 < 0) || (_arg_1 > _layers.length)))
            {
                return (false);
            };

            var _local_6:IDisposable = (_layers[_arg_1] as IDisposable);

            if (_local_6 != null)
            {
                _local_6.dispose();
                _local_6 = null;
            };

            _local_6 = new PlaneVisualizationLayer(_arg_2, _arg_3, _arg_4, _arg_5);
            _layers[_arg_1] = _local_6;
            return (true);
        }

        public function setAnimationLayer(_arg_1:int, _arg_2:XML, _arg_3:IGraphicAssetCollection):Boolean
        {
            if (((_arg_1 < 0) || (_arg_1 > _layers.length)))
            {
                return (false);
            };

            var _local_4:IDisposable = (_layers[_arg_1] as IDisposable);

            if (_local_4 != null)
            {
                _local_4.dispose();
                _local_4 = null;
            };

            _local_4 = new PlaneVisualizationAnimationLayer(_arg_2, _arg_3);
            _layers[_arg_1] = _local_4;
            _hasAnimationLayers = true;
            return (true);
        }

        public function getLayers():Array
        {
            return (_layers);
        }

        public function render(canvas:BitmapData, width:int, height:int, normal:IVector3d, useTexture:Boolean, offsetX:int=0, offsetY:int=0, maxX:int=0, maxY:int=0, dimensionX:Number=0, dimensionY:Number=0, timeSinceStartMs:int=0):BitmapData
        {
            var _local_14:int;
            var _local_15:PlaneVisualizationLayer;
            var _local_13:PlaneVisualizationAnimationLayer;

            if (width < 1)
            {
                width = 1;
            };

            if (height < 1)
            {
                height = 1;
            };

            if ((((canvas == null) || (!(canvas.width == width))) || (!(canvas.height == height))))
            {
                canvas = null;
            };

            if (_cachedBitmapData != null)
            {
                try
                {
                    if ((((_cachedBitmapData.width == width) && (_cachedBitmapData.height == height)) && (Vector3d.isEqual(_cachedBitmapNormal, normal))))
                    {
                        if (!hasAnimationLayers)
                        {
                            if (canvas != null)
                            {
                                canvas.copyPixels(_cachedBitmapData, _cachedBitmapData.rect, new Point(0, 0), null, null, false);

                                var _local_17:BitmapData = canvas;
                                return (_local_17);
                            };

                            var _local_18:BitmapData = _cachedBitmapData;
                            return (_local_18);
                        };
                    }

                    else
                    {
                        _cachedBitmapData.dispose();
                        _cachedBitmapData = null;
                    };
                }

                catch(e:Error)
                {
                    _cachedBitmapData.dispose();
                    _cachedBitmapData = null;
                    return (null);
                };
            };

            _isCached = true;

            if (_cachedBitmapData == null)
            {
                try
                {
                    _cachedBitmapData = new BitmapData(width, height, true, 0xFFFFFF);
                }

                catch(e:Error)
                {
                    if (_cachedBitmapData)
                    {
                        _cachedBitmapData.dispose();
                    };

                    _cachedBitmapData = null;
                    return (null);
                };
            }

            else
            {
                _cachedBitmapData.fillRect(_cachedBitmapData.rect, 0xFFFFFF);
            };

            if (canvas == null)
            {
                canvas = _cachedBitmapData;
            };

            _cachedBitmapNormal.assign(normal);
            _local_14 = 0;

            while (_local_14 < _layers.length)
            {
                _local_15 = (_layers[_local_14] as PlaneVisualizationLayer);
                _local_13 = (_layers[_local_14] as PlaneVisualizationAnimationLayer);

                if (_local_15 != null)
                {
                    _local_15.render(canvas, width, height, normal, useTexture, offsetX, offsetY);
                }

                else
                {
                    if (_local_13 != null)
                    {
                        _local_13.render(canvas, width, height, normal, offsetX, offsetY, maxX, maxY, dimensionX, dimensionY, timeSinceStartMs);
                    };
                };

                _local_14++;
            };

            if (((!(canvas == null)) && (!(canvas == _cachedBitmapData))))
            {
                _cachedBitmapData.copyPixels(canvas, canvas.rect, new Point(0, 0), null, null, false);
                return (canvas);
            };

            return (_cachedBitmapData);
        }

    }
}
