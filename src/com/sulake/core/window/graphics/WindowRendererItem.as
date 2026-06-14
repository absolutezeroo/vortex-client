package com.sulake.core.window.graphics
{
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import flash.display.BitmapData;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.geom.Point;

    public class WindowRendererItem implements IDisposable 
    {

        protected static const RENDER_TYPE_NULL:uint = 0;
        protected static const RENDER_TYPE_SKIN:uint = 1;
        protected static const RENDER_TYPE_FILL:uint = 2;
        protected static const MATRIX:Matrix = new Matrix();
        protected static const COLOR_TRANSFORM:ColorTransform = new ColorTransform();

        protected var _SafeStr_1132:TrackedBitmapData;
        protected var _SafeStr_437:ISkinContainer;
        protected var _disposed:Boolean;
        protected var _refresh:Boolean;
        protected var _SafeStr_1133:uint;
        protected var _SafeStr_1134:uint;

        public function WindowRendererItem(skinContainer:ISkinContainer)
        {
            _disposed = false;
            _SafeStr_437 = skinContainer;
            _SafeStr_1133 = 0xFFFFFFFF;
            _SafeStr_1134 = 0;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get buffer():BitmapData
        {
            return (_SafeStr_1132);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _disposed = true;
                _SafeStr_437 = null;

                if (_SafeStr_1132 != null)
                {
                    _SafeStr_1132.dispose();
                    _SafeStr_1132 = null;
                };
            };
        }

        public function purge():void
        {
        }

        public function render(window:IWindow, point:Point, _arg_3:Rectangle, _arg_4:Rectangle, data:BitmapData):BitmapData
        {
            var _local_12:Boolean;
            var _local_6:BitmapData;
            var _local_13:uint = ((window.background) ? 2 : 0);
            var _local_7:ISkinRenderer = _SafeStr_437.getSkinRendererByTypeAndStyle(window.type, window.style);

            if (_local_7 != null)
            {
                if (_local_7.isStateDrawable(_SafeStr_1134))
                {
                    _local_13 = 1;
                };
            };

            var _local_11:int = Math.max(window.renderingWidth, 1);
            var _local_8:int = Math.max(window.renderingHeight, 1);
            var _local_9:Boolean = true;

            if (_local_13 != 0)
            {
                if ((((!(_SafeStr_1132)) || (!(_SafeStr_1132.width == _local_11))) || (!(_SafeStr_1132.height == _local_8))))
                {
                    if (_SafeStr_1132)
                    {
                        _SafeStr_1132.dispose();
                    };

                    _SafeStr_1132 = new TrackedBitmapData(this, _local_11, _local_8, true, window.color);
                    _refresh = true;
                    _local_9 = false;
                };
            };

            var _local_14:IGraphicContext = IGraphicContextHost(window).getGraphicContext(false);

            if (_local_14)
            {
                if (!_local_14.visible)
                {
                    _local_14.visible = true;
                };

                _local_12 = window.testParamFlag(0x40000000);
                _local_6 = _local_14.setDrawRegion(window.renderingRectangle, (!(window.testParamFlag(16))), ((_local_12) ? _arg_4 : null));

                if (_local_6)
                {
                    data = _local_6;
                    _refresh = true;
                };
            };

            var _local_10:Boolean = (!(window.testParamFlag(16)));

            if (_local_13 != 0)
            {
                if (data != null)
                {
                    data.lock();

                    if (_local_13 == 1)
                    {
                        if (_refresh)
                        {
                            if (_local_10)
                            {
                                data.fillRect(_arg_3, 0);
                            };

                            _refresh = false;

                            if (_local_9)
                            {
                                _SafeStr_1132.fillRect(_SafeStr_1132.rect, window.color);
                            };

                            _local_7.draw(window, _SafeStr_1132, _SafeStr_1132.rect, _SafeStr_1134, false);
                        };

                        if (((window.blend < 1) && (!(_local_10))))
                        {
                            MATRIX.tx = (point.x - _arg_3.x);
                            MATRIX.ty = (point.y - _arg_3.y);
                            COLOR_TRANSFORM.alphaMultiplier = window.blend;
                            _arg_3.offset(MATRIX.tx, MATRIX.ty);
                            data.draw(_SafeStr_1132, MATRIX, COLOR_TRANSFORM, null, _arg_3, false);
                            _arg_3.offset(-(MATRIX.tx), -(MATRIX.ty));
                        }

                        else
                        {
                            data.copyPixels(_SafeStr_1132, _arg_3, point, null, null, true);
                        };
                    }

                    else
                    {
                        if (_local_13 == 2)
                        {
                            if (!_local_10)
                            {
                                _SafeStr_1132.fillRect(_SafeStr_1132.rect, window.color);
                                data.copyPixels(_SafeStr_1132, _arg_3, point, null, null, true);
                            }

                            else
                            {
                                data.fillRect(new Rectangle(point.x, point.y, _arg_3.width, _arg_3.height), window.color);
                                _local_14.blend = window.blend;
                            };
                        };
                    };

                    data.unlock();
                };
            }

            else
            {
                if (((_refresh) && (_local_10)))
                {
                    _refresh = false;

                    if (data != null)
                    {
                        data.fillRect(_arg_3, 0);
                    };
                };
            };

            _SafeStr_1133 = _SafeStr_1134;
            return (data);
        }

        public function testForStateChange(window:IWindow):Boolean
        {
            return (!(_SafeStr_437.getTheActualState(window.type, window.style, window.state) == _SafeStr_1133));
        }

        public function invalidate(window:IWindow, flag:uint):Boolean
        {
            var _local_4:IGraphicContext;
            var _local_3:Boolean;
            switch (flag)
            {
                case 1:
                    _refresh = true;
                    _local_3 = true;
                    break;
                case 2:
                    _refresh = true;
                    _local_3 = true;
                    break;
                case 4:

                    if (window.testParamFlag(16))
                    {
                        _local_3 = true;
                    }

                    else
                    {
                        _local_4 = IGraphicContextHost(window).getGraphicContext(true);
                        _local_4.setDrawRegion(window.renderingRectangle, false, null);

                        if (!_local_4.visible)
                        {
                            _local_3 = true;
                        };
                    };

                    break;
                case 8:
                    _SafeStr_1134 = _SafeStr_437.getTheActualState(window.type, window.style, window.state);

                    if (_SafeStr_1134 != _SafeStr_1133)
                    {
                        _refresh = true;
                        _local_3 = true;
                    };

                    break;
                case 16:

                    if (window.testParamFlag(16))
                    {
                        _refresh = true;
                        _local_3 = true;
                    }

                    else
                    {
                        IGraphicContextHost(window).getGraphicContext(true).blend = window.blend;
                    };

                    break;
                case 32:
                    _local_3 = true;
            };

            return (_local_3);
        }

        private function drawRect(data:BitmapData, rect:Rectangle, fillColor:uint):void
        {
            var _local_4:int;
            _local_4 = rect.left;

            while (_local_4 < rect.right)
            {
                data.setPixel32(_local_4, rect.top, fillColor);
                data.setPixel32(_local_4, (rect.bottom - 1), fillColor);
                _local_4++;
            };

            _local_4 = rect.top;

            while (_local_4 < rect.bottom)
            {
                data.setPixel32(rect.left, _local_4, fillColor);
                data.setPixel32((rect.right - 1), _local_4, fillColor);
                _local_4++;
            };
        }

    }
}
