package com.sulake.room.utils
{
    public class Vector3d implements IVector3d 
    {

        private var _x:Number;
        private var _y:Number;
        private var _z:Number;
        private var _length:Number = NaN;

        public function Vector3d(x:Number=0, y:Number=0, z:Number=0)
        {
            _x = x;
            _y = y;
            _z = z;
        }

        public static function sum(a:IVector3d, b:IVector3d):Vector3d
        {
            if (((a == null) || (b == null)))
            {
                return (null);
            };

            return (new Vector3d((a.x + b.x), (a.y + b.y), (a.z + b.z)));
        }

        public static function dif(a:IVector3d, b:IVector3d):Vector3d
        {
            if (((a == null) || (b == null)))
            {
                return (null);
            };

            return (new Vector3d((a.x - b.x), (a.y - b.y), (a.z - b.z)));
        }

        public static function product(vector:IVector3d, scalar:Number):Vector3d
        {
            if (vector == null)
            {
                return (null);
            };

            return (new Vector3d((vector.x * scalar), (vector.y * scalar), (vector.z * scalar)));
        }

        public static function dotProduct(a:IVector3d, b:IVector3d):Number
        {
            if (((a == null) || (b == null)))
            {
                return (0);
            };

            return (((a.x * b.x) + (a.y * b.y)) + (a.z * b.z));
        }

        public static function crossProduct(a:IVector3d, b:IVector3d):Vector3d
        {
            if (((a == null) || (b == null)))
            {
                return (null);
            };

            return (new Vector3d(((a.y * b.z) - (a.z * b.y)), ((a.z * b.x) - (a.x * b.z)), ((a.x * b.y) - (a.y * b.x))));
        }

        public static function scalarProjection(v:IVector3d, onto:IVector3d):Number
        {
            if (((v == null) || (onto == null)))
            {
                return (-1);
            };

            var _local_3:Number = onto.length;

            if (_local_3 > 0)
            {
                return ((((v.x * onto.x) + (v.y * onto.y)) + (v.z * onto.z)) / _local_3);
            };

            return (-1);
        }

        public static function cosAngle(a:IVector3d, b:IVector3d):Number
        {
            if (((a == null) || (b == null)))
            {
                return (0);
            };

            var _local_3:Number = (a.length * b.length);

            if (_local_3 == 0)
            {
                return (0);
            };

            return (Vector3d.dotProduct(a, b) / _local_3);
        }

        public static function isEqual(a:IVector3d, b:IVector3d):Boolean
        {
            if (((a == null) || (b == null)))
            {
                return (false);
            };

            if ((((a.x == b.x) && (a.y == b.y)) && (a.z == b.z)))
            {
                return (true);
            };

            return (false);
        }

        public function get x():Number
        {
            return (_x);
        }

        public function get y():Number
        {
            return (_y);
        }

        public function get z():Number
        {
            return (_z);
        }

        public function get length():Number
        {
            if (isNaN(_length))
            {
                _length = Math.sqrt((((_x * _x) + (_y * _y)) + (_z * _z)));
            };

            return (_length);
        }

        public function set x(value:Number):void
        {
            _x = value;
            _length = NaN;
        }

        public function set y(value:Number):void
        {
            _y = value;
            _length = NaN;
        }

        public function set z(value:Number):void
        {
            _z = value;
            _length = NaN;
        }

        public function negate():void
        {
            _x = -(_x);
            _y = -(_y);
            _z = -(_z);
        }

        public function add(vector:IVector3d):void
        {
            if (vector == null)
            {
                return;
            };

            _x = (_x + vector.x);
            _y = (_y + vector.y);
            _z = (_z + vector.z);
            _length = NaN;
        }

        public function sub(vector:IVector3d):void
        {
            if (vector == null)
            {
                return;
            };

            _x = (_x - vector.x);
            _y = (_y - vector.y);
            _z = (_z - vector.z);
            _length = NaN;
        }

        public function mul(value:Number):void
        {
            _x = (_x * value);
            _y = (_y * value);
            _z = (_z * value);
            _length = NaN;
        }

        public function div(value:Number):void
        {
            if (value != 0)
            {
                _x = (_x / value);
                _y = (_y / value);
                _z = (_z / value);
                _length = NaN;
            };
        }

        public function assign(vector:IVector3d):void
        {
            if (vector == null)
            {
                return;
            };

            _x = vector.x;
            _y = vector.y;
            _z = vector.z;
            _length = NaN;
        }

        public function toString():String
        {
            return (("(" + [_x, _y, _z].join(",")) + ")");
        }

    }
}
