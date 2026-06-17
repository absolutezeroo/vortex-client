package com.sulake.room.utils
{
    import flash.geom.Point;

    public class PointMath 
    {

        public static function sum(pointA:Point, pointB:Point):Point
        {
            return (new Point((pointA.x + pointB.x), (pointA.y + pointB.y)));
        }

        public static function sub(pointA:Point, pointB:Point):Point
        {
            return (new Point((pointA.x - pointB.x), (pointA.y - pointB.y)));
        }

        public static function mul(point:Point, scale:Number):Point
        {
            return (new Point((point.x * scale), (point.y * scale)));
        }

    }
}
