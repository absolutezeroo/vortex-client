package com.sulake.habbo.room.object.visualization.furniture
{
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    public class FurniturePlane 
    {

        private var _geometryUpdateId:int = -1;
        private var _geometryDirX:Number = 0;
        private var _geometryDirY:Number = 0;
        private var _geometryDirZ:Number = 0;
        private var _geometryScale:Number = 0;
        private var _origin:Vector3d = null;
        private var _location:Vector3d = null;
        private var _leftSide:Vector3d = null;
        private var _rightSide:Vector3d = null;
        private var _leftSideOriginal:Vector3d = null;
        private var _rightSideOriginal:Vector3d = null;
        private var _normal:Vector3d = null;
        private var _visible:Boolean = true;
        private var _bitmapData:BitmapData = null;
        private var _textures:Map = null;
        private var _offset:Point = null;
        private var _relativeDepth:Number = 0;
        private var _color:uint = 0;
        private var _rotated:Boolean = false;
        private var _id:String = null;
        private var _cornerA:Vector3d = null;
        private var _cornerB:Vector3d = null;
        private var _cornerC:Vector3d = null;
        private var _cornerD:Vector3d = null;
        private var _width:Number = 0;
        private var _height:Number = 0;

        public function FurniturePlane(_arg_1:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d)
        {
            _origin = new Vector3d();
            _location = new Vector3d();
            _location.assign(_arg_1);
            _leftSide = new Vector3d();
            _leftSide.assign(_arg_2);
            _rightSide = new Vector3d();
            _rightSide.assign(_arg_3);
            _leftSideOriginal = new Vector3d();
            _leftSideOriginal.assign(_arg_2);
            _rightSideOriginal = new Vector3d();
            _rightSideOriginal.assign(_arg_3);
            _normal = Vector3d.crossProduct(_leftSide, _rightSide);

            if (_normal.length > 0)
            {
                _normal.mul((1 / _normal.length));
            };

            _offset = new Point();
            _cornerA = new Vector3d();
            _cornerB = new Vector3d();
            _cornerC = new Vector3d();
            _cornerD = new Vector3d();
            _textures = new Map();
        }

        public function get bitmapData():BitmapData
        {
            if (_visible)
            {
                if (_bitmapData != null)
                {
                    return (_bitmapData.clone());
                };
            };

            return (null);
        }

        public function get visible():Boolean
        {
            return (_visible);
        }

        public function get offset():Point
        {
            return (_offset);
        }

        public function get relativeDepth():Number
        {
            return (_relativeDepth);
        }

        public function get color():uint
        {
            return (_color);
        }

        public function set color(_arg_1:uint):void
        {
            _color = _arg_1;
        }

        public function get leftSide():IVector3d
        {
            return (_leftSide);
        }

        public function get rightSide():IVector3d
        {
            return (_rightSide);
        }

        public function get location():IVector3d
        {
            return (_location);
        }

        public function get normal():IVector3d
        {
            return (_normal);
        }

        public function dispose():void
        {
            var _local_2:int;
            var _local_1:BitmapData;

            if (_bitmapData != null)
            {
                _bitmapData.dispose();
                _bitmapData = null;
            };

            if (_textures != null)
            {
                _local_2 = 0;

                while (_local_2 < _textures.length)
                {
                    _local_1 = (_textures.getWithIndex(_local_2) as BitmapData);

                    if (_local_1 != null)
                    {
                        _local_1.dispose();
                    };

                    _local_2++;
                };

                _textures.dispose();
                _textures = null;
            };

            _origin = null;
            _location = null;
            _leftSide = null;
            _rightSide = null;
            _leftSideOriginal = null;
            _rightSideOriginal = null;
            _normal = null;
            _cornerA = null;
            _cornerB = null;
            _cornerC = null;
            _cornerD = null;
        }

        public function setRotation(_arg_1:Boolean):void
        {
            if (_arg_1 != _rotated)
            {
                if (!_arg_1)
                {
                    _leftSide.assign(_leftSideOriginal);
                    _rightSide.assign(_rightSideOriginal);
                }

                else
                {
                    _leftSide.assign(_leftSideOriginal);
                    _leftSide.mul((_rightSideOriginal.length / _leftSideOriginal.length));
                    _rightSide.assign(_rightSideOriginal);
                    _rightSide.mul((_leftSideOriginal.length / _rightSideOriginal.length));
                };

                _geometryUpdateId = -1;
                _geometryDirX = (_geometryDirX - 1);
                _rotated = _arg_1;
                resetTextureCache();
            };
        }

        private function cacheTexture(_arg_1:String, _arg_2:BitmapData):Boolean
        {
            var _local_3:BitmapData = (_textures.remove(_arg_1) as BitmapData);

            if (((!(_local_3 == null)) && (!(_arg_2 == _local_3))))
            {
                _local_3.dispose();
            };

            _textures.add(_arg_1, _arg_2);
            return (true);
        }

        private function resetTextureCache():void
        {
            var _local_2:int;
            var _local_1:BitmapData;

            if (_textures != null)
            {
                _local_2 = 0;

                while (_local_2 < _textures.length)
                {
                    _local_1 = (_textures.getWithIndex(_local_2) as BitmapData);

                    if (_local_1 != null)
                    {
                        _local_1.dispose();
                    };

                    _local_2++;
                };

                _textures.reset();
            };
        }

        private function getTextureIdentifier(_arg_1:IRoomGeometry):String
        {
            if (_arg_1 == null)
            {
                return (null);
            };

            return (String(_arg_1.scale));
        }

        private function needsNewTexture(_arg_1:IRoomGeometry):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };

            var _local_2:String = getTextureIdentifier(_arg_1);
            var _local_3:BitmapData = (_textures.getValue(_local_2) as BitmapData);

            if (((_width > 0) && (_height > 0)))
            {
                if (_local_3 == null)
                {
                    return (true);
                };
            };

            return (false);
        }

        private function getTexture(_arg_1:IRoomGeometry, _arg_2:int):BitmapData
        {
            var _local_6:Number;
            var _local_7:Number;
            var _local_4:IVector3d;

            if (_arg_1 == null)
            {
                return (null);
            };

            var _local_3:String = getTextureIdentifier(_arg_1);
            var _local_5:BitmapData;

            if (needsNewTexture(_arg_1))
            {
                _local_6 = (_leftSide.length * _arg_1.scale);
                _local_7 = (_rightSide.length * _arg_1.scale);

                if (_local_6 < 1)
                {
                    _local_6 = 1;
                };

                if (_local_7 < 1)
                {
                    _local_7 = 1;
                };

                _local_4 = _arg_1.getCoordinatePosition(_normal);
                _local_5 = (_textures.getValue(_local_3) as BitmapData);

                if (_local_5 == null)
                {
                    _local_5 = new BitmapData(_local_6, _local_7, true, (0xFF000000 | _color));

                    if (_local_5 != null)
                    {
                        cacheTexture(_local_3, _local_5);
                    };
                };
            }

            else
            {
                _local_5 = (_textures.getValue(_local_3) as BitmapData);
            };

            if (_local_5 != null)
            {
                return (_local_5);
            };

            return (null);
        }

        public function update(_arg_1:IRoomGeometry, _arg_2:int):Boolean
        {
            var _local_6:IVector3d;
            var _local_3:Number;
            var _local_4:IVector3d;
            var _local_5:Number;
            var _local_7:Number;
            var _local_8:BitmapData;

            if ((((((_arg_1 == null) || ((_location == null) && (!(_origin == null)))) || (_leftSide == null)) || (_rightSide == null)) || (_normal == null)))
            {
                return (false);
            };

            var _local_9:Boolean;

            if (_arg_1.updateId != _geometryUpdateId)
            {
                _geometryUpdateId = _arg_1.updateId;
                _local_6 = _arg_1.direction;

                if (((!(_local_6 == null)) && ((((!(_local_6.x == _geometryDirX)) || (!(_local_6.y == _geometryDirY))) || (!(_local_6.z == _geometryDirZ))) || (!(_arg_1.scale == _geometryScale)))))
                {
                    _geometryDirX = _local_6.x;
                    _geometryDirY = _local_6.y;
                    _geometryDirZ = _local_6.z;
                    _geometryScale = _arg_1.scale;
                    _local_9 = true;
                    _local_3 = 0;
                    _local_3 = Vector3d.cosAngle(_arg_1.directionAxis, normal);

                    if (_local_3 > -0.001)
                    {
                        if (_visible)
                        {
                            _visible = false;
                            return (true);
                        };

                        return (false);
                    };

                    updateCorners(_arg_1);
                    _local_4 = _arg_1.getScreenPosition(_origin);
                    _local_5 = _local_4.z;
                    _local_7 = Math.max((_cornerA.z - _local_5), (_cornerB.z - _local_5), (_cornerC.z - _local_5), (_cornerD.z - _local_5));
                    _relativeDepth = _local_7;
                    _visible = true;
                };
            };

            if (((needsNewTexture(_arg_1)) || (_local_9)))
            {
                if ((((_bitmapData == null) || (!(_width == _bitmapData.width))) || (!(_height == _bitmapData.height))))
                {
                    if (_bitmapData != null)
                    {
                        _bitmapData.dispose();
                        _bitmapData = null;

                        if (((_width < 1) || (_height < 1)))
                        {
                            return (true);
                        };
                    }

                    else
                    {
                        if (((_width < 1) || (_height < 1)))
                        {
                            return (false);
                        };
                    };

                    _bitmapData = new BitmapData(_width, _height, true, 0xFFFFFF);
                    _bitmapData.lock();
                }

                else
                {
                    _bitmapData.lock();
                    _bitmapData.fillRect(_bitmapData.rect, 0xFFFFFF);
                };

                _local_8 = getTexture(_arg_1, _arg_2);

                if (_local_8 != null)
                {
                    renderTexture(_arg_1, _local_8);
                };

                _bitmapData.unlock();
                return (true);
            };

            return (false);
        }

        private function updateCorners(_arg_1:IRoomGeometry):void
        {
            _cornerA.assign(_arg_1.getScreenPosition(_location));
            _cornerB.assign(_arg_1.getScreenPosition(Vector3d.sum(_location, _rightSide)));
            _cornerC.assign(_arg_1.getScreenPosition(Vector3d.sum(Vector3d.sum(_location, _leftSide), _rightSide)));
            _cornerD.assign(_arg_1.getScreenPosition(Vector3d.sum(_location, _leftSide)));
            _offset = _arg_1.getScreenPoint(_origin);
            _cornerA.x = Math.round(_cornerA.x);
            _cornerA.y = Math.round(_cornerA.y);
            _cornerB.x = Math.round(_cornerB.x);
            _cornerB.y = Math.round(_cornerB.y);
            _cornerC.x = Math.round(_cornerC.x);
            _cornerC.y = Math.round(_cornerC.y);
            _cornerD.x = Math.round(_cornerD.x);
            _cornerD.y = Math.round(_cornerD.y);
            _offset.x = Math.round(_offset.x);
            _offset.y = Math.round(_offset.y);

            var _local_3:Number = Math.min(_cornerA.x, _cornerB.x, _cornerC.x, _cornerD.x);
            var _local_5:Number = Math.max(_cornerA.x, _cornerB.x, _cornerC.x, _cornerD.x);
            var _local_2:Number = Math.min(_cornerA.y, _cornerB.y, _cornerC.y, _cornerD.y);
            var _local_4:Number = Math.max(_cornerA.y, _cornerB.y, _cornerC.y, _cornerD.y);
            _local_5 = (_local_5 - _local_3);
            _offset.x = (_offset.x - _local_3);
            _cornerA.x = (_cornerA.x - _local_3);
            _cornerB.x = (_cornerB.x - _local_3);
            _cornerC.x = (_cornerC.x - _local_3);
            _cornerD.x = (_cornerD.x - _local_3);
            _local_4 = (_local_4 - _local_2);
            _offset.y = (_offset.y - _local_2);
            _cornerA.y = (_cornerA.y - _local_2);
            _cornerB.y = (_cornerB.y - _local_2);
            _cornerC.y = (_cornerC.y - _local_2);
            _cornerD.y = (_cornerD.y - _local_2);
            _width = _local_5;
            _height = _local_4;
        }

        private function renderTexture(_arg_1:IRoomGeometry, _arg_2:BitmapData):void
        {
            if (((((((_cornerA == null) || (_cornerB == null)) || (_cornerC == null)) || (_cornerD == null)) || (_arg_2 == null)) || (_bitmapData == null)))
            {
                return;
            };

            var _local_8:Number = (_cornerD.x - _cornerC.x);
            var _local_10:Number = (_cornerD.y - _cornerC.y);
            var _local_4:Number = (_cornerB.x - _cornerC.x);
            var _local_3:Number = (_cornerB.y - _cornerC.y);

            if (Math.abs((_local_4 - _arg_2.width)) <= 1)
            {
                _local_4 = _arg_2.width;
            };

            if (Math.abs((_local_3 - _arg_2.width)) <= 1)
            {
                _local_3 = _arg_2.width;
            };

            if (Math.abs((_local_8 - _arg_2.height)) <= 1)
            {
                _local_8 = _arg_2.height;
            };

            if (Math.abs((_local_10 - _arg_2.height)) <= 1)
            {
                _local_10 = _arg_2.height;
            };

            var _local_5:Number = (_local_4 / _arg_2.width);
            var _local_6:Number = (_local_3 / _arg_2.width);
            var _local_7:Number = (_local_8 / _arg_2.height);
            var _local_9:Number = (_local_10 / _arg_2.height);
            var _local_11:Matrix = new Matrix();
            _local_11.a = _local_5;
            _local_11.b = _local_6;
            _local_11.c = _local_7;
            _local_11.d = _local_9;
            _local_11.translate(_cornerC.x, _cornerC.y);
            draw(_arg_2, _local_11);
        }

        private function draw(_arg_1:BitmapData, _arg_2:Matrix):void
        {
            var _local_4:int;
            var _local_7:int;
            var _local_3:Number;
            var _local_6:int;
            var _local_5:int;

            if (_bitmapData != null)
            {
                if ((((((_arg_2.a == 1) && (_arg_2.d == 1)) && (_arg_2.c == 0)) && (!(_arg_2.b == 0))) && (Math.abs(_arg_2.b) <= 1)))
                {
                    _local_4 = 0;
                    _local_7 = 0;
                    _local_3 = 0;
                    _local_6 = 0;

                    if (_arg_2.b > 0)
                    {
                        _arg_2.ty++;
                    };

                    _local_5 = 0;

                    while (_local_4 < _arg_1.width)
                    {
                        _local_4++;
                        _local_3 = (_local_3 + Math.abs(_arg_2.b));

                        if (_local_3 >= 1)
                        {
                            _bitmapData.copyPixels(_arg_1, new Rectangle((_local_7 + _local_6), 0, (_local_4 - _local_7), _arg_1.height), new Point((_arg_2.tx + _local_7), (_arg_2.ty + _local_5)), null, null, true);
                            _local_7 = _local_4;

                            if (_arg_2.b > 0)
                            {
                                _local_5++;
                            }

                            else
                            {
                                _local_5--;
                            };

                            _local_3 = 0;
                        };
                    };

                    if (_local_3 > 0)
                    {
                        _bitmapData.copyPixels(_arg_1, new Rectangle(_local_7, 0, (_local_4 - _local_7), _arg_1.height), new Point((_arg_2.tx + _local_7), (_arg_2.ty + _local_5)), null, null, true);
                    };

                    return;
                };

                _bitmapData.draw(_arg_1, _arg_2, null, null, null, false);
            };
        }

    }
}
