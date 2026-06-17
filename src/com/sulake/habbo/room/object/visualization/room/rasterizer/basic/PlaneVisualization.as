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

        public function PlaneVisualization(scale:Number, layerCount:int, geometry:IRoomGeometry)
        {
            var index:int;
            super();

            if (layerCount < 0)
            {
                layerCount = 0;
            };

            index = 0;

            while (index < layerCount)
            {
                _layers.push(null);
                index++;
            };

            _geometry = geometry;
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
            var index:int;
            var disposable:IDisposable;

            if (_layers != null)
            {
                index = 0;

                while (index < _layers.length)
                {
                    disposable = (_layers[index] as IDisposable);

                    if (disposable != null)
                    {
                        disposable.dispose();
                    };

                    index++;
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
            var index:int;
            var visualizationLayer:PlaneVisualizationLayer;
            var animationLayer:PlaneVisualizationAnimationLayer;

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
                index = 0;

                while (index < _layers.length)
                {
                    visualizationLayer = (_layers[index] as PlaneVisualizationLayer);
                    animationLayer = (_layers[index] as PlaneVisualizationAnimationLayer);

                    if (visualizationLayer != null)
                    {
                        visualizationLayer.clearCache();
                    }

                    else
                    {
                        if (animationLayer != null)
                        {
                            animationLayer.clearCache();
                        };
                    };

                    index++;
                };
            };

            _isCached = false;
        }

        public function setLayer(layerIndex:int, material:PlaneMaterial, color:uint, align:int, offset:int=0):Boolean
        {
            if (((layerIndex < 0) || (layerIndex > _layers.length)))
            {
                return (false);
            };

            var disposable:IDisposable = (_layers[layerIndex] as IDisposable);

            if (disposable != null)
            {
                disposable.dispose();
                disposable = null;
            };

            disposable = new PlaneVisualizationLayer(material, color, align, offset);
            _layers[layerIndex] = disposable;
            return (true);
        }

        public function setAnimationLayer(layerIndex:int, xml:XML, assetCollection:IGraphicAssetCollection):Boolean
        {
            if (((layerIndex < 0) || (layerIndex > _layers.length)))
            {
                return (false);
            };

            var disposable:IDisposable = (_layers[layerIndex] as IDisposable);

            if (disposable != null)
            {
                disposable.dispose();
                disposable = null;
            };

            disposable = new PlaneVisualizationAnimationLayer(xml, assetCollection);
            _layers[layerIndex] = disposable;
            _hasAnimationLayers = true;
            return (true);
        }

        public function getLayers():Array
        {
            return (_layers);
        }

        public function render(canvas:BitmapData, width:int, height:int, normal:IVector3d, useTexture:Boolean, offsetX:int=0, offsetY:int=0, maxX:int=0, maxY:int=0, dimensionX:Number=0, dimensionY:Number=0, timeSinceStartMs:int=0):BitmapData
        {
            var index:int;
            var visualizationLayer:PlaneVisualizationLayer;
            var animationLayer:PlaneVisualizationAnimationLayer;

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

                                var resultCanvas:BitmapData = canvas;
                                return (resultCanvas);
                            };

                            var resultBitmapData:BitmapData = _cachedBitmapData;
                            return (resultBitmapData);
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
            index = 0;

            while (index < _layers.length)
            {
                visualizationLayer = (_layers[index] as PlaneVisualizationLayer);
                animationLayer = (_layers[index] as PlaneVisualizationAnimationLayer);

                if (visualizationLayer != null)
                {
                    visualizationLayer.render(canvas, width, height, normal, useTexture, offsetX, offsetY);
                }

                else
                {
                    if (animationLayer != null)
                    {
                        animationLayer.render(canvas, width, height, normal, offsetX, offsetY, maxX, maxY, dimensionX, dimensionY, timeSinceStartMs);
                    };
                };

                index++;
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
