package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
{
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.object.visualization.room.utils.Randomizer;
    import com.sulake.room.utils.IVector3d;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class PlaneMaterialCellMatrix 
    {

        public static const REPEAT_MODE_ALL:int = 1;
        public static const REPEAT_MODE_BORDERS:int = 2;
        public static const REPEAT_MODE_CENTER:int = 3;
        public static const REPEAT_MODE_FIRST:int = 4;
        public static const REPEAT_MODE_LAST:int = 5;
        public static const REPEAT_MODE_RANDOM:int = 6;
        public static const REPEAT_MODE_DEFAULT:int = 1;
        public static const _SafeStr_3425:Number = -1;
        public static const MAX_NORMAL_COORDINATE_VALUE:Number = 1;
        public static const ALIGN_TOP:int = 1;
        public static const ALIGN_BOTTOM:int = 2;
        public static const ALIGN_DEFAULT:int = 1;

        private var _columns:Array = [];
        private var _repeatMode:int = 1;
        private var _align:int = 1;
        private var _cachedBitmapData:BitmapData;
        private var _cachedBitmapNormal:Vector3d = null;
        private var _cachedBitmapHeight:int = 0;
        private var _isCached:Boolean = false;
        private var _isStatic:Boolean = true;
        private var _normalMinX:Number = -1;
        private var _normalMaxX:Number = 1;
        private var _normalMinY:Number = -1;
        private var _normalMaxY:Number = 1;

        public function PlaneMaterialCellMatrix(_arg_1:int, _arg_2:int=1, _arg_3:int=1, _arg_4:Number=-1, _arg_5:Number=1, _arg_6:Number=-1, _arg_7:Number=1)
        {
            var _local_8:int;
            super();

            if (_arg_1 < 1)
            {
                _arg_1 = 1;
            };

            _local_8 = 0;

            while (_local_8 < _arg_1)
            {
                _columns.push(null);
                _local_8++;
            };

            _repeatMode = _arg_2;
            _align = _arg_3;
            _normalMinX = _arg_4;
            _normalMaxX = _arg_5;
            _normalMinY = _arg_6;
            _normalMaxY = _arg_7;

            if (_repeatMode == 6)
            {
                _isStatic = false;
            };
        }

        private static function nextRandomColumnIndex(_arg_1:int):int
        {
            var _local_2:Array = Randomizer.getValues(1, 0, (_arg_1 * 17631));
            return (_local_2[0] % _arg_1);
        }

        public function get normalMinX():Number
        {
            return (_normalMinX);
        }

        public function get normalMaxX():Number
        {
            return (_normalMaxX);
        }

        public function get normalMinY():Number
        {
            return (_normalMinY);
        }

        public function get normalMaxY():Number
        {
            return (_normalMaxY);
        }

        public function isBottomAligned():Boolean
        {
            return (_align == 2);
        }

        public function get isStatic():Boolean
        {
            return (_isStatic);
        }

        public function dispose():void
        {
            if (_cachedBitmapData != null)
            {
                _cachedBitmapData.dispose();
                _cachedBitmapData = null;
            };

            if (_cachedBitmapNormal != null)
            {
                _cachedBitmapNormal = null;
            };
        }

        public function clearCache():void
        {
            var _local_2:int;
            var _local_1:PlaneMaterialCellColumn;

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
                _cachedBitmapNormal.x = 0;
                _cachedBitmapNormal.y = 0;
                _cachedBitmapNormal.z = 0;
            };

            _cachedBitmapHeight = 0;
            _local_2 = 0;

            while (_local_2 < _columns.length)
            {
                _local_1 = (_columns[_local_2] as PlaneMaterialCellColumn);

                if (_local_1 != null)
                {
                    _local_1.clearCache();
                };

                _local_2++;
            };

            _isCached = false;
        }

        public function createColumn(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int=1):Boolean
        {
            if (((_arg_1 < 0) || (_arg_1 >= _columns.length)))
            {
                return (false);
            };

            var _local_6:PlaneMaterialCellColumn = new PlaneMaterialCellColumn(_arg_2, _arg_3, _arg_4);
            var _local_5:PlaneMaterialCellColumn = (_columns[_arg_1] as PlaneMaterialCellColumn);

            if (_local_5 != null)
            {
                _local_5.dispose();
            };

            _columns[_arg_1] = _local_6;

            if (((!(_local_6 == null)) && (!(_local_6.isStatic))))
            {
                _isStatic = false;
            };

            return (true);
        }

        public function render(canvas:BitmapData, width:int, height:int, normal:IVector3d, useTexture:Boolean, offsetX:int, offsetY:int, topAlign:Boolean):BitmapData
        {
            var _local_12:int;
            var _local_11:PlaneMaterialCellColumn;
            var _local_10:BitmapData;

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

            if (_cachedBitmapNormal == null)
            {
                _cachedBitmapNormal = new Vector3d();
            };

            if (isStatic)
            {
                if (_cachedBitmapData != null)
                {
                    if ((((_cachedBitmapData.width == width) && (_cachedBitmapData.height == height)) && (Vector3d.isEqual(_cachedBitmapNormal, normal))))
                    {
                        if (canvas != null)
                        {
                            copyCachedBitmapOnCanvas(canvas, _cachedBitmapHeight, offsetY, topAlign);
                            return (canvas);
                        };

                        return (_cachedBitmapData);
                    };

                    _cachedBitmapData.dispose();
                    _cachedBitmapData = null;
                };
            }

            else
            {
                if (_cachedBitmapData != null)
                {
                    if (((_cachedBitmapData.width == width) && (_cachedBitmapData.height == height)))
                    {
                        _cachedBitmapData.fillRect(_cachedBitmapData.rect, 0xFFFFFF);
                    }

                    else
                    {
                        _cachedBitmapData.dispose();
                        _cachedBitmapData = null;
                    };
                };
            };

            _isCached = true;
            _cachedBitmapNormal.assign(normal);

            if (!useTexture)
            {
                _cachedBitmapHeight = height;

                if (_cachedBitmapData == null)
                {
                    try
                    {
                        _cachedBitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
                    }

                    catch(e:Error)
                    {
                        return (null);
                    };
                }

                else
                {
                    _cachedBitmapData.fillRect(_cachedBitmapData.rect, 0xFFFFFFFF);
                };

                if (canvas != null)
                {
                    copyCachedBitmapOnCanvas(canvas, height, offsetY, topAlign);
                    return (canvas);
                };

                return (_cachedBitmapData);
            };

            if (_cachedBitmapData == null)
            {
                _cachedBitmapHeight = height;
                try
                {
                    _cachedBitmapData = new BitmapData(width, height, true, 0xFFFFFF);
                }

                catch(e:Error)
                {
                    _cachedBitmapData = null;
                    return (null);
                };
            };

            var _local_9:Array = [];
            _local_12 = 0;

            while (_local_12 < _columns.length)
            {
                _local_11 = (_columns[_local_12] as PlaneMaterialCellColumn);

                if (_local_11 != null)
                {
                    _local_10 = _local_11.render(height, normal, offsetX, offsetY);

                    if (_local_10 != null)
                    {
                        _local_9.push(_local_10);
                    };
                };

                _local_12++;
            };

            if (_local_9.length == 0)
            {
                if (canvas != null)
                {
                    return (canvas);
                };

                return (_cachedBitmapData);
            };

            var _local_13:int;
            switch (_repeatMode)
            {
                case 2:
                    _local_13 = renderRepeatBorders(_cachedBitmapData, _local_9);
                    break;
                case 3:
                    _local_13 = renderRepeatCenter(_cachedBitmapData, _local_9);
                    break;
                case 4:
                    _local_13 = renderRepeatFirst(_cachedBitmapData, _local_9);
                    break;
                case 5:
                    _local_13 = renderRepeatLast(_cachedBitmapData, _local_9);
                    break;
                case 6:
                    _local_13 = renderRepeatRandom(_cachedBitmapData, _local_9);
                    break;
                default:
                    _local_13 = renderRepeatAll(_cachedBitmapData, _local_9);
            };

            _cachedBitmapHeight = _local_13;

            if (canvas != null)
            {
                copyCachedBitmapOnCanvas(canvas, _local_13, offsetY, topAlign);
                return (canvas);
            };

            return (_cachedBitmapData);
        }

        private function copyCachedBitmapOnCanvas(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            if ((((_arg_1 == null) || (_cachedBitmapData == null)) || (_arg_1 == _cachedBitmapData)))
            {
                return;
            };

            if (!_arg_4)
            {
                _arg_3 = ((_arg_1.height - _arg_2) - _arg_3);
            };

            var _local_5:Rectangle;

            if (_align == 1)
            {
                _local_5 = new Rectangle(0, 0, _cachedBitmapData.width, _cachedBitmapHeight);
            }

            else
            {
                _local_5 = new Rectangle(0, (_cachedBitmapData.height - _cachedBitmapHeight), _cachedBitmapData.width, _cachedBitmapHeight);
            };

            _arg_1.copyPixels(_cachedBitmapData, _local_5, new Point(0, _arg_3), null, null, true);
        }

        private function getColumnsWidth(_arg_1:Array):int
        {
            var _local_3:int;
            var _local_2:BitmapData;

            if (((_arg_1 == null) || (_arg_1.length == 0)))
            {
                return (0);
            };

            var _local_4:int;
            _local_3 = 0;

            while (_local_3 < _arg_1.length)
            {
                _local_2 = (_arg_1[_local_3] as BitmapData);

                if (_local_2 != null)
                {
                    _local_4 = (_local_4 + _local_2.width);
                };

                _local_3++;
            };

            return (_local_4);
        }

        private function renderColumns(_arg_1:BitmapData, _arg_2:Array, _arg_3:int, _arg_4:Boolean):Point
        {
            var _local_8:int;
            var _local_5:int;

            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (new Point(_arg_3, 0));
            };

            var _local_6:int;
            var _local_7:BitmapData;
            _local_8 = 0;

            while (_local_8 < _arg_2.length)
            {
                if (_arg_4)
                {
                    _local_7 = (_arg_2[_local_8] as BitmapData);
                }

                else
                {
                    _local_7 = (_arg_2[((_arg_2.length - 1) - _local_8)] as BitmapData);
                };

                if (_local_7 != null)
                {
                    if (!_arg_4)
                    {
                        _arg_3 = (_arg_3 - _local_7.width);
                    };

                    _local_5 = 0;

                    if (_align == 2)
                    {
                        _local_5 = (_arg_1.height - _local_7.height);
                    };

                    _arg_1.copyPixels(_local_7, _local_7.rect, new Point(_arg_3, _local_5), _local_7, null, true);

                    if (_local_7.height > _local_6)
                    {
                        _local_6 = _local_7.height;
                    };

                    if (_arg_4)
                    {
                        _arg_3 = (_arg_3 + _local_7.width);
                    };

                    if ((((_arg_4) && (_arg_3 >= _arg_1.width)) || ((!(_arg_4)) && (_arg_3 <= 0))))
                    {
                        return (new Point(_arg_3, _local_6));
                    };
                };

                _local_8++;
            };

            return (new Point(_arg_3, _local_6));
        }

        private function renderRepeatAll(_arg_1:BitmapData, _arg_2:Array):int
        {
            var _local_6:Point;

            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (0);
            };

            var _local_4:int;
            var _local_5:int = getColumnsWidth(_arg_2);
            var _local_3:int;

            if (_local_5 > _arg_1.width)
            {
            };

            while (_local_3 < _arg_1.width)
            {
                _local_6 = renderColumns(_arg_1, _arg_2, _local_3, true);
                _local_3 = _local_6.x;

                if (_local_6.y > _local_4)
                {
                    _local_4 = _local_6.y;
                };

                if (_local_6.x == 0)
                {
                    return (_local_4);
                };
            };

            return (_local_4);
        }

        private function renderRepeatBorders(_arg_1:BitmapData, _arg_2:Array):int
        {
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (0);
            };

            var _local_5:int;
            var _local_6:BitmapData;
            var _local_9:Array = [];
            var _local_3:int;
            var _local_7:int;
            _local_7 = 1;

            while (_local_7 < (_arg_2.length - 1))
            {
                _local_6 = (_arg_2[_local_7] as BitmapData);

                if (_local_6 != null)
                {
                    _local_3 = (_local_3 + _local_6.width);
                    _local_9.push(_local_6);
                };

                _local_7++;
            };

            if (_columns.length == 1)
            {
                _local_6 = (_columns[0] as BitmapData);

                if (_local_6 != null)
                {
                    _local_3 = _local_6.width;
                    _local_9.push(_local_6);
                };
            };

            var _local_4:int = ((_arg_1.width - _local_3) >> 1);
            var _local_10:Point;
            _local_10 = renderColumns(_arg_1, _local_9, _local_4, true);

            var _local_8:int = _local_10.x;

            if (_local_10.y > _local_5)
            {
                _local_5 = _local_10.y;
            };

            _local_6 = (_arg_2[0] as BitmapData);

            if (_local_6 != null)
            {
                _local_9 = [_local_6];

                while (_local_4 >= 0)
                {
                    _local_10 = renderColumns(_arg_1, _local_9, _local_4, false);
                    _local_4 = _local_10.x;

                    if (_local_10.y > _local_5)
                    {
                        _local_5 = _local_10.y;
                    };
                };
            };

            _local_6 = (_arg_2[(_arg_2.length - 1)] as BitmapData);

            if (_local_6 != null)
            {
                _local_9 = [_local_6];

                while (_local_8 < _arg_1.height)
                {
                    _local_10 = renderColumns(_arg_1, _local_9, _local_8, true);
                    _local_8 = _local_10.x;

                    if (_local_10.y > _local_5)
                    {
                        _local_5 = _local_10.y;
                    };
                };
            };

            return (_local_5);
        }

        private function renderRepeatCenter(_arg_1:BitmapData, _arg_2:Array):int
        {
            var _local_12:int;
            var _local_11:int;
            var _local_5:int;
            var _local_9:int;
            var _local_15:Array;

            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (0);
            };

            var _local_13:int;
            var _local_8:BitmapData;
            var _local_4:Array = [];
            var _local_3:Array = [];
            var _local_18:int;
            var _local_7:int;
            var _local_10:int;
            _local_10 = 0;

            while (_local_10 < (_arg_2.length >> 1))
            {
                _local_8 = (_arg_2[_local_10] as BitmapData);

                if (_local_8 != null)
                {
                    _local_18 = (_local_18 + _local_8.width);
                    _local_4.push(_local_8);
                };

                _local_10++;
            };

            _local_10 = ((_arg_2.length >> 1) + 1);

            while (_local_10 < _arg_2.length)
            {
                _local_8 = (_arg_2[_local_10] as BitmapData);

                if (_local_8 != null)
                {
                    _local_7 = (_local_7 + _local_8.width);
                    _local_3.push(_local_8);
                };

                _local_10++;
            };

            var _local_16:Point;
            var _local_14:int;
            var _local_6:int;
            var _local_17:int = _arg_1.width;

            if ((_local_18 + _local_7) > _arg_1.width)
            {
                _local_14 = ((_local_18 + _local_7) - _arg_1.width);
                _local_6 = (_local_6 - (_local_14 >> 1));
                _local_17 = (_local_17 + (_local_14 - (_local_14 >> 1)));
            };

            if (_local_14 == 0)
            {
                _local_8 = (_arg_2[(_arg_2.length >> 1)] as BitmapData);

                if (_local_8 != null)
                {
                    _local_12 = _local_8.width;
                    _local_11 = (_arg_1.width - (_local_18 + _local_7));
                    _local_5 = int((Math.ceil((_local_11 / _local_12)) * _local_12));
                    _local_6 = (_local_18 - ((_local_5 - _local_11) >> 1));
                    _local_9 = (_local_6 + _local_5);
                    _local_15 = [_local_8];

                    while (_local_6 < _local_9)
                    {
                        _local_16 = renderColumns(_arg_1, _local_15, _local_6, true);
                        _local_6 = _local_16.x;

                        if (_local_16.y > _local_13)
                        {
                            _local_13 = _local_16.y;
                        };
                    };
                };
            };

            _local_6 = 0;
            _local_16 = renderColumns(_arg_1, _local_4, _local_6, true);

            if (_local_16.y > _local_13)
            {
                _local_13 = _local_16.y;
            };

            _local_16 = renderColumns(_arg_1, _local_3, _local_17, false);

            if (_local_16.y > _local_13)
            {
                _local_13 = _local_16.y;
            };

            return (_local_13);
        }

        private function renderRepeatFirst(_arg_1:BitmapData, _arg_2:Array):int
        {
            var _local_6:Array;

            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (0);
            };

            var _local_4:int;
            var _local_5:BitmapData;
            var _local_3:int = _arg_1.width;
            var _local_7:Point = renderColumns(_arg_1, _arg_2, _local_3, false);
            _local_3 = _local_7.x;

            if (_local_7.y > _local_4)
            {
                _local_4 = _local_7.y;
            };

            _local_5 = (_arg_2[0] as BitmapData);

            if (_local_5 != null)
            {
                _local_6 = [_local_5];

                while (_local_3 >= 0)
                {
                    _local_7 = renderColumns(_arg_1, _local_6, _local_3, false);
                    _local_3 = _local_7.x;

                    if (_local_7.y > _local_4)
                    {
                        _local_4 = _local_7.y;
                    };
                };
            };

            return (_local_4);
        }

        private function renderRepeatLast(_arg_1:BitmapData, _arg_2:Array):int
        {
            var _local_6:Array;

            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (0);
            };

            var _local_4:int;
            var _local_5:BitmapData;
            var _local_3:int;
            var _local_7:Point = renderColumns(_arg_1, _arg_2, _local_3, true);
            _local_3 = _local_7.x;

            if (_local_7.y > _local_4)
            {
                _local_4 = _local_7.y;
            };

            _local_5 = (_arg_2[(_arg_2.length - 1)] as BitmapData);

            if (_local_5 != null)
            {
                _local_6 = [_local_5];

                while (_local_3 < _arg_1.width)
                {
                    _local_7 = renderColumns(_arg_1, _local_6, _local_3, true);
                    _local_3 = _local_7.x;

                    if (_local_7.y > _local_4)
                    {
                        _local_4 = _local_7.y;
                    };
                };
            };

            return (_local_4);
        }

        private function renderRepeatRandom(_arg_1:BitmapData, _arg_2:Array):int
        {
            var _local_6:Array;
            var _local_7:Point;

            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (_arg_1 == null)))
            {
                return (0);
            };

            var _local_4:int;
            var _local_5:BitmapData;
            var _local_3:int;

            while (_local_3 < _arg_1.width)
            {
                _local_5 = (_arg_2[nextRandomColumnIndex(_arg_2.length)] as BitmapData);

                if (_local_5 != null)
                {
                    _local_6 = [_local_5];
                    _local_7 = renderColumns(_arg_1, _local_6, _local_3, true);
                    _local_3 = _local_7.x;

                    if (_local_7.y > _local_4)
                    {
                        _local_4 = _local_7.y;
                    };
                }

                else
                {
                    return (_local_4);
                };
            };

            return (_local_4);
        }

        public function getColumns(_arg_1:int):Array
        {
            var _local_2:Array;
            var _local_4:int;
            var _local_3:PlaneMaterialCellColumn;

            if (_repeatMode == 6)
            {
                _local_2 = [];
                _local_4 = 0;

                while (_local_4 < _arg_1)
                {
                    _local_3 = _columns[nextRandomColumnIndex(_columns.length)];

                    if (_local_3 != null)
                    {
                        _local_2.push(_local_3);

                        if (_local_3.width > 1)
                        {
                            _local_4 = (_local_4 + _local_3.width);
                        }

                        else
                        {
                            break;
                        };
                    }

                    else
                    {
                        break;
                    };
                };

                return (_local_2);
            };

            return (_columns);
        }

    }
}
