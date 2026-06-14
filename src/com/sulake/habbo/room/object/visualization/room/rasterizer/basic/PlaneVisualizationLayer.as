package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import com.sulake.core.runtime.IDisposable;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

    public class PlaneVisualizationLayer implements IDisposable 
    {

        public static const DEFAULT_OFFSET:int = 0;
        public static const ALIGN_TOP:int = 1;
        public static const ALIGN_BOTTOM:int = 2;
        public static const ALIGN_DEFAULT:int = 1;

        private var _material:PlaneMaterial = null;
        private var _color:uint = 0;
        private var _offset:int = 0;
        private var _align:int = 1;
        private var _bitmapData:BitmapData = null;
        private var _disposed:Boolean = false;

        public function PlaneVisualizationLayer(_arg_1:PlaneMaterial, _arg_2:uint, _arg_3:int, _arg_4:int=0)
        {
            _material = _arg_1;
            _offset = _arg_4;
            _align = _arg_3;
            _color = _arg_2;
        }

        public function get offset():int
        {
            return (_offset);
        }

        public function get align():int
        {
            return (_align);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function dispose():void
        {
            _disposed = true;
            _material = null;

            if (_bitmapData != null)
            {
                _bitmapData.dispose();
                _bitmapData = null;
            };
        }

        public function clearCache():void
        {
            if (_bitmapData != null)
            {
                _bitmapData.dispose();
                _bitmapData = null;
            };
        }

        public function render(canvas:BitmapData, width:int, height:int, normal:IVector3d, useTexture:Boolean, offsetX:int, offsetY:int):BitmapData
        {
            var _local_16:Number;
            var _local_13:Number;
            var _local_10:Number;
            var _local_14:ColorTransform;
            var _local_12:uint = (_color >> 16);
            var _local_9:uint = ((_color >> 8) & 0xFF);
            var _local_8:uint = (_color & 0xFF);
            var _local_11:Boolean;

            if ((((_local_12 < 0xFF) || (_local_9 < 0xFF)) || (_local_8 < 0xFF)))
            {
                _local_11 = true;
            };

            if ((((canvas == null) || (!(canvas.width == width))) || (!(canvas.height == height))))
            {
                canvas = null;
            };

            var _local_15:BitmapData;

            if (_material != null)
            {
                if (_local_11)
                {
                    _local_15 = _material.render(null, width, height, normal, useTexture, offsetX, (offsetY + offset), (align == 1));
                }

                else
                {
                    _local_15 = _material.render(canvas, width, height, normal, useTexture, offsetX, (offsetY + offset), (align == 1));
                };

                if (((!(_local_15 == null)) && (!(_local_15 == canvas))))
                {
                    if (_bitmapData != null)
                    {
                        _bitmapData.dispose();
                    };

                    try
                    {
                        _bitmapData = _local_15.clone();
                    }

                    catch(e:Error)
                    {
                        if (_bitmapData)
                        {
                            _bitmapData.dispose();
                        };

                        _bitmapData = null;
                        return (null);
                    };

                    _local_15 = _bitmapData;
                };
            }

            else
            {
                if (canvas == null)
                {
                    if ((((!(_bitmapData == null)) && (_bitmapData.width == width)) && (_bitmapData.height == height)))
                    {
                        return (_bitmapData);
                    };

                    if (_bitmapData != null)
                    {
                        _bitmapData.dispose();
                    };

                    _bitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
                    _local_15 = _bitmapData;
                }

                else
                {
                    canvas.fillRect(canvas.rect, 0xFFFFFFFF);
                    _local_15 = canvas;
                };
            };

            if (_local_15 != null)
            {
                if (_local_11)
                {
                    _local_16 = (_local_12 / 0xFF);
                    _local_13 = (_local_9 / 0xFF);
                    _local_10 = (_local_8 / 0xFF);
                    _local_14 = new ColorTransform(_local_16, _local_13, _local_10);
                    _local_15.colorTransform(_local_15.rect, _local_14);

                    if (((!(canvas == null)) && (!(_local_15 == canvas))))
                    {
                        canvas.copyPixels(_local_15, _local_15.rect, new Point(0, 0), null, null, true);
                        _local_15 = canvas;
                    };
                };
            };

            return (_local_15);
        }

        public function getMaterial():PlaneMaterial
        {
            return (_material);
        }

        public function getColor():uint
        {
            return (_color);
        }

    }
}
