package com.sulake.room.utils
{
    import com.sulake.core.utils.Map;
    import flash.geom.Point;

    public class RoomGeometry implements IRoomGeometry 
    {

        public static const SCALE_ZOOMED_IN:Number = 64;
        public static const SCALE_ZOOMED_OUT:Number = 32;

        private var _updateId:int = 0;
        private var _x:Vector3d;
        private var _y:Vector3d;
        private var _z:Vector3d;
        private var _directionAxis:Vector3d;
        private var _location:Vector3d;
        private var _direction:Vector3d;
        private var _depth:Vector3d;
        private var _scale:Number = 1;
        private var _x_scale:Number = 1;
        private var _y_scale:Number = 1;
        private var _z_scale:Number = 1;
        private var _x_scale_internal:Number = 1;
        private var _y_scale_internal:Number = 1;
        private var _z_scale_internal:Number = 1;
        private var _loc:Vector3d;
        private var _dir:Vector3d;
        private var _clipNear:Number = -500;
        private var _clipFar:Number = 500;
        private var _displacements:Map = null;

        public function RoomGeometry(scale:Number, direction:IVector3d, location:IVector3d, depthVector:IVector3d=null)
        {
            this.scale = scale;
            _x = new Vector3d();
            _y = new Vector3d();
            _z = new Vector3d();
            _directionAxis = new Vector3d();
            _location = new Vector3d();
            _direction = new Vector3d();
            _depth = new Vector3d();
            _x_scale_internal = 1;
            _y_scale_internal = 1;
            x_scale = 1;
            y_scale = 1;
            _z_scale_internal = (Math.sqrt(0.5) / Math.sqrt(0.75));
            z_scale = 1;
            this.location = new Vector3d(location.x, location.y, location.z);
            this.direction = new Vector3d(direction.x, direction.y, direction.z);

            if (depthVector != null)
            {
                setDepthVector(depthVector);
            }

            else
            {
                setDepthVector(direction);
            };

            _displacements = new Map();
        }

        public static function getIntersectionVector(origin:IVector3d, direction:IVector3d, point:IVector3d, normal:IVector3d):IVector3d
        {
            var _local_6:Number = Vector3d.dotProduct(direction, normal);

            if (Math.abs(_local_6) < 1E-5)
            {
                return (null);
            };

            var _local_8:Vector3d = Vector3d.dif(origin, point);
            var _local_5:Number = (-(Vector3d.dotProduct(normal, _local_8)) / _local_6);
            var _local_7:Vector3d = Vector3d.sum(origin, Vector3d.product(direction, _local_5));
            return (_local_7);
        }

        public function get updateId():int
        {
            return (_updateId);
        }

        public function get scale():Number
        {
            return (_scale / Math.sqrt(0.5));
        }

        public function get directionAxis():IVector3d
        {
            return (_directionAxis);
        }

        public function get location():IVector3d
        {
            _location.assign(_loc);
            _location.x = (_location.x * _x_scale);
            _location.y = (_location.y * _y_scale);
            _location.z = (_location.z * _z_scale);
            return (_location);
        }

        public function get direction():IVector3d
        {
            return (_direction);
        }

        public function set x_scale(xScale:Number):void
        {
            if (_x_scale != (xScale * _x_scale_internal))
            {
                _x_scale = (xScale * _x_scale_internal);
                _updateId++;
            };
        }

        public function set y_scale(yScale:Number):void
        {
            if (_y_scale != (yScale * _y_scale_internal))
            {
                _y_scale = (yScale * _y_scale_internal);
                _updateId++;
            };
        }

        public function set z_scale(zScale:Number):void
        {
            if (_z_scale != (zScale * _z_scale_internal))
            {
                _z_scale = (zScale * _z_scale_internal);
                _updateId++;
            };
        }

        public function set scale(value:Number):void
        {
            if (value <= 1)
            {
                value = 1;
            };

            value = (value * Math.sqrt(0.5));

            if (value != _scale)
            {
                _scale = value;
                _updateId++;
            };
        }

        public function set location(value:IVector3d):void
        {
            if (value == null)
            {
                return;
            };

            if (_loc == null)
            {
                _loc = new Vector3d();
            };

            var _local_2:Number = _loc.x;
            var _local_3:Number = _loc.y;
            var _local_4:Number = _loc.z;
            _loc.assign(value);
            _loc.x = (_loc.x / _x_scale);
            _loc.y = (_loc.y / _y_scale);
            _loc.z = (_loc.z / _z_scale);

            if ((((!(_loc.x == _local_2)) || (!(_loc.y == _local_3))) || (!(_loc.z == _local_4))))
            {
                _updateId++;
            };
        }

        public function set direction(value:IVector3d):void
        {
            var _local_4:Number;
            var _local_21:Number;
            var _local_19:Vector3d;
            var _local_14:Vector3d;
            var _local_2:Vector3d;

            if (value == null)
            {
                return;
            };

            if (_dir == null)
            {
                _dir = new Vector3d();
            };

            var _local_7:Number = _dir.x;
            var _local_8:Number = _dir.y;
            var _local_9:Number = _dir.z;
            _dir.assign(value);
            _direction.assign(value);

            if ((((!(_dir.x == _local_7)) || (!(_dir.y == _local_8))) || (!(_dir.z == _local_9))))
            {
                _updateId++;
            };

            var _local_18:Vector3d = new Vector3d(0, 1, 0);
            var _local_20:Vector3d = new Vector3d(0, 0, 1);
            var _local_22:Vector3d = new Vector3d(1, 0, 0);
            var _local_10:Number = ((value.x / 180) * 3.14159265358979);
            var _local_11:Number = ((value.y / 180) * 3.14159265358979);
            var _local_12:Number = ((value.z / 180) * 3.14159265358979);
            var _local_6:Number = Math.cos(_local_10);
            var _local_25:Number = Math.sin(_local_10);
            var _local_16:Vector3d = Vector3d.sum(Vector3d.product(_local_18, _local_6), Vector3d.product(_local_22, -(_local_25)));
            var _local_15:Vector3d = new Vector3d(_local_20.x, _local_20.y, _local_20.z);
            var _local_17:Vector3d = Vector3d.sum(Vector3d.product(_local_18, _local_25), Vector3d.product(_local_22, _local_6));
            var _local_5:Number = Math.cos(_local_11);
            var _local_24:Number = Math.sin(_local_11);
            var _local_13:Vector3d = new Vector3d(_local_16.x, _local_16.y, _local_16.z);
            var _local_23:Vector3d = Vector3d.sum(Vector3d.product(_local_15, _local_5), Vector3d.product(_local_17, _local_24));
            var _local_3:Vector3d = Vector3d.sum(Vector3d.product(_local_15, -(_local_24)), Vector3d.product(_local_17, _local_5));

            if (_local_12 != 0)
            {
                _local_4 = Math.cos(_local_12);
                _local_21 = Math.sin(_local_12);
                _local_19 = Vector3d.sum(Vector3d.product(_local_13, _local_4), Vector3d.product(_local_23, _local_21));
                _local_14 = Vector3d.sum(Vector3d.product(_local_13, -(_local_21)), Vector3d.product(_local_23, _local_4));
                _local_2 = new Vector3d(_local_3.x, _local_3.y, _local_3.z);
                _x.assign(_local_19);
                _y.assign(_local_14);
                _z.assign(_local_2);
                _directionAxis.assign(_z);
            }

            else
            {
                _x.assign(_local_13);
                _y.assign(_local_23);
                _z.assign(_local_3);
                _directionAxis.assign(_z);
            };
        }

        public function dispose():void
        {
            _x = null;
            _y = null;
            _z = null;
            _loc = null;
            _dir = null;
            _directionAxis = null;
            _location = null;

            if (_displacements != null)
            {
                _displacements.dispose();
                _displacements = null;
            };
        }

        public function setDisplacement(from:IVector3d, to:IVector3d):void
        {
            var _local_4:String;
            var _local_3:Vector3d;

            if (((from == null) || (to == null)))
            {
                return;
            };

            if (_displacements != null)
            {
                _local_4 = ((((Math.round(from.x) + "_") + Math.round(from.y)) + "_") + Math.round(from.z));
                _displacements.remove(_local_4);
                _local_3 = new Vector3d();
                _local_3.assign(to);
                _displacements.add(_local_4, _local_3);
                _updateId++;
            };
        }

        private function getDisplacement(worldLocation:IVector3d):IVector3d
        {
            var _local_2:String;

            if (_displacements != null)
            {
                _local_2 = ((((Math.round(worldLocation.x) + "_") + Math.round(worldLocation.y)) + "_") + Math.round(worldLocation.z));
                return (_displacements.getValue(_local_2));
            };

            return (null);
        }

        public function setDepthVector(depthVector:IVector3d):void
        {
            var _local_9:Number;
            var _local_18:Number;
            var _local_16:Vector3d;
            var _local_7:Vector3d;
            var _local_4:Vector3d;
            var _local_15:Vector3d = new Vector3d(0, 1, 0);
            var _local_17:Vector3d = new Vector3d(0, 0, 1);
            var _local_19:Vector3d = new Vector3d(1, 0, 0);
            var _local_2:Number = ((depthVector.x / 180) * 3.14159265358979);
            var _local_3:Number = ((depthVector.y / 180) * 3.14159265358979);
            var _local_5:Number = ((depthVector.z / 180) * 3.14159265358979);
            var _local_11:Number = Math.cos(_local_2);
            var _local_22:Number = Math.sin(_local_2);
            var _local_13:Vector3d = Vector3d.sum(Vector3d.product(_local_15, _local_11), Vector3d.product(_local_19, -(_local_22)));
            var _local_12:Vector3d = new Vector3d(_local_17.x, _local_17.y, _local_17.z);
            var _local_14:Vector3d = Vector3d.sum(Vector3d.product(_local_15, _local_22), Vector3d.product(_local_19, _local_11));
            var _local_10:Number = Math.cos(_local_3);
            var _local_21:Number = Math.sin(_local_3);
            var _local_6:Vector3d = new Vector3d(_local_13.x, _local_13.y, _local_13.z);
            var _local_20:Vector3d = Vector3d.sum(Vector3d.product(_local_12, _local_10), Vector3d.product(_local_14, _local_21));
            var _local_8:Vector3d = Vector3d.sum(Vector3d.product(_local_12, -(_local_21)), Vector3d.product(_local_14, _local_10));

            if (_local_5 != 0)
            {
                _local_9 = Math.cos(_local_5);
                _local_18 = Math.sin(_local_5);
                _local_16 = Vector3d.sum(Vector3d.product(_local_6, _local_9), Vector3d.product(_local_20, _local_18));
                _local_7 = Vector3d.sum(Vector3d.product(_local_6, -(_local_18)), Vector3d.product(_local_20, _local_9));
                _local_4 = new Vector3d(_local_8.x, _local_8.y, _local_8.z);
                _depth.assign(_local_4);
            }

            else
            {
                _depth.assign(_local_8);
            };

            _updateId++;
        }

        public function adjustLocation(worldPosition:IVector3d, amount:Number):void
        {
            if (((worldPosition == null) || (_z == null)))
            {
                return;
            };

            var _local_4:Vector3d = Vector3d.product(_z, -(amount));
            var _local_3:Vector3d = new Vector3d((worldPosition.x + _local_4.x), (worldPosition.y + _local_4.y), (worldPosition.z + _local_4.z));
            location = _local_3;
        }

        public function getCoordinatePosition(worldPosition:IVector3d):IVector3d
        {
            if (worldPosition == null)
            {
                return (null);
            };

            var _local_3:Number = Vector3d.scalarProjection(worldPosition, _x);
            var _local_4:Number = Vector3d.scalarProjection(worldPosition, _y);
            var _local_5:Number = Vector3d.scalarProjection(worldPosition, _z);
            return (new Vector3d(_local_3, _local_4, _local_5));
        }

        public function getScreenPosition(worldPosition:IVector3d):IVector3d
        {
            var _local_2:Vector3d = Vector3d.dif(worldPosition, _loc);
            _local_2.x = (_local_2.x * _x_scale);
            _local_2.y = (_local_2.y * _y_scale);
            _local_2.z = (_local_2.z * _z_scale);

            var _local_5:Number = Vector3d.scalarProjection(_local_2, _depth);

            if (((_local_5 < _clipNear) || (_local_5 > _clipFar)))
            {
                return (null);
            };

            var _local_3:Number = Vector3d.scalarProjection(_local_2, _x);
            var _local_4:Number = -(Vector3d.scalarProjection(_local_2, _y));
            _local_3 = (_local_3 * _scale);
            _local_4 = (_local_4 * _scale);

            var _local_6:IVector3d = getDisplacement(worldPosition);

            if (_local_6 != null)
            {
                _local_2 = Vector3d.dif(worldPosition, _loc);
                _local_2.add(_local_6);
                _local_2.x = (_local_2.x * _x_scale);
                _local_2.y = (_local_2.y * _y_scale);
                _local_2.z = (_local_2.z * _z_scale);
                _local_5 = Vector3d.scalarProjection(_local_2, _depth);
            };

            _local_2.x = _local_3;
            _local_2.y = _local_4;
            _local_2.z = _local_5;
            return (_local_2);
        }

        public function getScreenPoint(worldPosition:IVector3d):Point
        {
            var _local_2:IVector3d = getScreenPosition(worldPosition);

            if (_local_2 == null)
            {
                return (null);
            };

            return (new Point(_local_2.x, _local_2.y));
        }

        public function getPlanePosition(screenPoint:Point, leftSide:IVector3d, rightSide:IVector3d, normal:IVector3d):Point
        {
            var _local_10:Number;
            var _local_12:Number;
            var _local_14:Number = (screenPoint.x / _scale);
            var _local_16:Number = (-(screenPoint.y) / _scale);
            var _local_6:Vector3d = Vector3d.product(_x, _local_14);
            _local_6.add(Vector3d.product(_y, _local_16));

            var _local_8:Vector3d = new Vector3d((_loc.x * _x_scale), (_loc.y * _y_scale), (_loc.z * _z_scale));
            _local_8.add(_local_6);

            var _local_15:IVector3d = _z;
            var _local_5:Vector3d = new Vector3d((leftSide.x * _x_scale), (leftSide.y * _y_scale), (leftSide.z * _z_scale));
            var _local_13:Vector3d = new Vector3d((rightSide.x * _x_scale), (rightSide.y * _y_scale), (rightSide.z * _z_scale));
            var _local_7:Vector3d = new Vector3d((normal.x * _x_scale), (normal.y * _y_scale), (normal.z * _z_scale));
            var _local_11:IVector3d = Vector3d.crossProduct(_local_13, _local_7);
            var _local_9:Vector3d = new Vector3d();
            _local_9.assign(RoomGeometry.getIntersectionVector(_local_8, _local_15, _local_5, _local_11));

            if (_local_9 != null)
            {
                _local_9.sub(_local_5);
                _local_10 = ((Vector3d.scalarProjection(_local_9, rightSide) / _local_13.length) * rightSide.length);
                _local_12 = ((Vector3d.scalarProjection(_local_9, normal) / _local_7.length) * normal.length);
                return (new Point(_local_10, _local_12));
            };

            return (null);
        }

        public function performZoom():void
        {
            if (isZoomedIn())
            {
                scale = 32;
            }

            else
            {
                scale = 64;
            };
        }

        public function isZoomedIn():Boolean
        {
            return (scale == 64);
        }

        public function performZoomOut():void
        {
            scale = 32;
        }

        public function performZoomIn():void
        {
            scale = 64;
        }

    }
}

