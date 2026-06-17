package com.sulake.room.utils
{
    import flash.geom.Point;

    public /*dynamic*/ interface IRoomGeometry 
    {

        function get scale():Number;
        function get directionAxis():IVector3d;
        function get direction():IVector3d;
        function getCoordinatePosition(worldPosition:IVector3d):IVector3d;
        function getScreenPoint(worldPosition:IVector3d):Point;
        function getScreenPosition(worldPosition:IVector3d):IVector3d;
        function getPlanePosition(screenPoint:Point, leftSide:IVector3d, rightSide:IVector3d, normal:IVector3d):Point;
        function setDisplacement(from:IVector3d, to:IVector3d):void;
        function adjustLocation(location:IVector3d, offset:Number):void;
        function performZoom():void;
        function performZoomOut():void;
        function performZoomIn():void;
        function isZoomedIn():Boolean;
        function get updateId():int;
        function set z_scale(zScale:Number):void;

    }
}
